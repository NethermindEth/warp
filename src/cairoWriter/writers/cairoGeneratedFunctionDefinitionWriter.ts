import { ASTWriter, SrcDesc } from 'solc-typed-ast';
import { CairoGeneratedFunctionDefinition } from '../../ast/cairoNodes/cairoGeneratedFunctionDefinition';
import { CairoASTNodeWriter } from '../base';

export class CairoGeneratedFunctionDefinitionWriter extends CairoASTNodeWriter {
  writeInner(node: CairoGeneratedFunctionDefinition, _writer: ASTWriter): SrcDesc {
    return [node.rawStringDefinition];
  }
}
