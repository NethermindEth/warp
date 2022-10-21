from typing import Optional
from starkware.cairo.lang.compiler.parser import parse_file
from starkware.cairo.lang.compiler.error_handling import LocationError
from starkware.cairo.lang.version import __version__
from starkware.cairo.lang.compiler.cairo_compile import (
    get_codes,
    cairo_compile_common,
    cairo_compile_add_common_args
)
from starkware.cairo.lang.compiler.scoped_name import ScopedName
from starkware.cairo.lang.compiler.ast.module import CairoFile, CairoModule
from starkware.cairo.lang.compiler.ast.visitor import Visitor
from starkware.cairo.lang.compiler.ast.code_elements import (
    CodeBlock,
    CodeElement,
    CodeElementAllocLocals,
    CodeElementFunction,
    CodeElementImport,
    CodeElementReference,
    CodeElementReturn,
    CodeElementReturnValueReference,
    CodeElementUnpackBinding,
    CommentedCodeElement,
    ExprTuple
)
from starkware.cairo.lang.compiler.ast.expr_func_call import ExprFuncCall
from starkware.cairo.lang.compiler.ast.expr import ExprIdentifier, ArgList, ExprAssignment
from starkware.cairo.lang.compiler.ast.arguments import IdentifierList
from starkware.cairo.lang.compiler.ast.notes import Notes
from starkware.cairo.lang.compiler.ast.rvalue import RvalueFuncCall
from starkware.cairo.lang.compiler.ast.types import (
    TypeFelt,
    TypedIdentifier
)


from starkware.cairo.lang.compiler.ast.formatting_utils import get_max_line_length
from starkware.cairo.lang.compiler.ast.cairo_types import TypePointer, CairoType, TypeTuple, TypeIdentifier
from starkware.cairo.lang.compiler.module_reader import ModuleReader
from starkware.cairo.lang.compiler.preprocessor.pass_manager import PassManager

from starkware.starknet.compiler.compile import assemble_starknet_contract, get_abi
from starkware.starknet.compiler.starknet_pass_manager import starknet_pass_manager
from starkware.starknet.public.abi import AbiType

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
    def __init__(self, abi_functions: list[str], abi_structs: list[str]):
        super().__init__()
        self.functions: list[CodeElementFunction] = list()
        self.structs: list[CodeElementFunction] = list()
        self.imports: list[CodeElementImport] = list()
        self.callable_decorators: list[str] = [
            "view",
            "external",
        ]
        self.abi_functions: list[str] = abi_functions
        self.abi_structs: list[str] = abi_structs

    def visit_CodeElementFunction(self, elm: CodeElementFunction):

        visited_elm = super().visit_CodeElementFunction(elm)

        if visited_elm.element_type == "func":
            if visited_elm.name in self.abi_functions and functionCallableCheck(self.callable_decorators, visited_elm.decorators):
                visited_elm.code_block = CodeBlock(list())
                visited_elm.decorators = list()
                visited_elm.implicit_arguments = None
                self.functions.append(visited_elm)

        elif visited_elm.element_type == "struct":
            self.structs.append(visited_elm)

        return visited_elm

    def getUsableImportItems(self, elm: CodeElementImport):
        import_items = list(
            filter(lambda x: x.orig_identifier.name in self.abi_structs, elm.import_items))
        # remove items which original identifier name is Uint256
        import_items = list(
            filter(lambda x: x.orig_identifier.name != "Uint256", import_items))
        return import_items

    def visit_CodeElementImport(self, elm: CodeElementImport):
        usableImportItems = self.getUsableImportItems(elm)
        if len(usableImportItems) > 0:
            elm.import_items = usableImportItems
            self.imports.append(elm)
            return elm
        return elm

    def _visit_default(self, obj):
        assert isinstance(
            obj, CodeElement), f"Got unexpected type {type(obj).__name__}."


def createForwarderInterface(interfaceElementCollector: InterfaceElementsCollector):
    """
        Returns a cairo Namespace ("Forwarder") with contract interface decorator
    """
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


