from fileinput import close
from starkware.cairo.lang.compiler.parser import parse_file
from starkware.cairo.lang.compiler.error_handling import LocationError
from starkware.cairo.lang.version import __version__
from starkware.cairo.lang.compiler.cairo_compile import (
    get_codes,
    cairo_compile_common,
    cairo_compile_add_common_args
)
from starkware.cairo.lang.compiler.ast.module import CairoFile, CairoModule
from starkware.cairo.lang.compiler.ast.visitor import Visitor
from starkware.cairo.lang.compiler.ast.code_elements import (
    CodeBlock,
    CodeElement,
    CodeElementFunction,
    CodeElementImport,
    CodeElementReturn,
    CodeElementUnpackBinding,
    CommentedCodeElement,
)
from starkware.cairo.lang.compiler.ast.expr import ExprIdentifier, ArgList, ExprAssignment
from starkware.cairo.lang.compiler.ast.arguments import IdentifierList
from starkware.cairo.lang.compiler.ast.notes import Notes
from starkware.cairo.lang.compiler.ast.rvalue import RvalueFuncCall
from starkware.cairo.lang.compiler.ast.types import (
    TypeFelt,
    TypedIdentifier
)

from starkware.cairo.lang.compiler.ast.cairo_types import TypePointer
from starkware.cairo.lang.compiler.module_reader import ModuleReader
from starkware.cairo.lang.compiler.preprocessor.pass_manager import PassManager

from starkware.starknet.compiler.compile import assemble_starknet_contract, get_abi
from starkware.starknet.compiler.starknet_pass_manager import starknet_pass_manager

import sys
import argparse
import functools
import os


def functionCallableCheck(callableDecorators, decorators: list[ExprIdentifier]):
    for decorator in decorators:
        if decorator.name in callableDecorators:
            return True
    return False


class InterfaceElementsCollector(Visitor):
    def __init__(self):
        super().__init__()
        self.functions: list[CodeElementFunction] = list()
        # TODO remove raw_functions, this is only for debugging
        self.raw_functions: list[CodeElementFunction] = list()
        self.structs: list[CodeElementFunction] = list()
        self.imports: list[CodeElementImport] = list()
        self.callableDecorators: list[str] = [
            "view",
            "external",
        ]

    def visit_CodeElementFunction(self, elm: CodeElementFunction):

        visited_elm = super().visit_CodeElementFunction(elm)

        if visited_elm.element_type != "namespace" and visited_elm.element_type != "struct":
            if functionCallableCheck(self.callableDecorators, visited_elm.decorators):
                visited_elm.code_block = CodeBlock(list())
                visited_elm.decorators = list()
                visited_elm.implicit_arguments = None
                self.functions.append(visited_elm)
                self.raw_functions.append(elm)

        elif visited_elm.element_type == "struct":
            self.structs.append(visited_elm)

        return visited_elm

    def visit_CodeElementImport(self, elm: CodeElementImport):
        self.imports.append(elm)
        return elm

    def _visit_default(self, obj):
        assert isinstance(
            obj, CodeElement), f"Got unexpected type {type(obj).__name__}."


def createForwarderInterface(interfaceElementCollector: InterfaceElementsCollector):
    return CodeElementFunction(
        element_type="namespace",
        identifier=ExprIdentifier(name="Forwarder"),
        arguments=IdentifierList(identifiers=list()),
        implicit_arguments=None,
        returns=None,
        code_block=CodeBlock(
            code_elements=[
                CommentedCodeElement(
                    code_elm=func,
                    comment=None
                ) for func in interfaceElementCollector.functions
            ]
        ),
        decorators=[ExprIdentifier(name="contract_interface")],
    )

# debug-functions


def writeCairoInterface(interfaceElementCollector: InterfaceElementsCollector, forwarderInterface: CodeElementFunction):
    print("%lang starknet")
    # imports
    for import_elm in interfaceElementCollector.imports:
        print(import_elm.format(100))
    # structs
    for struct_elm in interfaceElementCollector.structs:
        print(struct_elm.format(100))
    print(forwarderInterface.format(100))


