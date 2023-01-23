import {
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  ParameterList,
} from 'solc-typed-ast';
import { CairoFunctionDefinition, FunctionStubKind } from './cairoFunctionDefinition';
import { Implicits } from '../../utils/implicits';

export class CairoImportFunctionDefinition extends CairoFunctionDefinition {
  path: string;
  constructor(
    id: number,
    scope: number,
    name: string,
    path: string,
    implicits: Set<Implicits>,
    parameters: ParameterList,
    returnParameters: ParameterList,
    isStruct: boolean,
  ) {
    super(
      id,
      '',
      scope,
      FunctionKind.Function,
      name,
      false,
      FunctionVisibility.Internal,
      FunctionStateMutability.NonPayable,
      false,
      parameters,
      returnParameters,
      [],
      implicits,
      isStruct ? FunctionStubKind.StructDefStub : FunctionStubKind.FunctionDefStub,
      false,
      false,
    );
    this.path = path;
  }
}
