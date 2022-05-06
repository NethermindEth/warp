import assert from 'assert';
import {
  ErrorDefinition,
  FunctionDefinition,
  Identifier,
  ImportDirective,
  SourceUnit,
  StructDefinition,
  UserDefinedValueTypeDefinition,
  VariableDeclaration,
  UserDefinedTypeName,
  getNodeType,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { NotSupportedYetError } from '../utils/errors';
import * as pathLib from 'path';

export class ExternImporter extends ASTMapper {
  /*visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
      node.vParameters.vParameters.forEach((parameter) => {
        const typeNode = getNodeType(parameter, ast.compilerVersion);
        const declarationSourceUnit = node.getClosestParentByType(SourceUnit);
        const sourceUnit = node.getClosestParentByType(SourceUnit);

        assert(sourceUnit !== undefined, 'Trying to import a definition into an unknown source unit');
    if (declarationSourceUnit === undefined || sourceUnit === declarationSourceUnit) return; 
        if (typeNode instanceof UserDefinedTypeName && 
          typeNode.vReferencedDeclaration instanceof StructDefinition) {
            ast.registerImport(node, formatPath(declarationSourceUnit.absolutePath), node.name);
        }
      });
      return;
    }*/
  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    const declaration = node.vType;
    let declarationSourceUnit;
    if (declaration instanceof UserDefinedTypeName) {
      declarationSourceUnit = declaration.vReferencedDeclaration.getClosestParentByType(SourceUnit);
    } else {
      declarationSourceUnit = declaration?.getClosestParentByType(SourceUnit);
    }
    const sourceUnit = node.getClosestParentByType(SourceUnit);

    assert(sourceUnit !== undefined, 'Trying to import a definition into an unknown source unit');
    //if (declarationSourceUnit === undefined || sourceUnit === declarationSourceUnit) return;

    if (
      declarationSourceUnit !== undefined &&
      sourceUnit !== declarationSourceUnit &&
      declaration instanceof UserDefinedTypeName &&
      declaration.vReferencedDeclaration instanceof StructDefinition
    ) {
      ast.registerImport(
        node,
        formatPath(declarationSourceUnit.absolutePath),
        declaration.vReferencedDeclaration.name,
      );
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

    if (declaration instanceof FunctionDefinition || declaration instanceof StructDefinition) {
      ast.registerImport(node, formatPath(declarationSourceUnit.absolutePath), declaration.name);
    }

    if (
      declaration instanceof ErrorDefinition ||
      declaration instanceof UserDefinedValueTypeDefinition ||
      declaration instanceof VariableDeclaration ||
      declaration instanceof ImportDirective
    ) {
      throw new NotSupportedYetError(`Importing ${printNode(declaration)} not implemented yet`);
    }
  }
}

function formatPath(path: string): string {
  assert(path.length > 0, 'Attempted to format empty import path');
  const base = path.endsWith('.sol') ? path.slice(0, -'.sol'.length) : path;
  return base.replaceAll(pathLib.sep, '.');
}
