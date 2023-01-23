import assert from 'assert';
import {
  AddressType,
  ArrayType,
  ASTNode,
  BoolType,
  BytesType,
  ContractDefinition,
  DataLocation,
  EnumDefinition,
  Expression,
  FixedBytesType,
  FunctionCall,
  FunctionDefinition,
  FunctionStateMutability,
  generalizeType,
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
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { createIdentifier } from '../../utils/nodeTemplates';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import {
  delegateBasedOnType,
  GeneratedFunctionInfo,
  locationIfComplexType,
  StringIndexedFuncGen,
} from '../base';
import {
  checkableType,
  getElementType,
  isDynamicArray,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { cloneASTNode } from '../../utils/cloning';
import { GettersGenerator } from '../../export';

export class InputCheckGen extends StringIndexedFuncGen {
  gen(nodeInput: VariableDeclaration | Expression, typeToCheck: TypeNode): FunctionCall {
    let functionInput;
    let isUint256 = false;
    if (nodeInput instanceof VariableDeclaration) {
      functionInput = createIdentifier(nodeInput, this.ast);
    } else {
      functionInput = cloneASTNode(nodeInput, this.ast);
      const inputType = safeGetNodeType(nodeInput, this.ast.inference);
      this.ast.setContextRecursive(functionInput);
      isUint256 = inputType instanceof IntType && inputType.nBits === 256;
      this.requireImport('warplib.maths.utils', 'narrow_safe');
    }

    const funcDef = this.getOrCreateFuncDef(typeToCheck, isUint256);
    return createCallToFunction(funcDef, [functionInput], this.ast);
  }

  private getOrCreateFuncDef(typeToCheck: TypeNode, isUint256: boolean) {
    const key = `dynArrayPop(${typeToCheck.pp()})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(typeToCheck, isUint256);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        [
          'ref_var',
          typeNameFromTypeNode(typeToCheck, this.ast),
          locationIfComplexType(typeToCheck, DataLocation.CallData),
        ],
      ],
      [],
      // ['range_check_ptr'],
      this.ast,
      this.sourceUnit,
      {
        mutability: FunctionStateMutability.Pure,
        stubKind: FunctionStubKind.FunctionDefStub,
        acceptsRawDArray: isDynamicArray(typeToCheck),
      },
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(type: TypeNode, takesUint = false): GeneratedFunctionInfo {
    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(`Input check for ${printTypeNode(type)} not defined yet.`);
    };

    return delegateBasedOnType<GeneratedFunctionInfo>(
      type,
      (type) => this.createDynArrayInputCheck(this.generateFuncName().name, type),
      (type) => this.createStaticArrayInputCheck(this.generateFuncName().name, type),
      (type) => this.createStructInputCheck(this.generateFuncName().name, type),
      unexpectedTypeFunc,
      (type) => {
        if (type instanceof FixedBytesType) {
          return this.createIntInputCheck(type.size * 8);
        } else if (type instanceof IntType) {
          return this.createIntInputCheck(type.nBits);
        } else if (type instanceof BoolType) {
          return this.createBoolInputCheck();
        } else if (type instanceof UserDefinedType && type.definition instanceof EnumDefinition) {
          return this.createEnumInputCheck(type, takesUint);
        } else if (
          type instanceof AddressType ||
          (type instanceof UserDefinedType && type.definition instanceof ContractDefinition)
        ) {
          return this.createAddressInputCheck();
        } else {
          return unexpectedTypeFunc();
        }
      },
    );
  }

  private generateFuncName(): GeneratedFunctionInfo {
    const funcName = `extern_input_check${this.generatedFunctionsDef.size}`;
    const funcInfo: GeneratedFunctionInfo = { name: funcName, code: '', functionsCalled: [] };
    return funcInfo;
  }

  private createIntInputCheck(bitWidth: number): GeneratedFunctionInfo {
    const funcName = `warp_external_input_check_int${bitWidth}`;
    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport(
        'warplib.maths.external_input_check_ints',
        `warp_external_input_check_int${bitWidth}`,
      ),
    );
    return { name: funcName, code: '', functionsCalled: funcsCalled };
  }

  private createAddressInputCheck(): GeneratedFunctionInfo {
    const funcName = 'warp_external_input_check_address';
    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport(
        'warplib.maths.external_input_check_address',
        `warp_external_input_check_address`,
      ),
    );
    return { name: funcName, code: '', functionsCalled: funcsCalled };
  }

  private createStructInputCheck(funcName: string, type: UserDefinedType): GeneratedFunctionInfo {
    const implicits = '{range_check_ptr : felt}';

    const structDef = type.definition;
    assert(structDef instanceof StructDefinition);
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);

    const funcsCalled: FunctionDefinition[] = [];
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(arg : ${cairoType.toString()}) -> (){`,
        `alloc_locals;`,
        ...structDef.vMembers.map((decl) => {
          const memberType = safeGetNodeType(decl, this.ast.inference);
          this.checkForImport(memberType);
          if (checkableType(memberType)) {
            const memberCheckInfo = this.getOrCreate(memberType);
            funcsCalled.push(...memberCheckInfo.functionsCalled);
            return [`${memberCheckInfo.name}(arg.${decl.name});`];
          } else {
            return '';
          }
        }),
        `return ();`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }

  private createStaticArrayInputCheck(funcName: string, type: ArrayType): GeneratedFunctionInfo {
    const implicits = '{range_check_ptr : felt}';

    assert(type.size !== undefined);
    const length = narrowBigIntSafe(type.size);
    assert(length !== undefined);

    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    const elementType = generalizeType(type.elementT)[0];
    this.checkForImport(elementType);
    const funcsCalled: FunctionDefinition[] = [];
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(arg : ${cairoType.toString()}) -> (){`,
        `alloc_locals;`,
        ...mapRange(length, (index) => {
          const indexCheckinfo = this.getOrCreate(elementType);
          funcsCalled.push(...indexCheckinfo.functionsCalled);
          return [`${indexCheckinfo.name}(arg[${index}]);`];
        }),
        `return ();`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }

  private createBoolInputCheck(): GeneratedFunctionInfo {
    const funcName = `warp_external_input_check_bool`;
    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport(
        'warplib.maths.external_input_check_bool',
        `warp_external_input_check_bool`,
      ),
    );
    return { name: funcName, code: '', functionsCalled: funcsCalled };
  }

  private createEnumInputCheck(type: UserDefinedType, takesUint = false): GeneratedFunctionInfo {
    const funcName = `extern_input_check${this.generatedFunctionsDef.size}`;
    const implicits = '{range_check_ptr : felt}';

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(this.requireImport('starkware.cairo.common.math_cmp', 'is_le_felt'));
    const enumDef = type.definition;
    assert(enumDef instanceof EnumDefinition);
    const nMembers = enumDef.vMembers.length;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(arg : ${takesUint ? 'Uint256' : 'felt'}) -> (){`,
        takesUint
          ? [
              '    let (arg_0) = narrow_safe(arg);',
              `    let inRange: felt = is_le_felt(arg_0, ${nMembers - 1});`,
            ].join('\n')
          : `    let inRange : felt = is_le_felt(arg, ${nMembers - 1});`,
        `    with_attr error_message("Error: value out-of-bounds. Values passed to must be in enum range (0, ${
          nMembers - 1
        }]."){`,
        `        assert 1 = inRange;`,
        `    }`,
        `    return ();`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }

  private createDynArrayInputCheck(
    funcName: string,
    type: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const implicits = '{range_check_ptr : felt}';

    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    assert(cairoType instanceof CairoDynArray);
    const ptrType = cairoType.vPtr;
    const elementType = generalizeType(getElementType(type))[0];
    this.checkForImport(elementType);

    const funcsCalled: FunctionDefinition[] = [];

    const calledFunctionInfo = this.getOrCreate(elementType);
    funcsCalled.push(...calledFunctionInfo.functionsCalled);
    const indexCheck = [`${calledFunctionInfo.name}(ptr[0]);`];

    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(len: felt, ptr : ${ptrType.toString()}) -> (){`,
        `    alloc_locals;`,
        `    if (len == 0){`,
        `        return ();`,
        `    }`,
        ...indexCheck,
        `   ${funcName}(len = len - 1, ptr = ptr + ${ptrType.to.width});`,
        `    return ();`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }
}
