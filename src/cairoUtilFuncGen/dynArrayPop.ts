import assert = require('assert');
import {
  ArrayType,
  ASTNode,
  FunctionCall,
  getNodeType,
  MemberAccess,
  PointerType,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoType, TypeConversionContext } from '../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToStub } from '../utils/functionStubbing';
import { typeNameFromTypeNode } from '../utils/utils';
import { CairoFunction, CairoUtilFuncGenBase } from './base';
import { DynArrayGen } from './dynArray';

export class DynArrayPopGen extends CairoUtilFuncGenBase {
  constructor(private dynArrayGen: DynArrayGen, ast: AST) {
    super(ast);
  }

  private generatedFunctions: Map<string, CairoFunction> = new Map();
  getGeneratedCode(): string {
    return [...this.generatedFunctions.values()].map((func) => func.code).join('\n\n');
  }

  gen(pop: FunctionCall, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(pop.vExpression instanceof MemberAccess);
    const arrayType = getNodeType(pop.vExpression.vExpression, this.ast.compilerVersion);
    assert(arrayType instanceof PointerType && arrayType.to instanceof ArrayType);

    const name = this.getOrCreate(
      CairoType.fromSol(arrayType.to.elementT, this.ast, TypeConversionContext.StorageAllocation),
    );

    const functionStub = createCairoFunctionStub(
      name,
      [['loc', typeNameFromTypeNode(arrayType, this.ast)]],
      [],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? pop,
    );

    return createCallToStub(functionStub, [pop.vExpression.vExpression], this.ast);
  }

  private getOrCreate(elementType: CairoType): string {
    const key = elementType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const [arrayName, lengthName] = this.dynArrayGen.gen(elementType);
    const funcName = `${arrayName}_POP`;
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> ():`,
        `    alloc_locals`,
        `    let (len) = ${lengthName}.read(loc)`,
        `    let (isEmpty) = uint256_eq(len, Uint256(0,0))`,
        `    assert isEmpty = 0`,
        `    let (newLen) = uint256_sub(len, Uint256(1,0))`,
        `    ${lengthName}.write(loc, newLen)`,
        `    return ()`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_eq');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
    return funcName;
  }
}
