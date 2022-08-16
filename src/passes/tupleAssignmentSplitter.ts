import assert from 'assert';
import {
  Assignment,
  Block,
  DataLocation,
  Expression,
  ExpressionStatement,
  generalizeType,
  IntLiteralType,
  Mutability,
  Return,
  StateVariableVisibility,
  StringLiteralType,
  TupleExpression,
  TupleType,
  TypeNode,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { cloneASTNode } from '../utils/cloning';
import { TUPLE_VALUE_PREFIX } from '../utils/nameModifiers';
import { createBlock, createIdentifier } from '../utils/nodeTemplates';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { notNull } from '../utils/typeConstructs';
import { typeNameFromTypeNode } from '../utils/utils';

// Converts a non-declaration tuple assignment into a declaration of temporary variables,
// and piecewise assignments (x,y) = (y,x) -> (int a, int b) = (y,x); x = a; y = b;

// Also converts tuple returns into a tuple declaration and elementwise return
// This allows type conversions in cases where the individual elements would otherwise not be
// accessible, such as when returning a function call

export class TupleAssignmentSplitter extends ASTMapper {
  lastTempVarNumber = 0;

  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  newTempVarName(): string {
    return `${TUPLE_VALUE_PREFIX}${this.lastTempVarNumber++}`;
  }

  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.vExpression instanceof Assignment) {
      if (node.vExpression.vLeftHandSide instanceof TupleExpression) {
        ast.replaceNode(node, this.splitTupleAssignment(node.vExpression, ast));
      }
    }
  }

  visitReturn(node: Return, ast: AST): void {
    this.commonVisit(node, ast);

    if (node.vFunctionReturnParameters.vParameters.length > 1) {
      const returnExpression = node.vExpression;
      assert(
        returnExpression !== undefined,
        `Tuple return ${printNode(node)} has undefined value. Expects ${
          node.vFunctionReturnParameters.vParameters.length
        } parameters`,
      );
      const vars = node.vFunctionReturnParameters.vParameters.map((v) => cloneASTNode(v, ast));
      ast.insertStatementBefore(
        node,
        new VariableDeclarationStatement(
          ast.reserveId(),
          '',
          vars.map((d) => d.id),
          vars,
          returnExpression,
        ),
      );

      node.vExpression = new TupleExpression(
        ast.reserveId(),
        '',
        returnExpression.typeString,
        false,
        vars.map((v) => createIdentifier(v, ast, undefined, node)),
      );
      ast.registerChild(node.vExpression, node);
    }
  }

  splitTupleAssignment(node: Assignment, ast: AST): Block {
    const [lhs, rhs] = [node.vLeftHandSide, node.vRightHandSide];
    assert(
      lhs instanceof TupleExpression,
      `Split tuple assignment was called on non-tuple assignment ${node.type} # ${node.id}`,
    );
    const rhsType = safeGetNodeType(rhs, ast.compilerVersion);
    assert(
      rhsType instanceof TupleType,
      `Expected rhs of tuple assignment to be tuple type ${printNode(node)}`,
    );

    const block = createBlock([], ast);

    const tempVars = new Map<Expression, VariableDeclaration>(
      lhs.vOriginalComponents.filter(notNull).map((child, index) => {
        const lhsElementType = safeGetNodeType(child, ast.compilerVersion);
        const rhsElementType = rhsType.elements[index];

        // We need to calculate a type and location for the temporary variable
        // By default we can use the rhs value, unless it is a literal
        let typeNode: TypeNode;
        let location: DataLocation | undefined;
        if (rhsElementType instanceof IntLiteralType) {
          [typeNode, location] = generalizeType(lhsElementType);
        } else if (rhsElementType instanceof StringLiteralType) {
          typeNode = generalizeType(lhsElementType)[0];
          location = DataLocation.Memory;
        } else {
          [typeNode, location] = generalizeType(rhsElementType);
        }
        const typeName = typeNameFromTypeNode(typeNode, ast);
        const decl = new VariableDeclaration(
          ast.reserveId(),
          node.src,
          true,
          false,
          this.newTempVarName(),
          block.id,
          false,
          location ?? DataLocation.Default,
          StateVariableVisibility.Default,
          Mutability.Constant,
          typeNode.pp(),
          undefined,
          typeName,
        );
        ast.setContextRecursive(decl);
        return [child, decl];
      }),
    );

    const tempTupleDeclaration = new VariableDeclarationStatement(
      ast.reserveId(),
      node.src,
      lhs.vOriginalComponents.map((n) => (n === null ? null : tempVars.get(n)?.id ?? null)),
      [...tempVars.values()],
      node.vRightHandSide,
    );

    const assignments = [...tempVars.entries()]
      .filter(([_, tempVar]) => tempVar.storageLocation !== DataLocation.CallData)
      .map(
        ([target, tempVar]) =>
          new ExpressionStatement(
            ast.reserveId(),
            node.src,
            new Assignment(
              ast.reserveId(),
              node.src,
              target.typeString,
              '=',
              target,
              createIdentifier(tempVar, ast, undefined, node),
            ),
          ),
      )
      .reverse();

    block.appendChild(tempTupleDeclaration);
    assignments.forEach((n) => block.appendChild(n));
    ast.setContextRecursive(block);
    return block;
  }
}
