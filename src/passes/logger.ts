import { ElementaryTypeName, FunctionCall } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { primitiveTypeToCairo } from '../utils/utils';

export class logger extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    console.log(node);
  }
}
