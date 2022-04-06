import assert = require('assert');
import { ContractDefinition, ModifierDefinition } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { printNode } from '../../utils/astPrinter';

/*  Once functions with modifiers are processed, the code of each modifier invoked
    has been inlined in its corresponding function; modifiers are not used anywhere 
    else. Therefore, ModifierDefinition nodes are removed in order to simplify 
    further passes on the ast, as they are no longer needed.
*/
export class ModifierRemover extends ASTMapper {
  visitModifierDefinition(node: ModifierDefinition, _ast: AST) {
    const parent = node.getClosestParentByType(ContractDefinition);
    assert(parent !== undefined, `Unable to find parent of ${printNode(node)}`);
    parent.removeChild(node);
  }
}
