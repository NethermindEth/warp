from __future__ import annotations

import warp.yul.ast as ast
from warp.yul.call_graph import build_callgraph


def top_sort_ast(block: ast.Block) -> ast.Block:
    callgraph = build_callgraph(block)
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
