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
  is_struct: boolean;
  is_function: boolean;
  constructor(
    id: number,
    scope: number,
    name: string,
    path: string,
    is_struct: boolean,
    implicits: Set<Implicits>,
    parameters: ParameterList,
    returnParameters: ParameterList,
  ) {
    super(
      id,
      '',
      scope,
      FunctionKind.Function,
      name,
      false,
      FunctionVisibility.Internal,
      FunctionStateMutability.NonPayable, // TODO: This needs review
      false,
      parameters,
      returnParameters,
      [],
      implicits,
      FunctionStubKind.FunctionDefStub, // TODO: This is gonna be removed
      false,
      false,
    );
    this.path = path;
    if (is_struct) {
      this.is_struct = true;
      this.is_function = false;
    } else {
      this.is_struct = false;
      this.is_function = true;
    }
  }
}
