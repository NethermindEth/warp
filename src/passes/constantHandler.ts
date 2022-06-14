import {
  DataLocation,
  ElementaryTypeName,
  FunctionDefinition,
  Literal,
  Mutability,
  StateVariableVisibility,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneDocumentation } from '../utils/cloning';
import { collectUnboundVariables } from '../utils/functionGeneration';
import { primitiveTypeToCairo } from '../utils/utils';

export class ConstantHandler extends ASTMapper {
  // Visit all functions and inject 256 bit constants into the functions that
  // refer to these constants. Constants less than 256 bits are handled as native
  // Cairo constants that are directly printed in cairoWriter.ts
  // Note that all constants are excluded from the storage passes.

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (node.vBody === undefined) return;

    const unboundConstantsToReplace = new Map(
      [...collectUnboundVariables(node.vBody).entries()].filter(
        ([decl]) =>
          decl.mutability === Mutability.Constant &&
          decl.vValue instanceof Literal &&
          decl.vType instanceof ElementaryTypeName &&
          primitiveTypeToCairo(decl.vType.name) === 'Uint256',
      ),
    );

    const block = node.vBody;
    const blockId = block.id;

    [...unboundConstantsToReplace.entries()].map(([decl, ids]) => {
      if (
        decl.vType === undefined ||
        decl.vValue === undefined ||
        !(decl.vValue instanceof Literal)
      )
        return;

      const newDecl = new VariableDeclaration(
        ast.reserveId(),
        node.src,
        true,
        false,
        `${decl.name}_${node.name}`,
        blockId,
        false,
        DataLocation.Memory,
        StateVariableVisibility.Default,
        Mutability.Constant,
        decl.typeString,
        cloneDocumentation(decl.documentation, ast, new Map<number, number>()),
        new ElementaryTypeName(
          ast.reserveId(),
          node.src,
          `${decl.vType.typeString}`,
          decl.vType.typeString,
        ),
        undefined,
        undefined,
      );
      ast.setContextRecursive(newDecl);

      const newDeclStmt = new VariableDeclarationStatement(
        ast.reserveId(),
        decl.src,
        [newDecl.id],
        [newDecl],
        new Literal(
          ast.reserveId(),
          '',
          decl.vValue.typeString,
          decl.vValue.kind,
          decl.vValue.hexValue,
          decl.vValue.value,
        ),
      );
      block.insertAtBeginning(newDeclStmt);
      ast.setContextRecursive(block);
      ast.registerChild(newDeclStmt, block);
      ids.forEach((id) => (id.referencedDeclaration = newDecl.id));
    });
  }
}
