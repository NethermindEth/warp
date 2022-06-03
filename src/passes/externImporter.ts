import assert from 'assert';
import {
  ContractDefinition,
  FunctionDefinition,
  Identifier,
  SourceUnit,
  StructDefinition,
  UserDefinedTypeName,
  ASTNode,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import * as pathLib from 'path';
import { CairoContract } from '../ast/cairoNodes';

export class ExternImporter extends ASTMapper {
  visitUserDefinedTypeName(node: UserDefinedTypeName, ast: AST): void {
    const declaration = node.vReferencedDeclaration;
    const declarationSourceUnit = declaration.getClosestParentByType(SourceUnit);
    const sourceUnit = node.getClosestParentByType(SourceUnit);

    assert(sourceUnit !== undefined, 'Trying to import a definition into an unknown source unit');
    assert(
      declarationSourceUnit !== undefined,
      'Trying to import a definition from an unknown source unit',
    );

    if (
      sourceUnit !== declarationSourceUnit &&
      declaration instanceof StructDefinition &&
      isFree(declaration)
    ) {
      ast.registerImport(node, formatPath(declarationSourceUnit.absolutePath), declaration.name);
    }

    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    const declaration = node.vReferencedDeclaration;
    if (declaration === undefined) return;

    const declarationSourceUnit = declaration.getClosestParentByType(SourceUnit);
    const sourceUnit = node.getClosestParentByType(SourceUnit);

    assert(sourceUnit !== undefined, 'Trying to import a definition into an unknown source unit');
    if (declarationSourceUnit === undefined || sourceUnit === declarationSourceUnit) return;

    if (
      declaration instanceof FunctionDefinition ||
      (declaration instanceof StructDefinition && isFree(declaration))
    ) {
      ast.registerImport(node, formatPath(declarationSourceUnit.absolutePath), declaration.name);
    }

    if (declaration instanceof CairoContract) {
      ast.registerImport(node, formatPath(declarationSourceUnit.absolutePath), declaration.name);
    }
  }
}

function isFree(node: ASTNode): boolean {
  return node.getClosestParentByType(ContractDefinition) === undefined;
}

function formatPath(path: string): string {
  assert(path.length > 0, 'Attempted to format empty import path');
  const base = path.endsWith('.sol') ? path.slice(0, -'.sol'.length) : path;
  return base.replaceAll(pathLib.sep, '.');
}
