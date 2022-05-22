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
import { DynArrayGen } from './dynArray';
import { StorageDeleteGen } from './storageDelete';

export class DynArrayPopGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, private storageDelete: StorageDeleteGen, ast: AST) {
    super(ast);
  }

  gen(pop: FunctionCall, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(pop.vExpression instanceof MemberAccess);
    const arrayType = getNodeType(pop.vExpression.vExpression, this.ast.compilerVersion);
    assert(arrayType instanceof PointerType && arrayType.to instanceof ArrayType);

    const name = this.getOrCreate(arrayType.to.elementT);

    const functionStub = createCairoFunctionStub(
      name,
      [['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage]],
      [],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? pop,
    );

    return createCallToFunction(functionStub, [pop.vExpression.vExpression], this.ast);
  }

  private getOrCreate(elementType: TypeNode): string {
    const cairoElementType = CairoType.fromSol(
      elementType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const key = cairoElementType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const [arrayName, lengthName] = this.dynArrayGen.gen(cairoElementType);
    const deleteFuncName = this.storageDelete.genFuncName(generalizeType(elementType)[0]);

    const funcName = `${arrayName}_POP`;
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> ():`,
        `    alloc_locals`,
        `    assert loc = 1`,
        `    let (len) = ${lengthName}.read(loc)`,
        `    let (isEmpty) = uint256_eq(len, Uint256(0,0))`,
        `    assert isEmpty = 0`,
        `    let (newLen) = uint256_sub(len, Uint256(1,0))`,
        `    ${lengthName}.write(loc, newLen)`,
        `    let (elem_loc) = ${arrayName}.read(loc, newLen)`,
        `    return ${deleteFuncName}(elem_loc)`,
        `end`,
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_eq');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
    return funcName;
  }
}
