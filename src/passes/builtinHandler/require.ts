import { ExternalReferenceType, FunctionCall, Literal, LiteralKind } from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoAssert } from '../../ast/cairoNodes';
import { ASTMapper } from '../../ast/mapper';

export class Require extends ASTMapper {
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);
    if (node.vFunctionCallType !== ExternalReferenceType.Builtin) {
      return;
    }

    if (node.vIdentifier === 'require' || node.vIdentifier === 'assert') {
      // Require can have one or two arguments
      // TODO handle second argument (string explaining why it reverted)

      // TODO check what hexvalue solc-typed-ast produces for a boolean literal
      ast.replaceNode(
        node,
        new CairoAssert(
          ast.reserveId(),
          node.src,
          'CairoAssert',
          node.vArguments[0],
          new Literal(ast.reserveId(), node.src, 'Literal', 'bool', LiteralKind.Bool, '', 'true'),
          node.raw,
        ),
      );
    } else if (node.vIdentifier === 'revert') {
      ast.replaceNode(
        node,
        new CairoAssert(
          ast.reserveId(),
          node.src,
          'CairoAssert',
          new Literal(ast.reserveId(), node.src, 'Literal', 'bool', LiteralKind.Bool, '', 'true'),
          new Literal(ast.reserveId(), node.src, 'Literal', 'bool', LiteralKind.Bool, '', 'false'),
          node.raw,
        ),
      );
    }
  }
}
