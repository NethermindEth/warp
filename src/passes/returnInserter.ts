import { FunctionDefinition, Return } from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { analyseControlFlow } from '../utils/controlFlowAnalyser';
import { createIdentifier, createReturn } from '../utils/nodeTemplates';
import { toSingleExpression } from '../utils/utils';

export class ReturnInserter extends ASTMapper {
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
    ]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

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
      const newReturn = createReturn(expression, node.vReturnParameters.id, ast);
      node.vBody.appendChild(newReturn);
      ast.registerChild(newReturn, node.vBody);
    }
  }
}
