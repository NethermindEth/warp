import { ASTWriter, SrcDesc } from 'solc-typed-ast';
import { CairoImportFunctionDefinition } from '../../ast/cairoNodes';
import { CairoASTNodeWriter } from '../base';

// Not being used as for now
export class CairoImportFunctionDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: CairoImportFunctionDefinition, _writer: ASTWriter): SrcDesc {
    // Functions inside trait are not imported directly, only it's trait. Instead
    // of importing `import::path::Trait::funcName`,
    // we just import `import::path::Trait`
    if (node.path[node.path.length - 1].endsWith('Trait')) {
      return [`use ${node.path.join('::')};`];
    }

    return [`use ${[...node.path, node.name].join('::')};`];
  }
}
