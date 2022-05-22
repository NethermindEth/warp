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
import {
  CairoFelt,
  CairoStruct,
  CairoTuple,
  CairoType,
  TypeConversionContext,
  WarpLocation,
} from '../../utils/cairoTypeSystem';
import { TranspilationAbandonedError } from '../../utils/errors';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { mapRange, typeNameFromTypeNode } from '../../utils/utils';
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
  gen(from: Expression, to: Expression, nodeInSourceUnit?: ASTNode): Expression {
    const type = generalizeType(getNodeType(to, this.ast.compilerVersion))[0];

    const name = this.getOrCreate(type);
    const functionStub = createCairoFunctionStub(
      name,
      [
        ['from', typeNameFromTypeNode(type, this.ast), DataLocation.Storage],
        ['to', typeNameFromTypeNode(type, this.ast), DataLocation.Storage],
      ],
      [['retLoc', typeNameFromTypeNode(type, this.ast), DataLocation.Storage]],
      ['syscall_ptr', 'pedersen_ptr', 'range_check_ptr'],
      this.ast,
      nodeInSourceUnit ?? to,
      FunctionStateMutability.View,
    );
    return createCallToFunction(functionStub, [from, to], this.ast);
  }

  private getOrCreate(type: TypeNode): string {
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation);
    const key = generateKey(cairoType);
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcName = `ws_copy${this.generatedFunctions.size}`;

    // Set an empty entry so recursive function generation doesn't clash
    this.generatedFunctions.set(key, { name: funcName, code: '' });

    let cairoFunction: CairoFunction;
    if (type instanceof UserDefinedType && type.definition instanceof StructDefinition) {
      cairoFunction = this.createStructCopyFunction(funcName, type);
    } else if (type instanceof ArrayType) {
      if (type.size === undefined) {
        cairoFunction = this.createDynamicArrayCopyFunction(funcName, type);
      } else {
        cairoFunction = this.createStaticArrayCopyFunction(funcName, type);
      }
    } else {
      cairoFunction = this.createValueTypeCopyFunction(funcName, type);
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
        `func ${funcName}${implicits}(from: felt, to: felt) -> (retLoc: felt):`,
        `    alloc_locals`,
        ...members.map((memberType) => {
          if (memberType instanceof ArrayType) {
            const memberCopyFunc = this.getOrCreate(memberType);
            const code = `${memberCopyFunc}(${add('from', offset)}, ${add('to', offset)})`;
            ++offset;
            return code;
          } else {
            const width = CairoType.fromSol(
              memberType,
              this.ast,
              TypeConversionContext.StorageAllocation,
            ).width;
            const code = mapRange(width, copyAtOffset);
            offset += width;
            return code;
          }
        }),
        `    return (to)`,
        `end`,
      ].join('\n'),
    };
  }

  private createStaticArrayCopyFunction(funcName: string, type: ArrayType): CairoFunction {
    assert(type.size === undefined, 'Attempted to copy storage dynamic array as static array');

    const elementCopyFunc = this.getOrCreate(type.elementT);

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(from: felt, to: felt, index: felt) -> (retLoc: felt):`,
        `    if index == ${type.size}:`,
        `        return (to)`,
        `    end`,
        `    ${elementCopyFunc}(from + index, to + index)`,
        `    return ${funcName}_elem(from, to, index + 1)`,
        `end`,
        `func ${funcName}${implicits}(from: felt, to: felt) -> (retLoc: felt)`,
        `    return ${funcName}_elem(from, to, 0)`,
        `end`,
      ].join('\n'),
    };
  }

  private createDynamicArrayCopyFunction(funcName: string, type: ArrayType): CairoFunction {
    assert(type.size !== undefined, 'Attempted to copy storage static array as dynamic array');

    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');

    const elementCopyFunc = this.getOrCreate(type.elementT);
    const elementCairoType = CairoType.fromSol(
      type.elementT,
      this.ast,
      TypeConversionContext.StorageAllocation,
    );
    const [elementMapping, lengthMapping] = this.dynArrayGen.gen(elementCairoType);

    return {
      name: funcName,
      code: [
        `func ${funcName}_elem${implicits}(from: felt, to: felt, length: Uint256) -> ():`,
        `    alloc_locals`,
        `    if length.low == 0:`,
        `        if length.high == 0:`,
        `            return ()`,
        `        end`,
        `    end`,
        `    let (index) = uint256_sub(length, Uint256(1,0))`,
        `    let (fromElem) = ${elementMapping}.read(from, index)`,
        `    let (toElem) = ${elementMapping}.read(to, index)`,
        `    if toElem == 0:`,
        `        let (used) = WARP_USED_STORAGE.read()`,
        `        WARP_USED_STORAGE.write(used + ${elementCairoType.width})`,
        `        ${elementMapping}.write(to, index, used)`,
        `        ${elementCopyFunc}(fromElem, used)`,
        `        return ${funcName}_elem(from, to, index)`,
        `    else:`,
        `        ${elementCopyFunc}(fromElem, toElem)`,
        `        return ${funcName}_elem(from, to, index)`,
        `    end`,
        `end`,
        `func ${funcName}${implicits}(from: felt, to: felt) -> (retLoc: felt)`,
        `    alloc_locals`,
        `    let (fromName) = readId(from)`,
        `    let (fromLength) = ${lengthMapping}.read(fromName)`,
        `    let (toName) = readId(to)`,
        `    ${lengthMapping}.write(toName, fromLength)`,
        `    ${funcName}_elem(fromName, toName, fromLength)`,
        `    return (to)`,
        `end`,
      ].join('\n'),
    };
  }

  private createValueTypeCopyFunction(funcName: string, type: TypeNode): CairoFunction {
    const width = CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation).width;

    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(from : felt, to : felt) -> (retLoc : felt):`,
        `    alloc_locals`,
        ...mapRange(width, copyAtOffset),
        `    return (to)`,
        `end`,
      ].join('\n'),
    };
  }
}

const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

function generateKey(type: CairoType): string {
  if (type instanceof WarpLocation) return 'w';
  if (type instanceof CairoFelt) return 'f';
  if (type instanceof CairoStruct) return [...type.members.values()].map(generateKey).join('');
  if (type instanceof CairoTuple) return type.members.map(generateKey).join('');
  throw new TranspilationAbandonedError(
    `Attempted to create Storage->Storage copy for cairo type ${type.fullStringRepresentation}`,
  );
}

function copyAtOffset(n: number): string {
  return [
    `let (copy) = WARP_STORAGE.read(${add('from', n)})`,
    `WARP_STORAGE.write(${add('to', n)}, copy)`,
  ].join('\n');
}
