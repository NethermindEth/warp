import assert = require('assert');
import {
  ArrayType,
  DataLocation,
  FunctionCall,
  generalizeType,
  getNodeType,
  TupleExpression,
  TypeNode,
} from 'solc-typed-ast';
import { printNode } from '../../utils/astPrinter';
import { CairoType } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionGeneration';
import { notNull } from '../../utils/typeConstructs';
import { mapRange, narrowBigIntSafe, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, locationIfComplexType, StringIndexedFuncGen } from '../base';

/*
  Converts [a,b,c] into WM0_arr(a,b,c), which allocates new space in warp_memory
  and assigns the given values into that space, returning the location of the
  start of the array
*/
export class MemoryArrayLiteralGen extends StringIndexedFuncGen {
  gen(node: TupleExpression): FunctionCall {
    const elements = node.vOriginalComponents.filter(notNull);
    assert(elements.length === node.vOriginalComponents.length);

    const type = generalizeType(getNodeType(node, this.ast.compilerVersion))[0];
    assert(type instanceof ArrayType);

    assert(type.size !== undefined, `${printNode(node)} has undefined size`);
    const size = narrowBigIntSafe(type.size, `${printNode(node)} too long to process`);

    const name = this.getOrCreate(type.elementT, size);

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

  private getOrCreate(type: TypeNode, size: number): string {
    const elementCairoType = CairoType.fromSol(type, this.ast);
    const key = `${size}${elementCairoType.fullStringRepresentation}`;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return existing.name;
    }

    const funcName = `WM${this.generatedFunctions.size}_arr`;

    const argString = mapRange(size, (n) => `e${n}: ${elementCairoType.toString()}`).join(', ');

    this.generatedFunctions.set(key, {
      name: funcName,
      code: [
        `func ${funcName}{range_check_ptr, warp_memory: DictAccess*}(${argString}) -> (loc: felt):`,
        `    alloc_locals`,
        `    let (start) = wm_alloc(${uint256(size * elementCairoType.width)})`,
        mapRange(size, (n) => elementCairoType.serialiseMembers(`e${n}`))
          .flat()
          .map((name, index) => `dict_write{dict_ptr=warp_memory}(${add('start', index)}, ${name})`)
          .join('\n'),
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
