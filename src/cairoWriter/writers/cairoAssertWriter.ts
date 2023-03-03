import { ASTWriter, SrcDesc } from 'solc-typed-ast';
import { CairoAssert } from '../../ast/cairoNodes';
import { CairoASTNodeWriter } from '../base';

export class CairoAssertWriter extends CairoASTNodeWriter {
  writeInner(node: CairoAssert, writer: ASTWriter): SrcDesc {
    const expression = writer.write(node.vExpression);
    const message = node.assertMessage ?? 'Assertion error';
    return [`assert( ${expression}, "${message}" );`];
  }
}
