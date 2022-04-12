import assert from 'assert';
import {
  ASTNode,
  DataLocation,
  FunctionCall,
  getNodeType,
  MemberAccess,
  PointerType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionStubbing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

export class DynArrayPushWithoutArgGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST) {
    super(ast);
  }

  gen(push: FunctionCall, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(push.vExpression instanceof MemberAccess);
    const arrayType = getNodeType(push.vExpression.vExpression, this.ast.compilerVersion);
    const elementType = getNodeType(push, this.ast.compilerVersion);

    const name = this.getOrCreate(
      CairoType.fromSol(elementType, this.ast, TypeConversionContext.StorageAllocation),
    );

    const functionStub = createCairoFunctionStub(
      name,
      [['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage]],
      [
        [
          'newElemLoc',
          typeNameFromTypeNode(elementType, this.ast),
          elementType instanceof PointerType ? DataLocation.Storage : DataLocation.Default,
        ],
      ],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? push,
    );

    return createCallToFunction(functionStub, [push.vExpression.vExpression], this.ast);
  }

  private getOrCreate(elementType: CairoType): string {
    const key = elementType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const [arrayName, lengthName] = this.dynArrayGen.gen(elementType);
    const funcName = `${arrayName}_PUSH`;
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (newElemLoc: felt):`,
        `    alloc_locals`,
        `    let (len) = ${lengthName}.read(loc)`,
        `    let (newLen, carry) = uint256_add(len, Uint256(1,0))`,
        `    assert carry = 0`,
        `    ${lengthName}.write(loc, newLen)`,
        `    let (used) = WARP_USED_STORAGE.read()`,
        `    WARP_USED_STORAGE.write(used + ${elementType.width})`,
        `    ${arrayName}.write(loc, len, used)`,
        `    return (used)`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
    return funcName;
  }
}
