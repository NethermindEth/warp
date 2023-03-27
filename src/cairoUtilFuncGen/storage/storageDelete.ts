import assert from 'assert';
import {
  ArrayType,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  MappingType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoGeneratedFunctionDefinition } from '../../ast/cairoNodes';
import { CairoFunctionDefinition } from '../../export';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { GET_U128, UINT256_ADD, UINT256_EQ, UINT256_SUB } from '../../utils/importPaths';
import { getElementType, isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode, mapRange, narrowBigIntSafe } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';
import { StorageReadGen } from './storageRead';

const IMPLICITS = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

export class StorageDeleteGen extends StringIndexedFuncGen {
  // Map to store functions being created to
  // avoid infinite recursion when deleting
  // recursive types such as:
  // struct S {
  //    S[];
  // }
  private creatingFunctions: Map<string, string>;

  // Map to store unsolved function dependecies
  // of generated functions
  private functionDependencies: Map<string, string[]>;

  constructor(
    private dynArrayGen: DynArrayGen,
    private storageReadGen: StorageReadGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
    this.creatingFunctions = new Map();
    this.functionDependencies = new Map();
  }

  public gen(node: Expression): FunctionCall {
    const nodeType = generalizeType(safeGetNodeType(node, this.ast.inference))[0];
    const funcDef = this.getOrCreateFuncDef(nodeType);
    return createCallToFunction(funcDef, [node], this.ast);
  }

  public getOrCreateFuncDef(type: TypeNode) {
    const key = generateKey(type);
    const existing = this.generatedFunctionsDef.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcInfo = this.getOrCreate(type);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', typeNameFromTypeNode(type, this.ast), DataLocation.Storage]],
      [],
      this.ast,
      this.sourceUnit,
    );

    assert(
      this.creatingFunctions.delete(key),
      'Cannot delete function which is not being processed',
    );
    this.generatedFunctionsDef.set(key, funcDef);
    this.processRecursiveDependencies();

