import { Expression, FunctionCall, FunctionCallKind } from 'solc-typed-ast';
import { Implicits } from '../../utils/implicits';

export class CairoFunctionCall extends FunctionCall {
  implicits: Set<Implicits> = new Set();

  constructor(
    id: number,
    src: string,
    type: string,
    typeString: string,
    kind: FunctionCallKind,
    expression: Expression,
    args: Expression[],
    fieldNames?: string[],
    raw?: any,
    implicits?: Implicits[],
  ) {
    super(id, src, type, typeString, kind, expression, args, fieldNames, raw);
    implicits?.forEach((v) => this.implicits.add(v));
  }
}
