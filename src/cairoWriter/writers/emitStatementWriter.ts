import assert from 'assert';
import { ASTWriter, EmitStatement, EventDefinition, SrcDesc } from 'solc-typed-ast';
import { writeWithDocumentation } from '../../utils/writer';
import { CairoASTNodeWriter } from '../base';
import { getDocumentation } from '../utils';

export class EmitStatementWriter extends CairoASTNodeWriter {
  writeInner(node: EmitStatement, writer: ASTWriter): SrcDesc {
    const eventDef = node.vEventCall.vReferencedDeclaration;
    assert(eventDef instanceof EventDefinition, `Expected EventDefintion as referenced type`);

    const documentation = getDocumentation(node.documentation, writer);
    const args: string = node.vEventCall.vArguments.map((v) => writer.write(v)).join(', ');
    return [writeWithDocumentation(documentation, `${eventDef.name}.emit(${args});`)];
  }
}
