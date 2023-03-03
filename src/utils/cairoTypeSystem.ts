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
  FixedBytesType,
  UserDefinedValueTypeDefinition,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { printTypeNode } from './astPrinter';
import { NotSupportedYetError, TranspileFailedError } from './errors';
import { safeGetNodeType } from './nodeTypeProcessing';
import { mangleStructName, mapRange, narrowBigIntSafe } from './utils';

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
            generateCallDataDynArrayStructName(tp.elementT, ast),
            CairoType.fromSol(tp.elementT, ast, context),
          );
        } else if (context === TypeConversionContext.Ref) {
          return new MemoryLocation();
        }
        return new WarpLocation();
      } else if (context === TypeConversionContext.Ref) {
        return new MemoryLocation();
      } else {
        const recursionContext =
          context === TypeConversionContext.MemoryAllocation ? TypeConversionContext.Ref : context;
        const elementType = CairoType.fromSol(tp.elementT, ast, recursionContext);
        const narrowedLength = narrowBigIntSafe(
          tp.size,
          `Arrays of very large size (${tp.size.toString()}) are not supported`,
        );
        return new CairoStaticArray(elementType, narrowedLength);
      }
    } else if (tp instanceof BoolType) {
      return new CairoFelt();
    } else if (tp instanceof BuiltinType) {
      throw new NotSupportedYetError('Serialising BuiltinType not supported yet');
    } else if (tp instanceof BuiltinStructType) {
      throw new NotSupportedYetError('Serialising BuiltinStructType not supported yet');
    } else if (tp instanceof BytesType || tp instanceof StringType) {
      switch (context) {
        case TypeConversionContext.CallDataRef:
          return new CairoDynArray(
            generateCallDataDynArrayStructName(new FixedBytesType(1), ast),
            new CairoFelt(),
          );
        case TypeConversionContext.Ref:
          return new MemoryLocation();
        default:
          return new WarpLocation();
      }
    } else if (tp instanceof FixedBytesType) {
      return tp.size === 32 ? CairoUint256 : new CairoFelt();
    } else if (tp instanceof FunctionType) {
      throw new NotSupportedYetError('Serialising FunctionType not supported yet');
    } else if (tp instanceof IntType) {
      return new CairoUint(tp.nBits);
    } else if (tp instanceof MappingType) {
      return new WarpLocation();
    } else if (tp instanceof PointerType) {
      if (context !== TypeConversionContext.Ref) {
        return CairoType.fromSol(tp.to, ast, context);
      }
      return new MemoryLocation();
    } else if (tp instanceof UserDefinedType) {
      const specificType = tp.definition.type;
      if (tp.definition instanceof EnumDefinition) {
        return CairoType.fromSol(enumToIntType(tp.definition), ast);
      } else if (tp.definition instanceof StructDefinition) {
        if (context === TypeConversionContext.Ref) {
          return new MemoryLocation();
        } else if (context === TypeConversionContext.MemoryAllocation) {
          return new CairoStruct(
            mangleStructName(tp.definition),
            new Map(
              tp.definition.vMembers.map((decl) => [
                decl.name,
                CairoType.fromSol(
                  safeGetNodeType(decl, ast.inference),
                  ast,
                  TypeConversionContext.Ref,
                ),
              ]),
            ),
          );
        } else {
          return new CairoStruct(
            mangleStructName(tp.definition),
            new Map(
              tp.definition.vMembers.map((decl) => [
                decl.name,
                CairoType.fromSol(safeGetNodeType(decl, ast.inference), ast, context),
              ]),
            ),
          );
        }
      } else if (tp.definition instanceof ContractDefinition) {
        return new CairoFelt();
      } else if (tp.definition instanceof UserDefinedValueTypeDefinition) {
        return CairoType.fromSol(
          safeGetNodeType(tp.definition.underlyingType, ast.inference),
          ast,
          context,
        );
      }
      throw new TranspileFailedError(
        `Failed to analyse user defined ${specificType} type as cairo type}`,
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

export class CairoUint extends CairoType {
  constructor(public nBits: number = 256) {
    super();
  }
  get fullStringRepresentation(): string {
    return `[u${this.nBits}]`;
  }
  toString(): string {
    return `u${this.nBits}`;
  }
  get width(): number {
    return 1; // not sure about this width, but for the moment consider it as a felt
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
      ([name, type]) => `(${name}: ${type.fullStringRepresentation}),`,
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

export class CairoStaticArray extends CairoType {
  constructor(public type: CairoType, public size: number) {
    super();
  }
  get fullStringRepresentation(): string {
    return `[StaticArray][${this.size}][${this.type.fullStringRepresentation}]`;
  }
  toString(): string {
    return (
      `(${this.type.toString()}` + `${`, ` + this.type.toString()}`.repeat(this.size - 1) + `)`
    );
  }
  get typeName(): string {
    return `${this.type.typeName}` + `${`x` + this.type.typeName}`.repeat(this.size - 1);
  }
  get width(): number {
    return this.type.width * this.size;
  }
  serialiseMembers(name: string): string[] {
    return mapRange(this.size, (n) => this.type.serialiseMembers(`${name}[${n}]`)).flat();
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
  get typeName(): string {
    return 'warp_id';
  }
  get fullStringRepresentation(): string {
    return `[Id]`;
  }
}

export class MemoryLocation extends CairoFelt {}

export const CairoUint256 = new CairoStruct(
  'Uint256',
  new Map([
    ['low', new CairoFelt()],
    ['high', new CairoFelt()],
  ]),
);

const cd_dynarray_prefix = 'cd_dynarray_';
export function generateCallDataDynArrayStructName(elementType: TypeNode, ast: AST): string {
  return `${cd_dynarray_prefix}${generateCallDataDynArrayStructNameInner(elementType, ast)}`;
}

function generateCallDataDynArrayStructNameInner(elementType: TypeNode, ast: AST): string {
  if (elementType instanceof PointerType) {
    return generateCallDataDynArrayStructNameInner(elementType.to, ast);
  } else if (elementType instanceof ArrayType) {
    if (elementType.size !== undefined) {
      return `arr_${narrowBigIntSafe(elementType.size)}_${generateCallDataDynArrayStructNameInner(
        elementType.elementT,
        ast,
      )}`;
    } else {
      // This is included only for completeness. Starknet does not currently allow dynarrays of dynarrays to be passed
      return `arr_d_${generateCallDataDynArrayStructNameInner(elementType.elementT, ast)}`;
    }
  } else if (elementType instanceof BytesType) {
    return `arr_d_felt`;
  } else if (
    elementType instanceof UserDefinedType &&
    elementType.definition instanceof StructDefinition
  ) {
    return mangleStructName(elementType.definition);
  } else {
    return CairoType.fromSol(elementType, ast, TypeConversionContext.CallDataRef).toString();
  }
}
