import { ContractDefinition, EventDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { cloneASTNode } from '../../utils/cloning';
import { getBaseContracts } from './utils';

export function addEventDefintion(
  node: ContractDefinition,
  idRemapping: Map<number, EventDefinition>,
  ast: AST,
): void {
  getBaseContracts(node).forEach((base) =>
    base.vEvents.forEach((event) => {
      const newEvent = cloneASTNode(event, ast);
      node.insertAtBeginning(newEvent);
      idRemapping.set(event.id, newEvent);
    }),
  );
}
