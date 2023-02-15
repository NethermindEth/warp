import { ASTWriter, SrcDesc } from 'solc-typed-ast';
import { CairoAssert } from '../../ast/cairoNodes';
import { CairoASTNodeWriter } from '../base';

export class CairoAssertWriter extends CairoASTNodeWriter {
  writeInner(node: CairoAssert, writer: ASTWriter): SrcDesc {
    const expression = writer.write(node.vExpression);

    if (node.assertMessage === null) {
      return [`assert( ${expression} = 1 );`];
    } else {
      return [`assert( ${expression} = 1, "${node.assertMessage}" );`];
    }
  }
}
