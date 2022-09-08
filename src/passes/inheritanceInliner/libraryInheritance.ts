import assert from 'assert';
import { ContractDefinition, ContractKind } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoContract } from '../../ast/cairoNodes';
import { getBaseContracts } from './utils';

export function solveLibraryInheritance(node: CairoContract, ast: AST) {
  const libraryIds = collectAllLibrariesId(ast);
  node.linearizedBaseContracts.push(...getLibrariesInInheritanceLine(node, libraryIds));
}

function getLibrariesInInheritanceLine(node: CairoContract, libraryIds: Set<number>) {
  const libraries: Set<number> = new Set();
  getBaseContracts(node).forEach((contract) =>
    contract.linearizedBaseContracts
      .filter((id) => !node.linearizedBaseContracts.includes(id))
      .forEach((contractId) => {
        assert(libraryIds.has(contractId), `Contract #${contractId} should be a library`);
        libraries.add(contractId);
      }),
  );
  return libraries;
}

function collectAllLibrariesId(ast: AST): Set<number> {
  const librariesById: Set<number> = new Set();
  ast.context.map.forEach((astNode, id) => {
    if (astNode instanceof ContractDefinition && astNode.kind === ContractKind.Library)
      librariesById.add(id);
  });
  return librariesById;
}
