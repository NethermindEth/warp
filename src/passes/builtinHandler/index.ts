import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { MathsOperationToFunction } from './mathsOperationToFunction';
import { ExplicitConversionToFunc } from './explicitConversionToFunc';
import { MsgSender } from './msgSender';
import { ThisKeyword } from './thisKeyword';
import { Ecrecover } from './ecrecover';
import { Keccak } from './keccak';
import { BlockMethods } from './blockMethods';

export class BuiltinHandler extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    ast = MsgSender.map(ast);
    ast = BlockMethods.map(ast);
    ast = Ecrecover.map(ast);
    ast = Keccak.map(ast);
    ast = ExplicitConversionToFunc.map(ast);
    ast = MathsOperationToFunction.map(ast);
    ast = ThisKeyword.map(ast);
    return ast;
  }
}
