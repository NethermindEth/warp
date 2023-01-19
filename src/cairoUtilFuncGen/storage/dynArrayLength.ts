import {
  MemberAccess,
  ArrayType,
  FunctionCall,
  ASTNode,
  DataLocation,
  SourceUnit,
  BytesType,
  StringType,
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
import { CairoUtilFuncGenBase, GeneratedFunctionInfo } from '../base';
import { DynArrayGen } from './dynArray';

export class DynArrayLengthGen extends CairoUtilFuncGenBase {
  constructor(private dynArrayGen: DynArrayGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  getGeneratedCode(): string {
    return '';
  }

  gen(
    node: MemberAccess,
    arrayType: ArrayType | BytesType | StringType,
    nodeInSourceUnit?: ASTNode,
  ): FunctionCall {
    const arrayDef = this.dynArrayGen.gen(
      CairoType.fromSol(
        getElementType(arrayType),
        this.ast,
        TypeConversionContext.StorageAllocation,
      ),
      node,
      nodeInSourceUnit,
    );
    const lengthName = arrayInfo.name + '_LENGHT';

    const funcDef = createCairoGeneratedFunction(
      // TODO: Check what about the .read
      arrayInfo,
      [['name', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage]],
      [['len', createUint256TypeName(this.ast)]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? node,
    );

    return createCallToFunction(funcDef, [node.vExpression], this.ast);
  }
}
