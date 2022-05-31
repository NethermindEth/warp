import assert from 'assert';
import {
  AddressType,
  ArrayType,
  ASTNode,
  BoolType,
  DataLocation,
  EnumDefinition,
  FunctionCall,
  FunctionStateMutability,
  generalizeType,
  getNodeType,
  IntType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { FunctionStubKind } from '../../ast/cairoNodes';
import { printTypeNode } from '../../utils/astPrinter';
import {
  CairoDynArray,
  CairoFelt,
  CairoType,
  TypeConversionContext,
} from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createIdentifier } from '../../utils/nodeTemplates';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { StringIndexedFuncGen } from '../base';

export class RefInputCheck extends StringIndexedFuncGen {
  gen(node: VariableDeclaration, nodeInSourceUnit: ASTNode): FunctionCall {
    const type = generalizeType(getNodeType(node, this.ast.compilerVersion))[0];
    const functionInput = createIdentifier(node, this.ast);
    const name = this.getOrCreate(type);
    const functionStub = createCairoFunctionStub(
      name,
      [['ref_var', typeNameFromTypeNode(type, this.ast), DataLocation.CallData]],
      [],
      ['range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? node,
      FunctionStateMutability.Pure,
      FunctionStubKind.FunctionDefStub,
      type instanceof ArrayType && type.size === undefined ? true : false,
    );
    return createCallToFunction(functionStub, [functionInput], this.ast);
  }

  private getOrCreate(type: TypeNode): string {
    const key = type.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    if (type instanceof IntType) {
      return this.createIntInputCheck(type);
    } else if (type instanceof BoolType) {
      return this.createBoolInputCheck();
    } else if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      return this.createStructInputCheck(key, type);
    } else if (type instanceof UserDefinedType && type.definition instanceof EnumDefinition) {
      return this.createEnumInputCheck(key, type);
    } else if (type instanceof ArrayType) {
      return type.size === undefined
        ? this.createDynArrayInputCheck(key, type)
        : this.createStaticArrayInputCheck(key, type);
    } else if (type instanceof AddressType) {
      return this.createAddressInputCheck();
    } else {
      throw new NotSupportedYetError(` Input check for ${printTypeNode(type)} not defined yet.`);
    }
  }

  private createIntInputCheck(type: IntType): string {
    const funcName = `warp_external_input_check_int${type.nBits}`;
    this.requireImport(
      'warplib.maths.external_input_check_ints',
      `warp_external_input_check_int${type.nBits}`,
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

  private createStructInputCheck(key: string, type: UserDefinedType): string {
    const funcName = `extern_input_check${this.generatedFunctions.size}`;
    const implicits = '{range_check_ptr : felt}';

    // Set an empty entry so recursive function generation doesn't clash
    this.generatedFunctions.set(key, { name: funcName, code: '' });
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
          if (this.checkableType(memberType)) {
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

  private createStaticArrayInputCheck(key: string, type: ArrayType): string {
    const funcName = `extern_input_check${this.generatedFunctions.size}`;
    const implicits = '{range_check_ptr : felt}';

    // Set an empty entry so recursive function generation doesn't clash
    this.generatedFunctions.set(key, { name: funcName, code: '' });

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

    // Set an empty entry so recursive function generation doesn't clash
    this.generatedFunctions.set(key, { name: funcName, code: '' });
    const enumDef = type.definition;
    assert(enumDef instanceof EnumDefinition);
    //const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
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

  private createDynArrayInputCheck(key: string, type: ArrayType): string {
    const funcName = `extern_input_check${this.generatedFunctions.size}`;
    const implicits = '{range_check_ptr : felt}';

    // Set an empty entry so recursive function generation doesn't clash
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.CallDataRef);
    assert(cairoType instanceof CairoDynArray);
    const ptrType = cairoType.vPtr;
    const elementType = generalizeType(type.elementT)[0];
    const cairoElmType = CairoType.fromSol(
      elementType,
      this.ast,
      TypeConversionContext.CallDataRef,
    );
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
        `   ${funcName}(len = len - 1, ptr = ptr + ${
          ptrType.to instanceof CairoFelt ? '1' : cairoElmType.toString() + '.SIZE'
        })`,
        `    return ()`,
        `end`,
      ].join('\n'),
    });
    return funcName;
  }

  checkableType(type: TypeNode): boolean {
    if (
      type instanceof ArrayType ||
      (type instanceof UserDefinedType &&
        (type.definition instanceof StructDefinition ||
          type.definition instanceof EnumDefinition)) ||
      type instanceof AddressType ||
      type instanceof IntType ||
      type instanceof BoolType
    ) {
      return true;
    }
    return false;
  }
}
