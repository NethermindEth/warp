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
import {
  createReturn,
  generateFunctionCall,
  toSingleExpression,
} from '../../utils/functionGeneration';
import { createIdentifier } from '../../utils/nodeTemplates';

export class FunctionModifierInliner extends ASTMapper {
  currentFunction: FunctionDefinition;
  parameters: VariableDeclaration[];
  retVariables: VariableDeclaration[];
  retParamsId: number;

  constructor(
    node: FunctionDefinition,
    parameters: VariableDeclaration[],
    retParams: ParameterList,
  ) {
    super();
    this.currentFunction = node;
    this.parameters = parameters;
    this.retVariables = retParams.vParameters;
    this.retParamsId = retParams.id;
  }

  visitPlaceholderStatement(node: PlaceholderStatement, ast: AST) {
    const args = this.parameters?.map((v) => createIdentifier(v, ast));
    const resultIdentifiers = this.retVariables.map((v) => createIdentifier(v, ast));
    const assignmentValue = toSingleExpression(resultIdentifiers, ast);

    ast.replaceNode(
      node,
      new ExpressionStatement(
        ast.reserveId(),
        node.src,
        'ExpressionStatement',
        this.retVariables.length === 0
          ? generateFunctionCall(this.currentFunction, args, ast)
          : new Assignment(
              ast.reserveId(),
              '',
              'Assignment',
              assignmentValue.typeString,
              '=',
              assignmentValue,
              generateFunctionCall(this.currentFunction, args, ast),
            ),
        node.documentation,
        node.raw,
      ),
    );
  }

  visitReturn(node: Return, ast: AST): void {
    ast.replaceNode(node, createReturn(this.retVariables, this.retParamsId, ast));
  }
}
