import { VariableDeclarationStatement, getNodeType } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { getDefaultValue } from '../utils/defaultValueNodes';
import { TranspileFailedError } from '../utils/errors';

export class VariableDeclarationInitialiser extends ASTMapper {
  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): void {
    if (node.vInitialValue) return;

    // We assume the declaration list is only one long in the case it hasn't been initialised.
    // Tuple declarations must be initialised and the rhs cannot contain empty slots
    if (node.vDeclarations.length > 1) {
      throw new TranspileFailedError("Can't instantiate multiple arguments");
    }
    const declaration = node.vDeclarations[0];
    if (!declaration.vType) {
      // This could be transpile failed because a previous pass didn't specify a type,
      throw new TranspileFailedError('Please specify all types');
    }

    node.vInitialValue = getDefaultValue(
      getNodeType(declaration, ast.compilerVersion),
      declaration,
      ast,
    );
    ast.registerChild(node.vInitialValue, node);
  }
}
