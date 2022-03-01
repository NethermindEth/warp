import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { MathsOperationToFunction } from './MathsOperationToFunction';
import { ExplicitConversionToFunc } from './explicitConversionToFunc';
import { MsgSender } from './msgSender';
import { Require } from './require';
import { ShortCircuitToConditional } from './shortCircuitToConditional';

export class BuiltinHandler extends ASTMapper {
  static map(ast: AST): AST {
    ast = MsgSender.map(ast);
    ast = Require.map(ast);
    ast = ExplicitConversionToFunc.map(ast);
    ast = ShortCircuitToConditional.map(ast);
    ast = MathsOperationToFunction.map(ast);
    return ast;
  }
}
