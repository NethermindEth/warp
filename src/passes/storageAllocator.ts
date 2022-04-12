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
  getNodeType,
  Identifier,
  ParameterList,
  typeNameToSpecializedTypeNode,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoContract } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';
import { printTypeNode } from '../utils/astPrinter';
import { CairoType, TypeConversionContext } from '../utils/cairoTypeSystem';
import { isCairoConstant } from '../utils/utils';

export class StorageAllocator extends ASTMapper {
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    const initialisationBlock = new Block(ast.reserveId(), '', []);

    let usedStorage = 0;
    const allocations: Map<VariableDeclaration, number> = new Map();
    node.vStateVariables.forEach((v) => {
      if (!isCairoConstant(v)) {
        const width = CairoType.fromSol(
          getNodeType(v, ast.compilerVersion),
          ast,
          TypeConversionContext.StorageAllocation,
        ).width;
        allocations.set(v, usedStorage);
        usedStorage += width;
        extractInitialisation(v, initialisationBlock, ast);
      }
    });
    insertIntoConstructor(initialisationBlock, node, ast);
    ast.replaceNode(
      node,
      new CairoContract(
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
        node.documentation,
        node.children,
        node.nameLocation,
        node.raw,
      ),
    );
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
      new ParameterList(ast.reserveId(), '', []),
      new ParameterList(ast.reserveId(), '', []),
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
        new Identifier(ast.reserveId(), node.src, type.pp(), node.name, node.id),
        node.vValue,
      ),
    ),
  );

  node.vValue = undefined;
}
