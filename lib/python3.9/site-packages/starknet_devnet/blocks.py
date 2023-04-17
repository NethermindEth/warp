"""
Class for generating and handling blocks
"""

from typing import Dict

from starkware.starknet.core.os.block_hash.block_hash import calculate_block_hash
from starkware.starknet.definitions.error_codes import StarknetErrorCode
from starkware.starknet.services.api.feeder_gateway.response_objects import (
    BlockIdentifier,
    BlockStateUpdate,
    BlockStatus,
    StarknetBlock,
)
from starkware.starknet.testing.state import StarknetState
from starkware.starkware_utils.error_handling import StarkErrorCode

from starknet_devnet.constants import CAIRO_LANG_VERSION, DUMMY_STATE_ROOT

from .origin import Origin
from .transactions import DevnetTransaction
from .util import StarknetDevnetException


class DevnetBlocks:
    """This class is used to store the generated blocks of the devnet."""

    def __init__(self, origin: Origin, lite=False) -> None:
        self.origin = origin
        self.lite = lite
        self.__num2block: Dict[int, StarknetBlock] = {}
        self.__state_updates: Dict[int, BlockStateUpdate] = {}
        self.__hash2num: Dict[str, int] = {}

    async def get_last_block(self) -> StarknetBlock:
        """Returns the last block stored so far."""
        number_of_blocks = self.get_number_of_blocks()
        return await self.get_by_number(number_of_blocks - 1)

    def get_number_of_blocks(self) -> int:
        """Returns the number of blocks stored so far."""
        return len(self.__num2block) + self.origin.get_number_of_blocks()

    def __assert_block_number_in_range(self, block_number: BlockIdentifier):
        if block_number < 0:
            message = (
                f"Block number must be a non-negative integer; got: {block_number}."
            )
            raise StarknetDevnetException(
                code=StarkErrorCode.MALFORMED_REQUEST, message=message
            )

        if block_number >= self.get_number_of_blocks():
            message = f"Block number too high. There are currently {len(self.__num2block)} blocks; got: {block_number}."
            raise StarknetDevnetException(
                code=StarknetErrorCode.BLOCK_NOT_FOUND, message=message
            )

    async def get_by_number(self, block_number: BlockIdentifier) -> StarknetBlock:
        """Returns the block whose block_number is provided"""
        if block_number is None:
            if self.__num2block:
                return await self.get_last_block()
            return await self.origin.get_block_by_number(block_number)

        self.__assert_block_number_in_range(block_number)
        if block_number in self.__num2block:
            return self.__num2block[block_number]

        return await self.origin.get_block_by_number(block_number)

    async def get_by_hash(self, block_hash: str) -> StarknetBlock:
        """
        Returns the block with the given block hash.
        """
        numeric_hash = int(block_hash, 16)

        if numeric_hash in self.__hash2num:
            block_number = self.__hash2num[int(block_hash, 16)]
            return await self.get_by_number(block_number)

        return await self.origin.get_block_by_hash(block_hash)

    async def get_state_update(
        self, block_hash=None, block_number=None
    ) -> BlockStateUpdate:
        """
        Returns state update for the provided block hash or block number.
        It will return the last state update if block is not provided.
        """
        if block_hash:
            numeric_hash = int(block_hash, 16)

            if numeric_hash not in self.__hash2num:
                return await self.origin.get_state_update(block_hash=block_hash)

            block_number = self.__hash2num[numeric_hash]

        if block_number is not None:
            self.__assert_block_number_in_range(block_number)
            if block_number in self.__state_updates:
                return self.__state_updates[block_number]

            return await self.origin.get_state_update(block_number=block_number)

        return (
            self.__state_updates.get(self.get_number_of_blocks() - 1)
            or await self.origin.get_state_update()
        )

    async def generate(
        self,
        transaction: DevnetTransaction,
        state: StarknetState,
        state_update=None,
        is_empty_block=False,
    ) -> StarknetBlock:
        """
        Generates a block and stores it to blocks and hash2block. The block contains just the passed transaction.
        The `tx_wrapper.transaction` dict should contain a key `transaction`.
        Returns (block_hash, block_number).
        """
        state_root = DUMMY_STATE_ROOT
        block_number = self.get_number_of_blocks()
        timestamp = state.state.block_info.block_timestamp
        if block_number == 0:
            parent_block_hash = 0
        else:
            last_block = await self.get_last_block()
            parent_block_hash = last_block.block_hash

        if is_empty_block:
            transaction_receipts = ()
            transactions = []
        else:
            transaction_receipts = (transaction.get_execution(),)
            transactions = [transaction.internal_tx]

        if self.lite or is_empty_block:
            block_hash = block_number
        else:
            signature = transaction.get_signature()
            block_hash = await calculate_block_hash(
                general_config=state.general_config,
                parent_hash=parent_block_hash,
                block_number=block_number,
                global_state_root=state_root,
                block_timestamp=timestamp,
                tx_hashes=[transaction.internal_tx.hash_value],
                tx_signatures=[signature],
                event_hashes=[],
                sequencer_address=state.general_config.sequencer_address,
            )

        block = StarknetBlock.create(
            block_hash=block_hash,
            block_number=block_number,
            state_root=state_root,
            transactions=transactions,
            timestamp=timestamp,
            transaction_receipts=transaction_receipts,
            status=BlockStatus.ACCEPTED_ON_L2,
            gas_price=state.state.block_info.gas_price,
            sequencer_address=state.general_config.sequencer_address,
            parent_block_hash=parent_block_hash,
            starknet_version=CAIRO_LANG_VERSION,
        )

        self.__num2block[block_number] = block
        self.__hash2num[block_hash] = block_number

        if state_update is not None:
            state_update = BlockStateUpdate(
                block_hash=block_hash,
                old_root=state_update.old_root,
                new_root=state_update.new_root,
                state_diff=state_update.state_diff,
            )

        self.__state_updates[block_number] = state_update
        return block
