import assert from 'assert';
import {
  Assignment,
  Block,
  ContractDefinition,
  ContractKind,
  DataLocation,
  FunctionDefinition,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  generalizeType,
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
import { INIT_FUNCTION_PREFIX } from '../utils/nameModifiers';
import {
  createBlock,
  createExpressionStatement,
  createIdentifier,
  createParameterList,
  createVariableDeclarationStatement,
} from '../utils/nodeTemplates';
import {
  isDynamicArray,
  safeGetNodeType,
  typeNameToSpecializedTypeNode,
} from '../utils/nodeTypeProcessing';
import { isCairoConstant } from '../utils/utils';

export class StorageAllocator extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    const initialisationBlock = createBlock([], ast);

    let usedStorage = 0;
    let usedNames = 0;
    const dynamicAllocations: Map<VariableDeclaration, number> = new Map();
    const staticAllocations: Map<VariableDeclaration, number> = new Map();
    node.vStateVariables.forEach((v) => {
      const type = safeGetNodeType(v, ast.compilerVersion);
      if (generalizeType(type)[0] instanceof MappingType || isDynamicArray(type)) {
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
    insertIntoInitFunction(initialisationBlock, node, ast);

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

    if (node.kind === ContractKind.Library) {
      // mark all library functions as private
      cairoNode.vFunctions.forEach((f) => {
        f.visibility = FunctionVisibility.Private;
      });
    }

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

function insertIntoInitFunction(
  initialisationBlock: Block,
  contract: ContractDefinition,
  ast: AST,
) {
  // No need to create the initialization function if the block is empty
  if (initialisationBlock.vStatements.length == 0) return;

  const initFunc = new FunctionDefinition(
    ast.reserveId(),
    '',
    contract.id,
    FunctionKind.Function,
    `${INIT_FUNCTION_PREFIX}${contract.name}`,
    false,
    FunctionVisibility.Private,
    FunctionStateMutability.NonPayable,
    false,
    createParameterList([], ast),
    createParameterList([], ast),
    [],
    undefined,
    initialisationBlock,
  );
  contract.appendChild(initFunc);
  ast.registerChild(initFunc, contract);
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
    value = createIdentifier(memoryVariableDeclaration, ast, DataLocation.Memory, node);
  }
  initialisationBlock.appendChild(
    createExpressionStatement(
      ast,
      new Assignment(ast.reserveId(), node.src, type.pp(), '=', createIdentifier(node, ast), value),
    ),
  );

  node.vValue = undefined;
}
