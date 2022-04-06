import { FunctionDefinition, Return } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { analyseControlFlow } from '../utils/controlFlowAnalyser';
import { toSingleExpression } from '../utils/functionGeneration';
import { createIdentifier } from '../utils/nodeTemplates';

export class ReturnInserter extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (node.vBody === undefined) return;

    const controlFlows = analyseControlFlow(node.vBody);

    if (controlFlows.some((flow) => !flow.some((s) => s instanceof Return))) {
      const retVars = node.vReturnParameters.vParameters;
      let expression;
      if (retVars.length !== 0) {
        expression = toSingleExpression(
          retVars.map((r) => createIdentifier(r, ast)),
          ast,
        );
      }
      const newReturn = new Return(
        ast.reserveId(),
        node.src,
        node.vReturnParameters.id,
        expression,
      );
      node.vBody.appendChild(newReturn);
      ast.registerChild(newReturn, node.vBody);
    }
  }
}
