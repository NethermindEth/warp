import assert from 'assert';
import {
  Assignment,
  Block,
  ContractDefinition,
  ContractKind,
  DataLocation,
  ExpressionStatement,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  generalizeType,
  getNodeType,
  MappingType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoContract } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import { CairoType, TypeConversionContext } from '../utils/cairoTypeSystem';
import { createBlock, createIdentifier, createParameterList } from '../utils/nodeTemplates';
import { isDynamicStorageArray, typeNameToSpecializedTypeNode } from '../utils/nodeTypeProcessing';
import { isCairoConstant } from '../utils/utils';

export class StorageAllocator extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    const initialisationBlock = createBlock([], ast);

    let usedStorage = 0;
    let usedNames = 0;
    const allocations: Map<VariableDeclaration, number> = new Map();
    node.vStateVariables.forEach((v) => {
      const type = getNodeType(v, ast.compilerVersion);
      if (generalizeType(type)[0] instanceof MappingType || isDynamicStorageArray(type)) {
        const width = CairoType.fromSol(type, ast, TypeConversionContext.StorageAllocation).width;
        allocations.set(v, ++usedNames);
        usedStorage += width;
        extractInitialisation(v, initialisationBlock, ast);
      } else if (!isCairoConstant(v)) {
        const width = CairoType.fromSol(type, ast, TypeConversionContext.StorageAllocation).width;
        allocations.set(v, usedStorage);
        usedStorage += width;
        extractInitialisation(v, initialisationBlock, ast);
      }
    });
    insertIntoConstructor(initialisationBlock, node, ast);

    const cairoNode = new CairoContract(
      node.id,
      node.src,
      node.name,
      node.scope,
      node.kind,
      node.abstract,
      node.fullyImplemented,
      node.linearizedBaseContracts,
      node.usedErrors,
      allocations,
      usedStorage,
      usedNames,
      node.documentation,
      node.children,
      node.nameLocation,
      node.raw,
    );
    ast.replaceNode(node, cairoNode);

    // This next code line is a hotfix when there is struct inheritance and the base contract's definiton
    // gets replaced by its cairo counter part. From now on using `getNodeType` on an expression with a
    // an inherited struct type will crash unexpectedly.
    // The issue is caused because the property `vLinearizedBaseContracts` that is accessed through `getNodeType`
    // still points to the old contract's non-cairo definition which has it's context set as undefined due to
    // the replacement
    node.context = cairoNode.context;
  }
}

function insertIntoConstructor(initialisationBlock: Block, contract: ContractDefinition, ast: AST) {
  if (contract.kind !== ContractKind.Contract) return;

  const constructor = contract.vConstructor;
  if (constructor === undefined) {
    const newConstructor = new FunctionDefinition(
      ast.reserveId(),
      '',
      contract.id,
      FunctionKind.Constructor,
      '',
      false,
      FunctionVisibility.Public,
      FunctionStateMutability.NonPayable,
      true,
      createParameterList([], ast),
      createParameterList([], ast),
      [],
      undefined,
      initialisationBlock,
    );
    contract.appendChild(newConstructor);
    ast.registerChild(newConstructor, contract);
  } else {
    const body = constructor.vBody;
    assert(body !== undefined, 'Expected existing constructor to be implemented');
    initialisationBlock.children
      .slice()
      .reverse()
      .forEach((statement) => {
        body.insertAtBeginning(statement);
      });
  }
}

function extractInitialisation(node: VariableDeclaration, initialisationBlock: Block, ast: AST) {
  if (node.vValue === undefined) return;

  assert(node.vType !== undefined);
  const type = typeNameToSpecializedTypeNode(node.vType, DataLocation.Storage);

  initialisationBlock.appendChild(
    new ExpressionStatement(
      ast.reserveId(),
      node.src,
      new Assignment(
        ast.reserveId(),
        node.src,
        type.pp(),
        '=',
        createIdentifier(node, ast),
        node.vValue,
      ),
    ),
  );

  node.vValue = undefined;
}
