import { ASTWriter, SrcDesc, TupleExpression } from 'solc-typed-ast';
import { CairoASTNodeWriter } from '../base';

export class TupleExpressionWriter extends CairoASTNodeWriter {
  writeInner(node: TupleExpression, writer: ASTWriter): SrcDesc {
    return [`(${node.vComponents.map((value) => writer.write(value)).join(', ')})`];
  }
}