def get_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description='Produce a solidity interface for given cairo file')
    parser.add_argument(
        "--disable_hint_validation", action="store_true", help="Disable the hint validation."
    )
    cairo_compile_add_common_args(parser)
    return parser


def arrayLengthName(name: str):
    if name == "calldata":
        return "calldata_size"
    elif name == "retdata":
        return "retdata_size"
    return f"{name}_len"


def processArrayArguments(args: list[TypedIdentifier]):

    """
        Return a list of arguments with array arguments generated for the cairo function call in fn stub
        e.g 
            For a Cairo function if it accepts an array arugment
            ex. f(a_len: felt, a:felt*) -> felt
            Then, it's corresponding stub should accept a memory argument 
            for the above example it would be `a_mem: felt`

        [Args]:
            list of [(a_len: felt, a:felt*), ...]
        [Returns]:
            1. If there is an array arugment : hasArrayArguments <-> (boolean)
            2. Cairo Lines to be added to the function stub for arg conversion : lines_added <-> (list[CodeElement])
                e.g let (a_len, a) = mem2calldata(a_mem).len, mem2calldata(a_mem).ptr
            3. list of [a_mem, ...] : modifiedArgs <-> (list[TypedIdentifier])
    """

    modifiedArgs: list[TypedIdentifier] = list()
    lines_added: list[CommentedCodeElement] = list()
    hasArrayArguments = False

    for arg in args:
        if isinstance(arg.expr_type, TypePointer):
            assert (
                len(modifiedArgs) > 0 and
                modifiedArgs[-1].name == arrayLengthName(arg.name) and
                isinstance(modifiedArgs[-1].expr_type, TypeFelt)
            ), "Array type argument must be preceded by a length argument"

            hasArrayArguments = True
            modifiedArgs.pop()
            modifiedArgs.append(
                TypedIdentifier(
                    identifier=ExprIdentifier(name=arg.name+"_mem"),
                    expr_type=TypeFelt(),
                )
            )
            
            lines_added.extend([
                CommentedCodeElement(
                    code_elm=CodeElementUnpackBinding(
                        unpacking_list=IdentifierList(
                            identifiers=[
                                TypedIdentifier(
                                    identifier=ExprIdentifier(
                                        name=arg.name+"_cd"),
                                    expr_type=None,
                                )
                            ],
                            notes=[Notes([])]*2,
                        ),
                        rvalue=RvalueFuncCall(
                            func_ident=ExprIdentifier(
                                name="wm_to_calldata_NUM"),
                            arguments=ArgList(
                                [
                                    ExprAssignment(
                                        identifier=None,
                                        expr=ExprIdentifier(
                                            name=arg.name+"_mem")
                                    ),
                                ],
                                notes=[Notes([])]*2,
                                has_trailing_comma=False,
                            ),
                            implicit_arguments=None,
                        )
                    ),
                    comment=None,
                ),
                CommentedCodeElement(
                    code_elm=CodeElementReference(
                        typed_identifier=TypedIdentifier(
                            identifier=ExprIdentifier(
                                name=arrayLengthName(arg.name)),
                            expr_type=None,
                        ),
                        expr=ExprIdentifier(
                            name=arg.name + "_cd" + ".len"
                        )
                    ),
                    comment=None
                ),
                CommentedCodeElement(
                    code_elm=CodeElementReference(
                        typed_identifier=TypedIdentifier(
                            identifier=ExprIdentifier(name=arg.name),
                            expr_type=None,
                        ),
                        expr=ExprIdentifier(
                            name=arg.name + "_cd" + ".ptr"
                        )
                    ),
                    comment=None
                ),
            ])
        else:
            modifiedArgs.append(arg)
    return hasArrayArguments, lines_added, modifiedArgs