def get_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description='Produce a solidity interface for given cairo file')
    parser.add_argument(
        "--disable_hint_validation", action="store_true", help="Disable the hint validation."
    )
    cairo_compile_add_common_args(parser)
    return parser


def generateFunctionStubs(interfaceElementCollector: InterfaceElementsCollector) -> list[CodeElementFunction]:
    cairoFunctionStubs: list[CodeElementFunction] = list()
    for func in interfaceElementCollector.functions:
        cairoFunctionStubs.append(
            CodeElementFunction(
                element_type=func.element_type,
                identifier=ExprIdentifier(
                    name="Interface_" + func.identifier.name),
                arguments=IdentifierList(identifiers=[
                    TypedIdentifier(identifier=ExprIdentifier(
                        name="addr"), expr_type=TypeFelt())
                ] + func.arguments.identifiers),
                implicit_arguments=IdentifierList(
                    identifiers=[
                        TypedIdentifier(
                            identifier=ExprIdentifier(name='syscall_ptr'),
                            expr_type=TypePointer(pointee=TypeFelt()),
                            modifier=None
                        ),
                        TypedIdentifier(
                            identifier=ExprIdentifier(name='range_check_ptr'),
                            expr_type=TypeFelt(),
                            modifier=None
                        )
                    ]
                ),
                returns=func.returns,
                code_block=CodeBlock(
                    code_elements=[
                        CommentedCodeElement(
                            code_elm=CodeElementUnpackBinding(
                                unpacking_list=IdentifierList(
                                    identifiers=[TypedIdentifier(
                                        identifier=ExprIdentifier(name="val"), expr_type=None)]
                                ),
                                rvalue=RvalueFuncCall(
                                    func_ident=ExprIdentifier(
                                        name="Forwarder." + func.identifier.name),
                                    arguments=ArgList(
                                        args=[ExprIdentifier(name="addr")] + [
                                            ExprIdentifier(name=arg.identifier.name) for arg in func.arguments.identifiers
                                        ],
                                        notes=[
                                            Notes() for _ in func.arguments.identifiers] + [Notes()]*2,
                                        has_trailing_comma=False
                                    ),
                                    implicit_arguments=None
                                )
                            ),
                            comment=None
                        ),
                        CommentedCodeElement(
                            code_elm=CodeElementReturn(
                                exprs=[ExprAssignment(
                                    identifier=None, expr=ExprIdentifier(name='val'))],
                            ),
                            comment=None
                        )
                    ]
                ),
                decorators=list(),
            )
        )
    return cairoFunctionStubs


def get_cairo_abi(args: argparse.Namespace):

    args.output = open(os.devnull, "w")

    def pass_manager_factory(args: argparse.Namespace, module_reader: ModuleReader) -> PassManager:
        return starknet_pass_manager(
            prime=args.prime,
            read_module=module_reader.read,
            opt_unused_functions=args.opt_unused_functions,
            disable_hint_validation=args.disable_hint_validation,
        )

    assemble_func = functools.partial(
        assemble_starknet_contract,
        filter_identifiers=True,
        is_account_contract=False,
    )

    preprocessed = cairo_compile_common(
        args=args,
        pass_manager_factory=pass_manager_factory,
        assemble_func=assemble_func,
    )

    args.output.close()

    return get_abi(preprocessed=preprocessed)


def main():
    try:

        args = get_parser().parse_args()
        codes = get_codes(args.files)

        abi = get_cairo_abi(args=args)

        interfaceElementCollector = InterfaceElementsCollector()

        for code, filename in codes:
            parsed_file: CairoFile = parse_file(code, filename=filename)
            cairoModule: CairoModule = CairoModule(
                cairo_file=parsed_file, module_name=filename)
            interfaceElementCollector.visit(cairoModule)

        forwarderInterface = createForwarderInterface(
            interfaceElementCollector)

        # ----------------------------------debug--------------------------------
        writeCairoInterface(interfaceElementCollector, forwarderInterface)

        for stub in generateFunctionStubs(interfaceElementCollector):
            print(stub.format(100))

        print(abi)

    except LocationError as err:
        print(err, file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
