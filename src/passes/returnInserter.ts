import { ASTNode, FunctionDefinition, Block, Return } from 'solc-typed-ast';
import { ASTMapper } from '../ast/mapper';

export class ReturnInserter extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition): ASTNode {
    const body = node.vBody ? this.addReturn(node.vBody) : undefined;
    return new FunctionDefinition(
      this.genId(),
      node.src,
      node.type,
      node.scope,
      node.kind,
      node.name,
      node.virtual,
      node.visibility,
      node.stateMutability,
      node.isConstructor,
      node.vParameters,
      node.vReturnParameters,
      node.vModifiers,
      node.vOverrideSpecifier,
      body,
      node.documentation,
      node.nameLocation,
      node.raw,
    );
  }

  addReturn(node: Block): Block {
    if (node.vStatements.some((value) => value instanceof Return)) {
      return node;
    } else {
      return new Block(
        this.genId(),
        node.src,
        node.type,
        [
          ...node.vStatements,
          new Return(
            this.genId(),
            node.src,
            'Return',
            (node.parent as FunctionDefinition).vReturnParameters.id,
          ),
        ],
        node.documentation,
        node.raw,
      );
    }
  }

  getPassName(): string {
    return 'Return Inserter';
  }
}
