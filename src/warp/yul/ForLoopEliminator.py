from __future__ import annotations

from contextlib import contextmanager
from typing import List, Optional

import warp.yul.ast as ast
from warp.yul.ast import yul_log_not
from warp.yul.AstMapper import AstMapper
from warp.yul.extract_block import (
    extract_block_as_function,
    extract_rec_block_as_function,
)
from warp.yul.NameGenerator import NameGenerator
from warp.yul.Scope import get_scope


class ForLoopEliminator(AstMapper):
    """This class removes for-loops from Yul AST. Loops are replaced by
    recursive functions.

    Furthermore, it replaces breaks and continues with leaves.
    "breaking" from a loop requires an additional condition variable.

    """

    def __init__(self, name_gen: NameGenerator):
        super().__init__()
        self.name_gen = name_gen
        self.body_name: Optional[str] = None
        self.loop_name: Optional[str] = None
        self.break_name: Optional[str] = None
        self.leave_name: Optional[str] = None
        self.has_leave: bool = False
        self.aux_functions: List[ast.FunctionDefinition] = []

    def map(self, node: ast.Node, **kwargs):
        if not isinstance(node, ast.Block):
            return self.visit(node)

        block = self.visit(node)
        return ast.Block(block.statements + tuple(self.aux_functions))

    def visit_for_loop(self, node: ast.ForLoop):
        assert not node.pre.statements, "Loop not simplified"

        with self._new_for_loop():
            assert self.loop_name and self.body_name
            assert self.leave_name and self.break_name

            body = self.visit(node.body)
            post = self.visit(node.post)
            body_fun, body_stmt = extract_block_as_function(
                body, self.body_name, has_leave=self.has_leave
            )

            rec_loop_head = lambda rec: self._make_loop_head(
                node.condition, body_stmt, post.statements, rec
            )
            head_fun, head_stmt = extract_rec_block_as_function(
                rec_loop_head,
                self.loop_name,
                has_leave=True,
                # ↑ we leave if the loop condition is not satisified
            )
            self.aux_functions.extend((body_fun, head_fun))

            leave_id = ast.Identifier(self.leave_name)
            call_statements: ast.Statements
            if leave_id not in get_scope(body).modified_variables:
                call_statements = (head_stmt,)
            else:
                call_statements = (
                    ast.VariableDeclaration(
                        variables=[ast.TypedName(self.leave_name)],
                        value=ast.Literal(False),
                    ),
                    head_stmt,
                    ast.If(condition=leave_id, body=ast.LEAVE_BLOCK),
                )

            return ast.Block(call_statements)

    def visit_break(self, node: ast.Break):
        assert self.break_name
        self.has_leave = True
        return ast.Block(
            (
                ast.Assignment(
                    variable_names=[ast.Identifier(self.break_name)],
                    value=ast.Literal(True),
                ),
                ast.LEAVE,
            )
        )

    def visit_continue(self, node: ast.Continue):
        self.has_leave = True
        return ast.LEAVE

    def visit_leave(self, node: ast.Leave):
        self.has_leave = True
        if not self.leave_name:  # not in a loop
            return node
        return ast.Block(
            (
                ast.Assignment(
                    variable_names=[ast.Identifier(self.leave_name)],
                    value=ast.Literal(True),
                ),
                ast.LEAVE,
            )
        )

    @contextmanager
    def _new_for_loop(self):
        old_names = (self.body_name, self.loop_name, self.break_name, self.leave_name)
        (
            self.loop_name,
            self.body_name,
            self.break_name,
        ) = self.name_gen.make_loop_names()
        self.leave_name = self.name_gen.make_leave_name()
        old_has_leave = self.has_leave
        self.has_leave = False
        try:
            yield None
        finally:
            self.body_name, self.loop_name, self.break_name, self.leave_name = old_names
            self.has_leave = old_has_leave

    def _make_loop_head(
        self,
        condition: ast.Expression,
        body_stmt: ast.Statement,
        post_stmts: list[ast.Statement],
        rec: ast.Statement,
    ) -> ast.Block:
        assert self.break_name and self.leave_name
        break_id = ast.Identifier(self.break_name)
        leave_id = ast.Identifier(self.leave_name)
        modified_vars = get_scope(ast.Block((body_stmt,))).modified_variables
        head_stmts: list[ast.Statement] = []
        if break_id in modified_vars:
            head_stmts.append(
                ast.VariableDeclaration(
                    variables=[ast.TypedName(self.break_name)], value=ast.Literal(False)
                )
            )
        head_stmts.append(ast.If(yul_log_not(condition), ast.LEAVE_BLOCK))
        head_stmts.append(body_stmt)
        if break_id in modified_vars:
            head_stmts.append(ast.If(condition=break_id, body=ast.LEAVE_BLOCK))
        if leave_id in modified_vars:
            head_stmts.append(ast.If(condition=leave_id, body=ast.LEAVE_BLOCK))
        head_stmts += post_stmts
        head_stmts.append(rec)
        return ast.Block(tuple(head_stmts))
