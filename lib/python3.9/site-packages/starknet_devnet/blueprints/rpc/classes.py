"""
RPC classes endpoints
"""

from starkware.starkware_utils.error_handling import StarkException

from starknet_devnet.blueprints.rpc.structures.payloads import rpc_contract_class
from starknet_devnet.blueprints.rpc.structures.types import (
    Address,
    BlockId,
    Felt,
    RpcError,
)
from starknet_devnet.blueprints.rpc.utils import (
    assert_block_id_is_latest_or_pending,
    rpc_felt,
)
from starknet_devnet.state import state
from starknet_devnet.util import StarknetDevnetException


async def get_class(block_id: BlockId, class_hash: Felt) -> dict:
    """
    Get the contract class definition in the given block associated with the given hash
    """
    await assert_block_id_is_latest_or_pending(block_id)

    try:
        result = await state.starknet_wrapper.get_class_by_hash(
            class_hash=int(class_hash, 16)
        )
    except StarknetDevnetException as ex:
        raise RpcError(code=28, message="Class hash not found") from ex

    return rpc_contract_class(result)


async def get_class_hash_at(block_id: BlockId, contract_address: Address) -> Felt:
    """
    Get the contract class hash in the given block for the contract deployed at the given address
    """
    await assert_block_id_is_latest_or_pending(block_id)

    try:
        result = await state.starknet_wrapper.get_class_hash_at(
            int(contract_address, 16)
        )
    except StarkException as ex:
        raise RpcError(code=28, message="Class hash not found") from ex

    return rpc_felt(result)


async def get_class_at(block_id: BlockId, contract_address: Address) -> dict:
    """
    Get the contract class definition in the given block at the given address
    """
    await assert_block_id_is_latest_or_pending(block_id)

    try:
        result = await state.starknet_wrapper.get_class_by_address(
            int(contract_address, 16)
        )
    except StarkException as ex:
        raise RpcError(code=20, message="Contract not found") from ex

    return rpc_contract_class(result)
