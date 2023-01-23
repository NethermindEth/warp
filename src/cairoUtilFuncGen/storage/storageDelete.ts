import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  generalizeType,
  MappingType,
  PointerType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import { getElementType, isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode, mapRange, narrowBigIntSafe } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';
import { StorageReadGen } from './storageRead';

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

  gen(node: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    const nodeType = dereferenceType(safeGetNodeType(node, this.ast.inference));

    const funcDef = this.getOrCreateFuncDef(nodeType);
    return createCallToFunction(funcDef, [node], this.ast);
  }

  genFuncName(node: TypeNode): GeneratedFunctionInfo {
    return this.getOrCreate(node);
  }

  // TODO: Check what this function does
  genAuxFuncName(node: TypeNode): string {
    return `${this.getOrCreate(node)}_elem`;
  }

  getOrCreateFuncDef(type: TypeNode) {
    const key = `staticArrayIndexAccess(${type.pp()})`;
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
      () => `WSMAP_DELETE`,
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

    // WSMAP_DELETE can be keyed with multiple types but since its definition
    // is always the same we want to make sure its not duplicated or else it
    // clashes with itself.
    if (funcInfo.name === 'WSMAP_DELETE' && !this.nothingHandlerGen) {
      this.nothingHandlerGen = true;
    } else if (funcInfo.name === 'WSMAP_DELETE' && this.nothingHandlerGen) {
      funcInfo.code = '';
      return funcInfo;
    }
    return funcInfo;
  }

  private deleteGeneric(cairoType: CairoType, funcName: string): GeneratedFunctionInfo {
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(loc: felt){`,
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
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

    const funcsCalled: FunctionDefinition[] = [];

    const elementT = dereferenceType(getElementType(type));
    const arrayDef = this.dynArrayGen.getOrCreateFuncDef(elementT);
    funcsCalled.push(arrayDef);
    const arrayName = arrayDef.name;
    const lengthName = arrayName + '_LENGTH';

    funcsCalled.push(
      this.requireImport('starkware.cairo.common.uint256', 'uint256_eq'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_add'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
    );

    const calledFuncInfo = this.getOrCreate(elementT);
    funcsCalled.push(...calledFuncInfo.functionsCalled);
    const deleteCode = requiresReadBeforeRecursing(elementT)
      ? [
          `   let (elem_id) = ${this.storageReadGen.genFuncName(elementT)}(elem_loc);`,
          `   ${calledFuncInfo.name}(elem_id);`,
        ]
      : [`    ${calledFuncInfo.name}(elem_loc);`];

    const deleteFunc = [
      `func ${funcName}_elem${implicits}(loc : felt, index : Uint256, length : Uint256){`,
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
      `func ${funcName}${implicits}(loc : felt){`,
      `   alloc_locals;`,
      `   let (length) = ${lengthName}.read(loc);`,
      `   ${lengthName}.write(loc, ${uint256(0)});`,
      `   return ${funcName}_elem(loc, ${uint256(0)}, length);`,
      `}`,
    ].join('\n');

    return { name: funcName, code: deleteFunc, functionsCalled: funcsCalled };
  }

  private deleteSmallStaticArray(type: ArrayType, funcName: string): GeneratedFunctionInfo {
    assert(type.size !== undefined);
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

    const code = [
      `   alloc_locals;`,
      ...this.generateStructDeletionCode(
        mapRange(narrowBigIntSafe(type.size), () => type.elementT),
      ),
      `   return ();`,
      `}`,
    ];

    return {
      name: funcName,
      code: [`func ${funcName}${implicits}(loc : felt){`, ...code].join('\n'),
      functionsCalled: [],
    };
  }

  private deleteLargeStaticArray(type: ArrayType, funcName: string): GeneratedFunctionInfo {
    assert(type.size !== undefined);

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const elementT = dereferenceType(type.elementT);
    const elementTWidht = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.uint256', 'uint256_eq'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_sub'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
    );

    const calledFuncInfo = this.getOrCreate(elementT);
    funcsCalled.push(...calledFuncInfo.functionsCalled);
    const deleteCode = requiresReadBeforeRecursing(elementT)
      ? [
          `   let (elem_id) = ${this.storageReadGen.genFuncName(elementT)}(loc);`,
          `   ${calledFuncInfo.name}(elem_id);`,
        ]
      : [`    ${calledFuncInfo.name}(loc);`];
    const length = narrowBigIntSafe(type.size);
    const nextLoc = add('loc', elementTWidht);
    const deleteFunc = [
      `func ${funcName}_elem${implicits}(loc : felt, index : felt){`,
      `     alloc_locals;`,
      `     if (index == ${length}){`,
      `        return ();`,
      `     }`,
      `     let next_index = index + 1;`,
      ...deleteCode,
      `     return ${funcName}_elem(${nextLoc}, next_index);`,
      `}`,
      `func ${funcName}${implicits}(loc : felt){`,
      `   alloc_locals;`,
      `   return ${funcName}_elem(loc, 0);`,
      `}`,
    ].join('\n');

    return { name: funcName, code: deleteFunc, functionsCalled: funcsCalled };
  }

  private deleteStruct(structDef: StructDefinition, funcName: string): GeneratedFunctionInfo {
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    // struct names are unique
    const deleteFunc = [
      `func ${funcName}${implicits}(loc : felt){`,
      `   alloc_locals;`,
      ...this.generateStructDeletionCode(
        structDef.vMembers.map((varDecl) => safeGetNodeType(varDecl, this.ast.inference)),
      ),
      `   return ();`,
      `}`,
    ].join('\n');

    return { name: funcName, code: deleteFunc, functionsCalled: [] };
  }

  private deleteNothing(funcName: string): GeneratedFunctionInfo {
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    return {
      name: funcName,
      code: [`func ${funcName}${implicits}(loc: felt){`, `    return ();`, `}`].join('\n'),
      functionsCalled: [],
    };
  }

  private generateStructDeletionCode(varDeclarations: TypeNode[], index = 0, offset = 0): string[] {
    if (index >= varDeclarations.length) return [];
    const varType = dereferenceType(varDeclarations[index]);
    const varWidth = CairoType.fromSol(
      varType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;

    const deleteLoc = add('loc', offset);
    const deleteCode = requiresReadBeforeRecursing(varType)
      ? [
          `   let (elem_id) = ${this.storageReadGen.genFuncName(varType)}(${deleteLoc});`,
          `   ${this.getOrCreate(varType).name}(elem_id);`,
        ]
      : [`    ${this.getOrCreate(varType).name}(${deleteLoc});`];

    return [
      ...deleteCode,
      ...this.generateStructDeletionCode(varDeclarations, index + 1, offset + varWidth),
    ];
  }
}

function dereferenceType(type: TypeNode): TypeNode {
  return generalizeType(type)[0];
}

function requiresReadBeforeRecursing(type: TypeNode): boolean {
  if (type instanceof PointerType) return requiresReadBeforeRecursing(type.to);
  return isDynamicArray(type) || type instanceof MappingType;
}
