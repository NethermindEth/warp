import { ASTWriter, IfStatement, SrcDesc } from 'solc-typed-ast';
import { notUndefined } from '../../export';
import { writeWithDocumentation } from '../../utils/writer';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation } from '../utils';

export class IfStatementWriter extends CairoASTNodeWriter {
  writeInner(node: IfStatement, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    return [
      writeWithDocumentation(
        documentation,
        [
          `if (${writer.write(node.vCondition)} != 0){`,
          writer.write(node.vTrueBody),
          ...(node.vFalseBody ? ['}else{', writer.write(node.vFalseBody)] : []),
          '}',
        ]
          .filter(notUndefined)
          .flat()
          .join('\n'),
      ),
    ];
  }
}
