import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  FunctionCall,
  generalizeType,
  getNodeType,
  MappingType,
  PointerType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { printNode } from '../utils/astPrinter';
import { TranspileFailedError } from '../utils/errors';
import { formatPath } from '../utils/formatting';
import { isDynamicArray, isReferenceType } from '../utils/nodeTypeProcessing';

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

  addStructDefImports(): void {
    const constructorStructDefs = this.sourceUnit
      .getChildrenByType(FunctionCall, true)
      .filter((n) => {
        return n.vReferencedDeclaration instanceof StructDefinition;
      })
      .map((n) => n.vReferencedDeclaration);

    const varDeclStructDefs = this.sourceUnit
      .getChildrenByType(VariableDeclaration, true)
      .map((n) => {
        const type = getNodeType(n, this.ast.compilerVersion);
        if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
          return type.definition;
        }
      });

    const structDefs = new Set<StructDefinition>();
    [...constructorStructDefs, ...varDeclStructDefs].forEach((n) => {
      if (n instanceof StructDefinition) {
        structDefs.add(n);
      }
    });

    structDefs.forEach((def) => {
      assert(def instanceof StructDefinition);
      this.checkForStructDefImport(def);
    });
  }

  protected checkForStructDefImport(structDef: StructDefinition): void {
    const typeDefSourceUnit = structDef.root;
    assert(
      typeDefSourceUnit instanceof SourceUnit,
      `Unable to find SourceUnit holding type definition ${printNode(structDef)}.`,
    );
    if (this.sourceUnit !== typeDefSourceUnit) {
      this.requireImport(formatPath(typeDefSourceUnit.absolutePath), structDef.name);
    }
    structDef.vMembers.forEach((n) => {
      const type = generalizeType(getNodeType(n, this.ast.compilerVersion))[0];
      if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
        this.checkForStructDefImport(type.definition);
      }
    });
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
  if (isReferenceType(base)) {
    return location;
  } else {
    return DataLocation.Default;
  }
}

export function delegateBasedOnType<T>(
  type: TypeNode,
  dynamicArrayFunc: (type: ArrayType | BytesType | StringType) => T,
  staticArrayFunc: (type: ArrayType) => T,
  structFunc: (type: UserDefinedType, def: StructDefinition) => T,
  mappingFunc: (type: MappingType) => T,
  valueFunc: (type: TypeNode) => T,
): T {
  if (type instanceof PointerType) {
    throw new TranspileFailedError(
      `Attempted to delegate copy semantics based on specialised type ${type.pp()}`,
    );
  } else if (isDynamicArray(type)) {
    assert(type instanceof ArrayType || type instanceof BytesType || type instanceof StringType);
    return dynamicArrayFunc(type);
  } else if (type instanceof ArrayType) {
    return staticArrayFunc(type);
  } else if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
    return structFunc(type, type.definition);
  } else if (type instanceof MappingType) {
    return mappingFunc(type);
  } else {
    return valueFunc(type);
  }
}
