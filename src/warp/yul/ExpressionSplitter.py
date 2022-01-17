from __future__ import annotations

from contextlib import contextmanager
from dataclasses import dataclass
from typing import Optional

import warp.yul.ast as ast
from warp.yul.AstMapper import AstMapper
from warp.yul.NameGenerator import NameGenerator


@dataclass
class BlockEnv:
    def __init__(self, name_gen: NameGenerator):
        self.name_gen = name_gen
        self.split_stmts: list[ast.VariableDeclaration] = []

    def process_subexpr(self, call: ast.FunctionCall) -> str:
        name = self.name_gen.make_subexpr_name()
        self.split_stmts.append(
            ast.VariableDeclaration(variables=[ast.TypedName(name)], value=call)
        )
        return name


class ExpressionSplitter(AstMapper):
    def __init__(self, name_gen: NameGenerator):
        super().__init__()
        self.name_gen = name_gen
        self.env: Optional[BlockEnv] = None

    def visit_function_call(self, node: ast.FunctionCall):
        assert self.env
        if len(self.path) == 1:  # no parent
            return ast.FunctionCall(node.function_name, self.visit_list(node.arguments))
        parent = self.path[-2]
        if isinstance(
            parent, (ast.Assignment, ast.VariableDeclaration, ast.ExpressionStatement)
        ):
            return ast.FunctionCall(node.function_name, self.visit_list(node.arguments))
        var_name = self.env.process_subexpr(node)
        return ast.Identifier(var_name)

    def visit_block(self, node: ast.Block):
        with self._new_block():
            assert self.env
            new_stmts = []
            for stmt in node.statements:
                new_stmt = self.visit(stmt)
                split_stmts = [new_stmt]  # in the reverse order of declaration
                while self.env.split_stmts:
                    new_split_stmts = self.env.split_stmts
                    self.env.split_stmts = []
                    split_stmts.extend(self.visit_list(new_split_stmts))
                split_stmts.reverse()
                new_stmts.extend(split_stmts)
            return ast.Block(tuple(new_stmts))

    @contextmanager
    def _new_block(self):
        with self.name_gen.new_block():
            old_env = self.env
            self.env = BlockEnv(self.name_gen)
            try:
                yield None
            finally:
                self.env = old_env
