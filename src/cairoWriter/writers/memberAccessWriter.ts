import { ASTWriter, MemberAccess, SrcDesc } from 'solc-typed-ast';
import { CairoASTNodeWriter } from '../base';

export class MemberAccessWriter extends CairoASTNodeWriter {
  writeInner(node: MemberAccess, writer: ASTWriter): SrcDesc {
    return [`${writer.write(node.vExpression)}.${node.memberName}`];
  }
}
