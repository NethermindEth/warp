import assert from 'assert';
import {
  ArrayTypeName,
  Assignment,
  BinaryOperation,
  DataLocation,
  ElementaryTypeName,
  FunctionCall,
  FunctionDefinition,
  Identifier,
  IndexAccess,
  Literal,
  MemberAccess,
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
  getFixedBytesArrayMatch(typeString: string): string[] | null {
    const pattern = /^bytes(?:[1-9]$|[1-2]\d$|3[0-2]$)/;
    return typeString.match(pattern);
  }

  // Returns true if the typestring is of fixed-size bytes array type
  isFixedBytesArrayType(typeString: string): boolean {
    const matches = this.getFixedBytesArrayMatch(typeString);
    if (matches !== null) return true;
    return false;
  }

  // Returns the unsigned integer replacement typestring for a fixed-size bytes array.
  replacementTypeString(typeString: string): string {
    assert(this.isFixedBytesArrayType(typeString), 'Node is not of fixed-size bytes type');
    const byteArraySize = parseInt(typeString.slice(5));
    return `uint${byteArraySize * 8}`;
  }

  // Returns the integer value in string for a literal of integer constant type.
  // Fixed-size bytes arrays declarations are literals of integer constant type, but with hex values.
  getLiteralIntValueFromTypeString(node: Literal): number {
    assert(node.typeString.startsWith('int_const '));
    const intString = node.typeString.slice(10);
    return parseInt(intString) || 0;
  }

  visitAssignment(node: Assignment, ast: AST): void {
    if (this.isFixedBytesArrayType(node.typeString)) {
      node.typeString = this.replacementTypeString(node.typeString);

      if (node.vRightHandSide instanceof Literal) {
        const literalIntValue = this.getLiteralIntValueFromTypeString(node.vRightHandSide);
        node.vRightHandSide.value = literalIntValue.toString();
      }
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
      } else if (node.vReferencedDeclaration.vType instanceof ArrayTypeName) {
        this.commonVisit(node.vReferencedDeclaration, ast);

        if (node.vReferencedDeclaration.storageLocation === DataLocation.Default)
          node.typeString = `${node.vReferencedDeclaration.typeString} storage ref`;
        else if (node.vReferencedDeclaration.storageLocation === DataLocation.Memory)
          node.typeString = `${node.vReferencedDeclaration.typeString} memory`;
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

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    if (this.isFixedBytesArrayType(node.typeString)) {
      node.typeString = this.replacementTypeString(node.typeString);
    }
    this.commonVisit(node, ast);
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (this.isFixedBytesArrayType(node.typeString)) {
      node.typeString = this.replacementTypeString(node.typeString);
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
    } else if (
      node.vType instanceof ArrayTypeName &&
      node.vType.vBaseType instanceof ElementaryTypeName &&
      this.isFixedBytesArrayType(node.vType.vBaseType.typeString)
    ) {
      const byteString = this.getFixedBytesArrayMatch(node.vType.vBaseType.typeString);
      assert(
        byteString !== null && byteString.length === 1,
        'Unable to retrieve fixed-sized bytes array base type for array',
      );

      const replacementIntTypeString = this.replacementTypeString(node.vType.vBaseType.typeString);
      node.vType.vBaseType.typeString = node.vType.vBaseType.name = replacementIntTypeString;

      const replacementArrayIntTypeString = node.vType.typeString.replace(
        byteString[0],
        replacementIntTypeString,
      );
      node.typeString = node.vType.typeString = replacementArrayIntTypeString;
    }
  }
}
