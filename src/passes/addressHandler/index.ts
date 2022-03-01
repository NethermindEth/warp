import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { AddressArgumentPusher } from './addressArgumentPusher';

export class AddressHandler extends ASTMapper {
  static map(ast: AST): AST {
    return AddressArgumentPusher.map(ast);
  }
}
