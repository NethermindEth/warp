from __future__ import annotations

import yul.yul_ast as ast
from yul.AstMapper import AstMapper
from yul.call_graph import CallGraph, build_callgraph


class FunctionPruner(AstMapper):
    def __init__(self, public_functions: list[str]):
        super().__init__()
        self.public_functions: frozenset[str] = frozenset(public_functions)
        self.callgraph: CallGraph = {}
        self.visited_functions: set[str] = set()

    def map(self, node: ast.Node, *args, **kwargs) -> ast.Node:
        if not isinstance(node, ast.Block):
            return self.visit(node, *args, **kwargs)

        self.callgraph = build_callgraph(node)
        for function in self.callgraph:
            f_name = function.name
            if (
                f_name in self.public_functions
                or f_name == "fun_ENTRY_POINT"
                or "warp_constructor" in f_name
            ):
                self._dfs(function)

        return self.visit(node, *args, **kwargs)

    def visit_block(self, node: ast.Block):
        statements = []
        for stmt in node.statements:
            if self._is_unused_function(stmt):
                continue
            statements.append(self.visit(stmt))

        return ast.Block(statements=tuple(statements))

    def _dfs(self, function: ast.FunctionDefinition):
        if function.name in self.visited_functions:
            return

        self.visited_functions.add(function.name)
        for f in self.callgraph[function]:
            self._dfs(f)

    def _is_unused_function(self, node):
        return (
            isinstance(node, ast.FunctionDefinition)
            and node.name not in self.visited_functions
            and "constructor" not in node.name
            and "setter" not in node.name
            and "getter" not in node.name
        )
