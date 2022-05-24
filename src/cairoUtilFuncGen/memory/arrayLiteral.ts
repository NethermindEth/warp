import assert = require('assert');
import {
  ArrayType,
  DataLocation,
  FunctionCall,
  generalizeType,
  getNodeType,
  IntType,
  Literal,
  LiteralKind,
  TupleExpression,
  TypeNode,
} from 'solc-typed-ast';
import { printNode } from '../../utils/astPrinter';
import { CairoType } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { createArrayTypeName, createNumberLiteral } from '../../utils/nodeTemplates';
import { notNull } from '../../utils/typeConstructs';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, locationIfComplexType, StringIndexedFuncGen } from '../base';

/*
  Converts [a,b,c] and "abc" into WM0_arr(a,b,c), which allocates new space in warp_memory
  and assigns the given values into that space, returning the location of the
  start of the array
*/
export class MemoryArrayLiteralGen extends StringIndexedFuncGen {
  stringGen(node: Literal): FunctionCall {
    // Encode the literal to the uint-8 byte representation
    assert(node.kind === LiteralKind.String);
    const byteCode = [];
    for (let i = 0; i < node.hexValue.length; i++) {
      byteCode.push(node.hexValue.charCodeAt(i));
    }

    const baseType = new IntType(8, false);
    const baseTypeName = typeNameFromTypeNode(baseType, this.ast);
    const name = this.getOrCreate(baseType, byteCode.length, true);

    const stub = createCairoFunctionStub(
      name,
      byteCode.map((_, n) => [`e${n}`, baseTypeName, DataLocation.Default]),
      [['arr', createArrayTypeName(baseTypeName, this.ast), DataLocation.Memory]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      node,
    );

    return createCallToFunction(
      stub,
      byteCode.map((v) => createNumberLiteral(v, this.ast)),
      this.ast,
    );
  }

  tupleGen(node: TupleExpression): FunctionCall {
    const elements = node.vOriginalComponents.filter(notNull);
    assert(elements.length === node.vOriginalComponents.length);

    const type = generalizeType(getNodeType(node, this.ast.compilerVersion))[0];
    assert(type instanceof ArrayType);

    const dynamic = type.size === undefined;
    const size = type.size
      ? narrowBigIntSafe(type.size, `${printNode(node)} too long to process`)
      : elements.length;

    const name = this.getOrCreate(type.elementT, size, dynamic);

    const stub = createCairoFunctionStub(
      name,
      mapRange(size, (n) => [
        `e${n}`,
        typeNameFromTypeNode(type.elementT, this.ast),
        locationIfComplexType(type.elementT, DataLocation.Memory),
      ]),
      [['arr', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      node,
    );

    return createCallToFunction(stub, elements, this.ast);
  }

  private getOrCreate(type: TypeNode, size: number, dynamic: boolean): string {
    const elementCairoType = CairoType.fromSol(type, this.ast);
    const key = `${size}${elementCairoType.fullStringRepresentation}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcName = `WM${this.generatedFunctions.size}_arr`;

    const argString = mapRange(size, (n) => `e${n}: ${elementCairoType.toString()}`).join(', ');

    // If it's dynamic we need to include the length at the start
    const alloc_len = dynamic ? size * elementCairoType.width + 2 : size * elementCairoType.width;
    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory: DictAccess*}(${argString}) -> (loc: felt):`,
        `    alloc_locals`,
        `    let (start) = wm_alloc(${uint256(alloc_len)})`,
        [
          ...(dynamic ? [`wm_write_256{dict_ptr=warp_memory}(start, ${uint256(size)})`] : []),
          ...mapRange(size, (n) => elementCairoType.serialiseMembers(`e${n}`))
            .flat()
            .map(
              (name, index) =>
                `dict_write{dict_ptr=warp_memory}(${add(
                  'start',
                  dynamic ? index + 2 : index,
                )}, ${name})`,
            ),
        ].join('\n'),
        `    return (start)`,
        `end`,
      ].join('\n'),
    });

    this.requireImport('warplib.memory', 'wm_alloc');
    this.requireImport('starkware.cairo.common.uint256', 'Uint256');
    this.requireImport('starkware.cairo.common.dict', 'dict_write');

    return funcName;
  }
}
