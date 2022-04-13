import {
  AddressType,
  ASTNode,
  BoolType,
  DataLocation,
  EnumDefinition,
  Expression,
  getNodeType,
  IntType,
  StructDefinition,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printNode, printTypeNode } from '../../utils/astPrinter';
import { NotSupportedYetError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionStubbing';
import { dereferenceType, typeNameFromTypeNode } from '../../utils/utils';
import { CairoUtilFuncGenBase } from '../base';
import { StorageReadGen } from './storageRead';

// NOT FINISHED

export class StorageToMemoryGen extends CairoUtilFuncGenBase {
  getGeneratedCode(): string {
    // TODO implement
    return '';
  }
  constructor(private readGen: StorageReadGen, ast: AST) {
    super(ast);
  }
  gen(node: Expression, nodeInSourceUnit?: ASTNode): Expression {
    const type = dereferenceType(getNodeType(node, this.ast.compilerVersion));
    let name: string | null = null;
    if (type instanceof AddressType || type instanceof BoolType || type instanceof IntType) {
      return this.readGen.gen(node, typeNameFromTypeNode(type, this.ast));
    } else if (type instanceof UserDefinedType) {
      if (type.definition instanceof EnumDefinition) {
        return this.readGen.gen(node, typeNameFromTypeNode(type, this.ast));
      } else if (type.definition instanceof StructDefinition) {
        // name = this.getOrCreateStruct(type.definition);
        name = 'TEMP';
      }
    }

    if (name === null) {
      throw new NotSupportedYetError(
        `${printTypeNode(type)} storage -> memory not implemented yet. Needed for ${printNode(
          node,
        )}`,
      );
    }

    const stub = createCairoFunctionStub(
      name,
      [['arg', typeNameFromTypeNode(type, this.ast), DataLocation.Storage]],
      [['res', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      [],
      this.ast,
      nodeInSourceUnit ?? node,
    );

    return createCallToFunction(stub, [node], this.ast);
  }
}
