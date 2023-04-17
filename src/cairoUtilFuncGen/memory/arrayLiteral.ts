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
  MEMORY_TRAIT,
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
import { uint256 } from '../../warplib/utils';
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
    const funcInfo = this.getOrCreate(
      baseType,
      size,
      isDynamicArray(type) || type instanceof StringLiteralType,
    );
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

  private getOrCreate(type: TypeNode, size: number, dynamic: boolean): GeneratedFunctionInfo {
    const elementCairoType = CairoType.fromSol(type, this.ast);
    const funcName = `wm${this.generatedFunctionsDef.size}_${dynamic ? 'dynamic' : 'static'}_array`;

    const argString = mapRange(size, (n) => `e${n}: ${elementCairoType.toString()}`).join(', ');

    // If it's dynamic we need to include the length at the start
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const alloc_len = dynamic ? size * elementCairoType.width + 2 : size * elementCairoType.width;
    const writes = [
      ...(dynamic ? [`wm_write_256{warp_memory=warp_memory}(start, ${uint256(size)});`] : []),
      ...mapRange(size, (n) => elementCairoType.serialiseMembers(`e${n}`))
        .flat()
        .map(
          (name, index) => `warp_memory.insert(
            ${add('start', dynamic ? index + 2 : index)},
            ${name}
          );`,
        ),
    ];
    return {
      name: funcName,
      code: endent`
        #[implicit(warp_memory)]
        fn ${funcName}(${argString}) -> felt252 {
          let start = warp_memory.pointer;
          ${writes.join('\n')}
          return start;
        }`,
      functionsCalled: [
        this.requireImport(...ARRAY),
        this.requireImport(...ARRAY_TRAIT),
        this.requireImport(...U32_TO_FELT),
        this.requireImport(...WARP_MEMORY),
        this.requireImport(...MEMORY_TRAIT),
      ],
    };
  }
}
