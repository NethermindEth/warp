import { ASTWriter, MemberAccess, SrcDesc, TypeNameType } from 'solc-typed-ast';
import { CairoASTNodeWriter } from '../base';

export class MemberAccessWriter extends CairoASTNodeWriter {
  writeInner(node: MemberAccess, writer: ASTWriter): SrcDesc {
    if (this.ast.inference.typeOf(node.vExpression) instanceof TypeNameType) {
      return [`${writer.write(node.vExpression)}::${node.memberName}`];
    } else {
      return [`${writer.write(node.vExpression)}.${node.memberName}`];
    }
  }
}
