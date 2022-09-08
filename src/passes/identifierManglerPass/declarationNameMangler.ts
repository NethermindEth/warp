import {
  VariableDeclaration,
  FunctionDefinition,
  StructDefinition,
  FunctionVisibility,
  SourceUnit,
  ContractDefinition,
  ASTNode,
} from 'solc-typed-ast';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { WillNotSupportError } from '../../utils/errors';
import {
  MANGLED_INTERNAL_USER_FUNCTION,
  MANGLED_LOCAL_VAR,
  MANGLED_TYPE_NAME,
} from '../../utils/nameModifiers';
import { isNameless } from '../../utils/utils';

// Terms grabbed from here
// https://github.com/starkware-libs/cairo-lang/blob/master/src/starkware/cairo/lang/compiler/cairo.ebnf
export const reservedTerms = new Set<string>([
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
]);

const unsupportedCharacters = ['$'];

export function checkSourceTerms(term: string, node: ASTNode) {
  if (reservedTerms.has(term)) {
    throw new WillNotSupportError(`${printNode(node)} contains ${term} which is a cairo keyword`);
  }

  // Creating the regular expression that match unsupportedCharacters
  let regex_str = '\\' + unsupportedCharacters[0];
  for (let index = 1; index < unsupportedCharacters.length; index++) {
    regex_str += '|\\' + unsupportedCharacters[index];
  }
  // Looking for possible matches
  const regex = RegExp(regex_str, 'g');
  let match;
  let unsupported_characters_found = '';
  while ((match = regex.exec(term)) !== null) {
    // Saving all chars founded
    unsupported_characters_found += match[0];
  }
  if (unsupported_characters_found) {
    throw new WillNotSupportError(
      `${printNode(
        node,
      )} ${term} contains unsupported character(s) "${unsupported_characters_found}"`,
    );
  }
}

export class DeclarationNameMangler extends ASTMapper {
  lastUsedId = 0;

  // This strategy should allow checked demangling post transpilation for a more readable result
  createNewExternalFunctionName(fd: FunctionDefinition): string {
    return !isNameless(fd)
      ? `${fd.name}_${fd.canonicalSignatureHash(ABIEncoderVersion.V2)}`
      : fd.name;
  }

  // This strategy should allow checked demangling post transpilation for a more readable result
  createNewInternalFunctionName(existingName: string): string {
    return `${MANGLED_INTERNAL_USER_FUNCTION}${this.lastUsedId++}_${existingName}`;
  }

  createNewTypeName(existingName: string): string {
    return `${MANGLED_TYPE_NAME}${this.lastUsedId++}_${existingName}`;
  }

  createNewVariableName(existingName: string): string {
    return `${MANGLED_LOCAL_VAR}${this.lastUsedId++}_${existingName}`;
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
    checkSourceTerms(node.name, node);
    node.vMembers.forEach((m) => this.mangleVariableDeclaration(m));
  }
  mangleFunctionDefinition(node: FunctionDefinition): void {
    if (node.isConstructor) return;

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
    checkSourceTerms(node.name, node);
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
