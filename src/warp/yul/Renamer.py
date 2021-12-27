from typing import Callable

import warp.yul.ast as ast
from warp.yul.AstMapper import AstMapper

CAIRO_KEYWORDS = {"ret", "felt", "jmp", "func", "end"}


def mangle(identifier: str) -> str:
    identifier = identifier.replace("$", "_")
    if identifier in CAIRO_KEYWORDS:
        return identifier + "__warp_mangled"
    else:
        return identifier


class Renamer(AstMapper):
    def __init__(self, renamer: Callable[[str], str]):
        self.renamer = renamer

    def visit_typed_name(self, node: ast.TypedName):
        return ast.TypedName(self.renamer(node.name), node.type)

    def visit_identifier(self, node: ast.Identifier):
        return ast.Identifier(name=self.renamer(node.name))

    def visit_function_definition(self, node: ast.FunctionDefinition):
        return ast.FunctionDefinition(
            name=self.renamer(node.name),
            parameters=[self.visit(x) for x in node.parameters],
            return_variables=[self.visit(x) for x in node.return_variables],
            body=self.visit(node.body),
        )


class MangleNamesVisitor(Renamer):
    def __init__(self):
        super().__init__(mangle)
