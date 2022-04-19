import {
  AddressType,
  ASTNode,
  BoolType,
  EnumDefinition,
  Expression,
  getNodeType,
  IntType,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { NotSupportedYetError } from '../../utils/errors';
import { dereferenceType, typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase } from '../base';
import { StorageReadGen } from './storageRead';

/*
  UNFINISHED
  Generates functions to copy data from WARP_STORAGE to warp_memory
  For simple cases, reads can be used and are handled by their own FuncGen,
  this exists to handle complex cases such as structs and dynamic arrays

  Progress - Currently handles only addresses, bools, ints, and enums
*/

export class StorageToMemoryGen extends CairoUtilFuncGenBase {
  getGeneratedCode(): string {
    // TODO implement once complex cases requiring code generation are added
    return '';
  }
  constructor(private readGen: StorageReadGen, ast: AST) {
    super(ast);
  }
  gen(node: Expression, nodeInSourceUnit?: ASTNode): Expression {
    const type = dereferenceType(getNodeType(node, this.ast.compilerVersion));
    if (type instanceof AddressType || type instanceof BoolType || type instanceof IntType) {
      return this.readGen.gen(node, typeNameFromTypeNode(type, this.ast), nodeInSourceUnit);
    } else if (type instanceof UserDefinedType) {
      if (type.definition instanceof EnumDefinition) {
        return this.readGen.gen(node, typeNameFromTypeNode(type, this.ast), nodeInSourceUnit);
      }
    }

    throw new NotSupportedYetError(
      `${printTypeNode(type)} storage -> memory not implemented yet. Needed for ${printNode(node)}`,
    );
  }
}
