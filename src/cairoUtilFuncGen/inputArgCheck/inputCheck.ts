import assert from 'assert';
import {
  AddressType,
  ArrayType,
  ASTNode,
  BoolType,
  BytesType,
  DataLocation,
  EnumDefinition,
  FixedBytesType,
  FunctionCall,
  FunctionStateMutability,
  generalizeType,
  getNodeType,
  IntType,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { FunctionStubKind } from '../../ast/cairoNodes';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createIdentifier } from '../../utils/nodeTemplates';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { delegateBasedOnType, locationIfComplexType, StringIndexedFuncGen } from '../base';
import { checkableType, getElementType, isDynamicArray } from '../../utils/nodeTypeProcessing';

export class InputCheckGen extends StringIndexedFuncGen {
  gen(node: VariableDeclaration, nodeInSourceUnit: ASTNode): FunctionCall {
    const type = generalizeType(getNodeType(node, this.ast.compilerVersion))[0];
    const functionInput = createIdentifier(node, this.ast);
    this.sourceUnit = this.ast.getContainingRoot(nodeInSourceUnit);
    const name = this.getOrCreate(type);
    const functionStub = createCairoFunctionStub(
      name,
      [
        [
          'ref_var',
          typeNameFromTypeNode(type, this.ast),
          locationIfComplexType(type, DataLocation.CallData),
        ],
      ],
      [],
      ['range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? node,
      FunctionStateMutability.Pure,
      FunctionStubKind.FunctionDefStub,
      isDynamicArray(type),
    );
    return createCallToFunction(functionStub, [functionInput], this.ast);
  }

  private getOrCreate(type: TypeNode): string {
    const key = type.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(`Input check for ${printTypeNode(type)} not defined yet.`);
    };

    return delegateBasedOnType<string>(
      type,
      (type) => this.createDynArrayInputCheck(key, this.generateFuncName(key), type),
      (type) => this.createStaticArrayInputCheck(key, this.generateFuncName(key), type),
      (type) => this.createStructInputCheck(key, this.generateFuncName(key), type),
      unexpectedTypeFunc,
      (type) => {
        if (type instanceof FixedBytesType) {
          return this.createIntInputCheck(type.size * 8);
        } else if (type instanceof IntType) {
          return this.createIntInputCheck(type.nBits);
        } else if (type instanceof BoolType) {
          return this.createBoolInputCheck();
        } else if (type instanceof UserDefinedType && type.definition instanceof EnumDefinition) {
          return this.createEnumInputCheck(key, type);
        } else if (type instanceof AddressType) {
          return this.createAddressInputCheck();
        } else {
          return unexpectedTypeFunc();
        }
      },
    );
  }

  private generateFuncName(key: string): string {
    const funcName = `extern_input_check${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, { name: funcName, code: '' });
    return funcName;
  }

  private createIntInputCheck(bitWidth: number): string {
    const funcName = `warp_external_input_check_int${bitWidth}`;
    this.requireImport(
      'warplib.maths.external_input_check_ints',
      `warp_external_input_check_int${bitWidth}`,
    );
    return funcName;
  }

  private createAddressInputCheck(): string {
    const funcName = 'warp_external_input_check_address';
    this.requireImport(
      'warplib.maths.external_input_check_address',
      `warp_external_input_check_address`,
    );
    return funcName;
  }

  private createStructInputCheck(key: string, funcName: string, type: UserDefinedType): string {
    const implicits = '{range_check_ptr : felt}';

    const structDef = type.definition;
    assert(structDef instanceof StructDefinition);
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(arg : ${cairoType.toString()}) -> ():`,
        `alloc_locals`,
        ...structDef.vMembers.map((decl) => {
          const memberType = getNodeType(decl, this.ast.compilerVersion);
          if (checkableType(memberType)) {
            const memberCheck = this.getOrCreate(memberType);
            return [`${memberCheck}(arg.${decl.name})`];
          } else {
            return '';
          }
        }),
        `return ()`,
        `end`,
      ].join('\n'),
    });
    return funcName;
  }

  private createStaticArrayInputCheck(key: string, funcName: string, type: ArrayType): string {
    const implicits = '{range_check_ptr : felt}';

    assert(type.size !== undefined);
    const length = narrowBigIntSafe(type.size);
    assert(length !== undefined);

    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    const elementType = generalizeType(type.elementT)[0];
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(arg : ${cairoType.toString()}) -> ():`,
        `alloc_locals`,
        ...mapRange(length, (index) => {
          const indexCheck = this.getOrCreate(elementType);
          return [`${indexCheck}(arg[${index}])`];
        }),
        `return ()`,
        `end`,
      ].join('\n'),
    });
    return funcName;
  }

  private createBoolInputCheck(): string {
    const funcName = `warp_external_input_check_bool`;
    this.requireImport('warplib.maths.external_input_check_bool', `warp_external_input_check_bool`);
    return funcName;
  }

  private createEnumInputCheck(key: string, type: UserDefinedType): string {
    const funcName = `extern_input_check${this.generatedFunctions.size}`;
    const implicits = '{range_check_ptr : felt}';

    const enumDef = type.definition;
    assert(enumDef instanceof EnumDefinition);
    const nMembers = enumDef.vMembers.length;
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(arg : felt) -> ():`,
        `    let (inRange : felt) = is_le_felt(arg, ${nMembers - 1})`,
        `    with_attr error_message("Error: value out-of-bounds. Values passed to must be in enum range (0, ${
          nMembers - 1
        }]."):`,
        `        assert 1 = inRange`,
        `    end`,
        `    return ()`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.math_cmp', 'is_le_felt');
    return funcName;
  }

  private createDynArrayInputCheck(
    key: string,
    funcName: string,
    type: ArrayType | BytesType | StringType,
  ): string {
    const implicits = '{range_check_ptr : felt}';

    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    assert(cairoType instanceof CairoDynArray);
    const ptrType = cairoType.vPtr;
    const elementType = generalizeType(getElementType(type))[0];
    const indexCheck = [`${this.getOrCreate(elementType)}(ptr[0])`];

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(len: felt, ptr : ${ptrType.toString()}) -> ():`,
        `    alloc_locals`,
        `    if len == 0:`,
        `        return ()`,
        `    end`,
        ...indexCheck,
        `   ${funcName}(len = len - 1, ptr = ptr + ${ptrType.to.width})`,
        `    return ()`,
        `end`,
      ].join('\n'),
    });
    return funcName;
  }
}
