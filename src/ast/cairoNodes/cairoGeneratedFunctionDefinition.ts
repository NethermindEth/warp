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
   * List of functions defintions called by the generated function
   */
  functionsCalled: FunctionDefinition[];
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
    );
    this.functionsCalled = removeRepeatedFunction(functionsCalled);
  }
}

function removeRepeatedFunction(functionsCalled: FunctionDefinition[]) {
  return [...new Set(functionsCalled)];
}