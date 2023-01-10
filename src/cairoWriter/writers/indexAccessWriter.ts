import assert from 'assert';
import { ASTWriter, IndexAccess, SrcDesc } from 'solc-typed-ast';
import { isDynamicCallDataArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { CairoASTNodeWriter } from '../base';

export class IndexAccessWriter extends CairoASTNodeWriter {
  writeInner(node: IndexAccess, writer: ASTWriter): SrcDesc {
    assert(node.vIndexExpression !== undefined);
    const baseWritten = writer.write(node.vBaseExpression);
    const indexWritten = writer.write(node.vIndexExpression);
    if (isDynamicCallDataArray(safeGetNodeType(node.vBaseExpression, this.ast.compilerVersion))) {
      return [`${baseWritten}.ptr[${indexWritten}]`];
    }
    return [`${baseWritten}[${indexWritten}]`];
  }
}
