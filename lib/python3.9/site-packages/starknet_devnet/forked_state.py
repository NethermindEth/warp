"""Forked state"""

import contextlib
import json

from services.external_api.client import BadRequest
from starkware.python.utils import to_bytes
from starkware.starknet.business_logic.state.state import BlockInfo, CachedState
from starkware.starknet.business_logic.state.state_api import StateReader
from starkware.starknet.definitions.constants import UNINITIALIZED_CLASS_HASH
from starkware.starknet.definitions.general_config import StarknetChainId
from starkware.starknet.services.api.contract_class import ContractClass
from starkware.starknet.services.api.feeder_gateway.feeder_gateway_client import (
    FeederGatewayClient,
)
from starkware.starknet.testing.starknet import Starknet
from starkware.starknet.testing.state import StarknetState
from starkware.starkware_utils.error_handling import StarkException

from .block_info_generator import now
from .general_config import build_devnet_general_config


def is_originally_starknet_exception(exc: BadRequest):
    """
    Return `True` if `exc` matches scheme of a Starknet exception.
    Oterhwise return `False`.
    """
    try:
        loaded = json.loads(exc.text)
        assert loaded["code"]
        assert loaded["message"]
        return True
    except (AssertionError, json.decoder.JSONDecodeError):
        return False


class ForkedStateReader(StateReader):
    """State with a fallback to a forked origin"""

    def __init__(
        self,
        feeder_gateway_client: FeederGatewayClient,
        block_number: int,
    ):
        self.__feeder_gateway_client = feeder_gateway_client
        self.__block_number = block_number

    async def get_contract_class(self, class_hash: bytes) -> ContractClass:
        try:
            with contextlib.redirect_stderr(None):
                class_hash_hex = "0x" + class_hash.hex()
                contract_class_dict = (
                    await self.__feeder_gateway_client.get_class_by_hash(class_hash_hex)
                )
                return ContractClass.load(contract_class_dict)
        except BadRequest as bad_request:
            original_error = StarkException(**json.loads(bad_request.text))
            raise original_error from bad_request

    async def _get_raw_contract_class(self, class_hash: bytes) -> bytes:
        raise NotImplementedError

    async def get_class_hash_at(self, contract_address: int) -> bytes:
        try:
            with contextlib.redirect_stderr(None):
                class_hash_hex = await self.__feeder_gateway_client.get_class_hash_at(
                    contract_address=contract_address,
                    block_number=self.__block_number,
                )
            return to_bytes(int(class_hash_hex, 16))
        except BadRequest as bad_request:
            if is_originally_starknet_exception(bad_request):
                return UNINITIALIZED_CLASS_HASH
            raise

    async def get_nonce_at(self, contract_address: int) -> int:
        return await self.__feeder_gateway_client.get_nonce(
            contract_address=contract_address,
            block_number=self.__block_number,
        )

    async def get_storage_at(self, contract_address: int, key: int) -> int:
        storage_hex = await self.__feeder_gateway_client.get_storage_at(
            contract_address=contract_address,
            key=key,
            block_number=self.__block_number,
        )
        return int(storage_hex, 16)


def get_forked_starknet(
    feeder_gateway_client: FeederGatewayClient,
    block_number: int,
    gas_price: int,
    chain_id: StarknetChainId,
) -> Starknet:
    """Return a forked Starknet"""
    state_reader = ForkedStateReader(
        feeder_gateway_client=feeder_gateway_client,
        block_number=block_number,
    )
    return Starknet(
        state=StarknetState(
            state=CachedState(
                block_info=BlockInfo.create_for_testing(
                    block_number=block_number,
                    block_timestamp=now(),
                    gas_price=gas_price,
                ),
                state_reader=state_reader,
                contract_class_cache={},
            ),
            general_config=build_devnet_general_config(chain_id),
        )
    )
