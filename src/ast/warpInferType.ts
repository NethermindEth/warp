import { Expression, InferType, TupleType, TypeNode } from 'solc-typed-ast';
import { CairoAssert } from './cairoNodes';

export class WarpInferType extends InferType {
  typeOf(node: Expression): TypeNode {
    if (node instanceof CairoAssert) {
      return new TupleType([]);
    }
    return super.typeOf(node);
  }
}
