import {
  AddressType,
  ElementaryTypeName,
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
import { createImport } from '../utils/importFuncGenerator';
import { INTO, U256_FROM_FELTS, U128_FROM_FELT, CONTRACT_ADDRESS } from '../utils/importPaths';
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
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitElementaryTypeName(node: ElementaryTypeName, ast: AST): void {
    const cairoType = primitiveTypeToCairo(node.name);
    if (cairoType === 'u256') {
      createImport(...U128_FROM_FELT, this.dummySourceUnit ?? node, ast);
    } else if (cairoType === 'ContractAddress') {
      createImport(...CONTRACT_ADDRESS, this.dummySourceUnit ?? node, ast);
    }
  }

  visitLiteral(node: Literal, ast: AST): void {
    const type = safeGetNodeType(node, ast.inference);
    if (type instanceof IntType && type.nBits > 251) {
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
