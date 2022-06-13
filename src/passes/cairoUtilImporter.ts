import { ArrayType, DataLocation, ElementaryTypeName, getNodeType } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoFunctionDefinition } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import { isExternallyVisible, primitiveTypeToCairo } from '../utils/utils';

/*
  Analyses the tree after all processing has been done to find code the relies on
  cairo imports that are not easy to add elsewhere. For example it's easy to import
  the warplib maths functions as they are added to the code, but for determining if
  Uint256 needs to be imported, it's easier to do it here
*/
export class CairoUtilImporter extends ASTMapper {
  visitElementaryTypeName(node: ElementaryTypeName, ast: AST): void {
    if (primitiveTypeToCairo(node.name) === 'Uint256') {
      ast.registerImport(node, 'starkware.cairo.common.uint256', 'Uint256');
    }
  }

  visitCairoFunctionDefinition(node: CairoFunctionDefinition, ast: AST): void {
    if (node.implicits.has('warp_memory') && isExternallyVisible(node)) {
      ast.registerImport(node, 'starkware.cairo.common.default_dict', 'default_dict_new');
      ast.registerImport(node, 'starkware.cairo.common.default_dict', 'default_dict_finalize');
      ast.registerImport(node, 'starkware.cairo.common.dict', 'dict_write');
    }

    if (node.implicits.has('keccak_ptr') && isExternallyVisible(node)) {
      ast.registerImport(node, 'starkware.cairo.common.cairo_keccak.keccak', 'finalize_keccak');
      // Required to create a keccak_ptr
      ast.registerImport(node, 'starkware.cairo.common.alloc', 'alloc');
    }

    // Making sure all the dynamic array struct constructors are present
    node.vParameters.vParameters.forEach((decl) => {
      const type = getNodeType(decl, ast.compilerVersion);
      if (
        type instanceof ArrayType &&
        type.size === undefined &&
        decl.storageLocation === DataLocation.CallData
      ) {
        ast.getUtilFuncGen(node).externalFunctions.inputs.darrayStructConstructor.gen(decl, node);
      }
    });

    this.commonVisit(node, ast);
  }
}
