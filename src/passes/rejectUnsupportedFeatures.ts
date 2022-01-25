import { InlineAssembly } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { WillNotSupportError } from '../utils/errors';

export class RejectUnsupportedFeatures extends ASTMapper {
  visitInlineAssembly(_node: InlineAssembly, _ast: AST): void {
    throw new WillNotSupportError('Yul blocks are not supported');
  }
}
