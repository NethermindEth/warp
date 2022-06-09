import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  BytesType,
  DataLocation,
  Expression,
  FunctionCall,
  generalizeType,
  getNodeType,
  MappingType,
  PointerType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { getElementType, isDynamicArray } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode, mapRange, narrowBigIntSafe } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, CairoFunction, delegateBasedOnType, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';
import { StorageReadGen } from './storageRead';

export class StorageDeleteGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageReadGen: StorageReadGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }

  gen(node: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    const nodeType = dereferenceType(getNodeType(node, this.ast.compilerVersion));

    const functionName = this.getOrCreate(nodeType);

    const functionStub = createCairoFunctionStub(
      functionName,
      [['loc', typeNameFromTypeNode(nodeType, this.ast), DataLocation.Storage]],
      [],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? node,
    );
    return createCallToFunction(functionStub, [node], this.ast);
  }

  genFuncName(node: TypeNode): string {
    return this.getOrCreate(node);
  }

  genAuxFuncName(node: TypeNode): string {
    return `${this.getOrCreate(node)}_elem`;
  }

  private getOrCreate(type: TypeNode): string {
    const key = type.pp();
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const cairoFunc = delegateBasedOnType<CairoFunction>(
      type,
      (type) => this.deleteDynamicArray(type),
      (type) => {
        assert(type.size !== undefined);
        return type.size <= 5
          ? this.deleteSmallStaticArray(type)
          : this.deleteLargeStaticArray(type);
      },
      (_type, def) => this.deleteStruct(def),
      () => this.deleteNothing(),
      () => this.deleteGeneric(CairoType.fromSol(type, this.ast)),
    );

    this.generatedFunctions.set(key, cairoFunc);

    return cairoFunc.name;
  }

  private deleteGeneric(cairoType: CairoType): CairoFunction {
    const funcName = `WS${this.generatedFunctions.size}_DELETE`;
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(loc: felt):`,
        ...mapRange(cairoType.width, (n) => `    WARP_STORAGE.write(${add('loc', n)}, 0)`),
        `    return ()`,
        `end`,
      ].join('\n'),
    };
  }

  private deleteDynamicArray(type: ArrayType | BytesType | StringType): CairoFunction {
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

    const elementT = dereferenceType(getElementType(type));
    const [arrayName, lengthName] = this.dynArrayGen.gen(
      CairoType.fromSol(elementT, this.ast, TypeConversionContext.StorageAllocation),
    );

    const deleteCode = requiresReadBeforeRecursing(elementT)
      ? [
          `   let (elem_id) = ${this.storageReadGen.genFuncName(elementT)}(elem_loc)`,
          `   ${this.getOrCreate(elementT)}(elem_id)`,
        ]
      : [`    ${this.getOrCreate(elementT)}(elem_loc)`];

    const funcName = `WS${this.generatedFunctions.size}_DYNAMIC_ARRAY_DELETE`;
    const deleteFunc = [
      `func ${funcName}_elem${implicits}(loc : felt, index : Uint256, length : Uint256):`,
      `     alloc_locals`,
      `     let (stop) = uint256_eq(index, length)`,
      `     if stop == 1:`,
      `        return ()`,
      `     end`,
      `     let (elem_loc) = ${arrayName}.read(loc, index)`,
      ...deleteCode,
      `     let (next_index, _) = uint256_add(index, ${uint256(1)})`,
      `     return ${funcName}_elem(loc, next_index, length)`,
      `end`,
      `func ${funcName}${implicits}(loc : felt):`,
      `   alloc_locals`,
      `   let (length) = ${lengthName}.read(loc)`,
      `   ${lengthName}.write(loc, ${uint256(0)})`,
      `   return ${funcName}_elem(loc, ${uint256(0)}, length)`,
      `end`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'uint256_eq');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');

    return { name: funcName, code: deleteFunc };
  }

  private deleteSmallStaticArray(type: ArrayType) {
    assert(type.size !== undefined);
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

    const code = [
      `   alloc_locals`,
      ...this.generateStructDeletionCode(
        mapRange(narrowBigIntSafe(type.size), () => type.elementT),
      ),
      `   return ()`,
      `end`,
    ];
    const funcName = `WS${this.generatedFunctions.size}_STATIC_ARRAY_DELETE`;

    return {
      name: funcName,
      code: [`func ${funcName}${implicits}(loc : felt):`, ...code].join('\n'),
    };
  }

  private deleteLargeStaticArray(type: ArrayType) {
    assert(type.size !== undefined);

    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    const elementT = dereferenceType(type.elementT);
    const elementTWidht = CairoType.fromSol(
      elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    ).width;

    const deleteCode = requiresReadBeforeRecursing(elementT)
      ? [
          `   let (elem_id) = ${this.storageReadGen.genFuncName(elementT)}(loc)`,
          `   ${this.getOrCreate(elementT)}(elem_id)`,
        ]
      : [`    ${this.getOrCreate(elementT)}(loc)`];
    const funcName = `WS${this.generatedFunctions.size}_STATIC_ARRAY_DELETE`;
    const length = narrowBigIntSafe(type.size);
    const nextLoc = add('loc', elementTWidht);
    const deleteFunc = [
      `func ${funcName}_elem${implicits}(loc : felt, index : felt):`,
      `     alloc_locals`,
      `     if index == ${length}:`,
      `        return ()`,
      `     end`,
      `     let next_index = index + 1`,
      ...deleteCode,
      `     return ${funcName}_elem(${nextLoc}, next_index)`,
      `end`,
      `func ${funcName}${implicits}(loc : felt):`,
      `   alloc_locals`,
      `   return ${funcName}_elem(loc, 0)`,
      `end`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'uint256_eq');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');

    return { name: funcName, code: deleteFunc };
  }

  private deleteStruct(structDef: StructDefinition): CairoFunction {
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

    // struct names are unique
    const funcName = `WS_STRUCT_${structDef.name}_DELETE`;
    const deleteFunc = [
      `func ${funcName}${implicits}(loc : felt):`,
      `   alloc_locals`,
      ...this.generateStructDeletionCode(
        structDef.vMembers.map((varDecl) => getNodeType(varDecl, this.ast.compilerVersion)),
      ),
      `   return ()`,
      `end`,
    ].join('\n');

    return { name: funcName, code: deleteFunc };
  }

  private deleteNothing(): CairoFunction {
    const funcName = `WSMAP_DELETE`;
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    return {
      name: funcName,
      code: [`func ${funcName}${implicits}(loc: felt):`, `    return ()`, `end`].join('\n'),
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
          `   let (elem_id) = ${this.storageReadGen.genFuncName(varType)}(${deleteLoc})`,
          `   ${this.getOrCreate(varType)}(elem_id)`,
        ]
      : [`    ${this.getOrCreate(varType)}(${deleteLoc})`];

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
