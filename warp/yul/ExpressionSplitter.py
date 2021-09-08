from __future__ import annotations
from contextlib import contextmanager
from dataclasses import dataclass
from typing import Optional

import yul.yul_ast as ast
from yul.AstMapper import AstMapper


@dataclass
class BlockEnv:
    split_stmt: Optional[ast.VariableDeclaration] = None
    split_stmt_count: int = 0

    def process_subexpr(self, call: ast.FunctionCall) -> str:
        name = f"__warp_subexpr_{self.split_stmt_count}"
        self.split_stmt = ast.VariableDeclaration(
            variables=[ast.TypedName(name)], value=call
        )
        return name


class ExpressionSplitter(AstMapper):
    def __init__(self):
        super().__init__()
        self.block_env_stack: list[BlockEnv] = []

    def visit_function_call(self, node: ast.FunctionCall):
        if len(self.path) == 1:  # no parent
            return ast.FunctionCall(node.function_name, self.visit_list(node.arguments))
        parent = self.path[-2]
        if isinstance(
            parent, (ast.Assignment, ast.VariableDeclaration, ast.ExpressionStatement)
        ):
            return ast.FunctionCall(node.function_name, self.visit_list(node.arguments))
        var_name = self.block_env_stack[-1].process_subexpr(node)
        return ast.Identifier(var_name)

    def visit_block(self, node: ast.Block):
        with self._new_block_env() as env:
            new_stmts = []
            for stmt in node.statements:
                new_stmt = self.visit(stmt)
                split_stmts = [new_stmt]  # in the reverse order of declaration
                while env.split_stmt:
                    split_stmt = env.split_stmt
                    env.split_stmt = None
                    split_stmts.append(self.visit(split_stmt))
                split_stmts.reverse()
                new_stmts.extend(split_stmts)
            return ast.Block(tuple(new_stmts))

    @contextmanager
    def _new_block_env(self) -> BlockEnv:
        env = BlockEnv()
        self.block_env_stack.append(env)
        try:
            yield env
        finally:
            self.block_env_stack.pop()
