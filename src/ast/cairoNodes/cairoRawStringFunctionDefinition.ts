import {
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  ParameterList,
} from 'solc-typed-ast';
import { CairoFunctionDefinition, FunctionStubKind } from './cairoFunctionDefinition';
import { Implicits } from '../../utils/implicits';

export class CairoRawStringFunctionDefinition extends CairoFunctionDefinition {
  rawStringDefinition: string;
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
      false,
      visibility,
      stateMutability,
      false,
      parameters,
      returnParameters,
      [],
      implicits,
      FunctionStubKind.None,
      false,
      false,
    );
    this.rawStringDefinition = rawStringDefinition;
  }
}
