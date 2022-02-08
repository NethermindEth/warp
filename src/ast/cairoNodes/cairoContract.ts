import {
  ASTNode,
  ContractDefinition,
  ContractKind,
  StructuredDocumentation,
  VariableDeclaration,
} from 'solc-typed-ast';

// TODO merge initialisationBlock with the constructor if there is one, or add one if not
export class CairoContract extends ContractDefinition {
  storageAllocations: Map<VariableDeclaration, number>;

  constructor(
    id: number,
    src: string,
    type: string,
    name: string,
    scope: number,
    kind: ContractKind,
    abstract: boolean,
    fullyImplemented: boolean,
    linearizedBaseContracts: number[],
    usedErrors: number[],
    storageAllocations: Map<VariableDeclaration, number>,
    documentation?: string | StructuredDocumentation,
    children?: Iterable<ASTNode>,
    nameLocation?: string,
    raw?: unknown,
  ) {
    super(
      id,
      src,
      type,
      name,
      scope,
      kind,
      abstract,
      fullyImplemented,
      linearizedBaseContracts,
      usedErrors,
      documentation,
      children,
      nameLocation,
      raw,
    );
    this.storageAllocations = storageAllocations;
    this.acceptChildren();
  }
}
