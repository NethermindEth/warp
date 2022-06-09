import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  BytesType,
  DataLocation,
  Expression,
  generalizeType,
  getNodeType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { getElementType } from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { add, delegateBasedOnType, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from '../storage/dynArray';
import { StorageWriteGen } from '../storage/storageWrite';

export class CalldataToStorageGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageWriteGen: StorageWriteGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  gen(storageLocation: Expression, calldataLocation: Expression, nodeInSourceUnit?: ASTNode) {
    const storageType = generalizeType(getNodeType(storageLocation, this.ast.compilerVersion))[0];
    const calldataType = generalizeType(getNodeType(calldataLocation, this.ast.compilerVersion))[0];

    const name = this.getOrCreate(calldataType);
    const functionStub = createCairoFunctionStub(
      name,
      [
        ['loc', typeNameFromTypeNode(storageType, this.ast), DataLocation.Storage],
        ['dynarray', typeNameFromTypeNode(calldataType, this.ast), DataLocation.CallData],
      ],
      [['loc', typeNameFromTypeNode(storageType, this.ast), DataLocation.Storage]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? storageLocation,
    );

    return createCallToFunction(functionStub, [storageLocation, calldataLocation], this.ast);
  }

  getOrCreate(type: TypeNode) {
    const key = type.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const unexpectedTypeFunc = () => {
      throw new NotSupportedYetError(
        `Copying ${printTypeNode(type)} from calldata to storage is not supported yet`,
      );
    };

    return delegateBasedOnType<string>(
      type,
      (type) => this.createDynamicArrayCopyFunction(key, type),
      (type) => this.createStaticArrayCopyFunction(key, type),
      (type) => this.createStructCopyFunction(key, type),
      unexpectedTypeFunc,
      unexpectedTypeFunc,
    );
  }

  private createStructCopyFunction(key: string, structType: UserDefinedType): string {
    assert(structType.definition instanceof StructDefinition);
    const structDef = structType.definition;
    const cairoStruct = CairoType.fromSol(
      structType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const structName = `struct_${structDef.name}`;

    const members = structDef.vMembers.map((varDecl) => `${structName}.${varDecl.name}`);
    const copyInstructions = this.generateStructCopyInstructions(
      structDef.vMembers.map((varDecl) => getNodeType(varDecl, this.ast.compilerVersion)),
      members,
    );

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const funcName = `cd_struct_${structDef.name}_to_storage`;
    const code = [
      `func ${funcName}${implicits}(loc : felt, ${structName} : ${cairoStruct.toString()}) -> (loc : felt):`,
      `   alloc_locals`,
      ...copyInstructions,
      `   return (loc)`,
      `end`,
    ].join('\n');

    this.generatedFunctions.set(key, { name: funcName, code: code });
    return funcName;
  }

  private createStaticArrayCopyFunction(key: string, arrayType: ArrayType): string {
    assert(arrayType.size !== undefined);

    const cairoType = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);

    const len = narrowBigIntSafe(arrayType.size);

    const elems = mapRange(len, (n) => `static_array[${n}]`);
    const copyInstructions = this.generateStructCopyInstructions(
      mapRange(len, () => arrayType.elementT),
      elems,
    );

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const funcName = `cd_static_array_to_storage${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}${implicits}(loc : felt, static_array : ${cairoType.toString()}) -> (loc : felt):`,
      `   alloc_locals`,
      ...copyInstructions,
      `   return (loc)`,
      `end`,
    ].join('\n');

    this.generatedFunctions.set(key, { name: funcName, code: code });

    return funcName;
  }

  private createDynamicArrayCopyFunction(
    key: string,
    arrayType: ArrayType | BytesType | StringType,
  ): string {
    const elementT = getElementType(arrayType);
    const structDef = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);
    assert(structDef instanceof CairoDynArray);

    const [arrayName, arrayLen] = this.dynArrayGen.gen(
      CairoType.fromSol(elementT, this.ast, TypeConversionContext.StorageAllocation),
    );
    const cairoElementType = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const copyCode = `${this.storageWriteGen.getOrCreate(elementT)}(elem_loc, elem[index])`;

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const pointerType = `${cairoElementType.toString()}*`;

    const funcName = `cd_dynamic_array_to_storage${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}_write${implicits}(loc : felt, index : felt, len : felt, elem: ${pointerType}):`,
      `   alloc_locals`,
      `   if index == len:`,
      `       return ()`,
      `   end`,
      `   let (index_uint256) = warp_uint256(index)`,
      `   let (elem_loc) = ${arrayName}.read(loc, index_uint256)`,
      `   if elem_loc == 0:`,
      `       let (elem_loc) = WARP_USED_STORAGE.read() `,
      `       WARP_USED_STORAGE.write(elem_loc + ${cairoElementType.width})`,
      `       ${arrayName}.write(loc, index_uint256, elem_loc)`,
      `       ${copyCode}`,
      `       return ${funcName}_write(loc, index + 1, len, elem)`,
      `   else:`,
      `       ${copyCode}`,
      `       return ${funcName}_write(loc, index + 1, len, elem)`,
      `   end`,
      `end`,

      `func ${funcName}${implicits}(loc : felt, dyn_array_struct : ${structDef.name}) -> (loc : felt): `,
      `   alloc_locals`,
      `   let (len_uint256) = warp_uint256(dyn_array_struct.len)`,
      `   ${arrayLen}.write(loc, len_uint256)`,
      `   ${funcName}_write(loc, 0, dyn_array_struct.len, dyn_array_struct.ptr)`,
      `   return (loc)`,
      `end`,
    ].join('\n');

    this.requireImport('warplib.maths.int_conversions', 'warp_uint256');

    this.generatedFunctions.set(key, { name: funcName, code: code });

    return funcName;
  }

  private generateStructCopyInstructions(varTypes: TypeNode[], names: string[]): string[] {
    let offset = 0;
    const copyInstructions = varTypes.map((varType, index) => {
      const varCairoTypeWidth = CairoType.fromSol(
        varType,
        this.ast,
        TypeConversionContext.CallDataRef,
      ).width;

      const funcName = this.storageWriteGen.getOrCreate(varType);
      const location = add('loc', offset);

      offset += varCairoTypeWidth;

      return `    ${funcName}(${location}, ${names[index]})`;
    });

    return copyInstructions;
  }
}
