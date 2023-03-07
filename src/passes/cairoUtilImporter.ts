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
import { createImport } from '../utils/importFuncGenerator';
import {
  allocImport,
  defaultDictFinalizeImport,
  defaultDictNewImport,
  dictWriteImport,
  finalizeKeccakImport,
  uint256Import,
} from '../utils/importPaths';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { getContainingSourceUnit, isExternallyVisible, primitiveTypeToCairo } from '../utils/utils';

/*
  Analyses the tree after all processing has been done to find code the relies on
  cairo imports that are not easy to add elsewhere. For example it's easy to import
  the warplib maths functions as they are added to the code, but for determining if
  Uint256 needs to be imported, it's easier to do it here
*/

export class CairoUtilImporter extends ASTMapper {
  private dummySourceUnit: SourceUnit | undefined;

  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitElementaryTypeName(node: ElementaryTypeName, ast: AST): void {
    if (primitiveTypeToCairo(node.name) === 'Uint256') {
      createImport(...uint256Import(), this.dummySourceUnit ?? node, ast);
    }
  }

  visitLiteral(node: Literal, ast: AST): void {
    const type = safeGetNodeType(node, ast.inference);
    if (type instanceof IntType && type.nBits > 251) {
      createImport(...uint256Import(), this.dummySourceUnit ?? node, ast);
    }
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    const type = safeGetNodeType(node, ast.inference);
    if (type instanceof IntType && type.nBits > 251) {
      createImport(...uint256Import(), this.dummySourceUnit ?? node, ast);
    }

    //  Patch to struct inlining
    if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      const currentSourceUnit = getContainingSourceUnit(node);
      if (currentSourceUnit !== type.definition.getClosestParentByType(SourceUnit)) {
        this.dummySourceUnit = this.dummySourceUnit ?? currentSourceUnit;
        type.definition.walkChildren((child) => this.commonVisit(child, ast));
        this.dummySourceUnit =
          this.dummySourceUnit === currentSourceUnit ? undefined : this.dummySourceUnit;
      }
    }
    this.visitExpression(node, ast);
  }

  visitCairoFunctionDefinition(node: CairoFunctionDefinition, ast: AST): void {
    if (node.implicits.has('warp_memory') && isExternallyVisible(node)) {
      createImport(...defaultDictNewImport(), node, ast);
      createImport(...defaultDictFinalizeImport(), node, ast);
      createImport(...dictWriteImport(), node, ast);
    }

    if (node.implicits.has('keccak_ptr') && isExternallyVisible(node)) {
      createImport(...finalizeKeccakImport(), node, ast);
      // Required to create a keccak_ptr
      createImport(...allocImport(), node, ast);
    }

    this.commonVisit(node, ast);
  }
}
