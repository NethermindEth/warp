import { ASTMapper, AST } from '../../ast/mapper';
import { BinaryOperations } from './binaryOperations';
import { ExplicitConversionToFunc } from './explicitConversionToFunc';
import { MsgSender } from './msgSender';
import { Require } from './require';

export class BuiltinHandler extends ASTMapper {
  map(node: AST): AST {
    node = new MsgSender().map(node);
    node = new Require().map(node);
    node = new ExplicitConversionToFunc().map(node);
    node = new BinaryOperations().map(node);
    return node;
  }

  getPassName(): string {
    return 'Builtin Handler';
  }
}
