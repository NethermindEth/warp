import assert from 'assert';
import {
  ArrayType,
  Assignment,
  Block,
  BytesType,
  ContractDefinition,
  ContractKind,
  DataLocation,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  generalizeType,
  getNodeType,
  Literal,
  LiteralKind,
  MappingType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoContract } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import { CairoType, TypeConversionContext } from '../utils/cairoTypeSystem';
import { cloneASTNode } from '../utils/cloning';
import {
  createBlock,
  createExpressionStatement,
  createIdentifier,
  createParameterList,
  createVariableDeclarationStatement,
} from '../utils/nodeTemplates';
import { typeNameToSpecializedTypeNode } from '../utils/nodeTypeProcessing';
import { isCairoConstant } from '../utils/utils';

export class StorageAllocator extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    const initialisationBlock = createBlock([], ast);

    let usedStorage = 0;
    let usedNames = 0;
    const dynamicAllocations: Map<VariableDeclaration, number> = new Map();
    const staticAllocations: Map<VariableDeclaration, number> = new Map();
    node.vStateVariables.forEach((v) => {
      const type = getNodeType(v, ast.compilerVersion);
      if (
        generalizeType(type)[0] instanceof MappingType ||
        (type instanceof ArrayType && type.size === undefined) ||
        type instanceof BytesType
      ) {
        const width = CairoType.fromSol(type, ast, TypeConversionContext.StorageAllocation).width;
        dynamicAllocations.set(v, ++usedNames);
        usedStorage += width;
        extractInitialisation(v, initialisationBlock, ast);
      } else if (!isCairoConstant(v)) {
        const width = CairoType.fromSol(type, ast, TypeConversionContext.StorageAllocation).width;
        staticAllocations.set(v, usedStorage);
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
      dynamicAllocations,
      staticAllocations,
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

  let value = node.vValue;
  if (value && value instanceof Literal && value.kind === LiteralKind.String) {
    const memoryVariableDeclaration = cloneASTNode(node, ast);
    memoryVariableDeclaration.storageLocation = DataLocation.Memory;
    memoryVariableDeclaration.name = 'wm_' + memoryVariableDeclaration.name;
    memoryVariableDeclaration.stateVariable = false;
    initialisationBlock.appendChild(
      createVariableDeclarationStatement([memoryVariableDeclaration], value, ast),
    );
    value = createIdentifier(memoryVariableDeclaration, ast, DataLocation.Memory);
  }
  initialisationBlock.appendChild(
    createExpressionStatement(
      ast,
      new Assignment(ast.reserveId(), node.src, type.pp(), '=', createIdentifier(node, ast), value),
    ),
  );

  node.vValue = undefined;
}
