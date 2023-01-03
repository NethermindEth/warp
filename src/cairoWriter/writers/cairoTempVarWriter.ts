import { ASTWriter, SrcDesc } from 'solc-typed-ast';
import { CairoTempVarStatement } from '../../ast/cairoNodes';
import { CairoASTNodeWriter } from '../base';

export class CairoTempVarWriter extends CairoASTNodeWriter {
  writeInner(node: CairoTempVarStatement, _writer: ASTWriter): SrcDesc {
    return [`tempvar ${node.name} = ${node.name}`];
  }
}
