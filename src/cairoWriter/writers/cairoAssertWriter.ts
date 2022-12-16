import { ASTWriter, SrcDesc } from 'solc-typed-ast';
import { CairoAssert } from '../../export';
import { CairoASTNodeWriter } from '../base';
import { INDENT } from '../utils';

export class CairoAssertWriter extends CairoASTNodeWriter {
  writeInner(node: CairoAssert, writer: ASTWriter): SrcDesc {
    const assertExpr = `assert ${writer.write(node.vExpression)} = 1;`;

    if (node.assertMessage === null) {
      return [assertExpr];
    } else {
      return [
        [`with_attr error_message("${node.assertMessage}"){`, `${INDENT}${assertExpr}`, `}`].join(
          '\n',
        ),
      ];
    }
  }
}
