import {
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  ParameterList,
} from 'solc-typed-ast';
import { Implicits } from '../../utils/implicits';
import { CairoRawStringFunctionDefinition } from './cairoRawStringFunctionDefinition';

export class CairoFunctionStub extends CairoRawStringFunctionDefinition {
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
    implicits: Set<Implicits>,
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
      implicits,
      rawStringDefinition,
    );
  }
}
