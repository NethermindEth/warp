import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { CallGraphBuilder } from './callGraph';
import { FunctionRemover } from './functionRemover';
import { IdentityFunctionRemover } from './identityFunctionRemover';

export class FunctionPruner extends ASTMapper {
    static map(ast: AST): AST {
        ast.roots.forEach((root) => {
            const graph = new CallGraphBuilder();
            graph.dispatchVisit(root, ast);
            new FunctionRemover(graph.getFunctionGraph()).dispatchVisit(root, ast);
            new IdentityFunctionRemover().dispatchVisit(root, ast);
        });
        return ast;
    }
}
