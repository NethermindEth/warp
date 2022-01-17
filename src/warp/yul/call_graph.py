from __future__ import annotations

from typing import Dict, Optional, Tuple

import warp.yul.ast as ast
from warp.yul.AstVisitor import AstVisitor

CallGraph = Dict[ast.FunctionDefinition, Tuple[ast.FunctionDefinition]]


class CallGraphBuilder(AstVisitor):
    def __init__(self):
        super().__init__()
        # ↓ using second dict instead of set to preserve order
        self.callgraph: dict[ast.FunctionDefinition, dict[str, None]] = {}
        self.last_function: Optional[ast.FunctionDefinition] = None

    def gather(self, block: ast.Block) -> CallGraph:
        self.visit(block)
        return _cleanup_callgraph(self.callgraph)

    def visit_function_call(self, node: ast.FunctionCall):
        self.callgraph[self.last_function][node.function_name.name] = None
        self.common_visit(node)

    def visit_function_definition(self, node: ast.FunctionDefinition):
        self.last_function = node
        self.callgraph[node] = {}
        self.common_visit(node)


def _cleanup_callgraph(
    callgraph: dict[ast.FunctionDefinition, dict[str, None]]
) -> CallGraph:
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


def build_callgraph(block: ast.Block) -> CallGraph:
    return CallGraphBuilder().gather(block)
