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
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoFunctionDefinition } from '../../export';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { getElementType, isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode, mapRange, narrowBigIntSafe } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';
import { StorageReadGen } from './storageRead';

const IMPLICITS = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

export class StorageDeleteGen extends StringIndexedFuncGen {
  private nothingHandlerGen: boolean;
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageReadGen: StorageReadGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
    this.nothingHandlerGen = false;
  }

  public gen(node: Expression): FunctionCall {
    const nodeType = generalizeType(safeGetNodeType(node, this.ast.inference))[0];
    const funcDef = this.getOrCreateFuncDef(nodeType);
    return createCallToFunction(funcDef, [node], this.ast);
  }

  public getOrCreateFuncDef(type: TypeNode) {
    const key = type.pp();
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const funcInfo = this.getOrCreate(type);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [['loc', typeNameFromTypeNode(type, this.ast), DataLocation.Storage]],
      [],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(type: TypeNode): GeneratedFunctionInfo {
    const cairoFuncName = delegateBasedOnType<string>(
      type,
      () => `WS${this.generatedFunctionsDef.size}_DYNAMIC_ARRAY_DELETE`,
      () => `WS${this.generatedFunctionsDef.size}_STATIC_ARRAY_DELETE`,
      (_type, def) => `WS_STRUCT_${def.name}_DELETE`,
      () => `WS_MAP_DELETE`,
      () => `WS${this.generatedFunctionsDef.size}_DELETE`,
    );

    const funcInfo = delegateBasedOnType<GeneratedFunctionInfo>(
      type,
      (type) => this.deleteDynamicArray(type, cairoFuncName),
      (type) => {
        assert(type.size !== undefined);
        return type.size <= 5
          ? this.deleteSmallStaticArray(type, cairoFuncName)
          : this.deleteLargeStaticArray(type, cairoFuncName);
      },
      (_type, def) => this.deleteStruct(def, cairoFuncName),
      () => this.deleteNothing(cairoFuncName),
      () => this.deleteGeneric(CairoType.fromSol(type, this.ast), cairoFuncName),
    );

    // WS_MAP_DELETE can be keyed with multiple types but since its definition
    // is always the same we want to make sure its not duplicated or else it
    // clashes with itself.
    if (funcInfo.name === 'WS_MAP_DELETE' && !this.nothingHandlerGen) {
      this.nothingHandlerGen = true;
    } else if (funcInfo.name === 'WS_MAP_DELETE' && this.nothingHandlerGen) {
      funcInfo.code = '';
      return funcInfo;
    }
    return funcInfo;
  }

  private deleteGeneric(cairoType: CairoType, funcName: string): GeneratedFunctionInfo {
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

  private deleteDynamicArray(
    type: ArrayType | BytesType | StringType,
    funcName: string,
  ): GeneratedFunctionInfo {
    const elementT = generalizeType(getElementType(type))[0];

    const arrayDef = this.dynArrayGen.getOrCreateFuncDef(elementT);
    const arrayName = arrayDef.name;
    const lengthName = arrayName + '_LENGTH';

    const readFunc = this.storageReadGen.getOrCreateFuncDef(elementT);
    const auxDeleteFunc = this.getOrCreateFuncDef(elementT);

    const deleteCode = requiresReadBeforeRecursing(elementT)
      ? [`   let (elem_id) = ${readFunc.name}(elem_loc);`, `   ${auxDeleteFunc.name}(elem_id);`]
      : [`    ${auxDeleteFunc.name}(elem_loc);`];

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
      this.requireImport('starkware.cairo.common.uint256', 'uint256_eq'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_add'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
    ];
    return {
      name: funcName,
      code: deleteFunc,
      functionsCalled: [...importedFuncs, arrayDef, readFunc, auxDeleteFunc],
    };
  }

  private deleteSmallStaticArray(type: ArrayType, funcName: string): GeneratedFunctionInfo {
    assert(type.size !== undefined);
    const [deleteCode, funcCalls] = this.generateStaticArrayDeletionCode(
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

  private deleteLargeStaticArray(type: ArrayType, funcName: string): GeneratedFunctionInfo {
    assert(type.size !== undefined);

    const elementT = generalizeType(type.elementT)[0];
    const elementTWidht = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;

    const storageReadFunc = this.storageReadGen.getOrCreateFuncDef(elementT);
    const auxiliarDeleteFunc = this.getOrCreateFuncDef(elementT);

    const deleteCode = requiresReadBeforeRecursing(elementT)
      ? [
          `   let (elem_id) = ${storageReadFunc.name}(loc);`,
          `   ${auxiliarDeleteFunc.name}(elem_id);`,
        ]
      : [`    ${auxiliarDeleteFunc.name}(loc);`];
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
      this.requireImport('starkware.cairo.common.uint256', 'uint256_eq'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_sub'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
    ];

    return {
      name: funcName,
      code: deleteFunc,
      functionsCalled: [...importedFuncs, storageReadFunc, auxiliarDeleteFunc],
    };
  }

  private deleteStruct(structDef: StructDefinition, funcName: string): GeneratedFunctionInfo {
    const [deleteCode, funcCalls] = this.generateStructDeletionCode(
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

  private deleteNothing(funcName: string): GeneratedFunctionInfo {
    return {
      name: funcName,
      code: [`func ${funcName}{}(loc: felt){`, `    return ();`, `}`].join('\n'),
      functionsCalled: [],
    };
  }

  private generateStructDeletionCode(
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
    const auxDeleteFunc = this.getOrCreateFuncDef(varType);

    const deleteLoc = add('loc', offset);
    const deleteCode = requiresReadBeforeRecursing(varType)
      ? [
          `   let (elem_id) = ${readIdFunc.name}(${deleteLoc});`,
          `   ${auxDeleteFunc.name}(elem_id);`,
        ]
      : [`    ${auxDeleteFunc.name}(${deleteLoc});`];

    const [code, funcsCalled] = this.generateStructDeletionCode(
      varDeclarations,
      index + 1,
      offset + varWidth,
    );
    return [
      [...deleteCode, ...code],
      [readIdFunc, auxDeleteFunc, ...funcsCalled],
    ];
  }

  private generateStaticArrayDeletionCode(
    elementT: TypeNode,
    size: number,
  ): [string[], CairoFunctionDefinition[]] {
    const elementTWidth = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;
    const readIdFunc = this.storageReadGen.getOrCreateFuncDef(elementT);
    const auxDeleteFunc = this.getOrCreateFuncDef(elementT);

    const generateDeleteCode = requiresReadBeforeRecursing(elementT)
      ? (deleteLoc: string) => [
          `   let (elem_id) = ${readIdFunc.name}(${deleteLoc});`,
          `   ${auxDeleteFunc.name}(elem_id);`,
        ]
      : (deleteLoc: string) => [`    ${auxDeleteFunc.name}(${deleteLoc});`];

    const generateCode = (index: number, offset: number): string[] => {
      if (index === size) {
        return [];
      }
      const deleteLoc = add('loc', offset);
      const deleteCode = generateDeleteCode(deleteLoc);

      return [...deleteCode, ...generateCode(index + 1, offset + elementTWidth)];
    };

    return [generateCode(0, 0), [readIdFunc, auxDeleteFunc]];
  }
}

function requiresReadBeforeRecursing(type: TypeNode): boolean {
  return isDynamicArray(type) || type instanceof MappingType;
}
