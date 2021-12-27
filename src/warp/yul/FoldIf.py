from __future__ import annotations

from typing import Union

import warp.yul.ast as ast
from warp.yul.AstMapper import AstMapper


class FoldIf(AstMapper):
    """This class replaces an if statment with its body or else_body if the
    condition is a literal.
    """

    def visit_block(self, node: ast.Block) -> ast.Block:
        statements = []
        for statement in node.statements:
            if isinstance(statement, ast.If):
                visited_if = self.visit(statement)
                if isinstance(visited_if, ast.Block):
                    statements += list(visited_if.statements)
                else:
                    statements.append(visited_if)
            else:
                statements.append(self.visit(statement))

        return ast.Block(tuple(statements))

    def visit_if(self, node: ast.If) -> Union[ast.Block, ast.If]:
        if isinstance(node.condition, ast.Literal):
            if node.condition.value:
                return self.visit(node.body)
            else:
                return (
                    self.visit(node.else_body) if node.else_body else ast.Block(tuple())
                )

        return super().visit_if(node)
