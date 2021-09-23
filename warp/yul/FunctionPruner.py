from __future__ import annotations

import yul.yul_ast as ast
from yul.AstMapper import AstMapper
from yul.top_sort import CallGraphBuilder, cleanup_callgraph


class FunctionPruner(AstMapper):
    def __init__(self, public_functions: list[str]):
        super().__init__()
        self.public_functions: set[str] = public_functions
        self.callgraph: dict[ast.FunctionDefinition, tuple[ast.FunctionDefinition]] = {}
        self.visited_functions: set[str] = set()

    def map(self, node: ast.Node, *args, **kwargs) -> ast.Node:
        if not isinstance(node, ast.Block):
            return self.visit(node)
        
        self.callgraph = cleanup_callgraph(CallGraphBuilder().gather(node))
        
        for function in self.callgraph:
            f_name = function.name
            if f_name in self.public_functions or "ENTRY_POINT" in f_name:
                if not f_name in self.visited_functions:
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
        self.visited_functions.add(function.name)

        for f in self.callgraph[function]:
            if not f.name in self.visited_functions:
                self._dfs(f)
        
    def _is_unused_function(self, node):
        return (
            isinstance(node, ast.FunctionDefinition) and 
            not node.name in self.visited_functions
        )