    return funcDef;
  }

  private safeGetOrCreateFuncDef(parentType: TypeNode, type: TypeNode) {
    const parentKey = generateKey(parentType);
    const childKey = generateKey(type);
    const dependencies = this.functionDependencies.get(parentKey);
    if (dependencies === undefined) {
      this.functionDependencies.set(parentKey, [childKey]);
    } else {
      dependencies.push(childKey);
    }

    const processingName = this.creatingFunctions.get(childKey);
    if (processingName !== undefined) {
      return processingName;
    }

    return this.getOrCreateFuncDef(type).name;
  }

  private getOrCreate(type: TypeNode): GeneratedFunctionInfo {
    const funcInfo = delegateBasedOnType<GeneratedFunctionInfo>(
      type,
      (type) => this.deleteDynamicArray(type),
      (type) => {
        assert(type.size !== undefined);
        return type.size <= 5
          ? this.deleteSmallStaticArray(type)
          : this.deleteLargeStaticArray(type);
      },
      (type, def) => this.deleteStruct(type, def),
      (type) => this.deleteNothing(type),
      (type) => this.deleteGeneric(type),
    );
    return funcInfo;
  }

  private deleteGeneric(type: TypeNode): GeneratedFunctionInfo {
    const funcName = `WS${this.getId()}_GENERIC_DELETE`;
    this.creatingFunctions.set(generateKey(type), funcName);

    const cairoType = CairoType.fromSol(type, this.ast);
    return {
      name: funcName,
      code: [
        `func ${funcName}${IMPLICITS}(loc: felt){`,
        ...mapRange(cairoType.width, (n) => `    WARP_STORAGE.write(${add('loc', n)}, 0);`),
        `    return ();`,
        `}`,
      ].join('\n'),
      functionsCalled: [],
    };
  }

  private deleteDynamicArray(type: ArrayType | BytesType | StringType): GeneratedFunctionInfo {
    const funcName = `WS${this.getId()}_DYNAMIC_ARRAY_DELETE`;
    this.creatingFunctions.set(generateKey(type), funcName);

    const elementT = generalizeType(getElementType(type))[0];

    const [dynArray, dynArrayLen] = this.dynArrayGen.getOrCreateFuncDef(elementT);
    const arrayName = dynArray.name;
    const lengthName = dynArrayLen.name;

    const readFunc = this.storageReadGen.getOrCreateFuncDef(elementT);
    const auxDeleteFuncName = this.safeGetOrCreateFuncDef(type, elementT);

    const deleteCode = requiresReadBeforeRecursing(elementT)
      ? [`   let (elem_id) = ${readFunc.name}(elem_loc);`, `   ${auxDeleteFuncName}(elem_id);`]
      : [`    ${auxDeleteFuncName}(elem_loc);`];

    const deleteFunc = [
      `func ${funcName}_elem${IMPLICITS}(loc : felt, index : Uint256, length : Uint256){`,
      `     alloc_locals;`,
      `     let (stop) = uint256_eq(index, length);`,
      `     if (stop == 1){`,
      `        return ();`,
      `     }`,
      `     let (elem_loc) = ${arrayName}.read(loc, index);`,
      ...deleteCode,
      `     let (next_index, _) = uint256_add(index, ${uint256(1)});`,
      `     return ${funcName}_elem(loc, next_index, length);`,
      `}`,
      `func ${funcName}${IMPLICITS}(loc : felt){`,
      `   alloc_locals;`,
      `   let (length) = ${lengthName}.read(loc);`,
      `   ${lengthName}.write(loc, ${uint256(0)});`,
      `   return ${funcName}_elem(loc, ${uint256(0)}, length);`,
      `}`,
    ].join('\n');

    const importedFuncs = [
      this.requireImport(...UINT256_EQ),
      this.requireImport(...UINT256_ADD),
      this.requireImport(...GET_U128),
    ];
    return {
      name: funcName,
      code: deleteFunc,
      functionsCalled: [...importedFuncs, dynArray, dynArrayLen, readFunc],
    };
  }

  private deleteSmallStaticArray(type: ArrayType): GeneratedFunctionInfo {
    const funcName = `WS${this.getId()}_SMALL_STATIC_ARRAY_DELETE`;
    this.creatingFunctions.set(generateKey(type), funcName);

    assert(type.size !== undefined);
    const [deleteCode, funcCalls] = this.generateStaticArrayDeletionCode(
      type,
      type.elementT,
      narrowBigIntSafe(type.size),
    );

    const code = [
      `func ${funcName}${IMPLICITS}(loc: felt) {`,
      `   alloc_locals;`,
      ...deleteCode,
      `   return ();`,
      `}`,
    ].join('\n');

    return {
      name: funcName,
      code: code,
      functionsCalled: funcCalls,
    };
  }

  private deleteLargeStaticArray(type: ArrayType): GeneratedFunctionInfo {
    assert(type.size !== undefined);
    const funcName = `WS${this.getId()}_LARGE_STATIC_ARRAY_DELETE`;
    this.creatingFunctions.set(generateKey(type), funcName);

    const elementT = generalizeType(type.elementT)[0];
    const elementTWidht = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;

    const storageReadFunc = this.storageReadGen.getOrCreateFuncDef(elementT);
    const auxDeleteFuncName = this.safeGetOrCreateFuncDef(type, elementT);

    const deleteCode = requiresReadBeforeRecursing(elementT)
      ? [`   let (elem_id) = ${storageReadFunc.name}(loc);`, `   ${auxDeleteFuncName}(elem_id);`]
      : [`    ${auxDeleteFuncName}(loc);`];
    const length = narrowBigIntSafe(type.size);
    const nextLoc = add('loc', elementTWidht);

    const deleteFunc = [
      `func ${funcName}_elem${IMPLICITS}(loc : felt, index : felt){`,
      `     alloc_locals;`,
      `     if (index == ${length}){`,
      `        return ();`,
      `     }`,
      `     let next_index = index + 1;`,
      ...deleteCode,
      `     return ${funcName}_elem(${nextLoc}, next_index);`,
      `}`,
      `func ${funcName}${IMPLICITS}(loc : felt){`,
      `   alloc_locals;`,
      `   return ${funcName}_elem(loc, 0);`,
      `}`,
    ].join('\n');

    const importedFuncs = [
      this.requireImport(...UINT256_EQ),
      this.requireImport(...UINT256_SUB),
      this.requireImport(...GET_U128),
    ];

    return {
      name: funcName,
      code: deleteFunc,
      functionsCalled: [...importedFuncs, storageReadFunc],
    };
  }

  private deleteStruct(type: UserDefinedType, structDef: StructDefinition): GeneratedFunctionInfo {
    const funcName = `WS_STRUCT_${structDef.name}_DELETE`;
    this.creatingFunctions.set(generateKey(type), funcName);

    const [deleteCode, funcCalls] = this.generateStructDeletionCode(
      type,
      structDef.vMembers.map((varDecl) => safeGetNodeType(varDecl, this.ast.inference)),
    );

    const deleteFunc = [
      `func ${funcName}${IMPLICITS}(loc : felt){`,
      `   alloc_locals;`,
      ...deleteCode,
      `   return ();`,
      `}`,
    ].join('\n');

    return { name: funcName, code: deleteFunc, functionsCalled: funcCalls };
  }

  private deleteNothing(type: TypeNode): GeneratedFunctionInfo {
    const funcName = 'WS_MAP_DELETE';
    this.creatingFunctions.set(generateKey(type), funcName);

    return {
      name: funcName,
      code: [`func ${funcName}${IMPLICITS}(loc: felt){`, `    return ();`, `}`].join('\n'),
      functionsCalled: [],
    };
  }

  private generateStructDeletionCode(
    structType: UserDefinedType,
    varDeclarations: TypeNode[],
    index = 0,
    offset = 0,
  ): [string[], CairoFunctionDefinition[]] {
    if (index >= varDeclarations.length) {
      return [[], []];
    }

    const varType = generalizeType(varDeclarations[index])[0];
    const varWidth = CairoType.fromSol(
      varType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;

    const readIdFunc = this.storageReadGen.getOrCreateFuncDef(varType);
    const auxDeleteFuncName = this.safeGetOrCreateFuncDef(structType, varType);

    const deleteLoc = add('loc', offset);
    const deleteCode = requiresReadBeforeRecursing(varType)
      ? [
          `   let (elem_id) = ${readIdFunc.name}(${deleteLoc});`,
          `   ${auxDeleteFuncName}(elem_id);`,
        ]
      : [`    ${auxDeleteFuncName}(${deleteLoc});`];

    const [code, funcsCalled] = this.generateStructDeletionCode(
      structType,
      varDeclarations,
      index + 1,
      offset + varWidth,
    );
    return [
      [...deleteCode, ...code],
      [readIdFunc, ...funcsCalled],
    ];
  }

  private generateStaticArrayDeletionCode(
    arrayType: ArrayType,
    elementT: TypeNode,
    size: number,
  ): [string[], CairoFunctionDefinition[]] {
    const elementTWidth = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;
    const readIdFunc = this.storageReadGen.getOrCreateFuncDef(elementT);
    const auxDeleteFuncName = this.safeGetOrCreateFuncDef(arrayType, elementT);

    const generateDeleteCode = requiresReadBeforeRecursing(elementT)
      ? (deleteLoc: string) => [
          `   let (elem_id) = ${readIdFunc.name}(${deleteLoc});`,
          `   ${auxDeleteFuncName}(elem_id);`,
        ]
      : (deleteLoc: string) => [`    ${auxDeleteFuncName}(${deleteLoc});`];

    const generateCode = (index: number, offset: number): string[] => {
      if (index === size) {
        return [];
      }
      const deleteLoc = add('loc', offset);
      const deleteCode = generateDeleteCode(deleteLoc);

      return [...deleteCode, ...generateCode(index + 1, offset + elementTWidth)];
    };

    return [generateCode(0, 0), requiresReadBeforeRecursing(elementT) ? [readIdFunc] : []];
  }

  private processRecursiveDependencies() {
    [...this.functionDependencies.entries()].forEach(([key, dependencies]) => {
      if (!this.creatingFunctions.has(key)) {
        const generatedFunc = this.generatedFunctionsDef.get(key);
        assert(generatedFunc instanceof CairoGeneratedFunctionDefinition);

        dependencies.forEach((otherKey) => {
          const otherFunc = this.generatedFunctionsDef.get(otherKey);
          if (otherFunc === undefined) {
            assert(this.creatingFunctions.has(otherKey));
            return;
          }
          generatedFunc.functionsCalled.push(otherFunc);
        });
      }
    });
  }

  private getId() {
    return this.generatedFunctionsDef.size + this.creatingFunctions.size;
  }
}

function requiresReadBeforeRecursing(type: TypeNode): boolean {
  return isDynamicArray(type) || type instanceof MappingType;
}

function generateKey(type: TypeNode) {
  return type.pp();
}
