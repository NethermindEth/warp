import {
  UserDefinedTypeName,
  Identifier,
  MemberAccess,
  VariableDeclaration,
  FunctionDefinition,
  StructDefinition,
  EnumValue,
  UserDefinedValueTypeDefinition,
  ExternalReferenceType,
  FunctionVisibility,
  SourceUnit,
  ContractDefinition,
  ImportDirective,
} from 'solc-typed-ast';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

export class IdentifierMangler extends ASTMapper {
  lastUsedVariableId = 0;
  lastUsedFunctionId = 0;
  lastUsedTypeId = 0;

  // This strategy should allow checked demangling post transpilation for a more readable result
  createNewExternalFunctionName(fd: FunctionDefinition): string {
    return `${fd.name}_${fd.canonicalSignatureHash(ABIEncoderVersion.V2)}`;
  }

  // This strategy should allow checked demangling post transpilation for a more readable result
  createNewInternalFunctionName(existingName: string): string {
    return `__warp_usrfn${this.lastUsedFunctionId++}_${existingName}`;
  }

  createNewTypeName(existingName: string): string {
    return `__warp_usrT${this.lastUsedTypeId++}_${existingName}`;
  }

  createNewVariableName(existingName: string): string {
    return `__warp_usrid${this.lastUsedVariableId++}_${existingName}`;
  }

  visitUserDefinedTypeName(node: UserDefinedTypeName, ast: AST): void {
    if (
      node.vReferencedDeclaration instanceof UserDefinedValueTypeDefinition ||
      node.vReferencedDeclaration instanceof StructDefinition
    ) {
      node.name = node.vReferencedDeclaration.name;
    }

    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, _ast: AST): void {
    if (
      node.vIdentifierType === ExternalReferenceType.UserDefined &&
      (node.vReferencedDeclaration instanceof VariableDeclaration ||
        (node.vReferencedDeclaration instanceof FunctionDefinition &&
          !(node.parent instanceof ImportDirective)))
    ) {
      node.name = node.vReferencedDeclaration.name;
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.commonVisit(node, ast);
    const declaration = node.vReferencedDeclaration;

    if (declaration === undefined) {
      // No declaration means this is a solidity internal identifier
      return;
    } else if (
      declaration instanceof FunctionDefinition ||
      declaration instanceof VariableDeclaration ||
      declaration instanceof EnumValue
    ) {
      node.memberName = declaration.name;
    }
  }
  visitStructDefinition(_node: StructDefinition, _ast: AST): void {
    // struct definitions should already have been mangled at this point
    // by visitContractDefinition and visitSourceUnit
    return;
  }
  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    if (!node.stateVariable) {
      this.mangleVariableDeclaration(node);
    }
    this.commonVisit(node, ast);
  }
  mangleVariableDeclaration(node: VariableDeclaration): void {
    node.name = this.createNewVariableName(node.name);
  }
  mangleStructDefinition(node: StructDefinition): void {
    node.vMembers.forEach((m) => this.mangleVariableDeclaration(m));
  }
  mangleFunctionDefinition(node: FunctionDefinition): void {
    // TODO switch based on type
    switch (node.visibility) {
      case FunctionVisibility.External:
      case FunctionVisibility.Public:
        node.name = this.createNewExternalFunctionName(node);
        break;
      default:
        node.name = this.createNewInternalFunctionName(node.name);
    }
  }
  mangleContractDefinition(node: ContractDefinition): void {
    node.vStructs.forEach((s) => this.mangleStructDefinition(s));
    node.vFunctions.forEach((n) => this.mangleFunctionDefinition(n));
    node.vStateVariables.forEach((v) => this.mangleVariableDeclaration(v));
  }
  visitSourceUnit(node: SourceUnit, ast: AST): void {
    node.vStructs.forEach((s) => this.mangleStructDefinition(s));
    node.vFunctions.forEach((n) => this.mangleFunctionDefinition(n));
    node.vContracts.forEach((n) => this.mangleContractDefinition(n));
    this.commonVisit(node, ast);
  }
}
