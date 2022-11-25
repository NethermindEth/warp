import {
  ArrayType,
  ElementaryTypeName,
  Expression,
  FunctionCall,
  FunctionType,
  IntLiteralType,
  MappingType,
  MemberAccess,
  PointerType,
  TupleType,
  TypeName,
  TypeNameType,
  TypeNode,
  UserDefinedType,
  UserDefinedTypeName,
  UserDefinedValueTypeDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import assert from 'assert';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { generateExpressionTypeString } from '../utils/getTypeString';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { infer } from '../utils/inference';

class UserDefinedValueTypeDefinitionEliminator extends ASTMapper {
  visitUserDefinedValueTypeDefinition(node: UserDefinedValueTypeDefinition, _ast: AST): void {
    node.vScope.removeChild(node);
  }
}

export class UserDefinedTypesConverter extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    this.commonVisit(node, ast);
    const replacementNode = replaceUserDefinedType(safeGetNodeType(node, ast.compilerVersion));
    node.typeString = generateExpressionTypeString(replacementNode);
  }

  visitTypeName(node: TypeName, ast: AST): void {
    this.commonVisit(node, ast);
    const tNode = safeGetNodeType(node, ast.compilerVersion);
    const replacementNode = replaceUserDefinedType(tNode);
    if (tNode.pp() !== replacementNode.pp()) {
      node.typeString = generateExpressionTypeString(replacementNode);
    }
  }

  visitExpression(node: Expression, ast: AST): void {
    this.commonVisit(node, ast);
    const nodeType = safeGetNodeType(node, ast.compilerVersion);
    if (!(nodeType instanceof IntLiteralType)) {
      const replacementNode = replaceUserDefinedType(nodeType);
      node.typeString = generateExpressionTypeString(replacementNode);
    }
  }

  visitUserDefinedTypeName(node: UserDefinedTypeName, ast: AST): void {
    const typeNode = safeGetNodeType(node, ast.compilerVersion);
    assert(typeNode instanceof UserDefinedType, 'Expected UserDefinedType');
    if (!(typeNode.definition instanceof UserDefinedValueTypeDefinition)) return;

    ast.replaceNode(
      node,
      new ElementaryTypeName(
        node.id,
        node.src,
        typeNode.definition.underlyingType.typeString,
        typeNode.definition.underlyingType.typeString,
      ),
    );
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (node.vExpression instanceof MemberAccess) {
      if (['unwrap', 'wrap'].includes(node.vExpression.memberName)) {
        const typeNode = safeGetNodeType(node.vExpression.vExpression, ast.compilerVersion);
        this.commonVisit(node, ast);
        if (!(typeNode instanceof TypeNameType)) return;
        if (!(typeNode.type instanceof UserDefinedType)) return;
        if (!(typeNode.type.definition instanceof UserDefinedValueTypeDefinition)) return;

        ast.replaceNode(node, node.vArguments[0]);
      } else this.visitExpression(node, ast);
    } else this.visitExpression(node, ast);
  }

  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      const mapper = new this();
      mapper.dispatchVisit(root, ast);
    });

    ast.roots.forEach((root) => {
      const mapper = new UserDefinedValueTypeDefinitionEliminator();
      mapper.dispatchVisit(root, ast);
    });
    return ast;
  }
}

function replaceUserDefinedType(type: TypeNode): TypeNode {
  if (type instanceof ArrayType) {
    return new ArrayType(replaceUserDefinedType(type.elementT), type.size, type.src);
  } else if (type instanceof FunctionType) {
    return new FunctionType(
      type.name,
      type.parameters.map(replaceUserDefinedType),
      type.returns.map(replaceUserDefinedType),
      type.visibility,
      type.mutability,
      type.implicitFirstArg,
      type.src,
    );
  } else if (type instanceof MappingType) {
    return new MappingType(
      replaceUserDefinedType(type.keyType),
      replaceUserDefinedType(type.valueType),
      type.src,
    );
  } else if (type instanceof PointerType) {
    return new PointerType(replaceUserDefinedType(type.to), type.location, type.kind, type.src);
  } else if (type instanceof TupleType) {
    return new TupleType(type.elements.map(replaceUserDefinedType), type.src);
  } else if (type instanceof TypeNameType) {
    return new TypeNameType(replaceUserDefinedType(type.type), type.src);
  } else if (type instanceof UserDefinedType) {
    if (type.definition instanceof UserDefinedValueTypeDefinition) {
      return infer.typeNameToTypeNode(type.definition.underlyingType);
    } else return type;
  } else {
    return type;
  }
}
