import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { AddressArgumentPusher } from './addressArgumentPusher';
//import { AddressEliminator } from './addressEliminator';

export class AddressHandler extends ASTMapper {
  map(node: AST): AST {
    //node = new AddressEliminator().map(node);
    node = new AddressArgumentPusher().map(node);
    return node;
  }
}
