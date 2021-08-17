import dataclasses
from typing import Callable, List, Optional

from starkware.cairo.lang.compiler.ast.cairo_types import CairoType, CastType
from starkware.cairo.lang.compiler.ast.code_elements import (
    CodeBlock, CodeElement, CodeElementAllocLocals, CodeElementCompoundAssertEq, CodeElementConst,
    CodeElementIf, CodeElementInstruction, CodeElementLocalVariable, CodeElementReference,
    CodeElementStaticAssert, CodeElementUnpackBinding, CodeElementWith, CommentedCodeElement)
from starkware.cairo.lang.compiler.ast.expr import ExprCast, ExprConst, ExprIdentifier
from starkware.cairo.lang.compiler.ast.instructions import AddApInstruction, InstructionAst
from starkware.cairo.lang.compiler.error_handling import Location
from starkware.cairo.lang.compiler.expression_transformer import ExpressionTransformer
from starkware.cairo.lang.compiler.identifier_definition import StructDefinition
from starkware.cairo.lang.compiler.instruction import Register
from starkware.cairo.lang.compiler.preprocessor.preprocessor_error import PreprocessorError
from starkware.cairo.lang.compiler.preprocessor.preprocessor_utils import assert_no_modifier
from starkware.cairo.lang.compiler.references import create_simple_ref_expr
from starkware.cairo.lang.compiler.scoped_name import ScopedName

N_LOCALS_CONSTANT = 'SIZEOF_LOCALS'


class NLocalsUsedVisitor(ExpressionTransformer):
    """
    Tracks the usage of the SIZEOF_LOCALS constant in expressions.
    """

    def __init__(self):
        self.saw_n_locals_const = False

    def visit_ExprIdentifier(self, expr: ExprIdentifier):
        if expr.name == N_LOCALS_CONSTANT:
            self.saw_n_locals_const = True
        return super().visit_ExprIdentifier(expr)


