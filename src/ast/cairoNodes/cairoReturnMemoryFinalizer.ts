import { Expression, Return, StructuredDocumentation } from 'solc-typed-ast';

export class CairoReturnMemoryFinalizer extends Return {
  /*
  Class that wraps a Return statement when Warp Memory dict must be finalized
  before returning.
  This class is transpiled as:
  ```
  default_dict_finalize(warp_memory_start, warp_memory, 0)
  return <expression>
  ```
  */
  constructor(
    id: number,
    src: string,
    functionRetunrParameters: number,
    expression: Expression | undefined,
    documentation: string | StructuredDocumentation | undefined,
    raw: any,
  ) {
    super(id, src, functionRetunrParameters, expression, documentation, raw);
  }
}
