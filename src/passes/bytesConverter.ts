import assert from 'assert';
import {
  Assignment,
  BinaryOperation,
  ElementaryTypeName,
  FunctionCall,
  FunctionDefinition,
  Identifier,
  Literal,
  UnaryOperation,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { getFunctionTypeString } from '../utils/utils';

/* Convert fixed-size byte arrays (e.g. bytes2, bytes8) to their equivalent unsigned integer.
		This pass currently does not handle dynamically-sized bytes arrays (i.e. bytes).
*/

export class BytesConverter extends ASTMapper {
  // Returns true if the typestring is of fixed-size bytes array type
  isFixedBytesArrayType(typeString: string): boolean {
    if ((typeString.startsWith('byte') && typeString.length > 5) || typeString === 'byte')
      return true;
    return false;
  }

  // Returns the unsigned integer replacement typestring for a fixed-size bytes array.
  replacementTypeString(typeString: string): string {
    assert(this.isFixedBytesArrayType(typeString), 'Node is not of fixed-size bytes type');
    const byteArraySize = typeString === 'byte' ? 1 : parseInt(typeString.slice(5));
    assert(
      1 <= byteArraySize && byteArraySize <= 32,
      'Fixed-size bytes must be of size between 1 and 32',
    );
    return `uint${byteArraySize * 8}`;
  }

  // Returns the integer value in string for a literal of integer constant type.
  // Fixed-size bytes arrays declarations are literals of integer constant type, but with hex values.
  getLiteralIntValueFromTypeString(node: Literal): number {
    assert(node.typeString.startsWith('int_const '));
    const intString = node.typeString.slice(11);
    return parseInt(intString) || 0;
  }

  visitAssignment(node: Assignment, ast: AST): void {
    if (this.isFixedBytesArrayType(node.typeString)) {
      node.typeString = this.replacementTypeString(node.typeString);
    }
    this.commonVisit(node, ast);
  }

  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    if (this.isFixedBytesArrayType(node.typeString)) {
      node.typeString = this.replacementTypeString(node.typeString);
    }
    this.commonVisit(node, ast);
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (this.isFixedBytesArrayType(node.typeString)) {
      node.typeString = this.replacementTypeString(node.typeString);
    }
    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    if (node.vReferencedDeclaration instanceof VariableDeclaration) {
      if (this.isFixedBytesArrayType(node.typeString)) {
        node.typeString = this.replacementTypeString(node.typeString);
      }
    } else if (node.vReferencedDeclaration instanceof FunctionDefinition) {
      // Visit FunctionDefinition to ensure variable declarations for bytesN have
      // been replaced with uintN.
      this.commonVisit(node.vReferencedDeclaration, ast);
      const updatedTypeString = getFunctionTypeString(
        node.vReferencedDeclaration,
        ast.compilerVersion,
      );
      node.typeString = updatedTypeString;
    }
  }

  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    if (this.isFixedBytesArrayType(node.typeString)) {
      node.typeString = this.replacementTypeString(node.typeString);
    }
    this.commonVisit(node, ast);
  }

  visitVariableDeclaration(node: VariableDeclaration, _: AST): void {
    if (
      node.vType instanceof ElementaryTypeName &&
      this.isFixedBytesArrayType(node.vType.typeString)
    ) {
      const replacementIntTypeString = this.replacementTypeString(node.vType.typeString);
      node.typeString = node.vType.name = node.vType.typeString = replacementIntTypeString;

      if (node.vValue && node.vValue instanceof Literal) {
        const literalIntValue = this.getLiteralIntValueFromTypeString(node.vValue);
        node.vValue.value = literalIntValue.toString();
      }
    }
  }
}
