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

export class DynArrayPushWithArgGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageWrite: StorageWriteGen,
    private memoryToStorage: MemoryToStorageGen,
    ast: AST,
  ) {
    super(ast);
  }

  gen(push: FunctionCall, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(push.vExpression instanceof MemberAccess);
    const arrayType = getNodeType(push.vExpression.vExpression, this.ast.compilerVersion);
    assert(arrayType instanceof PointerType && arrayType.to instanceof ArrayType);

    const name = this.getOrCreate(arrayType.to.elementT);

    assert(
      push.vArguments.length > 0,
      `Attempted to treat push without argument as push with argument`,
    );
    const [argType, argLoc] = generalizeType(
      getNodeType(push.vArguments[0], this.ast.compilerVersion),
    );

    const functionStub = createCairoFunctionStub(
      name,
      [
        ['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage],
        ['value', typeNameFromTypeNode(argType, this.ast), argLoc ?? DataLocation.Default],
      ],
      [],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? push,
    );

    return createCallToFunction(
      functionStub,
      [push.vExpression.vExpression, push.vArguments[0]],
      this.ast,
    );
  }

  private getOrCreate(elementType: TypeNode): string {
    const key = elementType.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const typeLocation = generalizeType(elementType)[1] ?? DataLocation.Default;
    let elementWriteGen: StorageWriteGen | MemoryToStorageGen;
    if (typeLocation === DataLocation.Default) {
      elementWriteGen = this.storageWrite;
    } else if (typeLocation === DataLocation.Memory) {
      elementWriteGen = this.memoryToStorage;
    } else if (typeLocation === DataLocation.Storage) {
      // TEMP
      elementWriteGen = this.storageWrite;
    } else {
      // TEMP
      elementWriteGen = this.storageWrite;
    }
    const elementWriteFunc = elementWriteGen.getOrCreate(elementType);
    const elementCairoType = CairoType.fromSol(
      elementType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const [arrayName, lengthName] = this.dynArrayGen.gen(elementCairoType);
    const funcName = `${arrayName}_PUSHV${this.generatedFunctions.size}`;
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: ${elementCairoType.toString()}) -> ():`,
        `    alloc_locals`,
        `    let (len) = ${lengthName}.read(loc)`,
        `    let (newLen, carry) = uint256_add(len, Uint256(1,0))`,
        `    assert carry = 0`,
        `    ${lengthName}.write(loc, newLen)`,
        `    let (existing) = ${arrayName}.read(loc, len)`,
        `    if (existing) == 0:`,
        `        let (used) = WARP_USED_STORAGE.read()`,
        `        WARP_USED_STORAGE.write(used + ${elementCairoType.width})`,
        `        ${arrayName}.write(loc, len, used)`,
        `        return ${elementWriteFunc}(used, value)`,
        `    else:`,
        `        return ${elementWriteFunc}(existing, value)`,
        `    end`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
    return funcName;
  }
}
