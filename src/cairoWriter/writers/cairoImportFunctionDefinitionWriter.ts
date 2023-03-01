import { ASTWriter, SrcDesc } from 'solc-typed-ast';
import { CairoImportFunctionDefinition } from '../../ast/cairoNodes';
import { CairoASTNodeWriter } from '../base';

// Not being used as for now
export class CairoImportFunctionDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: CairoImportFunctionDefinition, _writer: ASTWriter): SrcDesc {
    return [`from ${node.path} import ${node.name}`];
  }
}
