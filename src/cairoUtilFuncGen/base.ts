import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  FunctionDefinition,
  generalizeType,
  MappingType,
  PointerType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoFunctionDefinition, CairoImportFunctionDefinition } from '../ast/cairoNodes';
import { createCairoGeneratedFunction, ParameterInfo } from '../utils/functionGeneration';
import { TranspileFailedError } from '../utils/errors';
import { createImportFuncDefinition } from '../utils/importFuncGenerator';
import { isDynamicArray, isReferenceType } from '../utils/nodeTypeProcessing';

export type CairoStructDef = {
  name: string;
  code: string;
};

export type GeneratedFunctionInfo = {
  name: string;
  code: string;
  functionsCalled: FunctionDefinition[];
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

  protected requireImport(
    location: string,
    name: string,
    inputs?: ParameterInfo[],
    outputs?: ParameterInfo[],
  ): CairoImportFunctionDefinition {
    return createImportFuncDefinition(location, name, this.sourceUnit, this.ast, inputs, outputs);
  }

  // TODO: Erase this
  // protected checkForImport(type: TypeNode): void {
  //   if (type instanceof IntType && type.nBits === 256) {
  //     this.requireImport('starkware.cairo.common.uint256', 'Uint256');
  //   }
  // }
}

/*
  Most subclasses of CairoUtilFuncGenBase index their CairoFunctions off a single string,
  usually the cairo type of the input that the function's code depends on
*/
export abstract class StringIndexedFuncGen extends CairoUtilFuncGenBase {
  protected generatedFunctionsDef: Map<string, CairoFunctionDefinition> = new Map();
}

export abstract class StringIndexedFuncGenWithAuxiliar extends StringIndexedFuncGen {
  protected auxiliarGeneratedFunctions: Map<string, CairoFunctionDefinition> = new Map();

  protected createAuxiliarGeneratedFunction(genFuncInfo: GeneratedFunctionInfo) {
    return createCairoGeneratedFunction(genFuncInfo, [], [], this.ast, this.sourceUnit);
  }
}

// Quick shortcut for writing `${base} + ${offset}` that also shortens it in the case of +0
export function add(base: string, offset: number): string {
  return offset === 0 ? base : `${base} + ${offset}`;
}

// Quick shortcut for writing `${base} * ${scalar}` that also shortens it in the case of *1
export function mul(base: string, scalar: number | bigint) {
  return scalar === 1 ? base : `${base} * ${scalar}`;
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
    assert(false);
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
