import {
  ElementaryTypeName,
  IntType,
  Literal,
  SourceUnit,
  StructDefinition,
  UserDefinedType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoFunctionDefinition } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import { createImportFuncDefinition } from '../utils/importFuncGenerator';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { isExternallyVisible, primitiveTypeToCairo } from '../utils/utils';

/*
  Analyses the tree after all processing has been done to find code the relies on
  cairo imports that are not easy to add elsewhere. For example it's easy to import
  the warplib maths functions as they are added to the code, but for determining if
  Uint256 needs to be imported, it's easier to do it here
*/

export class CairoUtilImporter extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitElementaryTypeName(node: ElementaryTypeName, ast: AST): void {
    if (primitiveTypeToCairo(node.name) === 'Uint256') {
      createImportFuncDefinition('starkware.cairo.common.uint256', 'Uint256', node, ast);
    }
  }

  visitLiteral(node: Literal, ast: AST): void {
    const type = safeGetNodeType(node, ast.inference);
    if (type instanceof IntType && type.nBits > 251) {
      createImportFuncDefinition('starkware.cairo.common.uint256', 'Uint256', node, ast);
    }
  }

  //  Patch to struct inlining
  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    const type = safeGetNodeType(node, ast.inference);
    if (type instanceof IntType && type.nBits > 251) {
      createImportFuncDefinition('starkware.cairo.common.uint256', 'Uint256', node, ast);
    }

    if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      if (
        node.getClosestParentByType(SourceUnit) !==
        type.definition.getClosestParentByType(SourceUnit)
      ) {
        type.definition.vMembers.forEach((decl) => {
          const declType = safeGetNodeType(decl, ast.inference);
          if (declType instanceof IntType && declType.nBits > 251) {
            createImportFuncDefinition('starkware.cairo.common.uint256', 'Uint256', node, ast);
          }
        });
      }
    }
  }

  visitCairoFunctionDefinition(node: CairoFunctionDefinition, ast: AST): void {
    if (node.implicits.has('warp_memory') && isExternallyVisible(node)) {
      createImportFuncDefinition(
        'starkware.cairo.common.default_dict',
        'default_dict_new',
        node,
        ast,
      );
      createImportFuncDefinition(
        'starkware.cairo.common.default_dict',
        'default_dict_finalize',
        node,
        ast,
      );
      createImportFuncDefinition('starkware.cairo.common.dict', 'dict_write', node, ast);
    }

    if (node.implicits.has('keccak_ptr') && isExternallyVisible(node)) {
      createImportFuncDefinition(
        'starkware.cairo.common.cairo_keccak.keccak',
        'finalize_keccak',
        node,
        ast,
      );
      // Required to create a keccak_ptr
      createImportFuncDefinition('starkware.cairo.common.alloc', 'alloc', node, ast);
    }

    this.commonVisit(node, ast);
  }
}
