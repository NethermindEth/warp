"""
Utility functions used across the project.
"""

import os
import sys
from dataclasses import dataclass
from typing import Dict, List, Set, Union

from starkware.starknet.business_logic.state.state import CachedState
from starkware.starknet.definitions.error_codes import StarknetErrorCode
from starkware.starknet.services.api.feeder_gateway.response_objects import (
    DeployedContract,
    FeeEstimationInfo,
    StorageEntry,
)
from starkware.starknet.testing.contract import StarknetContract
from starkware.starkware_utils.error_handling import StarkException


def custom_int(arg: str) -> int:
    """
    Converts the argument to an integer.
    Conversion base is 16 if `arg` starts with `0x`, otherwise `10`.
    """
    base = 16 if arg.startswith("0x") else 10
    return int(arg, base)


def fixed_length_hex(arg: int) -> str:
    """
    Converts the int input to a hex output of fixed length
    """
    return f"0x{arg:064x}"


def to_int_array(values: List[str]) -> List[int]:
    """Convert to List of ints"""
    return [int(numeric, 16) for numeric in values]


@dataclass
class Uint256:
    """Abstraction of Uint256 type"""

    low: int
    high: int

    def to_felt(self) -> int:
        """Converts to felt."""
        return (self.high << 128) + self.low

    @staticmethod
    def from_felt(felt: int) -> "Uint256":
        """Converts felt to Uint256"""
        return Uint256(low=felt & ((1 << 128) - 1), high=felt >> 128)


class StarknetDevnetException(StarkException):
    """
    Exception raised across the project.
    Indicates the raised issue is devnet-related.
    """

    def __init__(self, code: StarknetErrorCode, status_code=500, message=None):
        super().__init__(code=code, message=message)
        self.status_code = status_code


def enable_pickling():
    """
    Extends the `StarknetContract` class to enable pickling.
    """

    def contract_getstate(self):
        return self.__dict__

    def contract_setstate(self, state):
        self.__dict__ = state

    StarknetContract.__getstate__ = contract_getstate
    StarknetContract.__setstate__ = contract_setstate


def to_bytes(value: Union[int, bytes]) -> bytes:
    """
    If int, convert to 32-byte big-endian bytes instance
    If bytes, return the received value
    """
    return value if isinstance(value, bytes) else value.to_bytes(32, "big")


def check_valid_dump_path(dump_path: str):
    """Checks if dump path is a directory. Raises ValueError if not."""

    dump_path_dir = os.path.dirname(dump_path)

    if not dump_path_dir:
        # dump_path is just a file, with no parent dir
        return

    if not os.path.isdir(dump_path_dir):
        raise ValueError(f"Invalid dump path: directory '{dump_path_dir}' not found.")


def str_to_felt(text: str) -> int:
    """Converts string to felt."""
    return int.from_bytes(bytes(text, "ascii"), "big")


async def get_all_declared_contracts(
    previous_state: CachedState,
    explicitly_declared_contracts: List[int],
    deployed_contracts: List[DeployedContract],
):
    """Returns a tuple of explicitly and implicitly declared classes"""
    declared_contracts_set = set(explicitly_declared_contracts)
    for deployed_contract in deployed_contracts:
        class_hash_bytes = to_bytes(deployed_contract.class_hash)
        try:
            await previous_state.get_contract_class(class_hash_bytes)
        except StarkException:
            declared_contracts_set.add(deployed_contract.class_hash)
    return tuple(declared_contracts_set)


async def get_storage_diffs(
    previous_state: CachedState,
    current_state: CachedState,
    visited_storage_entries: Set[StorageEntry],
):
    """Returns storages modified from change"""
    assert previous_state is not current_state

    storage_diffs: Dict[int, List[StorageEntry]] = {}

    for address, key in visited_storage_entries or {}:
        old_storage_value = await previous_state.get_storage_at(address, key)
        new_storage_value = await current_state.get_storage_at(address, key)
        if old_storage_value != new_storage_value:
            if address not in storage_diffs:
                storage_diffs[address] = []
            storage_diffs[address].append(
                StorageEntry(
                    key=key,
                    value=await current_state.get_storage_at(address, key),
                )
            )

    return storage_diffs


def get_fee_estimation_info(tx_fee: int, gas_price: int):
    """Construct fee estimation response"""

    gas_usage = tx_fee // gas_price if gas_price else 0

    return FeeEstimationInfo.load(
        {
            "overall_fee": tx_fee,
            "unit": "wei",
            "gas_price": gas_price,
            "gas_usage": gas_usage,
        }
    )


def warn(msg: str, file=sys.stderr):
    """Log a warning"""
    print(f"\033[93m{msg}\033[0m", file=file)
