from __future__ import annotations

from typing import Callable

import warp.yul.ast as ast
from warp.yul.Scope import get_scope


def extract_block_as_function(
    block: ast.Block, name: str, has_leave: bool = False
) -> tuple[ast.FunctionDefinition, ast.Statement]:
    read_vars = get_scope(block).read_variables
    if has_leave:
        # If there is a leave in the block, some subset of modified
        # variables will also be read at the time of "leaving". We
        # play safe and mark all of the modified variables as read. An
        # opportunity of optimization.
        read_vars |= get_scope(block).modified_variables
    read_vars = sorted(read_vars)
    mod_vars = sorted(get_scope(block).modified_variables)
    typed_read_vars = [ast.TypedName(x.name) for x in read_vars]
    typed_mod_vars = [ast.TypedName(x.name) for x in mod_vars]
    fun_def = ast.FunctionDefinition(
        name=name,
        parameters=typed_read_vars,
        return_variables=typed_mod_vars,
        body=block,
    )
    fun_call = ast.FunctionCall(ast.Identifier(name), read_vars)
    if mod_vars:
        fun_stmt = ast.Assignment(variable_names=mod_vars, value=fun_call)
    else:
        fun_stmt = ast.ExpressionStatement(fun_call)
    return fun_def, fun_stmt


DUMMY_CALL = ast.ExpressionStatement(
    ast.FunctionCall(ast.Identifier("__WARP_DUMMY"), [])
)


def extract_rec_block_as_function(
    rec_block: Callable[[ast.Statement], ast.Block], name: str, has_leave: bool = False
) -> tuple[ast.FunctionDefinition, ast.Statement]:
    stubbed_body = rec_block(DUMMY_CALL)
    read_vars = get_scope(stubbed_body).read_variables
    if has_leave:
        # If there is a leave in the block, some subset of modified
        # variables will also be read at the time of "leaving". We
        # play safe and mark all of the modified variables as read. An
        # opportunity of optimization.
        read_vars |= get_scope(stubbed_body).modified_variables
    read_vars = sorted(read_vars)
    mod_vars = sorted(get_scope(stubbed_body).modified_variables)
    typed_read_vars = [ast.TypedName(x.name) for x in read_vars]
    typed_mod_vars = [ast.TypedName(x.name) for x in mod_vars]
    fun_call = ast.FunctionCall(ast.Identifier(name), read_vars)
    if mod_vars:
        fun_stmt = ast.Assignment(variable_names=mod_vars, value=fun_call)
    else:
        fun_stmt = ast.ExpressionStatement(fun_call)
    real_body = rec_block(fun_stmt)
    fun_def = ast.FunctionDefinition(
        name=name,
        parameters=typed_read_vars,
        return_variables=typed_mod_vars,
        body=real_body,
    )
    return fun_def, fun_stmt