def processArrayReturnArguments(func_returns: Optional[CairoType]):

    """
        Return a list of arguments with memory argument corresponding to array return arguments
        generated for the cairo function call in fn stub
        e.g
            For a Cairo function if it returns an array arugment
            ex. f(a_len: felt, a:felt*) -> felt*
            Then, a_len and a should be read from a_mem
            and the return value should be a_mem

        [Args]:
            Cairo function return type : func_returns <-> (Optional[CairoType])
        [Returns]:
            1. If there is an array arugment : hasArrayReturnArguments <-> (boolean)
            2. If modification has been made to the return type : modifiedReturnType <-> (boolean)
            3. Cairo Lines to be added to the function stub for arg conversion : lines_added <-> (list[CodeElement])
                e.g let (a_len, a) = mem2calldata(a_mem).len, mem2calldata(a_mem).ptr
            4. Cairo function return type : modifiedReturns <-> (Optional[TypeTuple])

    """

    if func_returns is None:
        return False, False, [], None
    if not isinstance(func_returns, TypeTuple):
        return False, False, [], func_returns
    tuplesMembers: list["TypeTuple.Item"] = list()
    lines_added: list[CommentedCodeElement] = list()
    hasArrayReturnArguments = False
    for member in func_returns.members:
        if isinstance(member.typ, TypePointer):
            assert (
                len(tuplesMembers) > 0 and
                tuplesMembers[-1].name == arrayLengthName(member.name) and
                isinstance(tuplesMembers[-1].typ, TypeFelt)
            ), "Array type argument must be preceded by a length argument"
            hasArrayReturnArguments = True
            tuplesMembers.pop()
            tuplesMembers.append(
                TypeTuple.Item(
                    name=member.name+"_mem",
                    typ=TypeFelt(),
                )
            )
            lines_added.append(
                CommentedCodeElement(
                    code_elm=CodeElementUnpackBinding(
                        unpacking_list=IdentifierList(
                            identifiers=[
                                TypedIdentifier(
                                    identifier=ExprIdentifier(
                                        name=member.name+"_mem"),
                                    expr_type=None,
                                )
                            ],
                            notes=[Notes([])]*2,
                        ),
                        rvalue=RvalueFuncCall(
                            func_ident=ExprIdentifier(name="cd_to_memory_NUM"),
                            arguments=ArgList(
                                [
                                    ExprAssignment(
                                        identifier=None,
                                        expr=ExprFuncCall(
                                            rvalue=RvalueFuncCall(
                                                func_ident=ExprIdentifier(
                                                    name='cd_dynarray_OBJECT_TYPE'),
                                                arguments=ArgList(
                                                    args=[
                                                        ExprAssignment(
                                                            identifier=None,
                                                            expr=ExprIdentifier(
                                                                name=arrayLengthName(member.name)),
                                                        ),
                                                        ExprAssignment(
                                                            identifier=None,
                                                            expr=ExprIdentifier(
                                                                name=member.name)
                                                        ),
                                                    ],
                                                    notes=[Notes([])]*3,
                                                    has_trailing_comma=False,
                                                ),
                                                implicit_arguments=None,
                                            )
                                        )
                                    ),
                                ],
                                notes=[Notes([])]*2,
                                has_trailing_comma=False,
                            ),
                            implicit_arguments=None,
                        )
                    ),
                    comment=None,
                )
            )
        else:
            tuplesMembers.append(member)
    return hasArrayReturnArguments, True, lines_added, TypeTuple(
        members=tuplesMembers,
        notes=[Notes([])]*(len(tuplesMembers)+1),
        has_trailing_comma=len(tuplesMembers) == 1
    )


