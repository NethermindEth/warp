import { ASTWriter, SrcDesc, UncheckedBlock } from 'solc-typed-ast';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation, INDENT } from '../utils';

export class UncheckedBlockWriter extends CairoASTNodeWriter {
  writeInner(node: UncheckedBlock, writer: ASTWriter): SrcDesc {
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
