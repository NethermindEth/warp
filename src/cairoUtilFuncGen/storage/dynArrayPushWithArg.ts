import assert from 'assert';
import {
  ArrayType,
  MappingType,
  ASTNode,
  BytesType,
  DataLocation,
  FunctionCall,
  generalizeType,
  getNodeType,
  MemberAccess,
  SourceUnit,
  StringType,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { typeNameFromTypeNode } from '../../utils/utils';
import { StringIndexedFuncGen } from '../base';
import { MemoryToStorageGen } from '../memory/memoryToStorage';
import { DynArrayGen } from './dynArray';
import { StorageWriteGen } from './storageWrite';
import { StorageToStorageGen } from './copyToStorage';
import { CalldataToStorageGen } from '../calldata/calldataToStorage';
import { Implicits } from '../../utils/implicits';
import { getElementType, isDynamicArray, specializeType } from '../../utils/nodeTypeProcessing';
import { ImplicitArrayConversion } from '../calldata/implicitArrayConversion';

export class DynArrayPushWithArgGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageWrite: StorageWriteGen,
    private memoryToStorage: MemoryToStorageGen,
    private storageToStorage: StorageToStorageGen,
    private calldataToStorage: CalldataToStorageGen,
    private calldataToStorageConversion: ImplicitArrayConversion,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  gen(push: FunctionCall, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(push.vExpression instanceof MemberAccess);
    const arrayType = generalizeType(
      getNodeType(push.vExpression.vExpression, this.ast.compilerVersion),
    )[0];
    assert(
      arrayType instanceof ArrayType ||
        arrayType instanceof BytesType ||
        arrayType instanceof StringType,
    );

    assert(
      push.vArguments.length > 0,
      `Attempted to treat push without argument as push with argument`,
    );
    const [argType, argLoc] = generalizeType(
      getNodeType(push.vArguments[0], this.ast.compilerVersion),
    );

    const name = this.getOrCreate(
      getElementType(arrayType),
      argType,
      argLoc ?? DataLocation.Default,
    );
    const implicits: Implicits[] =
      argLoc === DataLocation.Memory
        ? ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'warp_memory']
        : ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'bitwise_ptr'];

    const functionStub = createCairoFunctionStub(
      name,
      [
        ['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage],
        ['value', typeNameFromTypeNode(argType, this.ast), argLoc ?? DataLocation.Default],
      ],
      [],
      implicits,
      this.ast,
      nodeInSourceUnit ?? push,
    );

    return createCallToFunction(
      functionStub,
      [push.vExpression.vExpression, push.vArguments[0]],
      this.ast,
    );
  }

  private getOrCreate(elementType: TypeNode, argType: TypeNode, argLoc: DataLocation): string {
    const key = `${elementType.pp()}->${argType.pp()}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    let elementWriteFunc: string;
    let inputType: string;
    if (argLoc === DataLocation.Memory) {
      elementWriteFunc = this.memoryToStorage.getOrCreate(elementType);
      inputType = 'felt';
    } else if (argLoc === DataLocation.Storage) {
      elementWriteFunc = this.storageToStorage.getOrCreate(elementType, argType);
      inputType = 'felt';
    } else if (argLoc === DataLocation.CallData) {
      if (elementType.pp() !== argType.pp()) {
        elementWriteFunc = this.calldataToStorageConversion.getOrCreate(
          specializeType(elementType, DataLocation.Storage),
          specializeType(argType, DataLocation.CallData),
        );
      } else {
        elementWriteFunc = this.calldataToStorage.getOrCreate(elementType);
      }
      inputType = CairoType.fromSol(
        argType,
        this.ast,
        TypeConversionContext.CallDataRef,
      ).toString();
    } else {
      elementWriteFunc = this.storageWrite.getOrCreate(elementType);
      inputType = CairoType.fromSol(elementType, this.ast).toString();
    }
    const allocationCairoType = CairoType.fromSol(
      elementType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const [arrayName, lengthName] = this.dynArrayGen.gen(allocationCairoType);
    const funcName = `${arrayName}_PUSHV${this.generatedFunctions.size}`;
    const implicits =
      argLoc === DataLocation.Memory
        ? '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory: DictAccess*}'
        : '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr: BitwiseBuiltin*}';

    const callWriteFunc = (cairoVar: string) =>
      isDynamicArray(argType) || argType instanceof MappingType
        ? [`let (elem_id) = readId(${cairoVar})`, `${elementWriteFunc}(elem_id, value)`]
        : [`${elementWriteFunc}(${cairoVar}, value)`];

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(loc: felt, value: ${inputType}) -> ():`,
        `    alloc_locals`,
        `    let (len) = ${lengthName}.read(loc)`,
        `    let (newLen, carry) = uint256_add(len, Uint256(1,0))`,
        `    assert carry = 0`,
        `    ${lengthName}.write(loc, newLen)`,
        `    let (existing) = ${arrayName}.read(loc, len)`,
        `    if (existing) == 0:`,
        `        let (used) = WARP_USED_STORAGE.read()`,
        `        WARP_USED_STORAGE.write(used + ${allocationCairoType.width})`,
        `        ${arrayName}.write(loc, len, used)`,
        ...callWriteFunc('used'),
        `    else:`,
        ...callWriteFunc('existing'),
        `    end`,
        `    return ()`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
    return funcName;
  }
}
