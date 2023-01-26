import {
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  ParameterList,
} from 'solc-typed-ast';
import { CairoFunctionDefinition, FunctionStubKind } from './cairoFunctionDefinition';
import { getRawCairoFunctionInfo } from '../../utils/cairoParsing';

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
    functionSutbKind: FunctionStubKind,
    rawStringDefinition: string,
  ) {
    super(
      id,
      src,
      scope,
      kind,
      name,
      false, // Virtual
      visibility,
      stateMutability,
      false, // IsConstructor
      parameters,
      returnParameters,
      [], // Modifier Invocation
      functionSutbKind === FunctionStubKind.FunctionDefStub
        ? new Set(getRawCairoFunctionInfo(rawStringDefinition).implicits)
        : new Set(),
      functionSutbKind,
      false, // Accepts raw dynamic array
      false, // Acceps structured dynamic array
    );
    this.rawStringDefinition = rawStringDefinition;
  }
}
