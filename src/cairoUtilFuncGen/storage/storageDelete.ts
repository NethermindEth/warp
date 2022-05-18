import {
  ArrayType,
  ASTNode,
  DataLocation,
  Expression,
  FunctionCall,
  getNodeType,
  PointerType,
  TypeNode,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { typeNameFromTypeNode, mapRange, isReferenceType } from '../../utils/utils';
import { add, CairoFunction, StringIndexedFuncGen } from '../base';
import { DynArrayGen } from './dynArray';

export class StorageDeleteGen extends StringIndexedFuncGen {
  constructor(private dynArrayGen: DynArrayGen, ast: AST) {
    super(ast);
  }

  gen(node: Expression, nodeInSourceUnit?: ASTNode): FunctionCall {
    const nodeType = getNodeType(node, this.ast.compilerVersion);
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
    const cairoType = CairoType.fromSol(type, this.ast, TypeConversionContext.StorageAllocation);
    const key = cairoType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    let cairoFunc;
    if (type instanceof PointerType && type.to instanceof ArrayType) {
      cairoFunc = this.deleteArray(type.to, cairoType);
    } else {
      cairoFunc = this.deleteGeneric(type, cairoType);
    }

    this.generatedFunctions.set(key, cairoFunc);

    return cairoFunc.name;
  }

  private deleteGeneric(type: TypeNode, cairoType: CairoType): CairoFunction {
    const funcName = `WS${this.generatedFunctions.size}_DELETE`;
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';
    return {
      name: funcName,
      code: [
        `func ${funcName}${implicits}(loc: felt) -> ():`,
        ...mapRange(cairoType.width, (n) => `    WARP_STORAGE.write(${add('loc', n)}, 0)`),
        `    return ()`,
        `end`,
      ].join('\n'),
    };
  }

  private deleteArray(type: ArrayType, cairoType: CairoType): CairoFunction {
    const implicits = '{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}';

    const [arrayName, lengthName] = this.dynArrayGen.gen(cairoType);

    const elementT = type.elementT;
    if (isReferenceType(elementT)) this.getOrCreate(elementT);

    const funcName = `WS${this.generatedFunctions.size}_DELETE`;
    let deleteFunc = [
      `func ${funcName}${implicits}(loc : felt):`,
      `   let (lenght) = ${lengthName}.read(loc)`,
      `   ${lengthName}.write(loc, Uint256(0, 0))`,
    ];

    if (isReferenceType(elementT)) {
      const cairoElementT = CairoType.fromSol(
        elementT,
        this.ast,
        TypeConversionContext.StorageAllocation,
      );
      deleteFunc = [
        `func ${funcName}_elem${implicits}(loc : felt, index : Uint256) -> ():`,
        `     alloc_locals`,
        `     let (elem_loc)= ${arrayName}.read(loc, index)`,
        `     ${this.getOrCreate(elementT)}(elem_loc)`,
        `     let (stop) = uint256_eq(index, Uint256(0, 0))`,
        `     if stop == 0:`,
        `         let (next_index) = uint256_sub(index, Uint256(1, 0))`,
        `         return ${funcName}_elem(${add('loc', cairoElementT.width)}, next_index)`,
        `     end`,
        `     return ()`,
        `end`,
        ...deleteFunc,
        `     ${funcName}_elem(loc, lenght)`,
      ];
      this.requireImport('starkware.cairo.common.uint256', 'uint256_eq');
      this.requireImport('starkware.cairo.common.uint256', 'uint256_sub');
    }
    const code = [...deleteFunc, 'return ()', 'end'].join('\n');
    return { name: funcName, code: code };
  }
}
