import {
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  ParameterList,
} from 'solc-typed-ast';
import { Implicits } from '../../utils/implicits';
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
      rawStringDefinition,
    );
    this.functionsCalled = removeRepeatedFunction(functionsCalled);
  }
}

function removeRepeatedFunction(functionsCalled: FunctionDefinition[]) {
  return [...new Set(functionsCalled)];
}
