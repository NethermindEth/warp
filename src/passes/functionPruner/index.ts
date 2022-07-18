import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { CallGraphBuilder } from './callGraph';
import { FunctionRemover } from './functionRemover';

export class UnreachableFunctionPruner extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: string[] = [
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
      'B',
      'Bc',
      'Us',
    ];
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  static map(ast: AST): AST {
    ast.roots.forEach((root) => {
      const graph = new CallGraphBuilder();
      graph.dispatchVisit(root, ast);
      new FunctionRemover(graph.getFunctionGraph()).dispatchVisit(root, ast);
    });
    return ast;
  }
}
