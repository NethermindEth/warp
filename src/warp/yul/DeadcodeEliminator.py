from contextlib import contextmanager
from functools import reduce
from typing import FrozenSet, List, Sequence, Set, Tuple, TypeVar, Union

import warp.yul.ast as ast
from warp.yul.AstMapper import AstMapper

LiveVars = FrozenSet[str]

fset = frozenset

NodeCategory = TypeVar("NodeCategory", ast.Expression, ast.Statement)


class DeadcodeEliminator(AstMapper):
    """This class removes any unused variale assignments.

    While this functionality is completely generalisable it
    requires the following passes to be used before it:

    - SwitchToIfVisitor
    - ForLoopIliminator
    """

    def __init__(self):
        self.return_vars: FrozenSet[str] = fset()
        self.live_vars: FrozenSet[str] = fset()

    def map(self, node: ast.Node, **kwargs) -> ast.Node:
        (vs, node) = self.visit(node)
        assert not vs, "There should be no uninstantiated variables in the top scope."
        return node

    def visit_list(
        self, nodes: Sequence[NodeCategory], *args, **kwargs
    ) -> Tuple[LiveVars, Tuple[NodeCategory, ...]]:
        if len(nodes) == 0:
            return (fset(), ())
        lis = [self.visit(x, *args, **kwargs) for x in nodes]
        var_set, nodes = map(list, zip(*lis))
        live_vars = reduce(lambda s1, s2: s1 | s2, var_set, fset())
        return (live_vars, nodes)

    def visit_literal(self, node: ast.Literal) -> Tuple[LiveVars, ast.Literal]:
        return (fset(), node)

    def visit_identifier(self, node: ast.Identifier) -> Tuple[LiveVars, ast.Identifier]:
        return (fset({node.name}), node)

    def visit_typed_name(self, node: ast.TypedName) -> Tuple[LiveVars, ast.TypedName]:
        return (fset({node.name}), node)

    def visit_function_call(
        self, node: ast.FunctionCall
    ) -> Tuple[LiveVars, ast.FunctionCall]:
        (live_vars, arguments) = self.visit_list(node.arguments)
        return (
            live_vars,
            ast.FunctionCall(
                function_name=node.function_name, arguments=list(arguments)
            ),
        )

    def visit_expression_statement(
        self, node: ast.ExpressionStatement
    ) -> Tuple[LiveVars, ast.ExpressionStatement]:
        (live_vars, _) = self.visit(node.expression)
        return (live_vars, node)

    def visit_assignment(self, node: ast.Assignment) -> Tuple[LiveVars, ast.Assignment]:
        (live_vars, _) = self.visit(node.value)
        return (live_vars, node)

    def visit_variable_declaration(
        self, node: ast.VariableDeclaration
    ) -> Tuple[LiveVars, ast.VariableDeclaration]:
        if node.value is None:
            return (fset(), node)
        (live_vars, _) = self.visit(node.value)
        return (live_vars, node)

    def visit_function_definition(
        self, node: ast.FunctionDefinition
    ) -> Tuple[LiveVars, ast.FunctionDefinition]:
        return_variables = fset({n.name for n in node.return_variables})
        with self._new_function(return_variables):
            (live_vars, body) = self.visit(node.body)
            live_vars -= fset({arg.name for arg in node.parameters})
            return (
                live_vars,
                ast.FunctionDefinition(
                    name=node.name,
                    parameters=node.parameters,
                    return_variables=node.return_variables,
                    body=body,
                ),
            )

    def visit_if(self, node: ast.If) -> Tuple[LiveVars, ast.If]:
        (live_vars_cond, cond) = self.visit(node.condition)
        (live_vars_body, body) = self.visit_block(node.body)
        (live_vars_else, else_body) = (
            self.visit_block(node.else_body) if node.else_body else (fset(), None)
        )
        return (
            live_vars_cond | live_vars_body | live_vars_else,
            ast.If(condition=cond, body=body, else_body=else_body),
        )

    def visit_switch(self, node: ast.Switch) -> Tuple[LiveVars, ast.Switch]:
        # TODO: Implement these so we can run DeadCodeEliminator at any stage
        assert False, "There should be no switches, run SwitchToIfVisitor first"

    def visit_forloop(self, node: ast.ForLoop) -> Tuple[LiveVars, ast.ForLoop]:
        # TODO: Implement these so we can run DeadCodeEliminator at any stage
        assert False, "There should be no for loops, run ForLoopIliminator first"

    def visit_break(self, node: ast.Break) -> Tuple[LiveVars, ast.Break]:
        # TODO: Implement these so we can run DeadCodeEliminator at any stage
        assert False, "There should be no breaks, run ForLoopIliminator first"
        return (fset(), node)

    def visit_continue(self, node: ast.Continue) -> Tuple[LiveVars, ast.Continue]:
        # TODO: Implement these so we can run DeadCodeEliminator at any stage
        assert False, "There should be no continues, run ForLoopIliminator first"
        return (fset(), node)

    def visit_leave(self, node: ast.Leave) -> Tuple[LiveVars, ast.Leave]:
        return (fset(), node)

    def visit_block(self, node: ast.Block) -> Tuple[LiveVars, ast.Block]:
        if not node.statements:
            return (fset(), node)

        live_vars = self.live_vars

        if any(isinstance(statement, ast.Leave) for statement in node.statements):
            live_vars |= self.return_vars

        statements = []
        for n in reversed(node.statements):
            keep = True
            with self._new_block(live_vars):
                (current_live_vars, statement) = self.visit(n)
                if isinstance(statement, (ast.Assignment, ast.VariableDeclaration)):
                    var_list = _get_variables(statement)
                    if not isinstance(statement.value, ast.FunctionCall):
                        # We under approximate for now, we keep the entire
                        # declaration if any of the declared variable is live.
                        keep = any(var in live_vars for var in var_list)
                    live_vars -= fset(var_list)
                if keep:
                    live_vars |= current_live_vars
                    statements.append(statement)
        statements.reverse()
        return (live_vars, ast.Block(tuple(statements)))

    @contextmanager
    def _new_function(self, return_vars):
        old_returns_vars = self.return_vars
        self.return_vars = return_vars
        try:
            yield None
        finally:
            self.return_vars = old_returns_vars

    @contextmanager
    def _new_block(self, live_vars):
        old_live_vars = self.live_vars
        self.live_vars = live_vars
        try:
            yield None
        finally:
            self.live_vars = old_live_vars


def _get_variables(node: Union[ast.Assignment, ast.VariableDeclaration]):
    if isinstance(node, ast.Assignment):
        return [n.name for n in node.variable_names]
    return [n.name for n in node.variables]
