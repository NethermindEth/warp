import { ASTWriter, SrcDesc } from 'solc-typed-ast';
import { CairoAssert } from '../../ast/cairoNodes';
import { CairoASTNodeWriter } from '../base';
import { INDENT } from '../utils';

export class CairoAssertWriter extends CairoASTNodeWriter {
  writeInner(node: CairoAssert, writer: ASTWriter): SrcDesc {
    const expression = writer.write(node.vExpression);
    const assertExpr = `assert( ${expression} = 1 );`;

    if (node.assertMessage === null) {
      return [assertExpr];
    } else {
      return [`assert( ${expression}, "${node.assertMessage}" );`];
    }
  }
}
