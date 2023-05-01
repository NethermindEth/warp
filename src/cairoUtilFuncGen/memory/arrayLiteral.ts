import assert = require('assert');
import {
  ArrayType,
  BytesType,
  DataLocation,
  FunctionCall,
  generalizeType,
  Literal,
  LiteralKind,
  StringLiteralType,
  StringType,
  TupleExpression,
  TupleType,
  TypeNode,
} from 'solc-typed-ast';
import { printNode } from '../../utils/astPrinter';
import { CairoType } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import { createCairoGeneratedFunction, createCallToFunction } from '../../utils/functionGeneration';
import {
  ARRAY,
  ARRAY_TRAIT,
  WARP_MEMORY_TRAIT,
  U32_TO_FELT,
  WARP_MEMORY,
} from '../../utils/importPaths';
import { createNumberLiteral } from '../../utils/nodeTemplates';
import {
  getElementType,
  getSize,
  isDynamicArray,
  safeGetNodeType,
} from '../../utils/nodeTypeProcessing';
import { notNull } from '../../utils/typeConstructs';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { add, GeneratedFunctionInfo, locationIfComplexType, StringIndexedFuncGen } from '../base';
import endent from 'endent';

/*
  Converts [a,b,c] and "abc" into WM0_arr(a,b,c), which allocates new space in warp_memory
  and assigns the given values into that space, returning the location of the
  start of the array
*/
export class MemoryArrayLiteralGen extends StringIndexedFuncGen {
  public stringGen(node: Literal): FunctionCall {
    // Encode the literal to the uint-8 byte representation
    assert(
      node.kind === LiteralKind.String ||
        node.kind === LiteralKind.UnicodeString ||
        LiteralKind.HexString,
    );

    const size = node.hexValue.length / 2;
    const type = generalizeType(safeGetNodeType(node, this.ast.inference))[0];

    const funcDef = this.getOrCreateFuncDef(type, size);
    return createCallToFunction(
      funcDef,
      mapRange(size, (n) =>
        createNumberLiteral(parseInt(node.hexValue.slice(2 * n, 2 * n + 2), 16), this.ast),
      ),
      this.ast,
    );
  }

  public tupleGen(node: TupleExpression): FunctionCall {
    const elements = node.vOriginalComponents.filter(notNull);
    assert(elements.length === node.vOriginalComponents.length);

    const type = generalizeType(safeGetNodeType(node, this.ast.inference))[0];
    assert(
      type instanceof ArrayType ||
        type instanceof TupleType ||
        type instanceof BytesType ||
        type instanceof StringType,
    );

    const wideSize = getSize(type);
    const size =
      wideSize !== undefined
        ? narrowBigIntSafe(wideSize, `${printNode(node)} too long to process`)
        : elements.length;

    const funcDef = this.getOrCreateFuncDef(type, size);
    return createCallToFunction(funcDef, elements, this.ast);
  }

  public getOrCreateFuncDef(type: ArrayType | StringType, size: number) {
    const baseType = getElementType(type);

    const key = baseType.pp() + size;
    const value = this.generatedFunctionsDef.get(key);
    if (value !== undefined) {
      return value;
    }

    const baseTypeName = typeNameFromTypeNode(baseType, this.ast);
    const funcInfo = this.getOrCreate(baseType, size);
    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      mapRange(size, (n) => [
        `arg_${n}`,
        cloneASTNode(baseTypeName, this.ast),
        locationIfComplexType(baseType, DataLocation.Memory),
      ]),
      [['arr', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      this.ast,
      this.sourceUnit,
    );
    this.generatedFunctionsDef.set(key, funcDef);
    return funcDef;
  }

  private getOrCreate(array_type: TypeNode, array_size: number): GeneratedFunctionInfo {
    const elementCairoType = CairoType.fromSol(array_type, this.ast);
    const dynamic = isDynamicArray(array_type) || array_type instanceof StringLiteralType;

    const funcName = `wm${this.generatedFunctionsDef.size}_${dynamic ? 'dynamic' : 'static'}_array`;
    const argString = mapRange(array_size, (n) => `e${n}: ${elementCairoType.toString()}`).join(
      ', ',
    );

    // If it's dynamic we need to include the length at the start
    const alloc_len = dynamic
      ? array_size * elementCairoType.width + 1
      : array_size * elementCairoType.width;
    const writes = [
      dynamic ? `warp_memory.write(start, ${array_size});` : '',
      ...mapRange(array_size, (n) => elementCairoType.serialiseMembers(`e${n}`))
        .flat()
        .map(
          (name, index) => `warp_memory.write(
            ${add('start', index)},
            ${name}
          );`,
        ),
    ];

    return {
      name: funcName,
      code: endent`
        #[implicit(warp_memory: WarpMemory)]
        fn ${funcName}(${argString}) -> felt252 {
          let start = warp_memory.unsafe_alloc(${alloc_len});
          ${writes.join('\n')}
          start
        }`,
      functionsCalled: [
        this.requireImport(...ARRAY),
        this.requireImport(...ARRAY_TRAIT),
        this.requireImport(...U32_TO_FELT),
        this.requireImport(...WARP_MEMORY),
        this.requireImport(...WARP_MEMORY_TRAIT),
      ],
    };
  }
}