def generateFunctionStubs(interfaceElementCollector: InterfaceElementsCollector) -> dict[str, CodeElementFunction]:

    """
    Generates function stubs for all functions in the interfaceElementCollector
        :param interfaceElementCollector: The interface element collector
        :return: A dictionary of function stubs 
    """

    cairoFunctionStubsDict: dict[str, CodeElementFunction] = dict()

    for func in interfaceElementCollector.functions:
        has_array, lines_added, func_arguments = processArrayArguments(
            func.arguments.identifiers)
        has_return_array, return_modification, lines_added_return, func_returns = processArrayReturnArguments(
            func.returns)
        cairoFunctionStubsDict[func.identifier.name] = (
            CodeElementFunction(
                element_type=func.element_type,
                identifier=ExprIdentifier(
                    name="CURRENTFUNC()"),
                arguments=IdentifierList(identifiers=func_arguments),
                implicit_arguments=IdentifierList(
                    identifiers=[
                        TypedIdentifier(
                            identifier=ExprIdentifier(name='syscall_ptr'),
                            expr_type=TypePointer(pointee=TypeFelt()),
                            modifier=None
                        )
                    ] + [
                        TypedIdentifier(
                            identifier=ExprIdentifier(name='pedersen_ptr'),
                            expr_type=TypePointer(pointee=TypeIdentifier(
                                name=ScopedName(path=('HashBuiltin',)))),
                            modifier=None
                        )
                    ] +
                    [
                        TypedIdentifier(
                            identifier=ExprIdentifier(name='range_check_ptr'),
                            expr_type=TypeFelt(),
                            modifier=None
                        )
                    ] + ([
                        TypedIdentifier(
                            identifier=ExprIdentifier(name='warp_memory'),
                            expr_type=TypePointer(pointee=TypeIdentifier(
                                name=ScopedName(path=('DictAccess',)))),
                            modifier=None
                        )
                    ] if has_return_array else []),
                ),
                returns=func_returns,
                code_block=CodeBlock(
                    code_elements=[
                        CommentedCodeElement(
                            code_elm=CodeElementAllocLocals(),
                            comment=None
                        ), 
                        CommentedCodeElement(
                            code_elm = CodeElementUnpackBinding(
                                unpacking_list=IdentifierList(
                                    identifiers=[
                                        TypedIdentifier(identifier = ExprIdentifier(name='__contract_address'), expr_type = TypeFelt()),
                                    ],
                                    notes=[Notes([])]*2,
                                ), 
                                rvalue = RvalueFuncCall(
                                    func_ident = ExprIdentifier(name='WARP_STORAGE.read'),
                                    arguments = ArgList(
                                        args =[ExprAssignment(identifier=None, expr=ExprIdentifier(name='__warp_usrid_00___fwd_contract_address'))], 
                                        notes=[Notes([])]*2,
                                        has_trailing_comma=False,
                                    ),
                                    implicit_arguments=None,
                                ),
                            ), 
                            comment=None,
                        )
                    ]
                     + lines_added + [
                        CommentedCodeElement(
                            code_elm=CodeElementUnpackBinding(
                                unpacking_list=IdentifierList(
                                    identifiers=[
                                        TypedIdentifier(identifier=ExprIdentifier(member.name), expr_type=member.typ) for member in func.returns.members
                                    ] if func.returns is not None else [],
                                    notes=[Notes()]*(len(func.returns.members) +
                                                     1) if func.returns is not None else [Notes()],
                                ),
                                rvalue=RvalueFuncCall(
                                    func_ident=ExprIdentifier(
                                        name="Forwarder." + func.identifier.name
                                    ),
                                    arguments=ArgList(
                                        args=[ExprAssignment(identifier=None, expr=ExprIdentifier(name='__contract_address'))] + [
                                            ExprAssignment(identifier=None, expr=ExprIdentifier(name=arg.identifier.name)) for arg in func.arguments.identifiers
                                        ],
                                        notes=[
                                            Notes() for _ in func.arguments.identifiers] + [Notes()]*2,
                                        has_trailing_comma=False
                                    ),
                                    implicit_arguments=None
                                )
                            ),
                            comment=None
                        ) if return_modification else CommentedCodeElement(
                            code_elm=CodeElementReturnValueReference(
                                TypedIdentifier(
                                    identifier=ExprIdentifier(name="val"),
                                    expr_type=None,
                                    modifier=None
                                ),
                                func_call=RvalueFuncCall(
                                    func_ident=ExprIdentifier(
                                        name="Forwarder." + func.identifier.name
                                    ),
                                    arguments=ArgList(
                                        args=[ExprAssignment(identifier=None, expr=ExprIdentifier(name='__contract_address'))] + [
                                            ExprAssignment(identifier=None, expr=ExprIdentifier(name=arg.identifier.name)) for arg in func.arguments.identifiers
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
                    ] + lines_added_return + [
                        CommentedCodeElement(
                            code_elm=CodeElementReturn(
                                expr=ExprTuple(
                                    members=ArgList(
                                        args=[
                                            ExprAssignment(identifier=None, expr=ExprIdentifier(name=member.name)) for member in func_returns.members
                                        ],
                                        notes=[Notes()] *
                                        (len(func_returns.members) + 1),
                                        has_trailing_comma=len(
                                            func_returns.members) == 1,
                                    ),
                                ),
                            ),
                            comment=None
                        ) if return_modification else CommentedCodeElement(
                            code_elm=CodeElementReturn(
                                expr=ExprIdentifier(name="val"),
                            ),
                            comment=None
                        )
                    ]
                ),
                decorators=list(),
            )
        )
    return cairoFunctionStubsDict


def get_cairo_abi(args: argparse.Namespace):

    curr_output_file = args.output

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
    args.output = curr_output_file

    return get_abi(preprocessed=preprocessed)


def modify_abi_with_stubs(abi: AbiType, cairoFunctionStubsDict: dict[str, CodeElementFunction]):
    for entry in abi:
        if entry['type'] == 'function':
            entry['stub'] = cairoFunctionStubsDict[entry['name']].format(
                get_max_line_length()).split('\n')
    return abi


def main():
    """
    This function generates JSON respresentation for a given Cairo contract.
    JSON contains the following fields:
    - name: contract name
    - modified_abi: list of functions and their signatures including stubs
    - forwarder_interface: Cairo interface for the Forwarder contract
    - imports: list of imports
    - structs: list of structs
    - functions: list of functions
    """
    try:
        args = get_parser().parse_args()

        # Read code lines from file =>  (file_key : file_data_lines, ...)
        codes = get_codes(args.files)

        abi = get_cairo_abi(args=args)

        if args.output is None:
            # If output file name is not specified, use the first cairo file name
            args.output = codes[0][1].replace('.cairo', '.json')
        else:
            args.output = args.output.name.replace('.sol', '.json')

        # Filter functions and structs which are in abi
        interfaceElementCollector = InterfaceElementsCollector(
            [entry["name"] for entry in abi if entry["type"] == "function"],
            [entry["name"] for entry in abi if entry["type"] == "struct"]
        )

        for code, filename in codes:
            parsed_file: CairoFile = parse_file(code, filename=filename)
            cairoModule: CairoModule = CairoModule(
                cairo_file=parsed_file, module_name=filename)

            # collect functions , imports and structs
            interfaceElementCollector.visit(cairoModule)

        forwarderInterface = createForwarderInterface(
            interfaceElementCollector)

        # Modify abi with function stubs which can be used to call the contract interface functions
        abi = modify_abi_with_stubs(
            abi, generateFunctionStubs(interfaceElementCollector))

        cairo_json = {}
        cairo_json["abi"] = abi
        cairo_json["forwarder_interface"] = forwarderInterface.format(
            get_max_line_length()).split('\n')
        cairo_json["imports"] = [import_elm.format(
            get_max_line_length()) for import_elm in interfaceElementCollector.imports]
        cairo_json["structs"] = [struct_elm.format(get_max_line_length()).split(
            '\n') for struct_elm in interfaceElementCollector.structs]
        cairo_json["functions"] = [func.format(get_max_line_length()).split(
            '\n') for func in interfaceElementCollector.functions]

        import json
        with open(args.output, "w") as f:
            json.dump(cairo_json, f, indent=4)

    except LocationError as err:
        print(err, file=sys.stderr)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())
