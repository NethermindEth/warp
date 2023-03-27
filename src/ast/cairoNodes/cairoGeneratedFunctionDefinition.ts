import {
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  ParameterList,
} from 'solc-typed-ast';
import { FunctionStubKind } from './cairoFunctionDefinition';
import { CairoRawStringFunctionDefinition } from './cairoRawStringFunctionDefinition';

export class CairoGeneratedFunctionDefinition extends CairoRawStringFunctionDefinition {
  /**
   * List of function definitions called by the generated function
   */
  public functionsCalled: FunctionDefinition[];

  constructor(
    id: number,
    src: string,
    scope: number,
    kind: FunctionKind,
    name: string,
    visibility: FunctionVisibility,
    stateMutability: FunctionStateMutability,
    parameters: ParameterList,
    returnParameters: ParameterList,
    functionStubKind: FunctionStubKind,
    rawStringDefinition: string,
    functionsCalled: FunctionDefinition[],
    acceptsRawDArray = false,
    acceptsUnpackedStructArray = false,
  ) {
    super(
      id,
      src,
      scope,
      kind,
      name,
      visibility,
      stateMutability,
      parameters,
      returnParameters,
      functionStubKind,
      rawStringDefinition,
      acceptsRawDArray,
      acceptsUnpackedStructArray,
    );
    this.functionsCalled = removeRepeatedFunction(functionsCalled);
  }
}

function removeRepeatedFunction(functionsCalled: FunctionDefinition[]) {
  return [...new Set(functionsCalled)];
}
