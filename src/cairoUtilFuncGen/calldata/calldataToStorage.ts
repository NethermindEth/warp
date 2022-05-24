import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  Expression,
  generalizeType,
  getNodeType,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoDynArray, CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { typeNameFromTypeNode } from '../../utils/utils';
import { StringIndexedFuncGen } from '../base';
import { DynArrayGen } from '../storage/dynArray';
import { StorageWriteGen } from '../storage/storageWrite';

export class CalldataToStorageGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageWriteGen: StorageWriteGen,
    ast: AST,
  ) {
    super(ast);
  }

  gen(storageLocation: Expression, calldataLocation: Expression, nodeInSourceUnit?: ASTNode) {
    const storageType = generalizeType(getNodeType(storageLocation, this.ast.compilerVersion))[0];
    const calldataType = generalizeType(getNodeType(calldataLocation, this.ast.compilerVersion))[0];

    if (calldataType instanceof ArrayType && calldataType.size === undefined) {
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

    throw new NotSupportedYetError(
      `Copying ${printTypeNode(calldataType)} from calldata to storage is not supported yet`,
    );
  }

  private getOrCreate(type: TypeNode) {
    const key = type.pp();
    if (type instanceof ArrayType && type.size === undefined) {
      return this.createDynamicArray(key, type);
    }

    throw new NotSupportedYetError(
      `Copying ${printTypeNode(type)} from calldata to storage is not supported yet`,
    );
  }

  private createDynamicArray(key: string, arrayType: ArrayType): string {
    const structDef = CairoType.fromSol(arrayType, this.ast, TypeConversionContext.CallDataRef);
    assert(structDef instanceof CairoDynArray);

    const [arrayName, arrayLen] = this.dynArrayGen.gen(
      CairoType.fromSol(arrayType.elementT, this.ast, TypeConversionContext.StorageAllocation),
    );
    const cairoElementType = CairoType.fromSol(
      arrayType.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const copyCode = `${this.storageWriteGen.getOrCreate(arrayType.elementT)}(elem_loc, [elem])`;

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const pointerType = `${cairoElementType.toString()}*`;

    const funcName = `cd_to_storage${this.generatedFunctions.size}`;
    const code = [
      `func ${funcName}_write${implicits}(loc : felt, len : felt, elem: ${pointerType}):`,
      `   alloc_locals`,
      `   if len == 0:`,
      `       return ()`,
      `   end`,
      `   let index = len - 1`,
      `   let (index_uint256) = warp_uint256(index)`,
      `   let (elem_loc) = ${arrayName}.read(loc, index_uint256)`,
      `   if elem_loc == 0:`,
      `       let (elem_loc) = WARP_USED_STORAGE.read() `,
      `       WARP_USED_STORAGE.write(loc + ${cairoElementType.width})`,
      `       ${arrayName}.write(loc, index_uint256, elem_loc)`,
      `       ${copyCode}`,
      `       return ${funcName}_write(loc, index, elem + ${cairoElementType.width})`,
      `   else:`,
      `       ${copyCode}`,
      `       return ${funcName}_write(loc, index, elem + ${cairoElementType.width})`,
      `   end`,
      `end`,

      `func ${funcName}${implicits}(loc : felt, dyn_array_struct : ${structDef.name}) -> (loc : felt): `,
      `   alloc_locals`,
      `   let (len_uint256) = warp_uint256(dyn_array_struct.len)`,
      `   ${arrayLen}.write(loc, len_uint256)`,
      `   ${funcName}_write(loc, dyn_array_struct.len, dyn_array_struct.ptr)`,
      `   return (loc)`,
      `end`,
    ].join('\n');

    this.requireImport('warplib.maths.int_conversions', 'warp_uint256');

    this.generatedFunctions.set(key, { name: funcName, code: code });

    return funcName;
  }
}
