import { ASTWriter, EventDefinition, SrcDesc } from 'solc-typed-ast';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation } from '../utils';

export class EventDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: EventDefinition, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    const args: string = writer.write(node.vParameters);
    return [[documentation, `// @event`, `// func ${node.name}(${args}){`, `// }`].join('\n')];
  }
}
