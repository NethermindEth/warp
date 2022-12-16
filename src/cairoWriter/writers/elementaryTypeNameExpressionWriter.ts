import { ASTWriter, ElementaryTypeNameExpression, SrcDesc } from 'solc-typed-ast';
import { CairoASTNodeWriter } from '../base';

export class ElementaryTypeNameExpressionWriter extends CairoASTNodeWriter {
  writeInner(_node: ElementaryTypeNameExpression, _writer: ASTWriter): SrcDesc {
    // ElementaryTypeNameExpressions left in the tree by this point
    // are unreferenced expressions, and that this needs to work without
    // ineffectual statement handling
    return ['0'];
  }
}
