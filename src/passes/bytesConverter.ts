import {
  ArrayType,
  ArrayTypeName,
  Assignment,
  BinaryOperation,
  DataLocation,
  ElementaryTypeName,
  FixedBytesType,
  FunctionCall,
  FunctionDefinition,
  getNodeType,
  Identifier,
  IndexAccess,
  IntType,
  Literal,
  MemberAccess,
  UnaryOperation,
  typeNameToTypeNode,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { getFunctionTypeString } from '../utils/utils';

/* Convert fixed-size byte arrays (e.g. bytes2, bytes8) to their equivalent unsigned integer.
		This pass currently does not handle dynamically-sized bytes arrays (i.e. bytes).
*/

export class BytesConverter extends ASTMapper {
  // Returns the integer value in string for a literal of integer constant type.
  // Fixed-size bytes arrays declarations are literals of integer constant type, but with hex values.
  replacementLiteralIntValue(node: Literal): string {
    const literalInt = BigInt(node.value);
    return literalInt.toString();
  }

  replacementTypeNode(typeNode: FixedBytesType): IntType {
    return new IntType(typeNode.size * 8, false, undefined);
  }

  visitAssignment(node: Assignment, ast: AST): void {
    const typeNode = getNodeType(node, ast.compilerVersion);
    if (typeNode instanceof FixedBytesType) {
      const replacementTypeNode = this.replacementTypeNode(typeNode);
      node.typeString = replacementTypeNode.pp();
    }
    this.commonVisit(node, ast);
  }

  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    const typeNode = getNodeType(node, ast.compilerVersion);
    if (typeNode instanceof FixedBytesType) {
      const replacementTypeNode = this.replacementTypeNode(typeNode);
      node.typeString = replacementTypeNode.pp();
    }
    this.commonVisit(node, ast);
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    const typeNode = getNodeType(node, ast.compilerVersion);
    if (typeNode instanceof FixedBytesType) {
      const replacementTypeNode = this.replacementTypeNode(typeNode);
      node.typeString = replacementTypeNode.pp();
    }
    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    const typeNode = getNodeType(node, ast.compilerVersion);
    if (typeNode instanceof FixedBytesType) {
      const replacementTypeNode = this.replacementTypeNode(typeNode);
      node.typeString = replacementTypeNode.pp();
    } else if (node.vReferencedDeclaration instanceof VariableDeclaration) {
      const referencedTypeNode = getNodeType(node.vReferencedDeclaration, ast.compilerVersion);
      if (referencedTypeNode instanceof ArrayType) {
        if (node.vReferencedDeclaration.storageLocation === DataLocation.Default)
          node.typeString = `${referencedTypeNode.pp()} storage ref`;
        else if (node.vReferencedDeclaration.storageLocation === DataLocation.Memory)
          node.typeString = `${referencedTypeNode.pp()} memory`;
      }
    } else if (node.vReferencedDeclaration instanceof FunctionDefinition) {
      // Visit FunctionDefinition to ensure variable declarations for bytesN have
      // been replaced with uintN.
      this.commonVisit(node.vReferencedDeclaration, ast);
      node.typeString = getFunctionTypeString(node.vReferencedDeclaration, ast.compilerVersion);
    }
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    const typeNode = getNodeType(node, ast.compilerVersion);
    if (typeNode instanceof FixedBytesType) {
      const replacementTypeNode = this.replacementTypeNode(typeNode);
      node.typeString = replacementTypeNode.pp();
    }
    this.commonVisit(node, ast);
  }

  visitLiteral(node: Literal, _: AST): void {
    if (node.typeString.startsWith('int_const ') && node.value.startsWith('0x')) {
      node.value = this.replacementLiteralIntValue(node);
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    const typeNode = getNodeType(node, ast.compilerVersion);
    if (typeNode instanceof FixedBytesType) {
      const replacementTypeNode = this.replacementTypeNode(typeNode);
      node.typeString = replacementTypeNode.pp();
    } else if (
      node.vExpression instanceof Identifier &&
      node.vExpression.vReferencedDeclaration instanceof VariableDeclaration &&
      node.vExpression.vReferencedDeclaration.vType instanceof ArrayTypeName &&
      node.memberName === 'push'
    ) {
      const replacementTypeString = `function (${node.vExpression.vReferencedDeclaration.vType.vBaseType.typeString})`;
      node.typeString = replacementTypeString;
    }
    this.commonVisit(node, ast);
  }

  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    const typeNode = getNodeType(node, ast.compilerVersion);
    if (typeNode instanceof FixedBytesType) {
      const replacementTypeNode = this.replacementTypeNode(typeNode);
      node.typeString = replacementTypeNode.pp();
    }
    this.commonVisit(node, ast);
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    if (node.vType instanceof ElementaryTypeName) {
      const typeNode = typeNameToTypeNode(node.vType);
      if (typeNode instanceof FixedBytesType) {
        const replacementTypeNode = this.replacementTypeNode(typeNode);
        node.typeString = node.vType.typeString = node.vType.name = replacementTypeNode.pp();

        if (node.vValue instanceof Literal) {
          const literalIntValue = this.replacementLiteralIntValue(node.vValue);
          node.vValue.value = literalIntValue;
        }
      }
    } else if (
      node.vType instanceof ArrayTypeName &&
      node.vType.vBaseType instanceof ElementaryTypeName
    ) {
      const baseTypeNode = typeNameToTypeNode(node.vType.vBaseType);
      if (baseTypeNode instanceof FixedBytesType) {
        const replacementBaseTypeNode = this.replacementTypeNode(baseTypeNode);
        node.vType.vBaseType.typeString = node.vType.vBaseType.name = replacementBaseTypeNode.pp();
        node.typeString = node.vType.typeString = node.vType.typeString.replace(
          baseTypeNode.pp(),
          replacementBaseTypeNode.pp(),
        );
      }
    }
    this.commonVisit(node, ast);
  }
}
