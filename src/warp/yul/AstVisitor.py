from typing import Iterable

import warp.yul.ast as ast
from warp.yul.utils import snakify


def get_children(node: ast.Node) -> Iterable[ast.Node]:
    if isinstance(node, ast.Assignment):
        return node.variable_names + [node.value]
    elif isinstance(node, ast.FunctionCall):
        return node.arguments + [node.function_name]
    elif isinstance(node, ast.ExpressionStatement):
        return [node.expression]
    elif isinstance(node, ast.VariableDeclaration):
        return node.variables + ([] if node.value is None else [node.value])
    elif isinstance(node, ast.Block):
        return node.statements
    elif isinstance(node, ast.FunctionDefinition):
        return node.parameters + node.return_variables + [node.body]
    elif isinstance(node, ast.If):
        return [node.condition, node.body] + (
            [] if node.else_body is None else [node.else_body]
        )
    elif isinstance(node, ast.Case):
        return [node.value, node.body]
    elif isinstance(node, ast.Switch):
        return node.cases + [node.expression]
    elif isinstance(node, ast.ForLoop):
        return [node.pre, node.condition, node.post, node.body]
    else:
        return []


class AstVisitor:
    def __init__(self):
        self.path = []
        # ↑ path of nodes from the AST root down to the current node,
        # inclusively

        def path_decorator(method):
            def new_method(node, *args, **kwargs):
                self.path.append(node)
                res = method(node, *args, **kwargs)
                self.path.pop()
                return res

            return new_method

        for node_type in ast.NODE_TYPES:
            visitor_name = "visit_" + snakify(node_type.__name__)
            method = getattr(self, visitor_name, None)
            if method is None:
                method = self.common_visit
            setattr(self, visitor_name, path_decorator(method))

    def visit(self, node: ast.Node, *args, **kwargs):
        method_name = "visit_" + snakify(type(node).__name__)
        method = getattr(self, method_name, self.common_visit)
        return method(node, *args, **kwargs)

    def common_visit(self, node, *args, **kwargs):
        self.visit_list(get_children(node))

    def visit_list(self, nodes: Iterable[ast.Node], *args, **kwargs) -> list:
        return [self.visit(x, *args, **kwargs) for x in nodes]
