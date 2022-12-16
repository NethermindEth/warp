import {
  Assignment,
  ASTWriter,
  ExpressionStatement,
  FunctionCall,
  FunctionCallKind,
  SrcDesc,
} from 'solc-typed-ast';
import { CairoAssert } from '../../export';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation } from '../utils';

export class ExpressionStatementWriter extends CairoASTNodeWriter {
  newVarCounter = 0;
  writeInner(node: ExpressionStatement, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    if (
      node.vExpression instanceof FunctionCall &&
      node.vExpression.kind !== FunctionCallKind.StructConstructorCall
    ) {
      return [[documentation, `${writer.write(node.vExpression)};`].join('\n')];
    } else if (node.vExpression instanceof Assignment || node.vExpression instanceof CairoAssert) {
      return [[documentation, `${writer.write(node.vExpression)}`].join('\n')];
    } else {
      return [
        [
          documentation,
          `let __warp_uv${this.newVarCounter++} = ${writer.write(node.vExpression)};`,
        ].join('\n'),
      ];
    }
  }
}
