import { ASTWriter, BinaryOperation, SrcDesc } from 'solc-typed-ast';
import { CairoASTNodeWriter } from '../base';

export class BinaryOperationWriter extends CairoASTNodeWriter {
  writeInner(node: BinaryOperation, writer: ASTWriter): SrcDesc {
    const args = [node.vLeftExpression, node.vRightExpression].map((v) => writer.write(v));
    return [`${args[0]} ${node.operator} ${args[1]}`];
  }
}
