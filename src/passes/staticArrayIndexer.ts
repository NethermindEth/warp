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

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    this.visitExpression(node, ast);

    const expressionType = getNodeType(node, ast.compilerVersion);
    const baseType = getNodeType(node.vBaseExpression, ast.compilerVersion);

    console.log(
      printNode(node),
      node.vBaseExpression instanceof Identifier ? node.vBaseExpression.name : '',
      printTypeNode(baseType),
      isCalldataStaticArray(baseType),
      node.vIndexExpression !== undefined && !(node.vIndexExpression instanceof Literal),
    );
    if (
      isCalldataStaticArray(baseType) &&
      node.vIndexExpression !== undefined &&
      !(node.vIndexExpression instanceof Literal)
    ) {
      assert(node.vBaseExpression instanceof Identifier);
      assert(
        node.vBaseExpression.vReferencedDeclaration !== undefined &&
          node.vBaseExpression.vReferencedDeclaration instanceof VariableDeclaration,
      );

      const refId = node.vBaseExpression.referencedDeclaration;
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
          `memory_${node.vBaseExpression.name}`,
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
          createIdentifier(node.vBaseExpression.vReferencedDeclaration, ast, DataLocation.CallData),
        );
        ast.setContextRecursive(varDeclStmnt);
        ast.setContextRecursive(varDecl);

        parentFunction.vBody?.insertAtBeginning(varDeclStmnt);
        this.staticArrayAccesed.set(refId, varDecl);
      }

      const varDecl = this.staticArrayAccesed.get(refId);
      assert(varDecl !== undefined);

      const indexReplacement = new IndexAccess(
        node.id,
        node.src,
        node.typeString,
        createIdentifier(varDecl, ast, DataLocation.Memory),
        cloneASTNode(node.vIndexExpression, ast),
      );

      ast.replaceNode(node, indexReplacement);
    }
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
