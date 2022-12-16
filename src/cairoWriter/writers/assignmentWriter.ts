import assert from 'assert';
import { Assignment, ASTWriter, FunctionCall, SrcDesc, TupleExpression } from 'solc-typed-ast';
import { CairoFunctionDefinition, FunctionStubKind } from '../../export';
import { CairoASTNodeWriter } from '../base';

export class AssignmentWriter extends CairoASTNodeWriter {
  writeInner(node: Assignment, writer: ASTWriter): SrcDesc {
    assert(node.operator === '=', `Unexpected operator ${node.operator}`);
    const [lhs, rhs] = [node.vLeftHandSide, node.vRightHandSide];
    const nodes = [lhs, rhs].map((v) => writer.write(v));
    // This is specifically needed because of the construtions involved with writing
    // conditionals (derived from short circuit expressions). Other tuple assignments
    // and function call assignments will have been split
    if (
      rhs instanceof FunctionCall &&
      !(
        rhs.vReferencedDeclaration instanceof CairoFunctionDefinition &&
        rhs.vReferencedDeclaration.functionStubKind === FunctionStubKind.StructDefStub
      ) &&
      !(lhs instanceof TupleExpression)
    ) {
      return [`let (${nodes[0]}) ${node.operator} ${nodes[1]};`];
    }
    return [`let ${nodes[0]} ${node.operator} ${nodes[1]};`];
  }
}
