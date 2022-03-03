import assert = require('assert');
import {
  Block,
  Expression,
  ExpressionStatement,
  ExternalReferenceType,
  FunctionCall,
  FunctionDefinition,
  Literal,
  Return,
  getNodeType,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { CairoAssert } from '../../ast/cairoNodes';
import { ASTMapper } from '../../ast/mapper';
import { getDefaultValue } from '../../utils/defaultValueNodes';
import { createBoolLiteral } from '../../utils/nodeTemplates';
import { toSingleExpression } from '../loopFunctionaliser/utils';

export class Require extends ASTMapper {
  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    const expressionNode = node.vExpression;

    const cairoAssert = this.requireToCairoAssert(expressionNode, ast);
    if (cairoAssert === null) {
      this.commonVisit(node, ast);
      return;
    }

    // Since the cairoAssert is not null, we have a require/revert/assert function call at hand
    assert(expressionNode instanceof FunctionCall);

    // Append a return after the revert to satisfy cairo's flow checker
    if (expressionNode.vIdentifier === 'revert') {
      const parentBlock = node.getClosestParentByType(Block);
      assert(parentBlock instanceof Block, 'Revert statement needs to be in a parent block');

      const containingFunction = node.getClosestParentByType(FunctionDefinition);
      assert(
        containingFunction instanceof FunctionDefinition,
        'Revert statement must be in a funciton body',
      );

      const returnTypes = containingFunction.vReturnParameters.vParameters.map((declaration) => ({
        declaration,
        type: getNodeType(declaration, ast.compilerVersion),
      }));
      const returnValues = returnTypes.map(({ declaration, type }) =>
        getDefaultValue(type, declaration, ast),
      );

      const returnExpression = new Return(
        ast.reserveId(),
        node.src,
        'Return',
        containingFunction.vReturnParameters.id,
        toSingleExpression(returnValues, ast),
      );
      parentBlock.appendChild(returnExpression);
      ast.registerChild(returnExpression, parentBlock);
    }
    ast.replaceNode(node, cairoAssert);
  }

  visitReturn(node: Return, ast: AST): void {
    const expressionNode = node.vExpression;
    const cairoAssert = this.requireToCairoAssert(expressionNode, ast);
    if (cairoAssert === null) return;

    ast.insertStatementBefore(node, cairoAssert);
    node.vExpression = undefined;
  }

  requireToCairoAssert(expression: Expression | undefined, ast: AST): ExpressionStatement | null {
    if (!(expression instanceof FunctionCall)) return null;
    if (expression.vFunctionCallType !== ExternalReferenceType.Builtin) {
      return null;
    }

    if (expression.vIdentifier === 'require' || expression.vIdentifier === 'assert') {
      const requireMessage =
        expression.vArguments[1] instanceof Literal ? expression.vArguments[1].value : null;

      return new ExpressionStatement(
        ast.reserveId(),
        expression.src,
        'ExpressionStatement',
        new CairoAssert(
          ast.reserveId(),
          expression.src,
          'CairoAssert',
          expression.vArguments[0],
          requireMessage,
          expression.raw,
        ),
      );
    } else if (expression.vIdentifier === 'revert') {
      const revertMessage =
        expression.vArguments[0] instanceof Literal ? expression.vArguments[0].value : null;

      return new ExpressionStatement(
        ast.reserveId(),
        expression.src,
        'ExpressionStatment',
        new CairoAssert(
          ast.reserveId(),
          expression.src,
          'CairoAssert',
          createBoolLiteral(false, ast),
          revertMessage,
          expression.raw,
        ),
      );
    }
    return null;
  }
}
