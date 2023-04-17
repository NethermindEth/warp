"""
RPC storage endpoints
"""

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


async def get_storage_at(
    contract_address: Address, key: str, block_id: BlockId
) -> Felt:
    """
    Get the value of the storage at the given address and key
    """
    await assert_block_id_is_latest_or_pending(block_id)

    if not await state.starknet_wrapper.is_deployed(int(contract_address, 16)):
        raise RpcError(code=20, message="Contract not found")

    storage = await state.starknet_wrapper.get_storage_at(
        contract_address=int(contract_address, 16), key=int(key, 16)
    )
    return rpc_felt(storage)
