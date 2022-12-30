import { ASTWriter, Block, SrcDesc } from 'solc-typed-ast';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation, INDENT } from '../utils';

export class BlockWriter extends CairoASTNodeWriter {
  writeInner(node: Block, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    return [
      [
        documentation,
        node.vStatements
          .map((value) => writer.write(value))
          .map((v) =>
            v
              .split('\n')
              .map((line) => INDENT + line)
              .join('\n'),
          )
          .join('\n'),
      ].join('\n'),
    ];
  }
}
