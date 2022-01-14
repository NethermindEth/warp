import assert = require('assert');
import {
  Assignment,
  Identifier,
  VariableDeclaration,
  IndexAccess,
  getNodeType,
  Literal,
  LiteralKind,
  PointerType,
  MappingType,
  Mapping,
} from 'solc-typed-ast';
import { ASTMapper } from '../ast/mapper';
import { cloneTypeName } from '../utils/cloning';
import { AST } from '../ast/ast';
import { printNode } from '../utils/astPrinter';
import { CairoContract } from '../ast/cairoNodes';
import { toHexString } from '../utils/utils';
import { NotSupportedYetError, WillNotSupportError } from '../utils/errors';

export class StorageVariableAccessRewriter extends ASTMapper {
  visitAssignment(node: Assignment, ast: AST): void {
    if (node.vLeftHandSide instanceof Identifier) {
      const decl = node.vLeftHandSide.vReferencedDeclaration;
      if (decl === undefined || !(decl instanceof VariableDeclaration && decl.stateVariable)) {
        this.commonVisit(node, ast);
        return;
      }
      const allocation = node.getClosestParentByType(CairoContract)?.storageAllocations.get(decl);
      assert(
        allocation !== undefined,
        'StorageVariableAccessRewriter expects storage variables to have assigned locations. Did you run storageAllocator?',
      );
      ast.replaceNode(
        node,
        ast.cairoUtilFuncGen.storageWrite(
          decl,
          new Literal(
            ast.reserveId(),
            '',
            'Literal',
            `int_const ${allocation}`,
            LiteralKind.Number,
            toHexString(`${allocation}`),
            `${allocation}`,
          ),
          node.vRightHandSide,
        ),
      );
      // Recurse only to the right, because the lhs is now handled
      // TODO check for any cases this doesn't cover
      this.dispatchVisit(node.vRightHandSide, ast);
      return;
    }
    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    // This is a read. Writes are caught by visitAssignment
    const decl = node.vReferencedDeclaration;
    if (decl === undefined || !(decl instanceof VariableDeclaration && decl.stateVariable)) {
      return;
    }

    assert(
      decl.vType !== undefined,
      'VariableDeclaration.vType should be defined for compiler versions > 0.4.x',
    );

    const typeName = cloneTypeName(decl.vType, ast);

    const parent = node.parent;
    assert(parent !== undefined, `Visited identifier with undefined parent: ${printNode(node)}`);

    const allocation = node.getClosestParentByType(CairoContract)?.storageAllocations.get(decl);
    assert(
      allocation !== undefined,
      'StorageVariableAccessRewriter expects storage variables to have assigned locations. Did you run storageAllocator?',
    );
    ast.replaceNode(
      node,
      ast.cairoUtilFuncGen.storageRead(
        new Literal(
          ast.reserveId(),
          '',
          'Literal',
          `int_const ${allocation}`,
          LiteralKind.Number,
          toHexString(`${allocation}`),
          `${allocation}`,
        ),
        typeName,
      ),
      parent,
    );
  }

  // TODO: Implement enum versions of the storage variable
  //   visitMemberAccess(node: MemberAccess): ASTNode {
  //     if (node.vExpression
  //   }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    if (node.vIndexExpression === undefined) {
      throw new WillNotSupportError(
        `Undefined index access not handled yet. Is this in abi.decode?`,
      );
    }

    const baseType = getNodeType(node.vBaseExpression, ast.compilerVersion);

    if (baseType instanceof PointerType) {
      if (baseType.to instanceof MappingType) {
        const base = node.vBaseExpression;
        assert(base instanceof Identifier);
        const decl = base.vReferencedDeclaration;
        assert(decl instanceof VariableDeclaration);
        assert(decl.vType !== undefined);
        const type = cloneTypeName(decl.vType, ast);
        assert(type instanceof Mapping);
        const replacementFunc = ast.cairoUtilFuncGen.readMapping(
          node.vBaseExpression,
          node.vIndexExpression,
          type,
        );
        ast.replaceNode(node, replacementFunc);
        this.commonVisit(replacementFunc, ast);
        return;
      }
    }
    throw new NotSupportedYetError(`Unhandled index access case ${printNode(node)}`);
  }
}
