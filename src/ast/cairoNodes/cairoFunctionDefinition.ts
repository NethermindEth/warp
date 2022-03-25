import {
  Block,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  ModifierInvocation,
  OverrideSpecifier,
  ParameterList,
  StructuredDocumentation,
} from 'solc-typed-ast';
import { Implicits } from '../../utils/implicits';

export class CairoFunctionDefinition extends FunctionDefinition {
  implicits: Set<Implicits>;
  isStub: boolean;

  constructor(
    id: number,
    src: string,
    type: string,
    scope: number,
    kind: FunctionKind,
    name: string,
    virtual: boolean,
    visibility: FunctionVisibility,
    stateMutability: FunctionStateMutability,
    isConstructor: boolean,
    parameters: ParameterList,
    returnParameters: ParameterList,
    modifiers: ModifierInvocation[],
    implicits: Set<Implicits>,
    isStub: boolean,
    overrideSpecifier?: OverrideSpecifier,
    body?: Block,
    documentation?: string | StructuredDocumentation,
    nameLocation?: string,
    raw?: unknown,
  ) {
    super(
      id,
      src,
      type,
      scope,
      kind,
      name,
      virtual,
      visibility,
      stateMutability,
      isConstructor,
      parameters,
      returnParameters,
      modifiers,
      overrideSpecifier,
      body,
      documentation,
      nameLocation,
      raw,
    );
    this.implicits = implicits;
    this.isStub = isStub;
  }
}
