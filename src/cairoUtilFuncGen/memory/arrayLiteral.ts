import assert = require('assert');
import {
  ArrayType,
  DataLocation,
  FunctionCall,
  getNodeType,
  PointerType,
  TupleExpression,
  TypeNode,
} from 'solc-typed-ast';
import { printNode } from '../../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../../utils/cairoTypeSystem';
import { createCairoFunctionStub, createCallToFunction } from '../../utils/functionStubbing';
import { notNull } from '../../utils/typeConstructs';
import { dereferenceType, mapRange, narrowBigInt, typeNameFromTypeNode } from '../../utils/utils';
import { uint256 } from '../../warplib/utils';
import { add, StringIndexedFuncGen } from '../base';

export class MemoryArrayLiteralGen extends StringIndexedFuncGen {
  gen(node: TupleExpression): FunctionCall {
    const elements = node.vOriginalComponents.filter(notNull);
    assert(elements.length === node.vOriginalComponents.length);

    const type = dereferenceType(getNodeType(node, this.ast.compilerVersion));
    assert(type instanceof ArrayType);

    assert(type.size !== undefined, `${printNode(node)} has undefined size`);
    const size = narrowBigInt(type.size);
    assert(size !== null, `${printNode(node)} too long to process`);

    const name = this.getOrCreate(type.elementT, size);

    const stub = createCairoFunctionStub(
      name,
      mapRange(size, (n) => [
        `e${n}`,
        typeNameFromTypeNode(type.elementT, this.ast),
        type.elementT instanceof PointerType ? DataLocation.Memory : DataLocation.Default,
      ]),
      [['arr', typeNameFromTypeNode(type, this.ast), DataLocation.Memory]],
      ['range_check_ptr', 'warp_memory'],
      this.ast,
      node,
    );

    return createCallToFunction(stub, elements, this.ast);
  }

  private getOrCreate(type: TypeNode, size: number): string {
    const elementCairoType = CairoType.fromSol(
      type,
      this.ast,
      TypeConversionContext.MemoryAllocation,
    );
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
        `    let (start) = wm_alloc(${uint256(BigInt(size * elementCairoType.width))})`,
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
