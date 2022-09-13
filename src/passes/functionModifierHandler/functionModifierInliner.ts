import {
  Assignment,
  ExpressionStatement,
  FunctionDefinition,
  ParameterList,
  PlaceholderStatement,
  Return,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { createCallToFunction } from '../../utils/functionGeneration';
import { createIdentifier, createReturn } from '../../utils/nodeTemplates';
import { toSingleExpression } from '../../utils/utils';

/*  ModifierInliner starts to walk the ast through a Modifier node as a root.
    Whenever it reaches a placeholder, it replaces it with a call to `currentFunction`.
    When it reaches a return statement, it is replaced with a new return accordingly 
    with `returnParameters`

    Given a function f() which returns one parameter: __warp_ret_parameter_a; and a 
    modifier m as follows:
    
    modifier m() {
      _;
      return;
    }

    The modifier that results from this pass will look like the following:

    modifier m() {
      __warp_ret_parameter_a = f();
      return __warp_ret_parameter_a;
    }
*/

export class FunctionModifierInliner extends ASTMapper {
  currentFunction: FunctionDefinition;
  parameters: VariableDeclaration[];
  returnParameters: ParameterList;

  constructor(
    node: FunctionDefinition,
    parameters: VariableDeclaration[],
    retParams: ParameterList,
  ) {
    super();
    this.currentFunction = node;
    this.parameters = parameters;
    this.returnParameters = retParams;
  }

  visitPlaceholderStatement(node: PlaceholderStatement, ast: AST) {
    const retVariables = this.returnParameters.vParameters;
    const args = this.parameters.map((v) =>
      createIdentifier(v, ast, undefined, this.currentFunction),
    );
    const resultIdentifiers = retVariables.map((v) =>
      createIdentifier(v, ast, undefined, this.currentFunction),
    );
    const assignmentValue = toSingleExpression(resultIdentifiers, ast);

    ast.replaceNode(
      node,
      new ExpressionStatement(
        ast.reserveId(),
        node.src,
        retVariables.length === 0
          ? createCallToFunction(this.currentFunction, args, ast)
          : new Assignment(
              ast.reserveId(),
              '',
              assignmentValue.typeString,
              '=',
              assignmentValue,
              createCallToFunction(this.currentFunction, args, ast),
            ),
        node.documentation,
        node.raw,
      ),
    );
  }

  visitReturn(node: Return, ast: AST): void {
    ast.replaceNode(
      node,
      createReturn(this.returnParameters.vParameters, this.returnParameters.id, ast),
    );
  }
}
