from __future__ import annotations

from contextlib import contextmanager
from functools import lru_cache
from typing import Optional

import warp.yul.ast as ast
from warp.yul.AstMapper import AstMapper
from warp.yul.extract_block import extract_block_as_function
from warp.yul.NameGenerator import NameGenerator
from warp.yul.Scope import get_scope


class ScopeFlattener(AstMapper):
    def __init__(self, name_gen: NameGenerator):
        super().__init__()
        self.name_gen = name_gen
        self.block_functions: list[ast.FunctionDefinition] = []
        self.leave_name: Optional[str] = None
        self.pass_leaves_higher = False

    def map(self, node: ast.Node, **kwargs) -> ast.Node:
        if not isinstance(node, ast.Block):
            return self.visit(node)
        all_statements = []
        statements = node.statements
        while statements:
            all_statements.extend(self.visit_list(statements))
            statements = self.block_functions
            self.block_functions = []
        return ast.Block(tuple(all_statements))

    def visit_block(self, node: ast.Block, inline: bool = False) -> ast.Block:
        if inline or not get_scope(node).bound_variables:
            stmts = []
            for stmt in node.statements:
                new_stmt = self.visit(stmt)
                if isinstance(new_stmt, ast.Block):
                    stmts.extend(new_stmt.statements)
                else:
                    stmts.append(new_stmt)
            return ast.Block(tuple(stmts))

        with self._new_extraction():
            fun_name = self.name_gen.make_block_name()
            node = super().visit_block(node)
            block_fun, block_stmt = extract_block_as_function(node, fun_name)
            self.block_functions.append(block_fun)
            leave_id = ast.Identifier(self.leave_name)
            if leave_id not in get_scope(node).modified_variables:
                stmts = (block_stmt,)
            elif _is_leave(block_fun.body):
                stmts = (block_stmt, ast.LEAVE)
            else:
                stmts = (block_stmt, ast.If(condition=leave_id, body=ast.LEAVE_BLOCK))
            return ast.Block(stmts)

    def visit_function_definition(self, node: ast.FunctionDefinition):
        # We do not want to flatten an if-block if it is the only statement in
        # the function body. Skip visit_if in such cases and instead visit all
        # the branches of the if-block.

        with self._new_function():
            if len(node.body.statements) == 1 and isinstance(
                node.body.statements[0], ast.If
            ):
                if_stmt = node.body.statements[0]
                if_body = self.visit_block(if_stmt.body, inline=True)
                if_else_body = None
                if if_stmt.else_body:
                    if_else_body = self.visit_block(if_stmt.else_body, inline=True)
                body = ast.Block((ast.If(if_stmt.condition, if_body, if_else_body),))
            else:
                body = self.visit(node.body, inline=True)
            leave_id = ast.Identifier(self.leave_name)
            if leave_id in get_scope(body).modified_variables:
                leave_var_decl = ast.VariableDeclaration(
                    [ast.TypedName(self.leave_name)], ast.Literal(False)
                )
                body = ast.Block((leave_var_decl, *body.statements))
            uninitialized_return_vars: list[ast.TypedName] = []
            params_set: set[str] = {x.name for x in node.parameters}
            for v in node.return_variables:
                v_id = ast.Identifier(v.name)
                if v_id in get_scope(body).read_variables and v.name not in params_set:
                    uninitialized_return_vars.append(v)
            if uninitialized_return_vars:
                init = ast.VariableDeclaration(uninitialized_return_vars, value=None)
                body = ast.Block((init, *body.statements))
            return ast.FunctionDefinition(
                name=node.name,
                parameters=self.visit_list(node.parameters),
                return_variables=self.visit_list(node.return_variables),
                body=body,
            )

    def visit_if(self, node: ast.If):
        with self._new_extraction():
            visited_if = super().visit_if(node)
            if self.is_leave_if(visited_if) or self.is_revert_if(visited_if):
                return visited_if
            fun_name = self.name_gen.make_if_name()
            if_block = ast.Block((visited_if,))
            if_fun, if_stmt = extract_block_as_function(if_block, fun_name)
            self.block_functions.append(if_fun)
            leave_id = ast.Identifier(self.leave_name)
            if leave_id in get_scope(if_block).modified_variables:
                stmts = (if_stmt, ast.If(condition=leave_id, body=ast.LEAVE_BLOCK))
            else:
                stmts = (if_stmt,)
            return ast.Block(stmts)

    def visit_leave(self, node: ast.Leave):
        if not self.pass_leaves_higher:
            return node
        else:
            leave_var_assign = ast.Assignment(
                [ast.Identifier(self.leave_name)], ast.Literal(True)
            )
            return ast.Block((leave_var_assign, ast.LEAVE))

    def is_revert_if(self, node: ast.If):
        return _is_revert(node.body) or _is_revert(node.else_body)

    def is_leave_if(self, node: ast.If):
        return _is_leave(node.body) or _is_leave(node.else_body)

    @contextmanager
    def _new_function(self):
        old_leave_name = self.leave_name
        self.leave_name = self.name_gen.make_leave_name()
        try:
            yield None
        finally:
            self.leave_name = old_leave_name

    @contextmanager
    def _new_extraction(self):
        old_pass_leaves_higher = self.pass_leaves_higher
        self.pass_leaves_higher = True
        try:
            yield None
        finally:
            self.pass_leaves_higher = old_pass_leaves_higher


@lru_cache()
def _is_leave(node: Optional[ast.Node]) -> bool:
    if isinstance(node, ast.Block):
        return any(_is_leave(x) for x in node.statements)
    elif isinstance(node, ast.If):
        return _is_leave(node.body) and _is_leave(node.else_body)
    elif isinstance(node, ast.Leave):
        return True
    else:
        return False


def _is_revert(node: Optional[ast.Node]) -> bool:
    if isinstance(node, ast.FunctionCall):
        return node.function_name.name == "revert"
    if isinstance(node, ast.ExpressionStatement):
        return _is_revert(node.expression)
    if isinstance(node, ast.Block):
        # if any statement is a revert, it's safe to not extract this
        # node
        return any(_is_revert(x) for x in node.statements)
    return False
