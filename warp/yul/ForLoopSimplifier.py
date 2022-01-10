import yul.yul_ast as ast
from yul.AstMapper import AstMapper


class ForLoopSimplifier(AstMapper):
    def visit_for_loop(self, node: ast.ForLoop):
        return ast.Block(
            self.visit(node.pre).statements
            + (
                ast.ForLoop(
                    pre=ast.Block(),
                    condition=node.condition,
                    post=self.visit(ast.Block(node.post.statements)),
                    body=self.visit(ast.Block(node.body.statements)),
                ),
            )
        )
