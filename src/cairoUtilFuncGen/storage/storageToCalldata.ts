import assert from 'assert';
import {
  ArrayType,
  DataLocation,
  Expression,
  generalizeType,
  getNodeType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { add, StringIndexedFuncGen } from '../base';
import { ExternalDynArrayStructConstructor } from '../memory/externalDynArray/externalDynArrayStructConstructor';
import { DynArrayGen } from './dynArray';
import { StorageReadGen } from './storageRead';

export class StorageToCalldataGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageReadGen: StorageReadGen,
    private externalDynArrayStructConstructor: ExternalDynArrayStructConstructor,
    ast: AST,
  ) {
    super(ast);
  }

  gen(storageLocation: Expression) {
    const storageType = generalizeType(getNodeType(storageLocation, this.ast.compilerVersion))[0];

    const name = this.getOrCreate(storageType);
    const functionStub = createCairoFunctionStub(
      name,
      [['loc', typeNameFromTypeNode(storageType, this.ast), DataLocation.Storage]],
      [['obj', typeNameFromTypeNode(storageType, this.ast), DataLocation.CallData]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      storageLocation,
    );

    return createCallToFunction(functionStub, [storageLocation], this.ast);
  }

  private getOrCreate(type: TypeNode): string {
    const key = type.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    if (type instanceof ArrayType) {
      return type.size === undefined
        ? this.createDynamicArrayCopyFunction(key, type)
        : this.createStaticArrayCopyFunction(key, type);
    }

    if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      return this.createStructCopyFunction(key, type);
    }

    throw new NotSupportedYetError(
      `Copying ${printTypeNode(type)} from storage to calldata is not supported yet`,
    );
  }

  private createStructCopyFunction(key: string, structType: UserDefinedType) {
    assert(structType.definition instanceof StructDefinition);

    const structDef = structType.definition;
    const cairoStruct = CairoType.fromSol(
      structType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const structName = `struct_${structDef.name}`;

    const [copyInstructions, members] = this.generateStructCopyInstructions(
      structDef.vMembers.map((varDecl) => getNodeType(varDecl, this.ast.compilerVersion)),
      'member',
    );

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const funcName = `ws_struct_${structDef.name}_to_calldata`;
    const code = [
      `func ${funcName}${implicits}(loc : felt) -> (${structName} : ${cairoStruct.toString()}):`,
      `   alloc_locals`,
      ...copyInstructions,
      `   let ${structName} = ${structDef.name}(${members.join(', ')})`,
      `   return (${structName})`,
      `end`,
    ].join('\n');

    this.generatedFunctions.set(key, { name: funcName, code: code });
    return funcName;
  }

  private createStaticArrayCopyFunction(key: string, arrayType: ArrayType): string {
    assert(arrayType.size !== undefined);

    const cairoType = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);

    const [copyInstructions, members] = this.generateStructCopyInstructions(
      mapRange(narrowBigIntSafe(arrayType.size), () => arrayType.elementT),
      'elem',
    );

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const funcName = `ws_static_array_to_calldata${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${implicits}(loc : felt) -> (static_array : ${cairoType.toString()}):`,
      `    alloc_locals`,
      ...copyInstructions,
      `    let result = (${members.join(', ')})`,
      `    return (result)`,
      `end`,
    ].join('\n');

    this.generatedFunctions.set(key, { name: funcName, code: code });

    return funcName;
  }

  private createDynamicArrayCopyFunction(key: string, arrayType: ArrayType): string {
    const structDef = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);
    assert(structDef instanceof CairoDynArray);

    this.externalDynArrayStructConstructor.getOrCreate(arrayType);
    const [arrayName, arrayLen] = this.dynArrayGen.gen(
      CairoType.fromSol(arrayType.elementT, this.ast, TypeConversionContext.StorageAllocation),
    );
    const cairoElementType = CairoType.fromSol(
      arrayType.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const ptrType = `${cairoElementType.toString()}*`;
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

    const funcName = `ws_dynamic_array_to_calldata${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}_write${implicits}(`,
      `   loc : felt,`,
      `   index : felt,`,
      `   len : felt,`,
      `   ptr : ${ptrType}) -> (ptr : ${ptrType}):`,
      `   alloc_locals`,
      `   if len == index:`,
      `       return (ptr)`,
      `   end`,
      `   let (index_uint256) = warp_uint256(index)`,
      `   let (elem_loc) = ${arrayName}.read(loc, index_uint256)`, // elem_loc should never be zero
      `   let (elem) = ${this.storageReadGen.genFuncName(arrayType.elementT)}(elem_loc)`,
      `   assert ptr[index] = elem`,
      `   return ${funcName}_write(loc, index + 1, len, ptr)`,
      `end`,

      `func ${funcName}${implicits}(loc : felt) -> (dyn_array_struct : ${structDef.name}):`,
      `   alloc_locals`,
      `   let (len_uint256) = ${arrayLen}.read(loc)`,
      `   let len = len_uint256.low + len_uint256.high*128`,
      `   let (ptr : ${ptrType}) = alloc()`,
      `   let (ptr : ${ptrType}) = ${funcName}_write(loc, 0, len, ptr)`,
      `   let dyn_array_struct = ${structDef.name}(len, ptr)`,
      `   return (dyn_array_struct)`,
      `end`,
    ].join('\n');

    this.requireImport('warplib.maths.int_conversions', 'warp_uint256');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.alloc', 'alloc');

    this.generatedFunctions.set(key, { name: funcName, code: code });

    return funcName;
  }

  private generateStructCopyInstructions(
    varDeclarations: TypeNode[],
    tempVarName: string,
  ): [string[], string[]] {
    const members: string[] = [];
    let offset = 0;
    const copyInstructions = varDeclarations.map((varType, index) => {
      const varCairoTypeWidth = CairoType.fromSol(
        varType,
        this.ast,
        TypeConversionContext.CallDataRef,
      ).width;

      const funcName = this.storageReadGen.genFuncName(varType);
      const location = add('loc', offset);
      const memberName = `${tempVarName}_${index}`;

      members.push(memberName);
      offset += varCairoTypeWidth;

      return `    let (${memberName}) = ${funcName}(${location})`;
    });

    return [copyInstructions, members];
  }
}
