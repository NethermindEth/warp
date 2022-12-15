import {
  ArrayType,
  ElementaryTypeName,
  Expression,
  FunctionCall,
  FunctionType,
  InferType,
  IntLiteralType,
  MappingType,
  MemberAccess,
  PointerType,
  StringLiteralType,
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
import {
  generateExpressionTypeString,
  generateExpressionTypeString1,
} from '../utils/getTypeString';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { ast } from 'peggy';
import { partial } from 'lodash';

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
    const replacementNode = replaceUserDefinedType(
      ast.inference,
      safeGetNodeType(node, ast.inference),
    );
    node.typeString = generateExpressionTypeString(replacementNode);
  }

  visitTypeName(node: TypeName, ast: AST): void {
    this.commonVisit(node, ast);
    const tNode = safeGetNodeType(node, ast.inference);
    const replacementNode = replaceUserDefinedType(ast.inference, tNode);
    if (tNode.pp() !== replacementNode.pp()) {
      node.typeString = generateExpressionTypeString(replacementNode);
    }
  }

  visitExpression(node: Expression, ast: AST): void {
    this.commonVisit(node, ast);
    const nodeType = safeGetNodeType(node, ast.inference);
    const replacementNode = replaceUserDefinedType(ast.inference, nodeType);
    node.typeString = generateExpressionTypeString1(ast.inference, node, replacementNode);
  }

  visitUserDefinedTypeName(node: UserDefinedTypeName, ast: AST): void {
    const typeNode = safeGetNodeType(node, ast.inference);
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
        const typeNode = safeGetNodeType(node.vExpression.vExpression, ast.inference);
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

function replaceUserDefinedType(inference: InferType, type: TypeNode): TypeNode {
  const callSelf = partial(replaceUserDefinedType, inference);

  if (type instanceof ArrayType) {
    return new ArrayType(callSelf(type.elementT), type.size, type.src);
  } else if (type instanceof FunctionType) {
    return new FunctionType(
      type.name,
      type.parameters.map(callSelf),
      type.returns.map(callSelf),
      type.visibility,
      type.mutability,
      type.implicitFirstArg,
      type.src,
    );
  } else if (type instanceof MappingType) {
    return new MappingType(callSelf(type.keyType), callSelf(type.valueType), type.src);
  } else if (type instanceof PointerType) {
    return new PointerType(callSelf(type.to), type.location, type.kind, type.src);
  } else if (type instanceof TupleType) {
    return new TupleType(type.elements.map(callSelf), type.src);
  } else if (type instanceof TypeNameType) {
    return new TypeNameType(callSelf(type.type), type.src);
  } else if (type instanceof UserDefinedType) {
    if (type.definition instanceof UserDefinedValueTypeDefinition) {
      return inference.typeNameToTypeNode(type.definition.underlyingType);
    } else return type;
  } else {
    return type;
  }
}
