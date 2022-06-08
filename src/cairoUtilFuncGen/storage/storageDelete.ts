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
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { getElementType } from '../../utils/nodeTypeProcessing';
import { typeNameFromTypeNode, mapRange, narrowBigIntSafe } from '../../utils/utils';
import { add, CairoFunction, StringIndexedFuncGen } from '../base';
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

  private getOrCreate(type: TypeNode): string {
    let prefix;
    if (type instanceof ArrayType && type.size === undefined) {
      prefix = `DELETE_DARRAY_${getNestedNumber(type).toString()}`;
    } else if (type instanceof MappingType) {
      prefix = `DELETE_MAPPING`;
    } else {
      prefix = '';
    }
    const fromType = getBaseType(type);

    const cairoType = CairoType.fromSol(
      fromType,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const key = `${prefix}${cairoType.fullStringRepresentation}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    let cairoFunc;
    if (type instanceof ArrayType) {
      cairoFunc =
        type.size === undefined
          ? this.deleteDynamicArray(type)
          : type.size <= 5
          ? this.deleteSmallStaticArray(type)
          : this.deleteLargeStaticArray(type);
    } else if (type instanceof BytesType) {
      cairoFunc = this.deleteDynamicArray(type);
    } else if (type instanceof MappingType) {
      cairoFunc = this.deleteNothing();
    } else if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      cairoFunc = this.deleteStruct(type.definition);
    } else {
      cairoFunc = this.deleteGeneric(cairoType);
    }

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

  private deleteDynamicArray(type: ArrayType | BytesType): CairoFunction {
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
      `func ${funcName}_elem${implicits}(loc : felt, index : Uint256):`,
      `     alloc_locals`,
      `     let (stop) = uint256_eq(index, Uint256(0, 0))`,
      `     if stop == 1:`,
      `        return ()`,
      `     end`,
      `     let (next_index) = uint256_sub(index, Uint256(1, 0))`,
      `     let (elem_loc) = ${arrayName}.read(loc, next_index)`,
      ...deleteCode,
      `     return ${funcName}_elem(loc, next_index)`,
      `end`,
      `func ${funcName}${implicits}(loc : felt):`,
      `   alloc_locals`,
      `   let (length) = ${lengthName}.read(loc)`,
      `   ${lengthName}.write(loc, Uint256(0, 0))`,
      `   return ${funcName}_elem(loc, length)`,
      `end`,
    ].join('\n');

    this.requireImport('starkware.cairo.common.uint256', 'uint256_eq');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
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

function getNestedNumber(type: ArrayType | BytesType | MappingType): number {
  const valueType = dereferenceType(
    type instanceof MappingType ? type.valueType : getElementType(type),
  );

  return 1 + (valueType instanceof ArrayType ? getNestedNumber(valueType) : 0);
}

function getBaseType(type: TypeNode): TypeNode {
  return type instanceof ArrayType && type.size === undefined
    ? getBaseType(dereferenceType(type.elementT))
    : type;
}

function dereferenceType(type: TypeNode): TypeNode {
  return generalizeType(type)[0];
}

function requiresReadBeforeRecursing(type: TypeNode): boolean {
  if (type instanceof PointerType) return requiresReadBeforeRecursing(type.to);
  return (
    (type instanceof ArrayType && type.size === undefined) ||
    type instanceof BytesType ||
    type instanceof MappingType
  );
}
