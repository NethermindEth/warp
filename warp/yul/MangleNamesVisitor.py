import yul.yul_ast as ast
from yul.AstMapper import AstMapper

CAIRO_KEYWORDS = {"ret", "felt", "jmp", "func", "end"}


def mangle(identifier: str) -> str:
    identifier = identifier.replace("$", "_")
    if identifier in CAIRO_KEYWORDS:
        return identifier + "__warp_mangled"
    else:
        return identifier


class MangleNamesVisitor(AstMapper):
    def visit_typed_name(self, node: ast.TypedName):
        return ast.TypedName(mangle(node.name), node.type)

    def visit_identifier(self, node: ast.Identifier):
        return ast.Identifier(name=mangle(node.name))

    def visit_function_definition(self, node: ast.FunctionDefinition):
        return ast.FunctionDefinition(
            name=mangle(node.name),
            parameters=[self.visit(x) for x in node.parameters],
            return_variables=[self.visit(x) for x in node.return_variables],
            body=self.visit(node.body),
        )
