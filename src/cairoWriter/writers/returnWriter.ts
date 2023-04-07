import { ASTWriter, Return, SrcDesc } from 'solc-typed-ast';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation } from '../utils';

export class ReturnWriter extends CairoASTNodeWriter {
  writeInner(node: Return, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    const returns = node.vExpression ? writer.write(node.vExpression) : '()';

    return [[documentation, `return ${returns};`].join('\n')];
  }
}
