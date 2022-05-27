import assert from 'assert';
import {
  ArrayType,
  DataLocation,
  Expression,
  FunctionDefinition,
  generalizeType,
  getNodeType,
  Identifier,
  IndexAccess,
  Literal,
  Mutability,
  PointerType,
  StateVariableVisibility,
  TypeNode,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';
import { generateExpressionTypeString } from '../utils/getTypeString';
import { createIdentifier } from '../utils/nodeTemplates';
import { specializeType } from '../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../utils/utils';

export class StaticArrayIndexer extends ASTMapper {
  /*
    This pass change replace all non literal calldata static array index access for 
    non literal MEMORY static array index access.
    This pass is needed because static arrays are handled as cairo tuples, but cairo
    tuples (for now) can only be indexed by literals
    e.g.
      uint8[3] calldata b = ...
      uint8 x = b[i]
   // gets replaced by:
      uint8[3] calldata b = ...
      uint8[3] memory mem_b  = b
      uint8[x] = mem_b[i]
  */

  // Tracks calldata arrays which already have a memory counterpart
  private staticArrayAccesed = new Map<number, VariableDeclaration>();
  // Tracks nested index access which need to be turned into memory
  private nestedDependence = new Set<number>();

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    // All calldata static array must have an identifer as a base expression
    const idIdentifier = getReferenceDeclaration(node.vBaseExpression);
    if (idIdentifier === null) return this.visitExpression(node, ast);

    const [refId, identifier] = idIdentifier;
    // Do not transform this array if it is not part of nested static arrays
    if (!this.nestedDependence.has(refId) && !isMemoryNested(node))
      return this.visitExpression(node, ast);
    // Add reference so all child calldata index access be transformed to
    // memory regardles of indexer
    this.nestedDependence.add(refId);

    // Visit parent expression and solve
    this.visitExpression(node, ast);

    const expressionType = getNodeType(node, ast.compilerVersion);
    const baseType = getNodeType(node.vBaseExpression, ast.compilerVersion);
    if (isCalldataStaticArray(baseType)) {
      assert(identifier.vReferencedDeclaration instanceof VariableDeclaration);

      const parentFunction = node.getClosestParentByType(FunctionDefinition);
      assert(
        parentFunction !== undefined,
        'Calldata types must be enclosed in a function definition',
      );

      const exprMemoryType = specializeType(generalizeType(expressionType)[0], DataLocation.Memory);
      const baseMemoryType = specializeType(generalizeType(baseType)[0], DataLocation.Memory);

      // Add a memory static array for each calldata static array
      if (!this.staticArrayAccesed.has(refId)) {
        const varDecl = new VariableDeclaration(
          ast.reserveId(),
          '',
          false,
          false,
          `memory_${identifier.name}`,
          parentFunction?.id,
          false,
          DataLocation.Memory,
          StateVariableVisibility.Internal,
          Mutability.Mutable,
          generateExpressionTypeString(baseMemoryType),
          undefined,
          typeNameFromTypeNode(baseMemoryType, ast),
          undefined,
        );
        const varDeclStmnt = new VariableDeclarationStatement(
          ast.reserveId(),
          '',
          [varDecl.id],
          [varDecl],
          createIdentifier(identifier.vReferencedDeclaration, ast, DataLocation.CallData),
        );
        ast.setContextRecursive(varDeclStmnt);
        ast.setContextRecursive(varDecl);

        if (parentFunction.vParameters.vParameters.some((vd) => vd.id === refId)) {
          parentFunction.vBody?.insertAtBeginning(varDeclStmnt);
        } else {
          ast.insertStatementAfter(identifier.vReferencedDeclaration, varDeclStmnt);
        }
        this.staticArrayAccesed.set(refId, varDecl);
      }

      const refVarDecl = this.staticArrayAccesed.get(refId);
      assert(refVarDecl !== undefined);
      assert(node.vIndexExpression instanceof Expression);

      const indexReplacement = new IndexAccess(
        node.id,
        node.src,
        generateExpressionTypeString(exprMemoryType),
        createIdentifier(refVarDecl, ast, DataLocation.Memory),
        cloneASTNode(node.vIndexExpression, ast),
      );

      ast.replaceNode(node, indexReplacement);
      return;
    }
    this.visitExpression(node, ast);
  }
}

function isCalldataStaticArray(type: TypeNode): boolean {
  return (
    type instanceof PointerType &&
    type.location === DataLocation.CallData &&
    type.to instanceof ArrayType &&
    type.to.size !== undefined
  );
}

function isMemoryNested(node: IndexAccess): boolean {
  return (
    isIndexedByNonLiteral(node) ||
    (node.vBaseExpression instanceof IndexAccess && isMemoryNested(node.vBaseExpression))
  );
}

function isIndexedByNonLiteral(node: IndexAccess): boolean {
  return node.vIndexExpression !== undefined && !(node.vIndexExpression instanceof Literal);
}

function getReferenceDeclaration(expr: Expression): [number, Identifier] | null {
  if (expr instanceof Identifier) {
    return [expr.referencedDeclaration, expr];
  }
  if (expr instanceof IndexAccess) {
    return getReferenceDeclaration(expr.vBaseExpression);
  }

  return null;
}
