import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  BytesType,
  DataLocation,
  Expression,
  FixedBytesType,
  FunctionCall,
  FunctionDefinition,
  FunctionStateMutability,
  generalizeType,
  IntType,
  SourceUnit,
  StringType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { printTypeNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext, WarpLocation } from '../../utils/cairoTypeSystem';
import { TranspileFailedError } from '../../utils/errors';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import {
  getElementType,
  getSize,
  isReferenceType,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, delegateBasedOnType, GeneratedFunctionInfo, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';
import { StorageDeleteGen } from './storageDelete';

/*
  Generates functions to copy data from WARP_STORAGE to WARP_STORAGE
  The main point of care here is to copy dynamic arrays. Mappings and types containing them
  cannot be copied from storage to storage, and all types other than dynamic arrays can be
  copied by caring only about their width
*/

export class StorageToStorageGen extends StringIndexedFuncGen {
  private genNode: Expression = new Expression(0, '', '');
  private genNodeInSourceUnit?: ASTNode;
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageDeleteGen: StorageDeleteGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }
  gen(to: Expression, from: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    this.genNode = to;
    this.genNodeInSourceUnit = nodeInSourceUnit;
    const toType = generalizeType(safeGetNodeType(to, this.ast.inference))[0];
    const fromType = generalizeType(safeGetNodeType(from, this.ast.inference))[0];
    const funcDef = this.getOrCreateFuncDef(toType, fromType, to, nodeInSourceUnit);

    return createCallToFunction(funcDef, [to, from], this.ast);
  }

  getOrCreateFuncDef(
    toType: TypeNode,
    fromType: TypeNode,
    node: Expression,
    nodeInSourceUnit?: ASTNode,
  ) {
    const funcInfo = this.getOrCreate(toType, fromType);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      [
        ['toLoc', typeNameFromTypeNode(toType, this.ast), DataLocation.Storage],
        ['fromLoc', typeNameFromTypeNode(fromType, this.ast), DataLocation.Storage],
      ],
      [['retLoc', typeNameFromTypeNode(toType, this.ast), DataLocation.Storage]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'bitwise_ptr'],
      this.ast,
      nodeInSourceUnit ?? node,
      { mutability: FunctionStateMutability.View },
    );
    return funcDef;
  }

  getOrCreate(toType: TypeNode, fromType: TypeNode): GeneratedFunctionInfo {
    const key = `${fromType.pp()}->${toType.pp()}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcName = `ws_copy${this.generatedFunctions.size}`;

    // Set an empty entry so recursive function generation doesn't clash
    const emptyFuncInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: '',
      functionsCalled: [],
    };
    this.generatedFunctions.set(key, emptyFuncInfo);

    const funcInfo = delegateBasedOnType<GeneratedFunctionInfo>(
      toType,
      (toType) => {
        assert(
          fromType instanceof ArrayType ||
            fromType instanceof BytesType ||
            fromType instanceof StringType,
        );
        if (getSize(fromType) === undefined) {
          return this.createDynamicArrayCopyFunction(funcName, toType, fromType);
        } else {
          assert(fromType instanceof ArrayType);
          return this.createStaticToDynamicArrayCopyFunction(funcName, toType, fromType);
        }
      },
      (toType) => {
        assert(fromType instanceof ArrayType);
        return this.createStaticArrayCopyFunction(funcName, toType, fromType);
      },
      (toType) => this.createStructCopyFunction(funcName, toType),
      () => {
        throw new TranspileFailedError('Attempted to create mapping clone function');
      },
      (toType) => {
        if (toType instanceof IntType) {
          assert(fromType instanceof IntType);
          return this.createIntegerCopyFunction(funcName, toType, fromType);
        } else if (toType instanceof FixedBytesType) {
          assert(fromType instanceof FixedBytesType);
          return this.createFixedBytesCopyFunction(funcName, toType, fromType);
        } else {
          return this.createValueTypeCopyFunction(funcName, toType);
        }
      },
    );

    this.generatedFunctions.set(key, funcInfo);
    return funcInfo;
  }

  private createStructCopyFunction(funcName: string, type: UserDefinedType): GeneratedFunctionInfo {
    const def = type.definition;
    assert(def instanceof StructDefinition);
    const members = def.vMembers.map((decl) => safeGetNodeType(decl, this.ast.inference));

    const funcsCalled: FunctionDefinition[] = [];

    let offset = 0;
    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(to_loc: felt, from_loc: felt) -> (retLoc: felt){`,
        `    alloc_locals;`,
        ...members.map((memberType): string => {
          const width = CairoType.fromSol(
            memberType,
            this.ast,
            TypeConversionContext.StorageAllocation,
          ).width;
          let code: string;
          if (isReferenceType(memberType)) {
            const memberCopyFuncInfo = this.getOrCreate(memberType, memberType);
            funcsCalled.push(...memberCopyFuncInfo.functionsCalled);
            code = `${memberCopyFuncInfo.name}(${add('to_loc', offset)}, ${add(
              'from_loc',
              offset,
            )});`;
          } else {
            code = mapRange(width, (index) => copyAtOffset(index + offset)).join('\n');
          }
          offset += width;
          return code;
        }),
        `    return (to_loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
  }

  private createStaticArrayCopyFunction(
    funcName: string,
    toType: ArrayType,
    fromType: ArrayType,
  ): GeneratedFunctionInfo {
    assert(
      toType.size !== undefined,
      `Attempted to copy to storage dynamic array as static array in ${printTypeNode(
        fromType,
      )}->${printTypeNode(toType)}`,
    );
    assert(
      fromType.size !== undefined,
      `Attempted to copy from storage dynamic array as static array in ${printTypeNode(
        fromType,
      )}->${printTypeNode(toType)}`,
    );

    const funcsCalled: FunctionDefinition[] = [];

    const elementCopyFuncInfo = this.getOrCreate(toType.elementT, fromType.elementT);
    funcsCalled.push(...elementCopyFuncInfo.functionsCalled);

    const toElemType = CairoType.fromSol(
      toType.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const fromElemType = CairoType.fromSol(
      fromType.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const copyCode = createElementCopy(toElemType, fromElemType, elementCopyFuncInfo.name);

    const fromSize = narrowBigIntSafe(fromType.size);
    const toSize = narrowBigIntSafe(toType.size);
    let stopRecursion;
    if (fromSize === toSize) {
      stopRecursion = [`if (index == ${fromSize}){`, `return ();`, `}`];
    } else {
      const calledFuncInfo = this.storageDeleteGen.genFuncName(toType.elementT);
      funcsCalled.push(
        ...calledFuncInfo.functionsCalled,
        this.requireImport('starkware.cairo.common.math_cmp', 'is_le'),
      );
      stopRecursion = [
        `if (index == ${toSize}){`,
        `    return ();`,
        `}`,
        `let lesser = is_le(index, ${fromSize - 1});`,
        `if (lesser == 0){`,
        `    ${calledFuncInfo.name}(to_elem_loc);`,
        `    return ${funcName}_elem(to_elem_loc + ${toElemType.width}, from_elem_loc, index + 1);`,
        `}`,
      ];
    }

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(to_elem_loc: felt, from_elem_loc: felt, index: felt) -> (){`,
        ...stopRecursion,
        `    ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `    return ${funcName}_elem(to_elem_loc + ${toElemType.width}, from_elem_loc + ${fromElemType.width}, index + 1);`,
        `}`,
        `func ${funcName}${implicits}(to_elem_loc: felt, from_elem_loc: felt) -> (retLoc: felt){`,
        `    ${funcName}_elem(to_elem_loc, from_elem_loc, 0);`,
        `    return (to_elem_loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
  }

  private createDynamicArrayCopyFunction(
    funcName: string,
    toType: ArrayType | BytesType | StringType,
    fromType: ArrayType | BytesType | StringType,
  ): GeneratedFunctionInfo {
    const fromElementT = getElementType(fromType);
    const fromSize = getSize(fromType);
    const toElementT = getElementType(toType);
    const toSize = getSize(toType);
    assert(toSize === undefined, 'Attempted to copy to storage static array as dynamic array');
    assert(fromSize === undefined, 'Attempted to copy from storage static array as dynamic array');

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_sub'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_lt'),
    );

    const elementCopyFuncInfo = this.getOrCreate(toElementT, fromElementT);
    funcsCalled.push(...elementCopyFuncInfo.functionsCalled);

    const fromElementCairoType = CairoType.fromSol(
      fromElementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const toElementCairoType = CairoType.fromSol(
      toElementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );

    const fromElementMappingDef = this.dynArrayGen.gen(
      fromElementCairoType,
      this.genNode,
      this.genNodeInSourceUnit,
    );
    const fromElementMappingName = fromElementMappingDef.name;
    const fromLengthMappingName = fromElementMappingName + '_LENGTH';
    const toElementMappingDef = this.dynArrayGen.gen(
      toElementCairoType,
      this.genNode,
      this.genNodeInSourceUnit,
    );
    const toElementMappingName = toElementMappingDef.name;
    const toLengthMappingName = toElementMappingName + '_LENGTH';
    funcsCalled.push(fromElementMappingDef, toElementMappingDef);

    const copyCode = createElementCopy(
      toElementCairoType,
      fromElementCairoType,
      elementCopyFuncInfo.name,
    );

    const deleteRemainingCode = `${this.storageDeleteGen.genAuxFuncName(
      toType,
    )}(to_loc, from_length, to_length)`;

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(to_loc: felt, from_loc: felt, length: Uint256) -> (){`,
        `    alloc_locals;`,
        `    if (length.low == 0 and length.high == 0){`,
        `        return ();`,
        `    }`,
        `    let (index) = uint256_sub(length, Uint256(1,0));`,
        `    let (from_elem_loc) = ${fromElementMappingName}.read(from_loc, index);`,
        `    let (to_elem_loc) = ${toElementMappingName}.read(to_loc, index);`,
        `    if (to_elem_loc == 0){`,
        `        let (to_elem_loc) = WARP_USED_STORAGE.read();`,
        `        WARP_USED_STORAGE.write(to_elem_loc + ${toElementCairoType.width});`,
        `        ${toElementMappingName}.write(to_loc, index, to_elem_loc);`,
        `        ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `        return ${funcName}_elem(to_loc, from_loc, index);`,
        `    }else{`,
        `        ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `        return ${funcName}_elem(to_loc, from_loc, index);`,
        `    }`,
        `}`,
        `func ${funcName}${implicits}(to_loc: felt, from_loc: felt) -> (retLoc: felt){`,
        `    alloc_locals;`,
        `    let (from_length) = ${fromLengthMappingName}.read(from_loc);`,
        `    let (to_length) = ${toLengthMappingName}.read(to_loc);`,
        `    ${toLengthMappingName}.write(to_loc, from_length);`,
        `    ${funcName}_elem(to_loc, from_loc, from_length);`,
        `    let (lesser) = uint256_lt(from_length, to_length);`,
        `    if (lesser == 1){`,
        `       ${deleteRemainingCode};`,
        `       return (to_loc,);`,
        `    }else{`,
        `       return (to_loc,);`,
        `    }`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
  }

  private createStaticToDynamicArrayCopyFunction(
    funcName: string,
    toType: ArrayType | BytesType | StringType,
    fromType: ArrayType,
  ): GeneratedFunctionInfo {
    const toSize = getSize(toType);
    const toElementT = getElementType(toType);
    assert(fromType.size !== undefined);
    assert(toSize === undefined);

    const funcsCalled: FunctionDefinition[] = [];

    funcsCalled.push(
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_add'),
      this.requireImport('starkware.cairo.common.uint256', 'uint256_lt'),
    );

    const elementCopyFuncInfo = this.getOrCreate(toElementT, fromType.elementT);
    funcsCalled.push(...elementCopyFuncInfo.functionsCalled);
    const fromElementCairoType = CairoType.fromSol(
      fromType.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const toElementCairoType = CairoType.fromSol(
      toElementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const toElementMappingDef = this.dynArrayGen.gen(
      toElementCairoType,
      this.genNode,
      this.genNodeInSourceUnit,
    );
    const toElementMappingName = toElementMappingDef.name;
    const toLengthMappingName = toElementMappingName + '_LENGTH';
    const copyCode = createElementCopy(
      toElementCairoType,
      fromElementCairoType,
      elementCopyFuncInfo.name,
    );

    const deleteRemainingCode = `${this.storageDeleteGen.genAuxFuncName(
      toType,
    )}(to_loc, from_length, to_length)`;

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(to_loc: felt, from_elem_loc: felt, length: Uint256, index: Uint256) -> (){`,
        `    alloc_locals;`,
        `    if (length.low == index.low){`,
        `        if (length.high == index.high){`,
        `            return ();`,
        `        }`,
        `    }`,
        `    let (to_elem_loc) = ${toElementMappingName}.read(to_loc, index);`,
        `    let (next_index, carry) = uint256_add(index, Uint256(1,0));`,
        `    assert carry = 0;`,
        `    if (to_elem_loc == 0){`,
        `        let (to_elem_loc) = WARP_USED_STORAGE.read();`,
        `        WARP_USED_STORAGE.write(to_elem_loc + ${toElementCairoType.width});`,
        `        ${toElementMappingName}.write(to_loc, index, to_elem_loc);`,
        `        ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `        return ${funcName}_elem(to_loc, from_elem_loc + ${fromElementCairoType.width}, length, next_index);`,
        `    }else{`,
        `        ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `        return ${funcName}_elem(to_loc, from_elem_loc + ${fromElementCairoType.width}, length, next_index);`,
        `    }`,
        `}`,
        `func ${funcName}${implicits}(to_loc: felt, from_loc: felt) -> (retLoc: felt){`,
        `    alloc_locals;`,
        `    let from_length  = ${uint256(narrowBigIntSafe(fromType.size))};`,
        `    let (to_length) = ${toLengthMappingName}.read(to_loc);`,
        `    ${toLengthMappingName}.write(to_loc, from_length);`,
        `    ${funcName}_elem(to_loc, from_loc, from_length , Uint256(0,0));`,
        `    let (lesser) = uint256_lt(from_length, to_length);`,
        `    if (lesser == 1){`,
        `       ${deleteRemainingCode};`,
        `       return (to_loc,);`,
        `    }else{`,
        `       return (to_loc,);`,
        `    }`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
  }

  private createIntegerCopyFunction(
    funcName: string,
    toType: IntType,
    fromType: IntType,
  ): GeneratedFunctionInfo {
    assert(
      fromType.nBits <= toType.nBits,
      `Attempted to scale integer ${fromType.nBits} to ${toType.nBits}`,
    );

    const funcsCalled: FunctionDefinition[] = [];

    funcsCalled.push(this.requireImport('starkware.cairo.common.uint256', 'Uint256'));
    if (toType.signed) {
      funcsCalled.push(
        this.requireImport(
          'warplib.maths.int_conversions',
          `warp_int${fromType.nBits}_to_int${toType.nBits}`,
        ),
      );
    } else {
      funcsCalled.push(this.requireImport('warplib.maths.utils', 'felt_to_uint256'));
    }

    // Read changes depending if From is 256 bits or less
    const readFromCode =
      fromType.nBits === 256
        ? [
            'let (from_low) = WARP_STORAGE.read(from_loc);',
            'let (from_high) = WARP_STORAGE.read(from_loc + 1);',
            'tempvar from_elem = Uint256(from_low, from_high);',
          ].join('\n')
        : 'let (from_elem) = WARP_STORAGE.read(from_loc);';

    // Scaling for ints is different than for uints
    // Also memory represenation only change when To is 256 bits
    // and From is lesser than 256 bits
    const scalingCode = toType.signed
      ? `let (to_elem) = warp_int${fromType.nBits}_to_int${toType.nBits}(from_elem);`
      : toType.nBits === 256 && fromType.nBits < 256
      ? 'let (to_elem) = felt_to_uint256(from_elem);'
      : `let to_elem = from_elem;`;

    // Copy changes depending if To is 256 bits or less
    const copyToCode =
      toType.nBits === 256
        ? [
            'WARP_STORAGE.write(to_loc, to_elem.low);',
            'WARP_STORAGE.write(to_loc + 1, to_elem.high);',
          ].join('\n')
        : 'WARP_STORAGE.write(to_loc, to_elem);';

    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(to_loc : felt, from_loc : felt) -> (ret_loc : felt){`,
        `   alloc_locals;`,
        `   ${readFromCode}`,
        `   ${scalingCode}`,
        `   ${copyToCode}`,
        `   return (to_loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
  }

  private createFixedBytesCopyFunction(
    funcName: string,
    toType: FixedBytesType,
    fromType: FixedBytesType,
  ): GeneratedFunctionInfo {
    const bitWidthDiff = (toType.size - fromType.size) * 8;
    assert(bitWidthDiff >= 0, `Attempted to scale fixed byte ${fromType.size} to ${toType.size}`);

    const funcsCalled: FunctionDefinition[] = [];
    const conversionFunc = toType.size === 32 ? 'warp_bytes_widen_256' : 'warp_bytes_widen';
    funcsCalled.push(this.requireImport('warplib.maths.bytes_conversions', conversionFunc));

    const readFromCode =
      fromType.size === 32
        ? [
            'let (from_low) = WARP_STORAGE.read(from_loc);',
            'let (from_high) = WARP_STORAGE.read(from_loc + 1);',
            'tempvar from_elem = Uint256(from_low, from_high);',
          ].join('\n')
        : 'let (from_elem) = WARP_STORAGE.read(from_loc);';

    const scalingCode =
      bitWidthDiff !== 0
        ? `let (to_elem) = ${conversionFunc}(from_elem, ${bitWidthDiff});`
        : 'let to_elem = from_elem;';

    const copyToCode =
      toType.size === 32
        ? [
            'WARP_STORAGE.write(to_loc, to_elem.low);',
            'WARP_STORAGE.write(to_loc + 1, to_elem.high);',
          ].join('\n')
        : 'WARP_STORAGE.write(to_loc, to_elem);';

    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(to_loc : felt, from_loc : felt) -> (ret_loc : felt){`,
        `   alloc_locals;`,
        `   ${readFromCode}`,
        `   ${scalingCode}`,
        `   ${copyToCode}`,
        `   return (to_loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
  }

  private createValueTypeCopyFunction(funcName: string, type: TypeNode): GeneratedFunctionInfo {
    const width = CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation).width;

    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(to_loc : felt, from_loc : felt) -> (ret_loc : felt){`,
        `    alloc_locals;`,
        ...mapRange(width, copyAtOffset),
        `    return (to_loc,);`,
        `}`,
      ].join('\n'),
      functionsCalled: [],
    };
  }
}

const implicits =
  '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}';

function copyAtOffset(n: number): string {
  return [
    `let (copy) = WARP_STORAGE.read(${add('from_loc', n)});`,
    `WARP_STORAGE.write(${add('to_loc', n)}, copy);`,
  ].join('\n');
}

function createElementCopy(
  toElementCairoType: CairoType,
  fromElementCairoType: CairoType,
  elementCopyFunc: string,
): (to: string, from: string) => string {
  if (fromElementCairoType instanceof WarpLocation) {
    if (toElementCairoType instanceof WarpLocation) {
      return (to: string, from: string): string =>
        [
          `let (from_elem_id) = readId(${from});`,
          `let (to_elem_id) = readId(${to});`,
          `${elementCopyFunc}(to_elem_id, from_elem_id);`,
        ].join('\n');
    } else {
      return (to: string, from: string): string =>
        [`let (from_elem_id) = readId(${from});`, `${elementCopyFunc}(${to}, from_elem_id);`].join(
          '\n',
        );
    }
  } else {
    if (toElementCairoType instanceof WarpLocation) {
      return (to: string, from: string): string =>
        [`let (to_elem_id) = readId(${to});`, `${elementCopyFunc}(to_elem_id, ${from});`].join(
          '\n',
        );
    } else {
      return (to: string, from: string): string =>
        [`${elementCopyFunc}(${to}, ${from});`].join('\n');
    }
  }
}
