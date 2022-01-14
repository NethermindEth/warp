import { assert } from 'console';
import {
  ContractDefinition,
  EnumDefinition,
  ErrorDefinition,
  FunctionDefinition,
  Identifier,
  ImportDirective,
  SourceUnit,
  StructDefinition,
  UserDefinedValueTypeDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { NotSupportedYetError } from '../utils/errors';

export class ExternImporter extends ASTMapper {
  visitIdentifier(node: Identifier, ast: AST): void {
    const declaration = node.vReferencedDeclaration;

    if (declaration === undefined) return;

    const sourceUnit = declaration.getClosestParentByType(SourceUnit);

    if (sourceUnit === undefined || sourceUnit === ast.root) return;

    if (declaration instanceof ContractDefinition) {
      ast.addImports({
        [formatPath(declaration.vScope.absolutePath)]: new Set([declaration.name]),
      });
    }

    if (
      declaration instanceof StructDefinition ||
      declaration instanceof EnumDefinition ||
      declaration instanceof ErrorDefinition ||
      declaration instanceof FunctionDefinition ||
      declaration instanceof UserDefinedValueTypeDefinition ||
      declaration instanceof VariableDeclaration ||
      declaration instanceof ImportDirective
    ) {
      throw new NotSupportedYetError(`Importing ${printNode(declaration)} not implemented yet`);
    }
  }
}

//TODO do this properly

function formatPath(path: string): string {
  assert(path.length > 0, 'Attempted to format empty import path');
  const splitPath = path.split('/');
  return splitPath[splitPath.length - 1].replace('.sol', '');
}
