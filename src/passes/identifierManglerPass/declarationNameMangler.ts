import {
  VariableDeclaration,
  FunctionDefinition,
  StructDefinition,
  FunctionVisibility,
  SourceUnit,
  ContractDefinition,
} from 'solc-typed-ast';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import {printNode} from '../../utils/astPrinter';
import { TranspileFailedError } from '../../utils/errors';
import { isNameless } from '../../utils/utils';

export class DeclarationNameMangler extends ASTMapper {
  lastUsedVariableId = 0;
  lastUsedFunctionId = 0;
  lastUsedTypeId = 0;

  rejectList = [
    'ret',
    'return',
    'using',
    'jmp',
    'alloc_locals',
    'rel',
    'func',
    'end',
    'nondet',
    'felt',
    'codeoffset',
    'Uint256',
    'cast',
    'ap',
    'fp',
    'dw',
    '%lang',
    '%builtins',
    'with_attr',
    'static_assert',
    'assert',
    'member',
    'new',
    'call',
    'abs',
    'as',
    'from',
    'local',
    'let',
    'tempvar',
    'const',
    'struct',
    'namespace',
  ];

  mangleUserProvidedName(node: ContractDefinition | StructDefinition | VariableDeclaration) {
    if (this.rejectList.includes(node.name)) {
      throw new TranspileFailedError(`${printNode(node)} name ${node.name} includes a cairo keyword.`);
    }
    node.name = node.name.replaceAll('_', '__').replaceAll('$', '_');
  }

  // This strategy should allow checked demangling post transpilation for a more readable result
  createNewExternalFunctionName(fd: FunctionDefinition): string {
    return !isNameless(fd)
      ? `${fd.name}_${fd.canonicalSignatureHash(ABIEncoderVersion.V2)}`
      : fd.name;
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

  visitStructDefinition(_node: StructDefinition, _ast: AST): void {
    // struct definitions should already have been mangled at this point
    // by visitContractDefinition and visitSourceUnit
    return;
  }
  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    if (!node.stateVariable) {
      this.mangleUserProvidedName(node);
      this.mangleVariableDeclaration(node);
    }

    this.commonVisit(node, ast);
  }

  mangleVariableDeclaration(node: VariableDeclaration): void {
    node.name = this.createNewVariableName(node.name);
  }
  mangleStructDefinition(node: StructDefinition): void {
    this.mangleUserProvidedName(node);
    node.vMembers.forEach((m) => this.mangleVariableDeclaration(m));
  }
  mangleFunctionDefinition(node: FunctionDefinition): void {
    if (node.isConstructor) return;

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
    this.mangleUserProvidedName(node);
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
