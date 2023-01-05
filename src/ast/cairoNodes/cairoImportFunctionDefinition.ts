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
    kind: FunctionKind,
    name: string,
    visibility: FunctionVisibility,
    stateMutability: FunctionStateMutability,
    parameters: ParameterList,
    returnParameters: ParameterList,
    implicits: Set<Implicits>,
    path: string,
    functionStubKind: FunctionStubKind,
  ) {
    super(
      id,
      '',
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
      functionStubKind,
      false,
      false,
    );
    this.path = path;
  }
}
