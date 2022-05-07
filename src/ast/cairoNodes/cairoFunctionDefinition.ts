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

/*
 An extension of FunctionDefinition to track which implicit arguments are used
 Additionally we often use function stubs for instances where we want to be able
 to insert function during transpilation where it wouldn't make sense to include
 their body in the AST. For example, stubs are used for warplib functions, and
 those generated to handle memory and storage processing. Marking a CairoFunctionDefintion
 as a stub tells the CairoWriter not to print it
*/

export enum FunctionStubKind {
  None,
  FunctionDefStub,
  StructDefStub,
}

export class CairoFunctionDefinition extends FunctionDefinition {
  implicits: Set<Implicits>;
  functionStubKind: FunctionStubKind;
  constructor(
    id: number,
    src: string,
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
    functionStubKind: FunctionStubKind = FunctionStubKind.None,
    overrideSpecifier?: OverrideSpecifier,
    body?: Block,
    documentation?: string | StructuredDocumentation,
    nameLocation?: string,
    raw?: unknown,
  ) {
    super(
      id,
      src,
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
    this.functionStubKind = functionStubKind;
  }
}
