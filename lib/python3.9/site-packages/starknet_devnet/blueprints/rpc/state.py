"""
RPC state endpoints
"""

from starknet_devnet.blueprints.rpc.structures.payloads import rpc_state_update
from starknet_devnet.blueprints.rpc.structures.types import BlockId, RpcError
from starknet_devnet.blueprints.rpc.utils import block_tag_to_block_number
from starknet_devnet.state import state
from starknet_devnet.util import StarknetDevnetException


async def get_state_update(block_id: BlockId) -> dict:
    """
    Get the information about the result of executing the requested block
    """
    block_id = block_tag_to_block_number(block_id)

    try:
        if "block_hash" in block_id:
            result = await state.starknet_wrapper.blocks.get_state_update(
                block_hash=block_id["block_hash"]
            )
        else:
            result = await state.starknet_wrapper.blocks.get_state_update(
                block_number=block_id["block_number"]
            )
    except StarknetDevnetException as ex:
        raise RpcError(code=24, message="Block not found") from ex

    return rpc_state_update(result)
