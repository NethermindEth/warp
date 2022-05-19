import {
  ArrayType,
  ASTNode,
  DataLocation,
  Expression,
  FunctionCall,
  getNodeType,
  MappingType,
  PointerType,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { typeNameFromTypeNode, mapRange, dereferenceType } from '../../utils/utils';
import { add, CairoFunction, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

export class StorageDeleteGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST) {
    super(ast);
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
    if (type instanceof ArrayType && type.size === undefined) {
      cairoFunc = this.deleteArray(type);
    } else if (type instanceof MappingType) {
      cairoFunc = this.deleteNothing();
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

  private deleteArray(type: ArrayType): CairoFunction {
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

    const elementT = type.elementT instanceof PointerType ? type.elementT.to : type.elementT;
    const [arrayName, lengthName] = this.dynArrayGen.gen(
      CairoType.fromSol(elementT, this.ast, TypeConversionContext.StorageAllocation),
    );

    const deleteCode = `${this.getOrCreate(elementT)}(elem_loc)`;

    const funcName = `WS${this.generatedFunctions.size}_DELETE`;
    const deleteFunc = [
      `func ${funcName}_elem${implicits}(loc : felt, index : Uint256):`,
      `     alloc_locals`,
      `     let (stop) = uint256_eq(index, Uint256(0, 0))`,
      `     if stop == 1:`,
      `        return ()`,
      `     end`,
      `     let (next_index) = uint256_sub(index, Uint256(1, 0))`,
      `     let (elem_loc) = ${arrayName}.read(loc, next_index)`,
      deleteCode,
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
  private deleteNothing(): CairoFunction {
    const funcName = `WSMAP_DELETE`;
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    return {
      name: funcName,
      code: [`func ${funcName}${implicits}(loc: felt):`, `    return ()`, `end`].join('\n'),
    };
  }
}

function getNestedNumber(type: ArrayType | MappingType): number {
  const valueType = dereferenceType(type instanceof ArrayType ? type.elementT : type.valueType);

  return 1 + (valueType instanceof ArrayType ? getNestedNumber(valueType) : 0);
}

function getBaseType(type: TypeNode): TypeNode {
  return type instanceof ArrayType && type.size === undefined
    ? getBaseType(dereferenceType(type.elementT))
    : type;
}
