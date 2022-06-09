import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  BytesType,
  DataLocation,
  Expression,
  FunctionStateMutability,
  generalizeType,
  getNodeType,
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
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { getElementType, getSize, isReferenceType } from '../../utils/nodeTypeProcessing';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, CairoFunction, delegateBasedOnType, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';
import { StorageDeleteGen } from './storageDelete';

/*
  Generates functions to copy data from WARP_STORAGE to WARP_STORAGE
  The main point of care here is to copy dynamic arrays. Mappings and types containing them
  cannot be copied from storage to storage, and all types other than dynamic arrays can be
  copied by caring only about their width
*/

export class StorageToStorageGen extends StringIndexedFuncGen {
  constructor(
    private dynArrayGen: DynArrayGen,
    private storageDeleteGen: StorageDeleteGen,
    ast: AST,
    sourceUnit: SourceUnit,
  ) {
    super(ast, sourceUnit);
  }
  gen(to: Expression, from: Expression, nodeInSourceUnit?: ASTNode): Expression {
    const toType = generalizeType(getNodeType(to, this.ast.compilerVersion))[0];
    const fromType = generalizeType(getNodeType(from, this.ast.compilerVersion))[0];

    const name = this.getOrCreate(toType, fromType);
    const functionStub = createCairoFunctionStub(
      name,
      [
        ['toLoc', typeNameFromTypeNode(toType, this.ast), DataLocation.Storage],
        ['fromLoc', typeNameFromTypeNode(fromType, this.ast), DataLocation.Storage],
      ],
      [['retLoc', typeNameFromTypeNode(toType, this.ast), DataLocation.Storage]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr', 'bitwise_ptr'],
      this.ast,
      nodeInSourceUnit ?? to,
      FunctionStateMutability.View,
    );
    return createCallToFunction(functionStub, [to, from], this.ast);
  }

  getOrCreate(toType: TypeNode, fromType: TypeNode): string {
    const key = `${fromType.pp()}->${toType.pp()}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcName = `ws_copy${this.generatedFunctions.size}`;

    // Set an empty entry so recursive function generation doesn't clash
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    const cairoFunction = delegateBasedOnType<CairoFunction>(
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
          return this.createScalarCopyFunction(funcName, toType, fromType);
        } else {
          return this.createValueTypeCopyFunction(funcName, toType);
        }
      },
    );

    this.generatedFunctions.set(key, cairoFunction);
    return cairoFunction.name;
  }

  private createStructCopyFunction(funcName: string, type: UserDefinedType): CairoFunction {
    const def = type.definition;
    assert(def instanceof StructDefinition);
    const members = def.vMembers.map((decl) => getNodeType(decl, this.ast.compilerVersion));

    let offset = 0;
    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(to_loc: felt, from_loc: felt) -> (retLoc: felt):`,
        `    alloc_locals`,
        ...members.map((memberType): string => {
          const width = CairoType.fromSol(
            memberType,
            this.ast,
            TypeConversionContext.StorageAllocation,
          ).width;
          let code: string;
          if (isReferenceType(memberType)) {
            const memberCopyFunc = this.getOrCreate(memberType, memberType);
            code = `${memberCopyFunc}(${add('to_loc', offset)}, ${add('from_loc', offset)})`;
          } else {
            code = mapRange(width, (index) => copyAtOffset(index + offset)).join('\n');
          }
          offset += width;
          return code;
        }),
        `    return (to_loc)`,
        `end`,
      ].join('\n'),
    };
  }

  private createStaticArrayCopyFunction(
    funcName: string,
    toType: ArrayType,
    fromType: ArrayType,
  ): CairoFunction {
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

    const elementCopyFunc = this.getOrCreate(toType.elementT, fromType.elementT);

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
    const copyCode = createElementCopy(toElemType, fromElemType, elementCopyFunc);

    const fromSize = narrowBigIntSafe(fromType.size);
    const toSize = narrowBigIntSafe(toType.size);
    let stopRecursion;
    if (fromSize === toSize) {
      stopRecursion = [`if index == ${fromSize}:`, `return ()`, `end`];
    } else {
      this.requireImport('starkware.cairo.common.math_cmp', 'is_le');
      stopRecursion = [
        `if index == ${toSize}:`,
        `    return ()`,
        `end`,
        `let (lesser) = is_le(index, ${fromSize - 1})`,
        `if lesser == 0:`,
        `    ${this.storageDeleteGen.genFuncName(toType.elementT)}(to_elem_loc)`,
        `    return ${funcName}_elem(to_elem_loc + ${toElemType.width}, from_elem_loc, index + 1)`,
        `end`,
      ];
    }

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(to_elem_loc: felt, from_elem_loc: felt, index: felt) -> ():`,
        ...stopRecursion,
        `    ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `    return ${funcName}_elem(to_elem_loc + ${toElemType.width}, from_elem_loc + ${fromElemType.width}, index + 1)`,
        `end`,
        `func ${funcName}${implicits}(to_elem_loc: felt, from_elem_loc: felt) -> (retLoc: felt):`,
        `    ${funcName}_elem(to_elem_loc, from_elem_loc, 0)`,
        `    return (to_elem_loc)`,
        `end`,
      ].join('\n'),
    };
  }

  private createDynamicArrayCopyFunction(
    funcName: string,
    toType: ArrayType | BytesType | StringType,
    fromType: ArrayType | BytesType | StringType,
  ): CairoFunction {
    const fromElementT = getElementType(fromType);
    const fromSize = getSize(fromType);
    const toElementT = getElementType(toType);
    const toSize = getSize(toType);
    assert(toSize === undefined, 'Attempted to copy to storage static array as dynamic array');
    assert(fromSize === undefined, 'Attempted to copy from storage static array as dynamic array');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_lt');

    const elementCopyFunc = this.getOrCreate(toElementT, fromElementT);
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
    const [fromElementMapping, fromLengthMapping] = this.dynArrayGen.gen(fromElementCairoType);
    const [toElementMapping, toLengthMapping] = this.dynArrayGen.gen(toElementCairoType);

    const copyCode = createElementCopy(toElementCairoType, fromElementCairoType, elementCopyFunc);

    const deleteRemainingCode = `${this.storageDeleteGen.genAuxFuncName(
      toType,
    )}(to_loc, from_length, to_length)`;

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(to_loc: felt, from_loc: felt, length: Uint256) -> ():`,
        `    alloc_locals`,
        `    if length.low == 0:`,
        `        if length.high == 0:`,
        `            return ()`,
        `        end`,
        `    end`,
        `    let (index) = uint256_sub(length, Uint256(1,0))`,
        `    let (from_elem_loc) = ${fromElementMapping}.read(from_loc, index)`,
        `    let (to_elem_loc) = ${toElementMapping}.read(to_loc, index)`,
        `    if to_elem_loc == 0:`,
        `        let (to_elem_loc) = WARP_USED_STORAGE.read()`,
        `        WARP_USED_STORAGE.write(to_elem_loc + ${toElementCairoType.width})`,
        `        ${toElementMapping}.write(to_loc, index, to_elem_loc)`,
        `        ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `        return ${funcName}_elem(to_loc, from_loc, index)`,
        `    else:`,
        `        ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `        return ${funcName}_elem(to_loc, from_loc, index)`,
        `    end`,
        `end`,
        `func ${funcName}${implicits}(to_loc: felt, from_loc: felt) -> (retLoc: felt):`,
        `    alloc_locals`,
        `    let (from_length) = ${fromLengthMapping}.read(from_loc)`,
        `    let (to_length) = ${toLengthMapping}.read(to_loc)`,
        `    ${toLengthMapping}.write(to_loc, from_length)`,
        `    ${funcName}_elem(to_loc, from_loc, from_length)`,
        `    let (lesser) = uint256_lt(from_length, to_length)`,
        `    if lesser == 1:`,
        `       ${deleteRemainingCode}`,
        `       return (to_loc)`,
        `    else:`,
        `       return (to_loc)`,
        `    end`,
        `end`,
      ].join('\n'),
    };
  }

  private createStaticToDynamicArrayCopyFunction(
    funcName: string,
    toType: ArrayType | BytesType | StringType,
    fromType: ArrayType,
  ): CairoFunction {
    const toSize = getSize(toType);
    const toElementT = getElementType(toType);
    assert(fromType.size !== undefined);
    assert(toSize === undefined);

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_add');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_lt');

    const elementCopyFunc = this.getOrCreate(toElementT, fromType.elementT);
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
    const [toElementMapping, toLengthMapping] = this.dynArrayGen.gen(toElementCairoType);
    const copyCode = createElementCopy(toElementCairoType, fromElementCairoType, elementCopyFunc);

    const deleteRemainingCode = `${this.storageDeleteGen.genAuxFuncName(
      toType,
    )}(to_loc, from_length, to_length)`;

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(to_loc: felt, from_elem_loc: felt, length: Uint256, index: Uint256) -> ():`,
        `    alloc_locals`,
        `    if length.low == index.low:`,
        `        if length.high == index.high:`,
        `            return ()`,
        `        end`,
        `    end`,
        `    let (to_elem_loc) = ${toElementMapping}.read(to_loc, index)`,
        `    let (next_index, carry) = uint256_add(index, Uint256(1,0))`,
        `    assert carry = 0`,
        `    if to_elem_loc == 0:`,
        `        let (to_elem_loc) = WARP_USED_STORAGE.read()`,
        `        WARP_USED_STORAGE.write(to_elem_loc + ${toElementCairoType.width})`,
        `        ${toElementMapping}.write(to_loc, index, to_elem_loc)`,
        `        ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `        return ${funcName}_elem(to_loc, from_elem_loc + ${fromElementCairoType.width}, length, next_index)`,
        `    else:`,
        `        ${copyCode('to_elem_loc', 'from_elem_loc')}`,
        `        return ${funcName}_elem(to_loc, from_elem_loc + ${fromElementCairoType.width}, length, next_index)`,
        `    end`,
        `end`,
        `func ${funcName}${implicits}(to_loc: felt, from_loc: felt) -> (retLoc: felt):`,
        `    alloc_locals`,
        `    let from_length  = ${uint256(narrowBigIntSafe(fromType.size))}`,
        `    let (to_length) = ${toLengthMapping}.read(to_loc)`,
        `    ${toLengthMapping}.write(to_loc, from_length)`,
        `    ${funcName}_elem(to_loc, from_loc, from_length , Uint256(0,0))`,
        `    let (lesser) = uint256_lt(from_length, to_length)`,
        `    if lesser == 1:`,
        `       ${deleteRemainingCode}`,
        `       return (to_loc)`,
        `    else:`,
        `       return (to_loc)`,
        `    end`,
        `end`,
      ].join('\n'),
    };
  }

  private createScalarCopyFunction(
    funcName: string,
    toType: IntType,
    fromType: IntType,
  ): CairoFunction {
    assert(
      fromType.nBits <= toType.nBits,
      `Attempted to scale integer ${fromType.nBits} to ${toType.nBits}`,
    );

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    if (toType.signed) {
      this.requireImport(
        'warplib.maths.int_conversions',
        `warp_int${fromType.nBits}_to_int${toType.nBits}`,
      );
    } else {
      this.requireImport('warplib.maths.utils', 'felt_to_uint256');
    }

    // Read changes depending if From is 256 bits or less
    const readFromCode =
      fromType.nBits === 256
        ? [
            'let (from_low) = WARP_STORAGE.read(from_loc)',
            'let (from_high) = WARP_STORAGE.read(from_loc + 1)',
            'tempvar from_elem = Uint256(from_low, from_high)',
          ].join('\n')
        : 'let (from_elem) = WARP_STORAGE.read(from_loc)';

    // Scaling for ints is different than for uints
    // Also memory represenation only change when To is 256 bits
    // and From is lesser than 256 bits
    const scalingCode = toType.signed
      ? `let (to_elem) = warp_int${fromType.nBits}_to_int${toType.nBits}(from_elem)`
      : toType.nBits === 256 && fromType.nBits < 256
      ? 'let (to_elem) = felt_to_uint256(from_elem)'
      : `let to_elem = from_elem`;

    // Copy changes depending if To is 256 bits or less
    const copyToCode =
      toType.nBits === 256
        ? [
            'WARP_STORAGE.write(to_loc, to_elem.low)',
            'WARP_STORAGE.write(to_loc + 1, to_elem.high)',
          ].join('\n')
        : 'WARP_STORAGE.write(to_loc, to_elem)';

    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(to_loc : felt, from_loc : felt) -> (ret_loc : felt):`,
        `   alloc_locals`,
        `   ${readFromCode}`,
        `   ${scalingCode}`,
        `   ${copyToCode}`,
        `   return (to_loc)`,
        `end`,
      ].join('\n'),
    };
  }

  private createValueTypeCopyFunction(funcName: string, type: TypeNode): CairoFunction {
    const width = CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation).width;

    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(to_loc : felt, from_loc : felt) -> (ret_loc : felt):`,
        `    alloc_locals`,
        ...mapRange(width, copyAtOffset),
        `    return (to_loc)`,
        `end`,
      ].join('\n'),
    };
  }
}

const implicits =
  '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}';

function copyAtOffset(n: number): string {
  return [
    `let (copy) = WARP_STORAGE.read(${add('from_loc', n)})`,
    `WARP_STORAGE.write(${add('to_loc', n)}, copy)`,
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
          `let (from_elem_id) = readId(${from})`,
          `let (to_elem_id) = readId(${to})`,
          `${elementCopyFunc}(to_elem_id, from_elem_id)`,
        ].join('\n');
    } else {
      return (to: string, from: string): string =>
        [`let (from_elem_id) = readId(${from})`, `${elementCopyFunc}(${to}, from_elem_id)`].join(
          '\n',
        );
    }
  } else {
    if (toElementCairoType instanceof WarpLocation) {
      return (to: string, from: string): string =>
        [`let (to_elem_id) = readId(${to})`, `${elementCopyFunc}(to_elem_id, ${from})`].join('\n');
    } else {
      return (to: string, from: string): string =>
        [`${elementCopyFunc}(${to}, ${from})`].join('\n');
    }
  }
}
