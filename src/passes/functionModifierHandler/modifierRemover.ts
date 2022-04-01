import assert = require('assert');
import { ContractDefinition, ModifierDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';

export class ModifierRemover extends ASTMapper {
  visitModifierDefinition(node: ModifierDefinition, _ast: AST) {
    const parent = node.getClosestParentByType(ContractDefinition);
    assert(parent !== undefined, `Unable to find parent of ${printNode(node)}`);
    parent?.removeChild(node);
  }
}
