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
  usedStorage: number;

  constructor(
    id: number,
    src: string,
    name: string,
    scope: number,
    kind: ContractKind,
    abstract: boolean,
    fullyImplemented: boolean,
    linearizedBaseContracts: number[],
    usedErrors: number[],
    storageAllocations: Map<VariableDeclaration, number>,
    usedStorage: number,
    documentation?: string | StructuredDocumentation,
    children?: Iterable<ASTNode>,
    nameLocation?: string,
    raw?: unknown,
  ) {
    super(
      id,
      src,
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
    this.usedStorage = usedStorage;
    this.acceptChildren();
  }
}
