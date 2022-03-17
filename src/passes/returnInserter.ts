import { FunctionDefinition, Return } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { analyseControlFlow } from '../utils/controlFlowAnalyser';
import { createIdentifier } from '../utils/nodeTemplates';
import { toSingleExpression } from './loopFunctionaliser/utils';

export class ReturnInserter extends ASTMapper {
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (node.vBody === undefined) return;

    const controlFlows = analyseControlFlow(node.vBody);

    if (controlFlows.some((flow) => !flow.some((s) => s instanceof Return))) {
      const retVars = node.vReturnParameters.vParameters;
      const newReturn = new Return(
        ast.reserveId(),
        node.src,
        'Return',
        node.vReturnParameters.id,
        toSingleExpression(
          retVars.map((r) => createIdentifier(r, ast)),
          ast,
        ),
      );
      node.vBody.appendChild(newReturn);
      ast.registerChild(newReturn, node.vBody);
    }
  }
}