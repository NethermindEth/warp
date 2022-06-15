import {
  ASTNode,
  ContractDefinition,
  ContractKind,
  StructuredDocumentation,
  VariableDeclaration,
} from 'solc-typed-ast';

/*
 A version of ContractDefinition annotated with the information required
 to allocate the required space for storage variables
*/
export class CairoContract extends ContractDefinition {
  // Maps each state variable to its start point in WARP_STORAGE
  dynamicStorageAllocations: Map<VariableDeclaration, number>;
  staticStorageAllocations: Map<VariableDeclaration, number>;
  usedStorage: number;
  usedIds: number;

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
    dynamicStorageAllocations: Map<VariableDeclaration, number>,
    staticStorageAllocations: Map<VariableDeclaration, number>,
    usedStorage: number,
    usedStoredPointerIds: number,
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
    this.dynamicStorageAllocations = dynamicStorageAllocations;
    this.staticStorageAllocations = staticStorageAllocations;
    this.usedStorage = usedStorage;
    this.usedIds = usedStoredPointerIds;
    this.acceptChildren();
  }
}
