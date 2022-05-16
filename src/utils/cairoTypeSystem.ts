import assert from 'assert';
import {
  TypeNode,
  IntType,
  ArrayType,
  BoolType,
  BytesType,
  ContractDefinition,
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
  FixedBytesType,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { printNode, printTypeNode } from './astPrinter';
import { NotSupportedYetError, TranspileFailedError } from './errors';
import { narrowBigInt } from './utils';

export enum TypeConversionContext {
  MemoryAllocation,
  Ref,
  StorageAllocation,
  CallDataRef,
}

export abstract class CairoType {
  // This gives the cairo typestring for the represented type
  abstract toString(): string;
  abstract get fullStringRepresentation(): string;
  get typeName(): string {
    return this.toString();
  }
  abstract get width(): number;
  // An array of the member-accesses required to access all the underlying felts
  abstract serialiseMembers(name: string): string[];
  static fromSol(
    tp: TypeNode,
    ast: AST,
    context: TypeConversionContext = TypeConversionContext.Ref,
  ): CairoType {
    if (tp instanceof AddressType) {
      return new CairoFelt();
    } else if (tp instanceof ArrayType) {
      if (tp.size === undefined) {
        if (context === TypeConversionContext.CallDataRef) {
          return new CairoDynArray(
            `wm_dynarry_${tp.elementT.toString()}`,
            CairoType.fromSol(tp.elementT, ast, context),
          );
          // new CairoPointer(CairoType.fromSol(tp.elementT, ast, context));
        }
        // Suggest that we put another type here that is WarpLocationRef that inherits from
        // the WarpLocation and it can point to the dArray.
        return new WarpLocation('dynArray');
      } else if (context === TypeConversionContext.Ref) {
        return new CairoFelt();
      } else {
        const recursionContext =
          context === TypeConversionContext.MemoryAllocation ? TypeConversionContext.Ref : context;
        const elementType = CairoType.fromSol(tp.elementT, ast, recursionContext);
        const narrowedLength = narrowBigInt(tp.size);
        if (narrowedLength === null) {
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
    } else if (tp instanceof FixedBytesType) {
      return tp.size === 32 ? CairoUint256 : new CairoFelt();
    } else if (tp instanceof FunctionType) {
      throw new NotSupportedYetError('Serialising FunctionType not supported yet');
    } else if (tp instanceof IntType) {
      return tp.nBits > 251 ? CairoUint256 : new CairoFelt();
    } else if (tp instanceof MappingType) {
      return new WarpLocation('mapping');
    } else if (tp instanceof PointerType) {
      if (context !== TypeConversionContext.Ref) {
        return CairoType.fromSol(tp.to, ast, context);
      }
      return new CairoFelt();
    } else if (tp instanceof StringType) {
      return new CairoFelt();
    } else if (tp instanceof UserDefinedType) {
      if (tp.definition instanceof EnumDefinition) {
        return CairoType.fromSol(enumToIntType(tp.definition), ast);
      } else if (tp.definition instanceof StructDefinition) {
        if (context === TypeConversionContext.Ref) {
          return new CairoFelt();
        } else if (context === TypeConversionContext.MemoryAllocation) {
          return new CairoStruct(
            tp.definition.name,
            new Map(
              tp.definition.vMembers.map((decl) => [
                decl.name,
                CairoType.fromSol(
                  getNodeType(decl, ast.compilerVersion),
                  ast,
                  TypeConversionContext.Ref,
                ),
              ]),
            ),
          );
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
      } else if (tp.definition instanceof ContractDefinition) {
        return new CairoFelt();
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

export class CairoFelt extends CairoType {
  get fullStringRepresentation(): string {
    return '[Felt]';
  }
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

export class CairoStruct extends CairoType {
  constructor(public name: string, public members: Map<string, CairoType>) {
    super();
  }
  get fullStringRepresentation(): string {
    return `[Struct ${this.name}]${[...this.members.entries()].map(
      ([name, type]) => `(${name}: ${type.fullStringRepresentation})`,
    )}`;
  }
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
  offsetOf(memberName: string): number {
    let offset = 0;
    for (const [name, type] of this.members) {
      if (name === memberName) return offset;
      offset += type.width;
    }
    throw new TranspileFailedError(
      `Attempted to find offset of non-existant member ${memberName} in ${this.name}`,
    );
  }
}

export class CairoDynArray extends CairoStruct {
  constructor(public name: string, public ptr_member: CairoType) {
    super(
      name,
      new Map([
        ['len', new CairoFelt()],
        ['ptr', new CairoPointer(ptr_member)],
      ]),
    );
  }

  get vPtr(): CairoPointer {
    const ptr_member = this.members.get('ptr');
    assert(ptr_member instanceof CairoPointer);
    return ptr_member;
  }

  get vLen(): CairoFelt {
    const len_member = this.members.get('len');
    assert(len_member instanceof CairoFelt);
    return len_member;
  }
}

export class CairoTuple extends CairoType {
  constructor(public members: CairoType[]) {
    super();
  }
  get fullStringRepresentation(): string {
    return `[Tuple]${this.members.map((type) => `(${type.fullStringRepresentation})`)}`;
  }
  toString(): string {
    return `(${this.members.map((m) => m.toString()).join(', ')})`;
  }
  get typeName(): string {
    return `${this.members.map((m) => m.typeName).join('x')}`;
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

export class CairoPointer extends CairoType {
  constructor(public to: CairoType) {
    super();
  }
  get fullStringRepresentation(): string {
    return `[Pointer](${this.to.fullStringRepresentation})`;
  }
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

export class WarpLocation extends CairoFelt {
  to: string;
  constructor(public to_: string) {
    super();
    this.to = to_;
  }

  get pointsTo(): string {
    return this.to;
  }

  get typeName(): string {
    // TODO make sure that struct names get mangled
    return 'warp_id';
  }
  get fullStringRepresentation(): string {
    return `[Id]`;
  }
}

export const CairoUint256 = new CairoStruct(
  'Uint256',
  new Map([
    ['low', new CairoFelt()],
    ['high', new CairoFelt()],
  ]),
);
