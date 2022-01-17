from __future__ import annotations

from typing import Optional

import warp.yul.ast as ast
from warp.yul.AstMapper import AstMapper


class SwitchToIfVisitor(AstMapper):
    def visit_switch(self, node: ast.Switch) -> ast.Block:
        return self.visit(
            ast.Block(
                (
                    ast.VariableDeclaration(
                        variables=[ast.TypedName("match_var")], value=node.expression
                    ),
                    switch_to_if(ast.Identifier("match_var"), node.cases),
                )
            )
        )


def switch_to_if(switch_var: ast.Identifier, cases: list[ast.Case]) -> ast.Block:
    res = switch_to_if_helper(switch_var, cases, case_no=0)
    assert res is not None
    return res


def switch_to_if_helper(
    switch_var: ast.Identifier, cases: list[ast.Case], case_no: int = 0
) -> Optional[ast.Block]:
    assert case_no <= len(cases)
    if case_no == len(cases):
        return None
    if cases[case_no].value is None:
        assert case_no == len(cases) - 1, "Default case should be the last one"
        return cases[case_no].body
    return ast.Block(
        (
            ast.If(
                condition=ast.FunctionCall(
                    function_name=ast.Identifier("eq"),
                    arguments=[switch_var, cases[case_no].value],
                ),
                body=cases[case_no].body,
                else_body=switch_to_if_helper(switch_var, cases, case_no + 1),
            ),
        )
    )
