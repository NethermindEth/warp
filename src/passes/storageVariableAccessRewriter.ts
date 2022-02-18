import assert = require('assert');

import {
  Assignment,
  FunctionCall,
  Identifier,
  IndexAccess,
  Literal,
  LiteralKind,
  Mapping,
  MappingType,
  PointerType,
  VariableDeclaration,
  getNodeType,
} from 'solc-typed-ast';
import { NotSupportedYetError, WillNotSupportError } from '../utils/errors';
import { cloneExpression, cloneTypeName } from '../utils/cloning';
import { printNode, printTypeNode } from '../utils/astPrinter';
import { toHexString, typeNameFromTypeNode } from '../utils/utils';

import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { CairoContract } from '../ast/cairoNodes';

export class StorageVariableAccessRewriter extends ASTMapper {
  visitAssignment(node: Assignment, ast: AST): void {
    if (node.vLeftHandSide instanceof Identifier) {
      // Replace writes to storage variables with functions
      // other assignments to identifiers work as is
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
    } else if (node.vLeftHandSide instanceof IndexAccess) {
      const lhsType = getNodeType(node.vLeftHandSide.vBaseExpression, ast.compilerVersion);
      if (lhsType instanceof PointerType && lhsType.to instanceof MappingType) {
        const mapping = node.vLeftHandSide.vBaseExpression;
        const index = node.vLeftHandSide.vIndexExpression;
        assert(index !== undefined, 'Write to index access requires defined index');
        const writeValue = node.vRightHandSide;
        const mappingTypeName = new Mapping(
          ast.reserveId(),
          '',
          'Mapping',
          lhsType.to.pp(),
          typeNameFromTypeNode(lhsType.to.keyType, ast),
          typeNameFromTypeNode(lhsType.to.valueType, ast),
        );
        const replacementFunc = ast.cairoUtilFuncGen.writeMapping(
          mapping,
          index,
          mappingTypeName,
          writeValue,
        );
        ast.replaceNode(node, replacementFunc);
        this.dispatchVisit(replacementFunc, ast);
      } else {
        throw new NotSupportedYetError(`Write to ${printTypeNode(lhsType)} not implemented yet`);
      }
    } else {
      this.commonVisit(node, ast);
    }
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

    if (typeName instanceof Mapping) {
      const replacementValue = decl.vValue;
      assert(
        replacementValue !== undefined,
        `StorageVariableAccessRewriter expects mappings to be initialised, did you run storageAllocator? Found at ${printNode(
          node,
        )}`,
      );
      ast.replaceNode(node, cloneExpression(replacementValue, ast));
    } else {
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
  }

  // TODO: Implement enum versions of the storage variable
  //   visitMemberAccess(node: MemberAccess): ASTNode {
  //     if (node.vExpression
  //   }
  replaceStorageVariableAccess(node: IndexAccess, ast: AST): FunctionCall {
    if (node.vIndexExpression === undefined) {
      throw new WillNotSupportError(
        `Undefined index access not handled yet. Is this in abi.decode?`,
      );
    }

    const baseType = getNodeType(node.vBaseExpression, ast.compilerVersion);
    if (baseType instanceof PointerType) {
      if (baseType.to instanceof MappingType) {
        const base = node.vBaseExpression;
        const base_type = getNodeType(node.vBaseExpression, ast.compilerVersion);
        let base_type_to;
        if (base_type instanceof PointerType && base_type.to instanceof MappingType)
          base_type_to = typeNameFromTypeNode(base_type.to, ast);
        if (base instanceof IndexAccess && base_type_to instanceof Mapping) {
          const funcCall = this.replaceStorageVariableAccess(base, ast);
          const replacementFunc_inner = ast.cairoUtilFuncGen.readMapping(
            funcCall,
            node.vIndexExpression,
            base_type_to,
          );
          return replacementFunc_inner;
        } else if (base instanceof Identifier) {
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
          return replacementFunc;
        }
      }
    }
    throw new NotSupportedYetError(`Unhandled index access case ${printNode(node)}`);
  }
  visitIndexAccess(node: IndexAccess, ast: AST): void {
    const replacementFunc = this.replaceStorageVariableAccess(node, ast);
    ast.replaceNode(node, replacementFunc);
    this.dispatchVisit(replacementFunc, ast);
  }
}
