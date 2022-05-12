import { ContractDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { cloneASTNode } from '../../utils/cloning';
import { getBaseContracts } from './utils';

export function addStructDefinition(node: ContractDefinition, ast: AST) {
  getBaseContracts(node).forEach((base) =>
    base.vStructs.forEach((struct) => {
      const newStruct = cloneASTNode(struct, ast);
      newStruct.scope = node.id;
      node.insertAtBeginning(newStruct);
    }),
  );
}
