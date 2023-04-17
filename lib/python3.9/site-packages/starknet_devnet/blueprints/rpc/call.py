"""
RPC call endpoint
"""

from typing import Any, List

from starkware.starkware_utils.error_handling import StarkException

from starknet_devnet.blueprints.rpc.structures.payloads import (
    RpcFunctionCall,
    make_call_function,
)
from starknet_devnet.blueprints.rpc.structures.types import (
    BlockId,
    Felt,
    RpcError,
    RpcErrorCode,
)
from starknet_devnet.blueprints.rpc.utils import (
    assert_block_id_is_latest_or_pending,
    rpc_felt,
)
from starknet_devnet.state import state
from starknet_devnet.util import StarknetDevnetException


def _validate_calldata(calldata: List[Any]):
    for calldata_value in calldata:
        try:
            int(calldata_value, 16)
        except (ValueError, TypeError) as error:
            raise RpcError(code=22, message="Invalid call data") from error


async def call(request: RpcFunctionCall, block_id: BlockId) -> List[Felt]:
    """
    Call a starknet function without creating a StarkNet transaction
    """
    await assert_block_id_is_latest_or_pending(block_id)

    if not await state.starknet_wrapper.is_deployed(
        int(request["contract_address"], 16)
    ):
        raise RpcError(code=20, message="Contract not found")

    _validate_calldata(request["calldata"])
    try:
        result = await state.starknet_wrapper.call(
            transaction=make_call_function(request)
        )
        return [rpc_felt(res) for res in result["result"]]
    except StarknetDevnetException as ex:
        raise RpcError(
            code=RpcErrorCode.INTERNAL_ERROR.value, message=ex.message
        ) from ex
    except StarkException as ex:
        if ex.code.name == "TRANSACTION_FAILED" and ex.code.value == 39:
            raise RpcError(code=22, message="Invalid call data") from ex
        if f"Entry point {request['entry_point_selector']} not found" in ex.message:
            raise RpcError(code=21, message="Invalid message selector") from ex
        if "While handling calldata" in ex.message:
            raise RpcError(code=22, message="Invalid call data") from ex
        raise RpcError(
            code=RpcErrorCode.INTERNAL_ERROR.value, message=ex.message
        ) from ex
