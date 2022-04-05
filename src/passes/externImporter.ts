import assert from 'assert';
import {
  ContractDefinition,
  ContractKind,
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
import { formatPath } from '../utils/utils';

export class ExternImporter extends ASTMapper {
  visitIdentifier(node: Identifier, ast: AST): void {
    const declaration = node.vReferencedDeclaration;

    if (declaration === undefined) return;

    const declarationSourceUnit = declaration.getClosestParentByType(SourceUnit);
    const sourceUnit = node.getClosestParentByType(SourceUnit);

    assert(sourceUnit !== undefined, 'Trying to import a definition into an unknown source unit');
    if (declarationSourceUnit === undefined || sourceUnit === declarationSourceUnit) return;

    if (
      declaration instanceof FunctionDefinition ||
      declaration instanceof EnumDefinition ||
      (declaration instanceof ContractDefinition && declaration.kind === ContractKind.Library)
    ) {
      ast.registerImport(node, formatPath(declarationSourceUnit.absolutePath), declaration.name);
    }

    if (
      declaration instanceof StructDefinition ||
      declaration instanceof ErrorDefinition ||
      declaration instanceof UserDefinedValueTypeDefinition ||
      declaration instanceof VariableDeclaration ||
      declaration instanceof ImportDirective
    ) {
      throw new NotSupportedYetError(`Importing ${printNode(declaration)} not implemented yet`);
    }
  }
}
