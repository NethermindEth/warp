import {
  TypeNode,
  IntType,
  ArrayType,
  BoolType,
  BytesType,
  StringType,
  AddressType,
  BuiltinType,
  BuiltinStructType,
  MappingType,
  UserDefinedType,
  FunctionType,
  PointerType,
  EnumDefinition,
  enumToIntType,
  StructDefinition,
  getNodeType,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { printNode, printTypeNode } from './astPrinter';
import { NotSupportedYetError } from './errors';

export enum TypeConversionContext {
  Ref,
  StorageAllocation,
}

export abstract class CairoType {
  abstract toString(): string;
  abstract get width(): number;
  // An array of the member-accesses required to access all the underlying felts
  abstract serialiseMembers(name: string): string[];
  // Sync this with the one in typewriter.ts
  static fromSol(
    tp: TypeNode,
    ast: AST,
    context: TypeConversionContext = TypeConversionContext.Ref,
  ): CairoType {
    if (tp instanceof AddressType) {
      return new CairoFelt();
    } else if (tp instanceof ArrayType) {
      if (context === TypeConversionContext.Ref) {
        return new CairoFelt();
      } else if (tp.size === undefined) {
        return new CairoStruct(
          'warp_dynamic_storage_array',
          new Map([
            ['name', new CairoFelt()],
            ['length', new CairoFelt()],
          ]),
        );
      } else {
        const elementType = CairoType.fromSol(tp.elementT, ast, context);
        const narrowedLength = parseInt(tp.size.toString());
        if (BigInt(narrowedLength) !== tp.size) {
          throw new NotSupportedYetError(
            `Arrays of very large size (${tp.size.toString()}) are not supported`,
          );
        }
        return new CairoTuple(Array(narrowedLength).fill(elementType));
      }
    } else if (tp instanceof BoolType) {
      return new CairoFelt();
    } else if (tp instanceof BuiltinType) {
      throw new NotSupportedYetError('Serialising BuiltinType not supported yet');
    } else if (tp instanceof BuiltinStructType) {
      throw new NotSupportedYetError('Serialising BuiltinStructType not supported yet');
    } else if (tp instanceof BytesType) {
      throw new NotSupportedYetError('Serialising BytesType not supported yet');
    } else if (tp instanceof FunctionType) {
      throw new NotSupportedYetError('Serialising FunctionType not supported yet');
    } else if (tp instanceof IntType) {
      return tp.nBits > 251 ? CairoUint256 : new CairoFelt();
    } else if (tp instanceof MappingType) {
      return new CairoFelt();
    } else if (tp instanceof PointerType) {
      return new CairoFelt();
    } else if (tp instanceof StringType) {
      return new CairoFelt();
    } else if (tp instanceof UserDefinedType) {
      if (tp.definition instanceof EnumDefinition) {
        return CairoType.fromSol(enumToIntType(tp.definition), ast);
      } else if (tp.definition instanceof StructDefinition) {
        if (context === TypeConversionContext.Ref) {
          return new CairoFelt();
        } else {
          return new CairoStruct(
            tp.definition.name,
            new Map(
              tp.definition.vMembers.map((decl) => [
                decl.name,
                CairoType.fromSol(getNodeType(decl, ast.compilerVersion), ast, context),
              ]),
            ),
          );
        }
      }
      throw new NotSupportedYetError(
        `Serialising ${tp.definition.type} UserDefinedType not supported yet. Found at ${printNode(
          tp.definition,
        )}`,
      );
    } else {
      throw new Error(`Don't know how to convert type ${printTypeNode(tp)}`);
    }
  }
}

export class CairoFelt implements CairoType {
  toString(): string {
    return 'felt';
  }
  get width(): number {
    return 1;
  }
  serialiseMembers(name: string): string[] {
    return [name];
  }
}

export class CairoStruct implements CairoType {
  constructor(public name: string, public members: Map<string, CairoType>) {}
  toString(): string {
    return this.name;
  }
  get width(): number {
    return [...this.members.values()].reduce((acc, t) => acc + t.width, 0);
  }
  serialiseMembers(name: string): string[] {
    return [...this.members.entries()].flatMap(([memberName, type]) =>
      type.serialiseMembers(`${name}.${memberName}`),
    );
  }
}

export class CairoTuple implements CairoType {
  constructor(public members: CairoType[]) {}
  toString(): string {
    return `(${this.members.map((m) => m.toString).join(', ')})`;
  }
  get width(): number {
    return this.members.reduce((acc, t) => acc + t.width, 0);
  }
  serialiseMembers(name: string): string[] {
    return this.members.flatMap((memberType, index) =>
      memberType.serialiseMembers(`${name}[${index}]`),
    );
  }
}

export class CairoPointer implements CairoType {
  constructor(public to: CairoType) {}
  toString(): string {
    return `${this.to.toString()}*`;
  }
  get width(): number {
    return 1;
  }
  serialiseMembers(name: string): string[] {
    return [name];
  }
}

export const CairoUint256 = new CairoStruct(
  'Uint256',
  new Map([
    ['low', new CairoFelt()],
    ['high', new CairoFelt()],
  ]),
);
