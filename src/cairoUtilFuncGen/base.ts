import assert from 'assert';
import {
  ArrayType,
  DataLocation,
  EnumDefinition,
  generalizeType,
  IntType,
  MappingType,
  SourceUnit,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { formatPath } from '../utils/formatting';

export type CairoFunction = {
  name: string;
  code: string;
};

export type CairoStructDef = {
  name: string;
  code: string;
};

/*
  Base class for all specific cairo function generators
  These exist for cases where a transform we need is too specific to cairo to
  be doable by directly changing the solidity AST, so a stubbed FunctionDefintion
  is created and called in the AST, and a cairo definition for the function is either
  directly added to the output code, or one in warplib is referenced
*/
export abstract class CairoUtilFuncGenBase {
  protected ast: AST;
  protected imports: Map<string, Set<string>> = new Map();
  protected sourceUnit: SourceUnit;
  constructor(ast: AST, sourceUnit: SourceUnit) {
    this.ast = ast;
    this.sourceUnit = sourceUnit;
  }

  // import file -> import symbols
  getImports(): Map<string, Set<string>> {
    return this.imports;
  }

  // Concatenate all the generated cairo code into a single string
  abstract getGeneratedCode(): string;

  protected requireImport(location: string, name: string): void {
    const existingImports = this.imports.get(location) ?? new Set<string>();
    existingImports.add(name);
    this.imports.set(location, existingImports);
  }

  protected checkForImport(type: TypeNode): void {
    if (
      type instanceof UserDefinedType &&
      (type.definition instanceof StructDefinition || type.definition instanceof EnumDefinition)
    ) {
      assert(this.sourceUnit !== undefined, 'Source unit is undefined.');
      const typeDefSourceUnit = type.definition.root;
      assert(typeDefSourceUnit instanceof SourceUnit);
      if (this.sourceUnit !== typeDefSourceUnit) {
        this.requireImport(formatPath(typeDefSourceUnit.absolutePath), type.definition.name);
      }
    } else if (type instanceof IntType && type.nBits === 256) {
      this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    }
  }
}

/*
  Most subclasses of CairoUtilFuncGenBase index their CairoFunctions off a single string,
  usually the cairo type of the input that the function's code depends on
*/
export class StringIndexedFuncGen extends CairoUtilFuncGenBase {
  protected generatedFunctions: Map<string, CairoFunction> = new Map();

  getGeneratedCode(): string {
    return [...this.generatedFunctions.values()].map((func) => func.code).join('\n\n');
  }
}

// Quick shortcut for writing `${base} + ${offset}` that also shortens it in the case of +0
export function add(base: string, offset: number): string {
  return offset === 0 ? base : `${base} + ${offset}`;
}

// This is needed because index access and member access functions return pointers, even if the data
// pointed to is a basic type, whereas read and write functions need to only return pointers if the
// data they're reading or writing is a complex type
export function locationIfComplexType(type: TypeNode, location: DataLocation): DataLocation {
  const base = generalizeType(type)[0];
  if (
    base instanceof ArrayType ||
    base instanceof MappingType ||
    (base instanceof UserDefinedType && base.definition instanceof StructDefinition) ||
    base instanceof MappingType
  ) {
    return location;
  } else {
    return DataLocation.Default;
  }
}
