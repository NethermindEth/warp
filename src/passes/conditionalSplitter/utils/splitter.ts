import assert from 'assert';
import {
  Assignment,
  DataLocation,
  ExpressionStatement,
  FunctionCall,
  Mutability,
  StateVariableVisibility,
  VariableDeclaration,
  VariableDeclarationStatement,
  generalizeType,
  TupleExpression,
  Block,
  TupleType,
  TypeNode,
  IntLiteralType,
  StringLiteralType,
  Expression,
  Return,
} from 'solc-typed-ast';
import { AST } from '../../../ast/ast';
import { printNode } from '../../../utils/astPrinter';
import { cloneASTNode } from '../../../utils/cloning';
import {
  createBlock,
  createEmptyTuple,
  createExpressionStatement,
  createIdentifier,
  createVariableDeclarationStatement,
} from '../../../utils/nodeTemplates';
import { safeGetNodeType } from '../../../utils/nodeTypeProcessing';
import { notNull } from '../../../utils/typeConstructs';
import { typeNameFromTypeNode } from '../../../utils/utils';

export function splitTupleAssignment(
  node: Assignment,
  eGen: Generator<string, string, unknown>,
  ast: AST,
): Block {
  const [lhs, rhs] = [node.vLeftHandSide, node.vRightHandSide];
  assert(
    lhs instanceof TupleExpression,
    `Split tuple assignment was called on non-tuple assignment ${node.type} # ${node.id}`,
  );
  const rhsType = safeGetNodeType(rhs, ast.inference);
  assert(
    rhsType instanceof TupleType,
    `Expected rhs of tuple assignment to be tuple type ${printNode(node)}`,
  );

  const block = createBlock([], ast);

  const tempVars = new Map<Expression, VariableDeclaration>(
    lhs.vOriginalComponents.filter(notNull).map((child, index) => {
      const lhsElementType = safeGetNodeType(child, ast.inference);
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
        true, // constant
        false, // indexed
        eGen.next().value,
        block.id,
        false, // stateVariable
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

export function splitFunctionCallWithoutReturn(node: FunctionCall, ast: AST): void {
  // If returns nothing then the function can be called in a previous statement and
  // replace this call with an empty tuple
  const parent = node.parent;
  assert(parent !== undefined, `${printNode(node)} ${node.vFunctionName} has no parent`);
  ast.replaceNode(node, createEmptyTuple(ast));
  ast.insertStatementBefore(parent, createExpressionStatement(ast, node));
}

export function splitFunctionCallWithReturn(
  node: FunctionCall,
  returnType: VariableDeclaration,
  eGen: Generator<string, string, unknown>,
  ast: AST,
): void {
  assert(
    returnType.vType !== undefined,
    'Return types should not be undefined since solidity 0.5.0',
  );
  const location = generalizeType(safeGetNodeType(node, ast.inference))[1] ?? DataLocation.Default;
  const replacementVariable = new VariableDeclaration(
    ast.reserveId(),
    node.src,
    true, // constant
    false, // indexed
    eGen.next().value,
    ast.getContainingScope(node),
    false, // stateVariable
    location,
    StateVariableVisibility.Private,
    Mutability.Constant,
    returnType.typeString,
    undefined, // documentation
    cloneASTNode(returnType.vType, ast),
  );
  const declaration = createVariableDeclarationStatement(
    [replacementVariable],
    cloneASTNode(node, ast),
    ast,
  );
  const temp_var = declaration.vDeclarations[0];

  // a = f() + 5
  // ~>
  // __warp_se = f()
  // a = __warp_se + 5
  ast.insertStatementBefore(node, declaration);
  ast.replaceNode(node, createIdentifier(temp_var, ast));
}

export function splitReturnTuple(node: Return, ast: AST): VariableDeclarationStatement {
  const returnExpression = node.vExpression;
  assert(
    returnExpression !== undefined,
    `Tuple return ${printNode(node)} has undefined value. Expects ${
      node.vFunctionReturnParameters.vParameters.length
    } parameters`,
  );
  const vars = node.vFunctionReturnParameters.vParameters.map((v) => cloneASTNode(v, ast));
  const replaceStatement = createVariableDeclarationStatement(vars, returnExpression, ast);
  ast.insertStatementBefore(node, replaceStatement);

  node.vExpression = new TupleExpression(
    ast.reserveId(),
    '',
    returnExpression.typeString,
    false, // isInlineArray
    vars.map((v) => createIdentifier(v, ast, undefined, node)),
  );
  ast.registerChild(node.vExpression, node);

  return replaceStatement;
}
