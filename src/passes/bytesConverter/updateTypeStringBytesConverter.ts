import {
  ElementaryTypeName,
  Expression,
  VariableDeclaration,
  TypeName,
  BytesType,
  StringType,
  StringLiteralType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { generateExpressionTypeString } from '../../utils/getTypeString';
import { createUint8TypeName, createArrayTypeName } from '../../utils/nodeTemplates';
import { safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { replaceBytesType } from './utils';

/* Convert fixed-size byte arrays (e.g. bytes2, bytes8) to their equivalent unsigned integer.
    This pass does not handle dynamically-sized bytes arrays (i.e. bytes).
*/

export class UpdateTypeStringBytesConverter extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitExpression(node: Expression, ast: AST): void {
    const typeNode = safeGetNodeType(node, ast.inference);
    if (typeNode instanceof StringLiteralType) {
      return;
    }
    node.typeString = generateExpressionTypeString(replaceBytesType(typeNode));
    this.commonVisit(node, ast);
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    const typeNode = replaceBytesType(safeGetNodeType(node, ast.inference));
    node.typeString = generateExpressionTypeString(typeNode);
    this.commonVisit(node, ast);
  }

  visitElementaryTypeName(node: ElementaryTypeName, ast: AST): void {
    const typeNode = ast.inference.typeNameToTypeNode(node);
    if (typeNode instanceof StringType || typeNode instanceof BytesType) {
      ast.replaceNode(node, createArrayTypeName(createUint8TypeName(ast), ast));
      return;
    }
    const replacementTypeNode = replaceBytesType(typeNode);
    if (typeNode.pp() !== replacementTypeNode.pp()) {
      const typeString = generateExpressionTypeString(replacementTypeNode);
      node.typeString = typeString;
      node.name = typeString;
    }
    this.commonVisit(node, ast);
  }

  visitTypeName(node: TypeName, ast: AST): void {
    const typeNode = safeGetNodeType(node, ast.inference);
    const replacementTypeNode = replaceBytesType(typeNode);
    if (typeNode.pp() !== replacementTypeNode.pp()) {
      const typeString = replacementTypeNode.pp();
      node.typeString = typeString;
    }
    this.commonVisit(node, ast);
  }
}