class LocalVariableHandler:
    """
    Helper visitor for preprocess_local_variables().
    Each instance can only be used to process one scope.
    """

    def __init__(
            self,
            new_unique_id_callback: Callable[[], str],
            get_size_callback: Callable[[CairoType], int],
            get_unpacking_struct_definition_callback: Callable[
                [CodeElementUnpackBinding], StructDefinition]):
        # The size of the local variables in this scope.
        self.local_vars_size: int = 0

        # The location of the first local instruction.
        self.first_location: Optional[Location] = None

        self.n_locals_used_visitor = NLocalsUsedVisitor()

        self.new_unique_id_callback = new_unique_id_callback
        self.get_size_callback = get_size_callback
        self.get_unpacking_struct_definition_callback = get_unpacking_struct_definition_callback

    def alloc_unique_id(self) -> str:
        return self.new_unique_id_callback()

    def visit(self, obj):
        funcname = f'visit_{type(obj).__name__}'
        if hasattr(self, funcname):
            return getattr(self, funcname)(obj)
        else:
            return [obj]

    def visit_CodeElementIf(self, obj: CodeElementIf):
        obj = dataclasses.replace(obj, main_code_block=self.visit(obj.main_code_block))
        if obj.else_code_block is not None:
            obj = dataclasses.replace(
                obj, else_code_block=self.visit(obj.else_code_block))
        return [obj]

    def visit_CodeBlock(self, obj: CodeBlock):
        res = []
        for code_element in obj.code_elements:
            res += self.visit(code_element.code_elm)
        return dataclasses.replace(
            obj,
            code_elements=[CommentedCodeElement(
                code_elm=code_elm, comment=None
            ) for code_elm in res])

    def visit_CodeElementStaticAssert(self, elm: CodeElementStaticAssert) -> List[CodeElement]:
        self.n_locals_used_visitor.visit(elm.a)
        self.n_locals_used_visitor.visit(elm.b)
        return [elm]

    def visit_CodeElementInstruction(self, elm: CodeElementInstruction) -> List[CodeElement]:
        self.visit(elm.instruction.body)
        return [elm]

    def visit_AddApInstruction(self, elm: AddApInstruction):
        self.n_locals_used_visitor.visit(elm.expr)

    def visit_CodeElementAllocLocals(self, elm: CodeElementAllocLocals) -> List[CodeElement]:
        location = elm.location
        # Replace alloc_locals with the instruction "ap += SIZEOF_LOCALS".
        new_elm = CodeElementInstruction(
            instruction=InstructionAst(
                body=AddApInstruction(
                    expr=ExprIdentifier(name=N_LOCALS_CONSTANT, location=location),
                    location=location,
                ),
                inc_ap=False,
                location=location
            ),
        )
        # Return the original element so that the preprocessor can check that ap was not advanced.
        return [elm] + self.visit(new_elm)

    def visit_CodeElementLocalVariable(self, elm: CodeElementLocalVariable) -> List[CodeElement]:
        if self.first_location is None:
            self.first_location = elm.location

        assert_no_modifier(elm.typed_identifier)

        local_type = elm.typed_identifier.get_type()
        ref_expr = create_simple_ref_expr(
            reg=Register.FP,
            offset=self.local_vars_size,
            cairo_type=local_type,
            location=elm.typed_identifier.identifier.location,
        )

        result: List[CodeElement] = []
        if elm.expr is not None:
            result.append(CodeElementCompoundAssertEq(
                a=ref_expr,
                b=ExprCast(
                    expr=elm.expr, dest_type=local_type, cast_type=CastType.ASSIGN,
                    location=elm.expr.location),
                location=elm.location))

        result.append(
            CodeElementReference(
                typed_identifier=elm.typed_identifier,
                expr=ref_expr,
            ))

        self.local_vars_size += self.get_size_callback(local_type)
        return result

    def visit_CodeElementUnpackBinding(self, elm: CodeElementUnpackBinding):
        """
        Replaces
            let (local a : T, b) = foo()
        with
            let (tempvar : T , b) = foo
            local a : T = tempvar
        """

        result = []

        struct_def = self.get_unpacking_struct_definition_callback(elm)
        unpacking_identifiers = []
        for typed_identifier, member_def in zip(
                elm.unpacking_list.identifiers, struct_def.members.values()):
            if typed_identifier.modifier is None or typed_identifier.modifier.name != 'local':
                unpacking_identifiers.append(typed_identifier)
                continue

            # typed_identifier has the "local" modifier.

            # Add type if missing.
            if typed_identifier.expr_type is None:
                typed_identifier = dataclasses.replace(
                    typed_identifier, expr_type=member_def.cairo_type)

            temp_ref = dataclasses.replace(
                typed_identifier,
                identifier=ExprIdentifier(name=self.alloc_unique_id()),
                modifier=None)
            unpacking_identifiers.append(temp_ref)

            result.extend(self.visit(CodeElementLocalVariable(
                typed_identifier=typed_identifier.strip_modifier(),
                expr=temp_ref.identifier,
                location=typed_identifier.location,
            )))

        result.insert(0, dataclasses.replace(
            elm, unpacking_list=dataclasses.replace(
                elm.unpacking_list, identifiers=unpacking_identifiers)))

        return result

    def visit_CodeElementWith(self, elm: CodeElementWith):
        return [dataclasses.replace(elm, code_block=self.visit(elm.code_block))]


def preprocess_local_variables(
        code_elements: List[CodeElement], scope: ScopedName,
        new_unique_id_callback: Callable[[], str],
        get_size_callback: Callable[[CairoType], int],
        get_unpacking_struct_definition_callback: Callable[
            [CodeElementUnpackBinding], StructDefinition],
        default_location: Optional[Location]) -> List[CodeElement]:
    """
    Preprocesses the local variables of one function.
    new_unique_id_callback is a callback that allocates a unique identifier.
    get_size_callback is a callback that takes a CairoType and returns its size.
    """
    handler = LocalVariableHandler(
        new_unique_id_callback=new_unique_id_callback,
        get_size_callback=get_size_callback,
        get_unpacking_struct_definition_callback=get_unpacking_struct_definition_callback)
    result = []
    for elm in code_elements:
        result += handler.visit(elm)

    n_locals_code_element = CodeElementConst(
        identifier=ExprIdentifier(name=N_LOCALS_CONSTANT, location=default_location),
        expr=ExprConst(val=handler.local_vars_size, location=default_location))

    if handler.local_vars_size > 0 and not handler.n_locals_used_visitor.saw_n_locals_const:
        raise PreprocessorError(
            'A function with local variables must use alloc_locals.',
            location=handler.first_location)

    result.insert(0, n_locals_code_element)
    return result
