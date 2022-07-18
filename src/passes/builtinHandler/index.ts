import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { MathsOperationToFunction } from './MathsOperationToFunction';
import { ExplicitConversionToFunc } from './explicitConversionToFunc';
import { MsgSender } from './msgSender';
import { ShortCircuitToConditional } from './shortCircuitToConditional';
import { ThisKeyword } from './thisKeyword';
import { Ecrecover } from './ecrecover';
import { Keccak } from './keccak';

export class BuiltinHandler extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([
      'Tf',
      'Tnr',
      'Ru',
      'Fm',
      'Ss',
      'Ct',
      'Ae',
      'Idi',
      'L',
      'Na',
      'Ufr',
      'Fd',
      'Tic',
      'Ch',
      'M',
      'Sai',
      'Udt',
      'Req',
      'Ffi',
      'Rl',
      'Ons',
      'Ech',
      'Sa',
      'Ii',
      'Mh',
      'Pfs',
      'Eam',
      'Lf',
      'R',
      'Rv',
      'If',
      'T',
      'U',
      'V',
      'Vs',
      'I',
      'Dh',
      'Rf',
      'Abc',
      'Ec',
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    ast = MsgSender.map(ast);
    ast = Ecrecover.map(ast);
    ast = Keccak.map(ast);
    ast = ExplicitConversionToFunc.map(ast);
    ast = ShortCircuitToConditional.map(ast);
    ast = MathsOperationToFunction.map(ast);
    ast = ThisKeyword.map(ast);
    return ast;
  }
}
