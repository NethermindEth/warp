import assert = require('assert');
import {
  ArrayType,
  BytesType,
  DataLocation,
  FixedBytesType,
  FunctionCall,
  FunctionDefinition,
  generalizeType,
  Literal,
  LiteralKind,
  StringType,
  TupleExpression,
  TupleType,
  TypeNode,
} from 'solc-typed-ast';
import { printNode } from '../../utils/astPrinter';
import { CairoType } from '../../utils/cairoTypeSystem';
import { cloneASTNode } from '../../utils/cloning';
import {
  createCairoFunctionStub,
  createCairoGeneratedFunction,
  createCallToFunction,
} from '../../utils/functionGeneration';
import { createNumberLiteral, createStringTypeName } from '../../utils/nodeTemplates';
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

/*
  Converts [a,b,c] and "abc" into WM0_arr(a,b,c), which allocates new space in warp_memory
  and assigns the given values into that space, returning the location of the
  start of the array
*/
export class MemoryArrayLiteralGen extends StringIndexedFuncGen {
  stringGen(node: Literal): FunctionCall {
    // Encode the literal to the uint-8 byte representation
    assert(
      node.kind === LiteralKind.String ||
        node.kind === LiteralKind.UnicodeString ||
        LiteralKind.HexString,
    );

    const size = node.hexValue.length / 2;
    const baseType = new FixedBytesType(1);
    const baseTypeName = typeNameFromTypeNode(baseType, this.ast);
    const funcInfo = this.getOrCreate(baseType, size, true);

    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      mapRange(size, (n) => [`e${n}`, cloneASTNode(baseTypeName, this.ast), DataLocation.Default]),
      [['arr', createStringTypeName(false, this.ast), DataLocation.Memory]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      node,
    );

    return createCallToFunction(
      funcDef,
      mapRange(size, (n) =>
        createNumberLiteral(parseInt(node.hexValue.slice(2 * n, 2 * n + 2), 16), this.ast),
      ),
      this.ast,
    );
  }

  tupleGen(node: TupleExpression): FunctionCall {
    const elements = node.vOriginalComponents.filter(notNull);
    assert(elements.length === node.vOriginalComponents.length);

    const type = generalizeType(safeGetNodeType(node, this.ast.inference))[0];
    assert(
      type instanceof ArrayType ||
        type instanceof TupleType ||
        type instanceof BytesType ||
        type instanceof StringType,
    );

    const elementT = getElementType(type);

    const wideSize = getSize(type);
    const size =
      wideSize !== undefined
        ? narrowBigIntSafe(wideSize, `${printNode(node)} too long to process`)
        : elements.length;

    const funcInfo = this.getOrCreate(elementT, size, isDynamicArray(type));

    const funcDef = createCairoGeneratedFunction(
      funcInfo,
      mapRange(size, (n) => [
        `e${n}`,
        typeNameFromTypeNode(elementT, this.ast),
        locationIfComplexType(elementT, DataLocation.Memory),
      ]),
      [['arr', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      node,
    );

    return createCallToFunction(funcDef, elements, this.ast);
  }

  private getOrCreate(type: TypeNode, size: number, dynamic: boolean): GeneratedFunctionInfo {
    const elementCairoType = CairoType.fromSol(type, this.ast);
    const key = `${dynamic ? 'd' : 's'}${size}${elementCairoType.fullStringRepresentation}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing;
    }

    const funcName = `WM${this.generatedFunctions.size}_${dynamic ? 'd' : 's'}_arr`;

    const funcsCalled: FunctionDefinition[] = [];
    funcsCalled.push(
      this.requireImport('warplib.memory', 'wm_alloc'),
      this.requireImport('warplib.memory', 'wm_write_256'),
      this.requireImport('starkware.cairo.common.uint256', 'Uint256'),
      this.requireImport('starkware.cairo.common.dict', 'dict_write'),
    );

    const argString = mapRange(size, (n) => `e${n}: ${elementCairoType.toString()}`).join(', ');

    // If it's dynamic we need to include the length at the start
    const alloc_len = dynamic ? size * elementCairoType.width + 2 : size * elementCairoType.width;
    const funcInfo: GeneratedFunctionInfo = {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory: DictAccess*}(${argString}) -> (loc: felt){`,
        `    alloc_locals;`,
        `    let (start) = wm_alloc(${uint256(alloc_len)});`,
        [
          ...(dynamic ? [`wm_write_256{warp_memory=warp_memory}(start, ${uint256(size)});`] : []),
          ...mapRange(size, (n) => elementCairoType.serialiseMembers(`e${n}`))
            .flat()
            .map(
              (name, index) =>
                `dict_write{dict_ptr=warp_memory}(${add(
                  'start',
                  dynamic ? index + 2 : index,
                )}, ${name});`,
            ),
        ].join('\n'),
        `    return (start,);`,
        `}`,
      ].join('\n'),
      functionsCalled: funcsCalled,
    };
    this.generatedFunctions.set(key, funcInfo);
    return funcInfo;
  }
}
