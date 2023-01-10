import { ASTWriter, SrcDesc, StructuredDocumentation } from 'solc-typed-ast';
import { CairoASTNodeWriter } from '../base';

export class StructuredDocumentationWriter extends CairoASTNodeWriter {
  writeInner(node: StructuredDocumentation, _writer: ASTWriter): SrcDesc {
    return [`// ${node.text.split('\n').join('\n//')}`];
  }
}
