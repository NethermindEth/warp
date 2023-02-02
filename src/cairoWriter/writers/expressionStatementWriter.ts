import {
  Assignment,
  ASTWriter,
  ExpressionStatement,
  FunctionCall,
  FunctionCallKind,
  SrcDesc,
} from 'solc-typed-ast';
import { CairoAssert } from '../../ast/cairoNodes';
import { writeWithDocumentation } from '../../utils/writer';
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
      return [writeWithDocumentation(documentation, writer.write(node.vExpression))];
    } else if (node.vExpression instanceof Assignment || node.vExpression instanceof CairoAssert) {
      return [writeWithDocumentation(documentation, `${writer.write(node.vExpression)}`)];
    } else {
      return [
        writeWithDocumentation(
          documentation,
          `let __warp_uv${this.newVarCounter++} = ${writer.write(node.vExpression)};`,
        ),
      ];
    }
  }
}
