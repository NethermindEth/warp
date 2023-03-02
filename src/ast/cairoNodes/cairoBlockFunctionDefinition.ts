import {
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  ParameterList,
} from 'solc-typed-ast';
import { FunctionStubKind } from './cairoFunctionDefinition';
import { CairoRawStringFunctionDefinition } from './cairoRawStringFunctionDefinition';

export class CairoBlockFunctionDefinition extends CairoRawStringFunctionDefinition {
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
      FunctionStubKind.FunctionDefStub,
      rawStringDefinition,
    );
  }
}
