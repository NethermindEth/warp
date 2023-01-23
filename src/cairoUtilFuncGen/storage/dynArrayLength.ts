import {
  MemberAccess,
  ArrayType,
  FunctionCall,
  ASTNode,
  DataLocation,
  SourceUnit,
  BytesType,
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
import { createUint256TypeName } from '../../utils/nodeTemplates';
import { getElementType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

export class DynArrayLengthGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  getGeneratedCode(): string {
    return '';
  }

  gen(node: MemberAccess, arrayType: ArrayType | BytesType | StringType): FunctionCall {
    const funcDef = this.getOrCreateFuncDef(arrayType);
    return createCallToFunction(funcDef, [node.vExpression], this.ast);
  }

  getOrCreateFuncDef(arrayType: TypeNode) {
    const key = `dynArrayLength(${arrayType.pp()})`;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const arrayInfo = this.dynArrayGen.getOrCreate(
      CairoType.fromSol(
        getElementType(arrayType),
        this.ast,
        TypeConversionContext.StorageAllocation,
      ),
    );
    arrayInfo.name += `.read`;
    const funcDef = createCairoGeneratedFunction(
      // TODO: Check what about the .read
      arrayInfo,
      [['name', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage]],
      [['len', createUint256TypeName(this.ast)]],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }
}
