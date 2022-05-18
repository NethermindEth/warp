import {
  ArrayTypeName,
  ElementaryTypeName,
  FunctionCall,
  FunctionType,
  getNodeType,
  Identifier,
  Mapping,
  MemberAccess,
  TypeNameType,
  UserDefinedType,
  UserDefinedTypeName,
  UserDefinedValueTypeDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import assert from 'assert';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { TranspileFailedError } from '../utils/errors';
import { generateExpressionTypeString } from '../utils/getTypeString';

class UserDefinedValueTypeDefinitionEliminator extends ASTMapper {
  visitUserDefinedValueTypeDefinition(node: UserDefinedValueTypeDefinition, _ast: AST): void {
    node.vScope.removeChild(node);
  }
}

export class UserDefinedTypesConverter extends ASTMapper {
  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    this.commonVisit(node, ast);
    if (node.vType === undefined)
      throw new TranspileFailedError(`Variable declaration type undefined for ${node.name}`);
    if (node.typeString !== node.vType.typeString) node.typeString = node.vType.typeString;
  }

  visitArrayTypeName(node: ArrayTypeName, ast: AST): void {
    this.commonVisit(node, ast);
    if (node.vBaseType === undefined)
      throw new TranspileFailedError(`Variable declaration type undefined for node id ${node.id}`);
    if (node.typeString.slice(0, node.typeString.lastIndexOf('[')) !== node.vBaseType.typeString)
      node.typeString =
        node.vBaseType.typeString + node.typeString.substring(node.typeString.lastIndexOf('['));
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    this.commonVisit(node, ast);
    const typeNode = getNodeType(node, ast.compilerVersion);
    if (typeNode instanceof UserDefinedType) {
      if (!(typeNode.definition instanceof UserDefinedValueTypeDefinition)) return;
      node.typeString = typeNode.definition.underlyingType.typeString;
    } else if (typeNode instanceof FunctionType) {
      const newTypeString: string = generateExpressionTypeString(typeNode);
      node.typeString = newTypeString;
    }
  }

  visitMapping(node: Mapping, ast: AST): void {
    this.commonVisit(node, ast);
    node.typeString = `mapping(${node.vKeyType.typeString} => ${node.vValueType.typeString})`;
  }

  visitUserDefinedTypeName(node: UserDefinedTypeName, ast: AST): void {
    const typeNode = getNodeType(node, ast.compilerVersion);
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
    this.commonVisit(node, ast);
    if (!(node.vExpression instanceof MemberAccess)) return;
    if (!['unwrap', 'wrap'].includes(node.vExpression.memberName)) return;
    const typeNode = getNodeType(node.vExpression.vExpression, ast.compilerVersion);
    if (!(typeNode instanceof TypeNameType)) return;
    if (!(typeNode.type instanceof UserDefinedType)) return;
    if (!(typeNode.type.definition instanceof UserDefinedValueTypeDefinition)) return;

    ast.replaceNode(node, node.vArguments[0]);
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
