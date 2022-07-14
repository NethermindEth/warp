import { ElementaryTypeName, getNodeType, IntType, Literal } from 'solc-typed-ast';
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
    const cairoType: string = primitiveTypeToCairo(node.name);
    // if cairoType is form of IntX or UintX
    if (cairoType.match(/^(Int)(\d+)$/)) {
      if (cairoType === 'Int256') {
        ast.registerImport(node, 'starkware.cairo.common.uint256', 'Uint256');
      }
      ast.registerImport(node, 'warplib.types.ints', `${cairoType}`);
    }
    if (cairoType.match(/^(Uint)(\d+)$/)) {
      if (cairoType === 'Uint256') {
        ast.registerImport(node, 'starkware.cairo.common.uint256', 'Uint256');
      } else ast.registerImport(node, 'warplib.types.uints', `${cairoType}`);
    }
  }

  visitLiteral(node: Literal, ast: AST): void {
    const type = getNodeType(node, ast.compilerVersion);
    if (type instanceof IntType) {
      if (type.signed) {
        ast.registerImport(node, 'warplib.types.ints', `Int${Math.ceil(type.nBits / 8) * 8}`);
        if (type.nBits > 251) {
          ast.registerImport(node, 'starkware.cairo.common.uint256', 'Uint256');
        }
      } else if (type.nBits > 251)
        ast.registerImport(node, 'starkware.cairo.common.uint256', 'Uint256');
      else {
        ast.registerImport(node, 'warplib.types.uints', `Uint${Math.ceil(type.nBits / 8) * 8}`);
      }
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

    this.commonVisit(node, ast);
  }
}
