import {
  MemberAccess,
  ArrayType,
  FunctionCall,
  DataLocation,
  SourceUnit,
  BytesType,
  StringType,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { createUint256TypeName } from '../../utils/nodeTemplates';
import { getElementType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

export class DynArrayLengthGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  public gen(node: MemberAccess, arrayType: ArrayType | BytesType | StringType): FunctionCall {
    const funcDef = this.getOrCreateFuncDef(arrayType);
    return createCallToFunction(funcDef, [node.vExpression], this.ast);
  }

  public getOrCreateFuncDef(arrayType: TypeNode) {
    const arrayFunc = this.dynArrayGen.getOrCreateFuncDef(getElementType(arrayType));

    arrayFunc.name += `_LENGTH`;
    const funcDef = createCairoGeneratedFunction(
      // TODO: Check what about the .read
      arrayInfo,
      [['name', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage]],
      [['len', createUint256TypeName(this.ast)]],
      this.ast,
      this.sourceUnit,
    );

    return funcDef;
  }
}
