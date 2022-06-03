import {
  MemberAccess,
  ArrayType,
  FunctionCall,
  ASTNode,
  DataLocation,
  SourceUnit,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createUint256TypeName } from '../../utils/nodeTemplates';
import { typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase } from '../base';
import { DynArrayGen } from './dynArray';

export class DynArrayLengthGen extends CairoUtilFuncGenBase {
  constructor(private dynArrayGen: DynArrayGen, ast: AST, sourceUnit: SourceUnit) {
    super(ast, sourceUnit);
  }

  getGeneratedCode(): string {
    return '';
  }

  gen(node: MemberAccess, arrayType: ArrayType, nodeInSourceUnit?: ASTNode): FunctionCall {
    const lengthName = this.dynArrayGen.gen(
      CairoType.fromSol(arrayType.elementT, this.ast, TypeConversionContext.StorageAllocation),
    )[1];

    const functionStub = createCairoFunctionStub(
      `${lengthName}.read`,
      [['name', typeNameFromTypeNode(arrayType, this.ast), DataLocation.Storage]],
      [['len', createUint256TypeName(this.ast)]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? node,
    );

    return createCallToFunction(functionStub, [node.vExpression], this.ast);
  }
}
