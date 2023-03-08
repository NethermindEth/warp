import {
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  ParameterList,
} from 'solc-typed-ast';
import { CairoFunctionDefinition, FunctionStubKind } from './cairoFunctionDefinition';
import { Implicits } from '../../utils/implicits';

export class CairoImportFunctionDefinition extends CairoFunctionDefinition {
  path: string[];
  constructor(
    id: number,
    src: string,
    scope: number,
    name: string,
    path: string[],
    implicits: Set<Implicits>,
    parameters: ParameterList,
    returnParameters: ParameterList,
    stubKind: FunctionStubKind,
    acceptsRawDArray = false,
    acceptsUnpackedStructArray = false,
  ) {
    super(
      id,
      src,
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
      stubKind,
      acceptsRawDArray,
      acceptsUnpackedStructArray,
    );
    this.path = path;
  }
}
