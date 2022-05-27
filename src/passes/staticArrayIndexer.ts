import assert from 'assert';
import {
  ArrayType,
  Assignment,
  DataLocation,
  Expression,
  ExpressionStatement,
  FunctionDefinition,
  generalizeType,
  getNodeType,
  Identifier,
  IndexAccess,
  Literal,
  Mutability,
  NewExpression,
  PointerType,
  StateVariableVisibility,
  TypeNode,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode, printTypeNode } from '../utils/astPrinter';
import { cloneASTNode } from '../utils/cloning';
import { generateExpressionTypeString } from '../utils/getTypeString';
import { createIdentifier } from '../utils/nodeTemplates';
import { specializeType } from '../utils/nodeTypeProcessing';
import { typeNameFromTypeNode } from '../utils/utils';

export class StaticArrayIndexer extends ASTMapper {
  private staticArrayAccesed = new Map<number, VariableDeclaration>();
  private nestedDependence = new Set<number>();

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    this.visitExpression(node, ast);
    const expressionType = getNodeType(node, ast.compilerVersion);
    const baseType = getNodeType(node.vBaseExpression, ast.compilerVersion);

    const [refId, identifier] = getReferenceDeclaration(node.vBaseExpression);

    if (
      this.nestedDependence.has(refId) ||
      (isCalldataStaticArray(baseType) && this.isMemoryNested)
    ) {
      this.nestedDependence.add(refId);
      assert(identifier.vReferencedDeclaration instanceof VariableDeclaration);

      const parentFunction = node.getClosestParentByType(FunctionDefinition);
      assert(
        parentFunction !== undefined,
        'Calldata types must be enclosed in a function definition',
      );

      const exprMemoryType = specializeType(generalizeType(expressionType)[0], DataLocation.Memory);
      const baseMemoryType = specializeType(generalizeType(baseType)[0], DataLocation.Memory);

      // const exprMemoryTypeString = generateExpressionTypeString(exprMemoryType);
      // const exprMemoryTypeName = typeNameFromTypeNode(exprMemoryType, ast);

      console.log('New expr type', printTypeNode(exprMemoryType));

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

        parentFunction.vBody?.insertAtBeginning(varDeclStmnt);
        this.staticArrayAccesed.set(refId, varDecl);
      }

      const varDecl = this.staticArrayAccesed.get(refId);

      assert(varDecl !== undefined);
      assert(node.vIndexExpression instanceof Expression);

      const indexReplacement = new IndexAccess(
        node.id,
        node.src,
        generateExpressionTypeString(exprMemoryType),
        createIdentifier(varDecl, ast, DataLocation.Memory),
        cloneASTNode(node.vIndexExpression, ast),
      );

      ast.replaceNode(node, indexReplacement);
    }
  }

  private isMemoryNested(node: IndexAccess): boolean {
    return (
      isIndexedByNonLiteral(node) ||
      (node.vBaseExpression instanceof IndexAccess && this.isMemoryNested(node))
    );
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

function isIndexedByNonLiteral(node: IndexAccess): boolean {
  return node.vIndexExpression !== undefined && !(node.vIndexExpression instanceof Literal);
}

function getReferenceDeclaration(expr: Expression): [number, Identifier] {
  if (expr instanceof Identifier) {
    return [expr.referencedDeclaration, expr];
  }
  if (expr instanceof IndexAccess) {
    return getReferenceDeclaration(expr.vBaseExpression);
  }

  throw new Error('Unexpected calldata expression');
}
