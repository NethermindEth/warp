import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { MathsOperationToFunction } from './MathsOperationToFunction';
import { ExplicitConversionToFunc } from './explicitConversionToFunc';
import { MsgSender } from './msgSender';
import { Require } from './require';
import { ShortCircuitToConditional } from './shortCircuitToConditional';

export class BuiltinHandler extends ASTMapper {
  map(ast: AST): AST {
    ast = new MsgSender().map(ast);
    ast = new Require().map(ast);
    ast = new ExplicitConversionToFunc().map(ast);
    ast = new ShortCircuitToConditional().map(ast);
    ast = new MathsOperationToFunction().map(ast);
    return ast;
  }
}
