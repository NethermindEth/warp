import {
  ArrayType,
  ArrayTypeName,
  ContractDefinition,
  DataLocation,
  ElementaryTypeName,
  Expression,
  FixedBytesType,
  FunctionDefinition,
  getNodeType,
  Identifier,
  IntType,
  Literal,
  PointerType,
  SourceUnit,
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

  replacementIntTypeNode(typeNode: FixedBytesType): IntType {
    return new IntType(typeNode.size * 8, false, undefined);
  }

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    node.vVariables.forEach((n) => this.visitVariableDeclaration(n, ast));
    node.vContracts.forEach((n) => this.visitContractDefinition(n, ast));
    node.vStructs.forEach((n) => this.commonVisit(n, ast));
    this.commonVisit(node, ast);
  }

  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    node.vStateVariables.forEach((n) => this.visitVariableDeclaration(n, ast));
    node.vFunctions.forEach((n) => this.commonVisit(n, ast));
    node.vStructs.forEach((n) => this.commonVisit(n, ast));
    this.commonVisit(node, ast);
  }

  visitExpression(node: Expression, ast: AST): void {
    const typeNode = getNodeType(node, ast.compilerVersion);
    console.log('visitExpression - node: ' + node.constructor.name);
    console.log('visitExpression - type node: ' + typeNode.constructor.name);
    if (typeNode instanceof FixedBytesType) {
      const replacementTypeNode = this.replacementIntTypeNode(typeNode);
      node.typeString = replacementTypeNode.pp();
    } else if (typeNode instanceof ArrayType && typeNode.elementT instanceof FixedBytesType) {
      const replacementIntTypeNode = this.replacementIntTypeNode(typeNode.elementT);
      node.typeString = `${replacementIntTypeNode.pp()}[${
        typeNode.size !== undefined ? typeNode.size : ''
      }]`;
    } else if (
      typeNode instanceof PointerType &&
      typeNode.to instanceof ArrayType &&
      typeNode.to.elementT instanceof FixedBytesType
    ) {
      const replacementIntTypeNode = this.replacementIntTypeNode(typeNode.to.elementT);
      typeNode.to.elementT = replacementIntTypeNode;
      if (typeNode.location === DataLocation.Default)
        node.typeString = `${typeNode.to.pp()} storage ref`;
      else if (typeNode.location === DataLocation.Memory)
        node.typeString = `${typeNode.to.pp()} memory`;
      else node.typeString = `${typeNode.to.pp()} storage pointer`;
    }
    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    const typeNode = getNodeType(node, ast.compilerVersion);
    if (typeNode instanceof FixedBytesType) {
      const replacementTypeNode = this.replacementIntTypeNode(typeNode);
      node.typeString = replacementTypeNode.pp();
    } else if (node.vReferencedDeclaration instanceof VariableDeclaration) {
      const referencedTypeNode = getNodeType(node.vReferencedDeclaration, ast.compilerVersion);
      if (referencedTypeNode instanceof ArrayType) {
        if (node.vReferencedDeclaration.storageLocation === DataLocation.Default)
          node.typeString = `${referencedTypeNode.pp()} storage ref`;
        else if (node.vReferencedDeclaration.storageLocation === DataLocation.Memory)
          node.typeString = `${referencedTypeNode.pp()} memory`;
        else node.typeString = `${referencedTypeNode.pp()} storage pointer`;
      }
    } else if (node.vReferencedDeclaration instanceof FunctionDefinition) {
      node.typeString = getFunctionTypeString(node.vReferencedDeclaration, ast.compilerVersion);
    }
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    if (node.vType instanceof ElementaryTypeName) {
      const typeNode = typeNameToTypeNode(node.vType);
      if (typeNode instanceof FixedBytesType) {
        const replacementTypeNode = this.replacementIntTypeNode(typeNode);
        node.typeString = node.vType.typeString = node.vType.name = replacementTypeNode.pp();
      }
    } else if (
      node.vType instanceof ArrayTypeName &&
      node.vType.vBaseType instanceof ElementaryTypeName
    ) {
      const baseTypeNode = typeNameToTypeNode(node.vType.vBaseType);
      if (baseTypeNode instanceof FixedBytesType) {
        const replacementBaseTypeNode = this.replacementIntTypeNode(baseTypeNode);
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
