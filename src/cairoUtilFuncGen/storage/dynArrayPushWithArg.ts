import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  FunctionCall,
  generalizeType,
  getNodeType,
  MemberAccess,
  PointerType,
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

export class DynArrayPushWithArgGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageWrite: StorageWriteGen,
    private memoryToStorage: MemoryToStorageGen,
    private storageToStorage: StorageToStorageGen,
    private calldataToStorage: CalldataToStorageGen,
    ast: AST,
  ) {
    super(ast);
  }

  gen(push: FunctionCall, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(push.vExpression instanceof MemberAccess);
    const arrayType = getNodeType(push.vExpression.vExpression, this.ast.compilerVersion);
    assert(arrayType instanceof PointerType && arrayType.to instanceof ArrayType);

    assert(
      push.vArguments.length > 0,
      `Attempted to treat push without argument as push with argument`,
    );
    const [argType, argLoc] = generalizeType(
      getNodeType(push.vArguments[0], this.ast.compilerVersion),
    );

    const name = this.getOrCreate(
      generalizeType(arrayType.to.elementT)[0],
      argType,
      argLoc ?? DataLocation.Default,
    );
    const implicits: Implicits[] =
      argLoc === DataLocation.Memory
        ? ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'warp_memory']
        : ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'];

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
      // TODO update once X->storage are all implemented
      elementWriteFunc = this.memoryToStorage.getOrCreate(elementType);
      inputType = 'felt';
    } else if (argLoc === DataLocation.Storage) {
      elementWriteFunc = this.storageToStorage.getOrCreate(elementType, argType);
      inputType = 'felt';
    } else if (argLoc === DataLocation.CallData) {
      elementWriteFunc = this.calldataToStorage.getOrCreate(elementType);
      inputType = 'felt';
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
        : '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
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
        `        ${elementWriteFunc}(used, value)`,
        `    else:`,
        `        ${elementWriteFunc}(existing, value)`,
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
