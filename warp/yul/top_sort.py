from __future__ import annotations

from typing import Optional

import yul.yul_ast as ast
from yul.yul_ast import AstVisitor


class CallGraphBuilder(AstVisitor):
    def __init__(self):
        super().__init__()
        # ↓ using second dict instead of set to preserve order
        self.callgraph: dict[ast.FunctionDefinition, dict[str, None]] = {}
        self.last_function: Optional[ast.FunctionDefinition] = None

    def gather(self, block: ast.Block) -> dict[ast.FunctionDefinition, dict[str, None]]:
        self.visit(block)
        return self.callgraph

    def visit_function_call(self, node: ast.FunctionCall):
        self.callgraph[self.last_function][node.function_name.name] = None
        self.common_visit(node)

    def visit_function_definition(self, node: ast.FunctionDefinition):
        self.last_function = node
        self.callgraph[node] = {}
        self.common_visit(node)


def top_sort_ast(block: ast.Block) -> ast.Block:
    callgraph = cleanup_callgraph(CallGraphBuilder().gather(block))
    fun_stmts = [
        stmt for stmt in block.statements if isinstance(stmt, ast.FunctionDefinition)
    ]
    other_stmts = [
        stmt
        for stmt in block.statements
        if not isinstance(stmt, ast.FunctionDefinition)
    ]
    # ↓ using dict instead of set to preserve order
    unmarked: dict[ast.FunctionDefinition, bool] = dict.fromkeys(fun_stmts)
    ordered: list[ast.FunctionDefinition] = []

    def dfs(node: ast.FunctionDefinition):
        if node not in unmarked:
            return
        del unmarked[node]
        for child in callgraph.get(node, tuple()):
            dfs(child)
        ordered.append(node)

    while unmarked:
        node = next(iter(unmarked))
        dfs(node)

    return ast.Block((*ordered, *other_stmts))


def cleanup_callgraph(
    callgraph: dict[ast.FunctionDefinition, dict[str, None]]
) -> dict[ast.FunctionDefinition, tuple[ast.FunctionDefinition]]:
    defined: dict[str, ast.FunctionDefinition] = {
        fun.name: fun for fun in callgraph.keys()
    }
    return {
        fun: tuple(
            defined[call]
            for call in calls.keys()
            if call in defined and call != fun.name
        )
        for (fun, calls) in callgraph.items()
    }
