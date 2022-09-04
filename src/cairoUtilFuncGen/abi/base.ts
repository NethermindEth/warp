import {
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  SourceUnit,
  TypeNode,
} from 'solc-typed-ast';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createBytesTypeName } from '../../utils/nodeTemplates';
import { isValueType, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../../utils/utils';
import { StringIndexedFuncGenWithAuxiliar } from '../base';

export abstract class AbiBase extends StringIndexedFuncGenWithAuxiliar {
  protected functionName = 'not_implemented';

  public gen(expressions: Expression[], sourceUnit?: SourceUnit): FunctionCall {
    const exprTypes = expressions.map(
      (expr) => generalizeType(safeGetNodeType(expr, this.ast.compilerVersion))[0],
    );
    const functionName = this.getOrCreate(exprTypes);

    const functionStub = createCairoFunctionStub(
      functionName,
      exprTypes.map((exprT, index) =>
        isValueType(exprT)
          ? [`param${index}`, typeNameFromTypeNode(exprT, this.ast)]
          : [`param${index}`, typeNameFromTypeNode(exprT, this.ast), DataLocation.Memory],
      ),
      [['result', createBytesTypeName(this.ast), DataLocation.Memory]],
      ['bitwise_ptr', 'range_check_ptr', 'warp_memory'],
      this.ast,
      sourceUnit ?? this.sourceUnit,
    );

    return createCallToFunction(functionStub, expressions, this.ast);
  }

  public getOrCreate(_types: TypeNode[]): string {
    throw new Error('Method not implemented.');
  }

  public getOrCreateEncoding(_type: TypeNode): string {
    throw new Error('Method not implemented.');
  }
}
