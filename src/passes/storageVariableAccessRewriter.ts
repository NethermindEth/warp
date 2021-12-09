import {
  Assignment,
  ASTNode,
  Identifier,
  VariableDeclaration,
  IndexAccess,
  Expression,
} from 'solc-typed-ast';
import { ASTMapper } from '../ast/mapper';
import { CairoStorageVariable, CairoStorageVariableKind } from '../ast/cairoNodes';

export class StorageVariableAccessRewriter extends ASTMapper {
  visitAssignment(node: Assignment): ASTNode {
    const lhs = this.visit(node.vLeftHandSide) as Expression;
    const rhs = this.visit(node.vRightHandSide) as Expression;
    if (!(lhs instanceof CairoStorageVariable))
      return new Assignment(
        this.genId(),
        node.src,
        node.type,
        node.typeString,
        node.operator,
        lhs,
        rhs,
        node.raw,
      );

    return new CairoStorageVariable(
      this.genId(),
      node.src,
      'CairoStorageVariable',
      node.typeString,
      lhs.vType,
      lhs.name,
      lhs.isEnum,
      lhs.args.concat(rhs),
      CairoStorageVariableKind.Write,
    );
  }

  visitIdentifier(node: Identifier): ASTNode {
    const n = node.vReferencedDeclaration as VariableDeclaration;
    if (n instanceof VariableDeclaration && n.stateVariable) {
      return new CairoStorageVariable(
        this.genId(),
        node.src,
        'CairoStorageVariable',
        node.typeString,
        n.vType,
        node,
        false,
        [],
        CairoStorageVariableKind.Read,
      );
    }
    return node;
  }

  // TODO: Implement enum versions of the storage variable
  //   visitMemberAccess(node: MemberAccess): ASTNode {
  //     if (node.vExpression
  //   }

  visitIndexAccess(node: IndexAccess): ASTNode {
    // @ts-ignore
    const base = this.visit(node.vBaseExpression) as Expression;
    const index = this.visit(node.vIndexExpression) as Expression;
    if (!(base instanceof CairoStorageVariable)) {
      return new IndexAccess(
        this.genId(),
        node.src,
        node.type,
        node.typeString,
        base,
        index,
        node.raw,
      );
    } else {
      return new CairoStorageVariable(
        this.genId(),
        node.src,
        'CairoStorageVariable',
        node.typeString,
        base.vType,
        base.name,
        base.isEnum,
        base.args.concat(index),
        CairoStorageVariableKind.Read,
      );
    }
  }
}
