import warp.yul.ast as ast
from warp.yul.AstVisitor import AstVisitor


class AstMapper(AstVisitor):
    def map(self, node: ast.Node, *args, **kwargs) -> ast.Node:
        return self.visit(node, *args, **kwargs)

    def visit_typed_name(self, node: ast.TypedName) -> ast.TypedName:
        return node

    def visit_literal(self, node: ast.Literal) -> ast.Literal:
        return node

    def visit_identifier(self, node: ast.Identifier) -> ast.Identifier:
        return node

    def visit_assignment(self, node: ast.Assignment) -> ast.Assignment:
        return ast.Assignment(
            variable_names=self.visit_list(node.variable_names),
            value=self.visit(node.value),
        )

    def visit_function_call(self, node: ast.FunctionCall) -> ast.FunctionCall:
        return ast.FunctionCall(
            function_name=self.visit(node.function_name),
            arguments=self.visit_list(node.arguments),
        )

    def visit_expression_statement(
        self, node: ast.ExpressionStatement
    ) -> ast.ExpressionStatement:
        return ast.ExpressionStatement(self.visit(node.expression))

    def visit_variable_declaration(
        self, node: ast.VariableDeclaration
    ) -> ast.VariableDeclaration:
        return ast.VariableDeclaration(
            variables=self.visit_list(node.variables),
            value=self.visit(node.value) if node.value is not None else None,
        )

    def visit_block(self, node: ast.Block) -> ast.Block:
        return ast.Block(tuple(self.visit_list(node.statements)))

    def visit_function_definition(
        self, node: ast.FunctionDefinition
    ) -> ast.FunctionDefinition:
        return ast.FunctionDefinition(
            name=node.name,
            parameters=self.visit_list(node.parameters),
            return_variables=self.visit_list(node.return_variables),
            body=self.visit(node.body),
        )

    def visit_if(self, node: ast.If) -> ast.If:
        return ast.If(
            condition=self.visit(node.condition),
            body=self.visit(node.body),
            else_body=self.visit(node.else_body)
            if node.else_body is not None
            else None,
        )

    def visit_case(self, node: ast.Case) -> ast.Case:
        return ast.Case(
            value=self.visit(node.value) if node.value is not None else None,
            body=self.visit(node.body),
        )

    def visit_switch(self, node: ast.Switch) -> ast.Switch:
        return ast.Switch(
            expression=self.visit(node.expression),
            cases=self.visit_list(node.cases),
        )

    def visit_for_loop(self, node: ast.ForLoop) -> ast.ForLoop:
        return ast.ForLoop(
            pre=self.visit(node.pre),
            condition=self.visit(node.condition),
            post=self.visit(node.post),
            body=self.visit(node.body),
        )

    def visit_break(self, node: ast.Break) -> ast.Break:
        return node

    def visit_continue(self, node: ast.Continue) -> ast.Continue:
        return node

    def visit_leave(self, node: ast.Leave) -> ast.Leave:
        return node
