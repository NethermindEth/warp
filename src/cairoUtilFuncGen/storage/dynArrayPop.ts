import assert from 'assert';
import {
  ArrayType,
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
import { CairoFunctionDefinition } from '../../export';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { uint256EqImport, uint256Import, uint256SubImport } from '../../utils/importFuncs';
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

  public gen(pop: FunctionCall): FunctionCall {
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

  public getOrCreateFuncDef(
    arrayType: ArrayType | BytesType | StringType,
  ): CairoFunctionDefinition {
    const elementT = getElementType(arrayType);
    const cairoElementType = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const key = cairoElementType.fullStringRepresentation;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(elementT);
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
    const deleteFunc = this.storageDelete.getOrCreateFuncDef(elementType);
    const [dynArray, dynArrayLength] = this.dynArrayGen.getOrCreateFuncDef(elementType);

    const arrayName = dynArray.name;
    const lengthName = dynArrayLength.name;

    const getElemLoc =
      isDynamicArray(elementType) || isMapping(elementType)
        ? [
            `let (elem_loc) = ${arrayName}.read(loc, newLen);`,
            `let (elem_loc) = readId(elem_loc);`,
          ].join('\n')
        : `let (elem_loc) = ${arrayName}.read(loc, newLen);`;

    const funcName = `${arrayName}_POP`;
    return {
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
        `    return ${deleteFunc.name}(elem_loc);`,
        `}`,
      ].join('\n'),
      functionsCalled: [
        this.requireImport(...uint256Import()),
        this.requireImport(...uint256EqImport()),
        this.requireImport(...uint256SubImport()),
        deleteFunc,
        dynArray,
        dynArrayLength,
      ],
    };
  }
}
