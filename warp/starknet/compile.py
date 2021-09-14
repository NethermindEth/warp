from typing import List

from starkware.cairo.lang.cairo_constants import DEFAULT_PRIME
from starkware.cairo.lang.compiler.cairo_compile import get_module_reader, compile_cairo_ex, get_codes
from starkware.starknet.compiler.compile import get_entry_points_by_type
from starkware.starknet.compiler.starknet_pass_manager import starknet_pass_manager
from starkware.starknet.compiler.starknet_preprocessor import StarknetPreprocessedProgram
from starkware.starknet.services.api.contract_definition import ContractDefinition

def compile_starknet_files(
    files, debug_info: bool = False, disable_hint_validation: bool = False, cairo_path: List[str] = None
) -> ContractDefinition:

    if cairo_path is None:
        cairo_path = []
    module_reader = get_module_reader(cairo_path)

    pass_manager = starknet_pass_manager(
        prime=DEFAULT_PRIME,
        read_module=module_reader.read,
        disable_hint_validation=disable_hint_validation,
    )

    program, preprocessed = compile_cairo_ex(
        code=get_codes(files), debug_info=debug_info, pass_manager=pass_manager
    )

    # Dump and load program, so that it is converted to the canonical form.
    program_schema = program.Schema()
    program = program_schema.load(data=program_schema.dump(obj=program))

    assert isinstance(preprocessed, StarknetPreprocessedProgram)
    return ContractDefinition(
        program=program,
        entry_points_by_type=get_entry_points_by_type(program=program),
        abi=preprocessed.abi,
    )