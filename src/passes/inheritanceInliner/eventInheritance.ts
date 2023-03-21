import { EventDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoContract } from '../../ast/cairoNodes';
import { cloneASTNode } from '../../utils/cloning';
import { getBaseContracts } from './utils';

export function addEventDefinition(
  node: CairoContract,
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
