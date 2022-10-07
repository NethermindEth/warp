import {
  VariableDeclaration,
  FunctionDefinition,
  StructDefinition,
  SourceUnit,
  ContractDefinition,
  ASTNode,
  EventDefinition,
} from 'solc-typed-ast';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';
import { WillNotSupportError, TranspileFailedError } from '../../utils/errors';
import {
  MANGLED_INTERNAL_USER_FUNCTION,
  MANGLED_LOCAL_VAR,
  MANGLED_TYPE_NAME,
} from '../../utils/nameModifiers';
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
  lastUsedId = 0;
  // Feel free to increase this value. The greater the value the less probably to
  // execute the code to fix Id's width, but less legible variable names would be.
  initialIdWidth = 2;
  nodesNameModified: ASTNode[] = [];

  // This strategy should allow checked demangling post transpilation for a more readable result
  createNewFunctionName(fd: FunctionDefinition, ast: AST): string {
    return !isNameless(fd) ? `${fd.name}_${safeCanonicalHash(fd, ast)}` : fd.name;
  }

  // Return a new id formatted to achieve the minimum length
  getFormattedId(): string {
    return (this.lastUsedId++).toString().padStart(this.initialIdWidth, '0');
  }

  createNewTypeName(existingName: string): string {
    return `${MANGLED_TYPE_NAME}${this.getFormattedId()}_${existingName}`;
  }

  createNewVariableName(existingName: string): string {
    return `${MANGLED_LOCAL_VAR}${this.getFormattedId()}_${existingName}`;
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
    this.nodesNameModified.push(node);
    node.name = this.createNewVariableName(node.name);
  }

  mangleStructDefinition(node: StructDefinition): void {
    checkSourceTerms(node.name, node);
    node.vMembers.forEach((m) => this.mangleVariableDeclaration(m));
  }

  mangleFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (node.isConstructor) return;
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
  visitSourceUnit(node: SourceUnit, ast: AST): void {
    node.vStructs.forEach((s) => this.mangleStructDefinition(s));
    node.vFunctions.forEach((n) => this.mangleFunctionDefinition(n, ast));
    node.vContracts.forEach((n) => this.mangleContractDefinition(n, ast));
    this.commonVisit(node, ast);

    // Checking if counter is greater than initialIdWidth digits. If so, names are
    // modified to insert 0's to achieve id's fixed width.
    const lastIdSize = this.lastUsedId.toString().length;
    if (lastIdSize > this.initialIdWidth) {
      this.nodesNameModified.forEach((node) => {
        if (node instanceof FunctionDefinition) {
          node.name = this.updateName(node.name, MANGLED_INTERNAL_USER_FUNCTION, lastIdSize);
        } else if (node instanceof VariableDeclaration) {
          node.name = this.updateName(node.name, MANGLED_LOCAL_VAR, lastIdSize);
        } else {
          throw new TranspileFailedError(`Not expected node to update name: ${node}`);
        }
      });
    }
    this.nodesNameModified = []; // Lose all references to avoid consuming unnecessary memory
  }

  // Set Id in a node name 'name' that follows the pattern 'pattern' to a fixed width
  updateName(name: string, pattern: string, lastIdSize: number) {
    const match = new RegExp(`${pattern}([0-9]+)`).exec(name);
    if (match === null) {
      throw new TranspileFailedError(`Expected ${pattern} node name: ${name}`);
    }
    const newName = `${pattern}${match[1].padStart(lastIdSize, '0')}`;
    return name.replace(new RegExp(`${pattern}([0-9]+)`), newName);
  }
}
