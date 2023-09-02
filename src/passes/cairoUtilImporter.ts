import {
  AddressType,
  ElementaryTypeName,
  FunctionCall,
  IntType,
  Literal,
  MemberAccess,
  SourceUnit,
  StructDefinition,
  UserDefinedType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { CairoFunctionDefinition } from '../export';
import { requireNonNullish } from '../export';
import { createImport } from '../utils/importFuncGenerator';
import {
  INTO,
  U256_FROM_FELTS,
  U128_FROM_FELT,
  CONTRACT_ADDRESS,
  WARP_MEMORY,
  WM_INIT,
  CUTOFF_DOWNCAST,
  WARPLIB_INTEGER,
} from '../utils/importPaths';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';
import { getContainingSourceUnit, primitiveTypeToCairo } from '../utils/utils';

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
    // It requires the AnnotateImplicits (An) because we need to know if any functions
    // uses WarpMemory
    // It requires Function Prunner (Fp) for it not to delete any of these newly added
    // imports
    const passKeys: Set<string> = new Set<string>(['An', 'Fp']);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitCairoFunctionDefinition(node: CairoFunctionDefinition, ast: AST): void {
    if (node.implicits.has('warp_memory')) {
      createImport(...WARP_MEMORY, this.dummySourceUnit ?? node, ast);
      createImport(...WM_INIT, this.dummySourceUnit ?? node, ast);
    }
    this.commonVisit(node, ast);
  }

  visitElementaryTypeName(node: ElementaryTypeName, ast: AST): void {
    const cairoType = primitiveTypeToCairo(node.name);
    if (cairoType === 'u256') {
      createImport(...U128_FROM_FELT, this.dummySourceUnit ?? node, ast);
    } else if (cairoType === 'ContractAddress') {
      createImport(...CONTRACT_ADDRESS, this.dummySourceUnit ?? node, ast);
    }
  }

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    // FIXME: remove when BitAnd is available for integer types in
    // corelib
    if (node.vFunctionName === CUTOFF_DOWNCAST[1]) {
      const path = WARPLIB_INTEGER.slice(0, -1);
      const name = requireNonNullish(WARPLIB_INTEGER.at(-1));
      createImport(path, name, this.dummySourceUnit ?? node, ast);
    }
    super.visitFunctionCall(node, ast);
  }

  visitLiteral(node: Literal, ast: AST): void {
    const type = safeGetNodeType(node, ast.inference);
    if (type instanceof IntType && type.nBits === 256) {
      createImport(...U256_FROM_FELTS, this.dummySourceUnit ?? node, ast);
    }

    if (type instanceof AddressType) {
      createImport(...CONTRACT_ADDRESS, this.dummySourceUnit ?? node, ast);
    }
  }

  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    const type = safeGetNodeType(node, ast.inference);
    if (type instanceof IntType && type.nBits > 251) {
      createImport(...U128_FROM_FELT, this.dummySourceUnit ?? node, ast);
    }

    if (type instanceof AddressType) {
      createImport(...CONTRACT_ADDRESS, this.dummySourceUnit ?? node, ast);
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

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (node.memberName === 'into') {
      createImport(...INTO, node, ast);
    }
  }
}
