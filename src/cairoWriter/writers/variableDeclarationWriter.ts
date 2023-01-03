import assert from 'assert';
import { ASTWriter, SourceUnit, SrcDesc, VariableDeclaration } from 'solc-typed-ast';
import { isCairoConstant } from '../../export';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation } from '../utils';

export class VariableDeclarationWriter extends CairoASTNodeWriter {
  writeInner(node: VariableDeclaration, writer: ASTWriter): SrcDesc {
    const documentation = getDocumentation(node.documentation, writer);
    if ((node.stateVariable || node.parent instanceof SourceUnit) && isCairoConstant(node)) {
      assert(node.vValue !== undefined, 'Constant should have a defined value.');
      const constantValue = writer.write(node.vValue);
      return [[documentation, `const ${node.name} = ${constantValue};`].join('\n')];
    }

    return [node.name];
  }
}
