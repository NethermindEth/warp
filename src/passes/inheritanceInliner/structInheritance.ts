import { AST } from '../../ast/ast';
import { CairoContract } from '../../ast/cairoNodes';
import { cloneASTNode } from '../../utils/cloning';
import { getBaseContracts } from './utils';

export function addStructDefinition(node: CairoContract, ast: AST) {
  getBaseContracts(node).forEach((base) =>
    base.vStructs.forEach((struct) => {
      const newStruct = cloneASTNode(struct, ast);
      newStruct.scope = node.id;
      node.insertAtBeginning(newStruct);
    }),
  );
}
