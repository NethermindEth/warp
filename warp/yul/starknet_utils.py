from cli.StarkNetEvmContract import get_evm_calldata
from starkware.starknet.business_logic.internal_transaction_interface import (
    TransactionExecutionInfo,
)
from starkware.starknet.testing.state import StarknetState
from yul.utils import cairoize_bytes


async def invoke_method(
    starknet: StarknetState, program_info: dict, address: str, method: str, *args: list
) -> TransactionExecutionInfo:
    evm_calldata = get_evm_calldata(
        program_info["sol_abi"],
        program_info["sol_abi_original"],
        program_info["sol_bytecode"],
        method,
        args,
    )
    calldata, unused_bytes = cairoize_bytes(bytes.fromhex(evm_calldata[2:]))
    calldata_size = len(calldata) * 16 - unused_bytes
    calldata_len = len(calldata)
    entry_calldata = [calldata_size, calldata_len, *calldata, address]
    return await starknet.invoke_raw(
        contract_address=address,
        selector="fun_ENTRY_POINT",
        calldata=entry_calldata,
        caller_address=0,
    )
