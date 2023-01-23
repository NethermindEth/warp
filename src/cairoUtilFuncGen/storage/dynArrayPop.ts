import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  generalizeType,
  MemberAccess,
  SourceUnit,
  StringType,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import {
  getElementType,
  isDynamicArray,
  isMapping,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
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

  gen(pop: FunctionCall): FunctionCall {
    assert(pop.vExpression instanceof MemberAccess);
    const arrayType = generalizeType(
      safeGetNodeType(pop.vExpression.vExpression, this.ast.inference),
    )[0];
    assert(
      arrayType instanceof ArrayType ||
        arrayType instanceof BytesType ||
        arrayType instanceof StringType,
    );

    const funcDef = this.getOrCreateFuncDef(arrayType);
    return createCallToFunction(funcDef, [pop.vExpression.vExpression], this.ast);
  }

  getOrCreateFuncDef(arrayType: TypeNode) {
    const key = `dynArrayPop(${arrayType.pp()})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(getElementType(arrayType));
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage]],
      [],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(elementType: TypeNode): GeneratedFunctionInfo {
    const cairoElementType = CairoType.fromSol(
      elementType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_eq'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_sub'),
    );

    const arrayDef = this.dynArrayGen.getOrCreateFuncDef(elementType);
    const arrayName = arrayDef.name;
    const lengthName = arrayName + '_LENGTH';
    const deleteFuncInfo = this.storageDelete.genFuncName(elementType);

    const getElemLoc =
      isDynamicArray(elementType) || isMapping(elementType)
        ? [
            `let (elem_loc) = ${arrayName}.read(loc, newLen);`,
            `let (elem_loc) = readId(elem_loc);`,
          ].join('\n')
        : `let (elem_loc) = ${arrayName}.read(loc, newLen);`;

    const funcName = `${arrayName}_POP`;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (){`,
        `    alloc_locals;`,
        `    let (len) = ${lengthName}.read(loc);`,
        `    let (isEmpty) = uint256_eq(len, Uint256(0,0));`,
        `    assert isEmpty = 0;`,
        `    let (newLen) = uint256_sub(len, Uint256(1,0));`,
        `    ${lengthName}.write(loc, newLen);`,
        `    ${getElemLoc}`,
        `    return ${deleteFuncInfo.name}(elem_loc);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    return funcInfo;
  }
}
