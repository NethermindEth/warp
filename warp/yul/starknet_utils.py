from cli.encoding import get_cairo_calldata, get_ctor_evm_calldata, get_evm_calldata
from starkware.starknet.business_logic.internal_transaction_interface import (
    TransactionExecutionInfo,
)
from starkware.starknet.services.api.contract_definition import ContractDefinition
from starkware.starknet.testing.state import StarknetState


async def invoke_method(
    starknet: StarknetState, program_info: dict, address: str, method: str, *args: list
) -> TransactionExecutionInfo:
    evm_calldata = get_evm_calldata(program_info["sol_abi"], method, args)
    cairo_calldata = get_cairo_calldata(evm_calldata)
    return await starknet.invoke_raw(
        contract_address=address,
        selector="__main",
        calldata=cairo_calldata,
        caller_address=0,
    )


async def deploy_contract(
    starknet: StarknetState,
    program_info: dict,
    contract_definition: ContractDefinition,
    *args: list,
) -> str:
    evm_calldata = get_ctor_evm_calldata(program_info["sol_abi"], args)
    cairo_calldata = get_cairo_calldata(evm_calldata)
    return await starknet.deploy(
        contract_definition=contract_definition, constructor_calldata=cairo_calldata
    )
