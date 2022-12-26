import { ASTNode, ASTWriter, SrcDesc } from 'solc-typed-ast';
import { printNode } from '../../utils/astPrinter';
import { CairoASTNodeWriter } from '../base';

export class NotImplementedWriter extends CairoASTNodeWriter {
  writeInner(node: ASTNode, _: ASTWriter): SrcDesc {
    this.logNotImplemented(
      `${node.type} to cairo not implemented yet (found at ${printNode(node)})`,
    );
    return [``];
  }
}
