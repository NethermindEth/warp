import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  BytesType,
  DataLocation,
  FunctionCall,
  generalizeType,
  MemberAccess,
  SourceUnit,
  StringType,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import {
  getElementType,
  isDynamicArray,
  isMapping,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';
import { StorageDeleteGen } from './storageDelete';

export class DynArrayPopGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageDelete: StorageDeleteGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  gen(pop: FunctionCall, nodeInSourceUnit?: ASTNode): FunctionCall {
    assert(pop.vExpression instanceof MemberAccess);
    const arrayType = generalizeType(
      safeGetNodeType(pop.vExpression.vExpression, this.ast.inference),
    )[0];
    assert(
      arrayType instanceof ArrayType ||
        arrayType instanceof BytesType ||
        arrayType instanceof StringType,
    );

    const name = this.getOrCreate(getElementType(arrayType));

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
    const deleteFuncName = this.storageDelete.genFuncName(elementType);

    const getElemLoc =
      isDynamicArray(elementType) || isMapping(elementType)
        ? [
            `let (elem_loc) = ${arrayName}.read(loc, newLen);`,
            `let (elem_loc) = readId(elem_loc);`,
          ].join('\n')
        : `let (elem_loc) = ${arrayName}.read(loc, newLen);`;

    const funcName = `${arrayName}_POP`;
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (){`,
        `    `,
        `    let (len) = ${lengthName}.read(loc);`,
        `    let (isEmpty) = uint256_eq(len, u256(0,0));`,
        `    assert isEmpty = 0;`,
        `    let (newLen) = uint256_sub(len, u256(1,0));`,
        `    ${lengthName}.write(loc, newLen);`,
        `    ${getElemLoc}`,
        `    return ${deleteFuncName}(elem_loc);`,
        `}`,
      ].join('\n'),
    });
    this.requireImport('starkware.cairo.common.uint256', 'u256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_eq');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
    return funcName;
  }
}
