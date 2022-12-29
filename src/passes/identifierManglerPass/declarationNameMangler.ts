import {
  ASTNode,
  ContractDefinition,
  ForStatement,
  FunctionDefinition,
  Identifier,
  SourceUnit,
  StructDefinition,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
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
  nameCounter = 0;

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    node.vStructs.forEach((s) => this.mangleStructDefinition(s));
    node.vFunctions.forEach((n) => this.mangleFunctionDefinition(n, ast));
    node.vContracts.forEach((n) => this.mangleContractDefinition(n, ast));
    this.commonVisit(node, ast);
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    // state variables should have already been mangled at this point
    // by mangleContractDefinition when visiting SourceUnit nodes
    if (!node.stateVariable) this.mangleVariableDeclaration(node);

    this.commonVisit(node, ast);
  }

  visitForStatement(node: ForStatement, ast: AST): void {
    // The declarations in for loops are mangled because the loop functionalisation extracts
    // declarations to the current scope instead of creating a new one.
    if (node.vInitializationExpression instanceof VariableDeclarationStatement) {
      node.vInitializationExpression.vDeclarations.forEach((declaration) => {
        declaration.name = this.createNewVariableName(declaration.name);
      });
    }
    this.commonVisit(node, ast);
  }

  // This strategy should allow checked demangling post transpilation for a more readable result
  createNewFunctionName(fd: FunctionDefinition, ast: AST): string {
    return !isNameless(fd) ? `${fd.name}_${safeCanonicalHash(fd, ast)}` : fd.name;
  }

  createNewVariableName(existingName: string): string {
    return `${MANGLED_WARP}${this.nameCounter++}${existingName !== '' ? `_${existingName}` : ''}`;
  }

  checkCollision(node: VariableDeclaration): boolean {
    const parentContract = node.getClosestParentByType(ContractDefinition);
    const parentScope = node.vScope;

    return (
      parentContract?.name === node.name ||
      parentScope
        .getChildrenByType(Identifier, true)
        .some((identifier) => identifier.name === node.name)
    );
  }

  mangleVariableDeclaration(node: VariableDeclaration): void {
    if (reservedTerms.has(node.name) || node.name === '' || this.checkCollision(node))
      node.name = this.createNewVariableName(node.name);
    checkSourceTerms(node.name, node);
  }

  mangleStructDefinition(node: StructDefinition): void {
    checkSourceTerms(node.name, node);
    node.vMembers.forEach((m) => this.mangleVariableDeclaration(m));
  }

  mangleFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    node.name = this.createNewFunctionName(node, ast);
  }

  mangleContractDefinition(node: ContractDefinition, ast: AST): void {
    checkSourceTerms(node.name, node);
    node.vStructs.forEach((s) => this.mangleStructDefinition(s));
    node.vFunctions.forEach((n) => this.mangleFunctionDefinition(n, ast));
    node.vStateVariables.forEach((v) => this.mangleVariableDeclaration(v));
  }
}
