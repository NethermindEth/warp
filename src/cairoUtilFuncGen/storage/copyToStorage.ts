import assert from 'assert';
import {
  ArrayType,
  ASTNode,
  DataLocation,
  Expression,
  FunctionStateMutability,
  generalizeType,
  getNodeType,
  StructDefinition,
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext, WarpLocation } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, CairoFunction, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

/*
  Generates functions to copy data from WARP_STORAGE to WARP_STORAGE
  The main point of care here is to copy dynamic arrays. Mappings and types containing them
  cannot be copied from storage to storage, and all types other than dynamic arrays can be
  copied by caring only about their width
*/

export class StorageToStorageGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST) {
    super(ast);
  }
  gen(to: Expression, from: Expression, nodeInSourceUnit?: ASTNode): Expression {
    const fromType = generalizeType(getNodeType(from, this.ast.compilerVersion))[0];
    const toType = generalizeType(getNodeType(to, this.ast.compilerVersion))[0];

    const name = this.getOrCreate(fromType, toType);
    const functionStub = createCairoFunctionStub(
      name,
      [
        ['toLoc', typeNameFromTypeNode(toType, this.ast), DataLocation.Storage],
        ['fromLoc', typeNameFromTypeNode(toType, this.ast), DataLocation.Storage],
      ],
      [['retLoc', typeNameFromTypeNode(toType, this.ast), DataLocation.Storage]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? to,
      FunctionStateMutability.View,
    );
    return createCallToFunction(functionStub, [from, to], this.ast);
  }

  private getOrCreate(fromType: TypeNode, toType: TypeNode): string {
    const key = `${fromType.pp()}->${toType.pp()}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcName = `ws_copy${this.generatedFunctions.size}`;

    // Set an empty entry so recursive function generation doesn't clash
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    let cairoFunction: CairoFunction;
    if (toType instanceof UserDefinedType && toType.definition instanceof StructDefinition) {
      assert(fromType.pp() === toType.pp());
      cairoFunction = this.createStructCopyFunction(funcName, toType);
    } else if (toType instanceof ArrayType) {
      assert(fromType instanceof ArrayType);
      if (toType.size === undefined) {
        if (fromType.size === undefined) {
          cairoFunction = this.createDynamicArrayCopyFunction(funcName, toType);
        } else {
          cairoFunction = this.createStaticToDynamicArrayCopyFunction(funcName, fromType, toType);
        }
      } else {
        cairoFunction = this.createStaticArrayCopyFunction(funcName, fromType, toType);
      }
    } else {
      cairoFunction = this.createValueTypeCopyFunction(funcName, toType);
    }
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
        `func ${funcName}${implicits}(toLoc: felt, fromLoc: felt) -> (retLoc: felt):`,
        `    alloc_locals`,
        ...members.map((memberType): string => {
          const width = CairoType.fromSol(
            memberType,
            this.ast,
            TypeConversionContext.StorageAllocation,
          ).width;
          let code: string;
          if (
            memberType instanceof ArrayType ||
            (memberType instanceof UserDefinedType &&
              memberType.definition instanceof StructDefinition)
          ) {
            const memberCopyFunc = this.getOrCreate(memberType, memberType);
            code = `${memberCopyFunc}(${add('toLoc', offset)}, ${add('fromLoc', offset)})`;
          } else {
            code = mapRange(width, (index) => copyAtOffset(index + offset)).join('\n');
          }
          offset += width;
          return code;
        }),
        `    return (toLoc)`,
        `end`,
      ].join('\n'),
    };
  }

  private createStaticArrayCopyFunction(funcName: string, type: ArrayType): CairoFunction {
    assert(type.size !== undefined, 'Attempted to copy storage dynamic array as static array');

    // TODO implement from->to
    const elementCopyFunc = this.getOrCreate(type.elementT, type.elementT);

    const width = BigInt(
      CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation).width,
    );

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(toLoc: felt, fromLoc: felt, index: felt) -> (retLoc: felt):`,
        `    if index == ${type.size * width}:`,
        `        return (toLoc)`,
        `    end`,
        `    ${elementCopyFunc}(toLoc + index, fromLoc + index)`,
        `    return ${funcName}_elem(toLoc, fromLoc, index + 1)`,
        `end`,
        `func ${funcName}${implicits}(toLoc: felt, fromLoc: felt) -> (retLoc: felt):`,
        `    return ${funcName}_elem(toLoc, fromLoc, 0)`,
        `end`,
      ].join('\n'),
    };
  }

  private createDynamicArrayCopyFunction(funcName: string, type: ArrayType): CairoFunction {
    assert(type.size === undefined, 'Attempted to copy storage static array as dynamic array');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');

    // TODO implement from->to
    const elementCopyFunc = this.getOrCreate(type.elementT, type.elementT);
    const elementCairoType = CairoType.fromSol(
      type.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const [elementMapping, lengthMapping] = this.dynArrayGen.gen(elementCairoType);

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(toLoc: felt, fromLoc: felt, length: Uint256) -> ():`,
        `    alloc_locals`,
        `    if length.low == 0:`,
        `        if length.high == 0:`,
        `            return ()`,
        `        end`,
        `    end`,
        `    let (index) = uint256_sub(length, Uint256(1,0))`,
        `    let (fromElem) = ${elementMapping}.read(fromLoc, index)`,
        `    let (toElem) = ${elementMapping}.read(toLoc, index)`,
        `    if toElem == 0:`,
        `        let (used) = WARP_USED_STORAGE.read()`,
        `        WARP_USED_STORAGE.write(used + ${elementCairoType.width})`,
        `        ${elementMapping}.write(toLoc, index, used)`,
        `        ${elementCopyFunc}(used, fromElem)`,
        `        return ${funcName}_elem(toLoc, fromLoc, index)`,
        `    else:`,
        `        ${elementCopyFunc}(toElem, fromElem)`,
        `        return ${funcName}_elem(toLoc, fromLoc, index)`,
        `    end`,
        `end`,
        `func ${funcName}${implicits}(toLoc: felt, fromLoc: felt) -> (retLoc: felt):`,
        `    alloc_locals`,
        `    let (fromLength) = ${lengthMapping}.read(fromLoc)`,
        `    ${lengthMapping}.write(toLoc, fromLength)`,
        `    ${funcName}_elem(toLoc, fromLoc, fromLength)`,
        `    return (toLoc)`,
        `end`,
      ].join('\n'),
    };
  }

  private createStaticToDynamicArrayCopyFunction(
    funcName: string,
    fromType: ArrayType,
    toType: ArrayType,
  ): CairoFunction {
    assert(fromType.size !== undefined);
    assert(toType.size === undefined);

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_add');

    // TODO implement from->to
    const elementCopyFunc = this.getOrCreate(fromType.elementT, toType.elementT);
    const fromElementCairoType = CairoType.fromSol(
      fromType.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const toElementCairoType = CairoType.fromSol(
      toType.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const [toElementMapping, toLengthMapping] = this.dynArrayGen.gen(toElementCairoType);
    let copyCode: (to: string, from: string) => string;
    if (fromElementCairoType instanceof WarpLocation) {
      if (toElementCairoType instanceof WarpLocation) {
        copyCode = (to: string, from: string): string =>
          [
            `let (fromElemId) = readId(${from})`,
            `let (toElemId) = readId(${to})`,
            `${elementCopyFunc}(toElemId, fromElemId)`,
          ].join('\n');
      } else {
        copyCode = (to: string, from: string): string =>
          [`let (fromElemId) = readId(${from})`, `${elementCopyFunc}(${to}, fromElemId)`].join(
            '\n',
          );
      }
    } else {
      if (toElementCairoType instanceof WarpLocation) {
        copyCode = (to: string, from: string): string =>
          [`let (toElemId) = readId(${to})`, `${elementCopyFunc}(toElemId, ${from})`].join('\n');
      } else {
        copyCode = (to: string, from: string): string =>
          [`${elementCopyFunc}(${to}, ${from})`].join('\n');
      }
    }

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(toLoc: felt, fromElem: felt, length: Uint256, index: Uint256) -> ():`,
        `    alloc_locals`,
        `    if length.low == index.low:`,
        `        if length.high == index.high:`,
        `            return ()`,
        `        end`,
        `    end`,
        `    let (toElem) = ${toElementMapping}.read(toLoc, index)`,
        `    let (nextIndex, carry) = uint256_add(index, Uint256(1,0))`,
        `    assert carry = 0`,
        `    if toElem == 0:`,
        `        let (used) = WARP_USED_STORAGE.read()`,
        `        WARP_USED_STORAGE.write(used + ${toElementCairoType.width})`,
        `        ${toElementMapping}.write(toLoc, index, used)`,
        `        ${copyCode('used', 'fromElem')}`,
        `        return ${funcName}_elem(toLoc, fromElem + ${fromElementCairoType.width}, length, nextIndex)`,
        `    else:`,
        `        ${copyCode('toElem', 'fromElem')}`,
        `        return ${funcName}_elem(toLoc, fromElem + ${fromElementCairoType.width}, length, nextIndex)`,
        `    end`,
        `end`,
        `func ${funcName}${implicits}(toLoc: felt, fromLoc: felt) -> (retLoc: felt):`,
        `    alloc_locals`,
        `    let fromLength = ${uint256(narrowBigIntSafe(fromType.size))}`,
        `    ${toLengthMapping}.write(toLoc, fromLength)`,
        `    ${funcName}_elem(toLoc, fromLoc, fromLength, Uint256(0,0))`,
        `    return (toLoc)`,
        `end`,
      ].join('\n'),
    };
  }

  private createValueTypeCopyFunction(funcName: string, type: TypeNode): CairoFunction {
    const width = CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation).width;

    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(toLoc : felt, fromLoc : felt) -> (retLoc : felt):`,
        `    alloc_locals`,
        ...mapRange(width, copyAtOffset),
        `    return (toLoc)`,
        `end`,
      ].join('\n'),
    };
  }
}

const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

function copyAtOffset(n: number): string {
  return [
    `let (copy) = WARP_STORAGE.read(${add('fromLoc', n)})`,
    `WARP_STORAGE.write(${add('toLoc', n)}, copy)`,
  ].join('\n');
}
