from __future__ import annotations

import warp.yul.ast as ast
from warp.yul.AstMapper import AstMapper
from warp.yul.call_graph import CallGraph, build_callgraph


class FunctionPruner(AstMapper):
    def __init__(self):
        super().__init__()
        self.callgraph: CallGraph = {}
        self.visited_functions: set[str] = set()

    def map(self, node: ast.Node, *args, **kwargs) -> ast.Node:
        if not isinstance(node, ast.Block):
            return self.visit(node, *args, **kwargs)

        self.callgraph = build_callgraph(node)
        for function in self.callgraph:
            if function.name in ("__main_meat", "__constructor_meat"):
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
            and node.name != "__constructor_meat"
            and "setter" not in node.name
            and "getter" not in node.name
        )
