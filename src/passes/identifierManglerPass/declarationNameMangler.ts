import {
  ASTNode,
  ContractDefinition,
  EventDefinition,
  FunctionDefinition,
  SourceUnit,
  StructDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { WillNotSupportError } from '../../utils/errors';
import { MANGLED_WARP } from '../../utils/nameModifiers';
import { isNameless } from '../../utils/utils';
import { safeCanonicalHash } from '../../utils/nodeTypeProcessing';
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
  const regexStr = unsupportedCharacters.reduce(
    (prevVal, val, i) => (i === 0 ? '\\' + val : (prevVal += '|\\' + val)),
    '',
  );
  // Looking for possible matches
  const regex = RegExp(regexStr, 'g');
  let match;
  let unsupportedCharactersFound = '';
  while ((match = regex.exec(term)) !== null) {
    // Saving all chars founded
    unsupportedCharactersFound += match[0];
  }
  if (unsupportedCharactersFound) {
    throw new WillNotSupportError(
      `${printNode(
        node,
      )} ${term} contains unsupported character(s) "${unsupportedCharactersFound}"`,
    );
  }
}

export class DeclarationNameMangler extends ASTMapper {
  noNameCounter = 0;
  visitSourceUnit(node: SourceUnit, ast: AST): void {
    node.vStructs.forEach((s) => this.mangleStructDefinition(s));
    node.vFunctions.forEach((n) => this.mangleFunctionDefinition(n, ast));
    node.vContracts.forEach((n) => this.mangleContractDefinition(n, ast));
    this.commonVisit(node, ast);
  }

  visitStructDefinition(_node: StructDefinition, _ast: AST): void {
    // struct definitions should have already been mangled at this point
    // by visitSourceUnit and mangleContractDefinition
    return;
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    // state variables should have already been mangled at this point
    // by mangleContractDefinition when visiting SourceUnit nodes
    if (!node.stateVariable) this.mangleVariableDeclaration(node);

    this.commonVisit(node, ast);
  }

  // This strategy should allow checked demangling post transpilation for a more readable result
  createNewFunctionName(fd: FunctionDefinition, ast: AST): string {
    return !isNameless(fd) ? `${fd.name}_${safeCanonicalHash(fd, ast)}` : fd.name;
  }

  createNewVariableName(existingName: string): string {
    return `${MANGLED_WARP}${existingName === '' ? this.noNameCounter++ : existingName}`;
  }

  mangleVariableDeclaration(node: VariableDeclaration): void {
    node.name = this.createNewVariableName(node.name);
  }

  mangleStructDefinition(node: StructDefinition): void {
    checkSourceTerms(node.name, node);
    node.vMembers.forEach((m) => this.mangleVariableDeclaration(m));
  }

  mangleFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    node.name = this.createNewFunctionName(node, ast);
  }

  mangleEventDefinition(node: EventDefinition): void {
    node.name = `${node.name}_${node.canonicalSignatureHash(ABIEncoderVersion.V2)}`;
  }

  mangleContractDefinition(node: ContractDefinition, ast: AST): void {
    checkSourceTerms(node.name, node);
    node.vStructs.forEach((s) => this.mangleStructDefinition(s));
    node.vFunctions.forEach((n) => this.mangleFunctionDefinition(n, ast));
    node.vStateVariables.forEach((v) => this.mangleVariableDeclaration(v));
    node.vEvents.forEach((e) => this.mangleEventDefinition(e));
  }
}
