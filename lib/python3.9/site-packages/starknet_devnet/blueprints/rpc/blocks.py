"""
RPC block endpoints
"""

from starknet_devnet.blueprints.rpc.structures.payloads import rpc_block
from starknet_devnet.blueprints.rpc.structures.types import BlockId, RpcError
from starknet_devnet.blueprints.rpc.utils import get_block_by_block_id, rpc_felt
from starknet_devnet.state import state


async def get_block_with_tx_hashes(block_id: BlockId) -> dict:
    """
    Get block information with transaction hashes given the block id
    """
    block = await get_block_by_block_id(block_id)
    return await rpc_block(block=block)


async def get_block_with_txs(block_id: BlockId) -> dict:
    """
    Get block information with full transactions given the block id
    """
    block = await get_block_by_block_id(block_id)
    return await rpc_block(block=block, tx_type="FULL_TXNS")


async def block_number() -> int:
    """
    Get the most recent accepted block number
    """
    number_of_blocks = state.starknet_wrapper.blocks.get_number_of_blocks()
    if number_of_blocks == 0:
        raise RpcError(code=32, message="There are no blocks")

    return number_of_blocks - 1


async def block_hash_and_number() -> dict:
    """
    Get the most recent accepted block hash and number
    """
    number_of_blocks = state.starknet_wrapper.blocks.get_number_of_blocks()
    if number_of_blocks == 0:
        raise RpcError(code=32, message="There are no blocks")

    last_block_number = number_of_blocks - 1
    last_block = await state.starknet_wrapper.blocks.get_by_number(last_block_number)

    result = {
        "block_hash": rpc_felt(last_block.block_hash),
        "block_number": last_block.block_number,
    }
    return result


async def get_block_transaction_count(block_id: BlockId) -> int:
    """
    Get the number of transactions in a block given a block id
    """
    block = await get_block_by_block_id(block_id)
    return len(block.transactions)
