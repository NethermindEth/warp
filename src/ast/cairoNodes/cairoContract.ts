import {
  ASTNode,
  Block,
  ContractDefinition,
  ContractKind,
  StructuredDocumentation,
  VariableDeclaration,
} from 'solc-typed-ast';

// TODO merge initialisationBlock with the constructor if there is one, or add one if not
export class CairoContract extends ContractDefinition {
  storageAllocations: Map<VariableDeclaration, number>;

  initialisationBlock: Block;

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
    initialisationBlock: Block,
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
    this.initialisationBlock = initialisationBlock;
    this.acceptChildren();
  }

  get children(): readonly ASTNode[] {
    return this.pickNodes(this.initialisationBlock, super.children);
  }

  get hasConstructor(): boolean {
    return this.initialisationBlock.children.length > 0;
  }
}
