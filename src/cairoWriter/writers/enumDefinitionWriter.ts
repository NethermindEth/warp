import { ASTWriter, EnumDefinition, SrcDesc } from 'solc-typed-ast';
import { CairoASTNodeWriter } from '../base';

export class EnumDefinitionWriter extends CairoASTNodeWriter {
  writeInner(_node: EnumDefinition, _writer: ASTWriter): SrcDesc {
    // EnumDefinition nodes do not need to be printed because they
    // would have already been replaced by integer literals
    return [``];
  }
}
