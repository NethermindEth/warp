import argparse
from enum import Enum, auto
from typing import Union

from starkware.starkware_utils.error_handling import StarkException


class TxStatus(Enum):
    """
    According to: https://www.cairo-lang.org/docs/hello_starknet/intro.html#interact-with-the-contract
    """

    PENDING = auto()
    """The transaction passed the validation and is waiting to be sent on-chain."""

    NOT_RECEIVED = auto()
    """The transaction has not been received yet (i.e., not written to storage"""

    RECEIVED = auto()
    """The transaction was received by the operator."""

    REJECTED = auto()
    """The transaction failed validation and thus was skipped."""

    ACCEPTED_ONCHAIN = auto()
    """The transaction was accepted on-chain."""


def custom_int(arg: str) -> str:
    base = 16 if arg.startswith("0x") else 10
    return int(arg, base)


def fixed_length_hex(arg: int) -> str:
    """
    Converts the int input to a hex output of fixed length
    """

    return f"0x{arg:064x}"


DEFAULT_HOST = "localhost"
DEFAULT_PORT = 5000


def parse_args():
    parser = argparse.ArgumentParser(
        description="Run a local instance of Starknet devnet"
    )
    parser.add_argument(
        "--host",
        help=f"Specify the address to listen at; defaults to {DEFAULT_HOST} (use the address the program outputs on start)",
        default=DEFAULT_HOST,
    )
    parser.add_argument(
        "--port",
        "-p",
        type=int,
        help=f"Specify the port to listen at; defaults to {DEFAULT_PORT}",
        default=DEFAULT_PORT,
    )
    return parser.parse_args()


class StarknetDevnetException(StarkException):
    def __init__(self, code=500, message=None):
        super().__init__(code=code, message=message)
