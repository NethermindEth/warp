"""Module for configuration specified by user"""

import argparse
import asyncio
import contextlib
import json
import os
import sys
from enum import Enum, auto
from typing import List

from aiohttp.client_exceptions import ClientConnectorError, InvalidURL
from marshmallow.exceptions import ValidationError
from services.external_api.client import BadRequest, RetryConfig
from starkware.python.utils import to_bytes
from starkware.starknet.core.os.class_hash import compute_class_hash
from starkware.starknet.definitions.general_config import StarknetChainId
from starkware.starknet.services.api.contract_class import ContractClass
from starkware.starknet.services.api.feeder_gateway.feeder_gateway_client import (
    FeederGatewayClient,
)

from . import __version__
from .constants import (
    DEFAULT_ACCOUNTS,
    DEFAULT_GAS_PRICE,
    DEFAULT_HOST,
    DEFAULT_INITIAL_BALANCE,
    DEFAULT_PORT,
    DEFAULT_TIMEOUT,
)
from .contract_class_wrapper import (
    DEFAULT_ACCOUNT_HASH_BYTES,
    DEFAULT_ACCOUNT_PATH,
    ContractClassWrapper,
)

NETWORK_TO_URL = {
    "alpha-goerli": "https://alpha4.starknet.io",
    "alpha-goerli2": "https://alpha4-2.starknet.io",
    "alpha-mainnet": "https://alpha-mainnet.starknet.io",
}
NETWORK_NAMES = ", ".join(NETWORK_TO_URL.keys())
CHAIN_IDS = ", ".join([member.name for member in StarknetChainId])


def _fork_network(network_id: str):
    """
    Return the URL corresponding to the provided name.
    If it's not one of predefined names, assumes it is already a URL.
    """
    return NETWORK_TO_URL.get(network_id, network_id)


def _fork_block(specifier: str):
    """Parse block specifier; allows int and 'latest'"""
    if specifier == "latest":
        return specifier

    try:
        parsed = int(specifier)
        assert parsed > 0
    except (AssertionError, ValueError):
        sys.exit(
            f"The value of --fork-block must be a non-negative integer or 'latest', got: {specifier}"
        )

    return parsed


def _chain_id(chain_id: str):
    """Parse chain id.'"""
    try:
        chain_id = StarknetChainId[chain_id]
    except KeyError:
        sys.exit(
            f"Error: The value of --chain-id must be in {{{CHAIN_IDS}}}, got: {chain_id}"
        )

    return chain_id


class DumpOn(Enum):
    """Enumerate possible dumping frequencies."""

    EXIT = auto()
    TRANSACTION = auto()


DUMP_ON_OPTIONS = [e.name.lower() for e in DumpOn]
DUMP_ON_OPTIONS_STRINGIFIED = ", ".join(DUMP_ON_OPTIONS)


def _parse_dump_on(option: str):
    """Parse dumping frequency option."""
    if option in DUMP_ON_OPTIONS:
        return DumpOn[option.upper()]
    sys.exit(
        f"Error: Invalid --dump-on option: {option}. Valid options: {DUMP_ON_OPTIONS_STRINGIFIED}"
    )


EXPECTED_ACCOUNT_METHODS = ["__execute__", "__validate__", "__validate_declare__"]


def _parse_account_class(class_path: str) -> ContractClassWrapper:
    """Parse account class"""
    class_path = os.path.abspath(class_path)

    if not os.path.isfile(class_path):
        sys.exit(f"Error: {class_path} is not a valid file")

    with open(class_path, mode="r", encoding="utf-8") as dict_file:
        try:
            loaded_dict = json.load(dict_file)
        except json.JSONDecodeError:
            sys.exit(f"Error: {class_path} is not a valid JSON file")

    try:
        contract_class = ContractClass.load(loaded_dict)
    except ValidationError:
        sys.exit(f"Error: {class_path} is not a valid contract class artifact")

    if class_path == DEFAULT_ACCOUNT_PATH:
        class_hash_bytes = DEFAULT_ACCOUNT_HASH_BYTES
    else:
        contract_methods = [entry["name"] for entry in contract_class.abi]
        missing_methods = [
            m for m in EXPECTED_ACCOUNT_METHODS if m not in contract_methods
        ]
        if missing_methods:
            sys.exit(
                f"Error: {class_path} is missing account methods: {', '.join(missing_methods)}"
            )
        class_hash_bytes = to_bytes(compute_class_hash(contract_class))

    return ContractClassWrapper(contract_class, class_hash_bytes)


def _get_feeder_gateway_client(url: str, block_id: str):
    """Construct a feeder gateway client at url and block"""

    feeder_gateway_client = FeederGatewayClient(
        url=url,
        retry_config=RetryConfig(n_retries=1),
    )

    try:
        # FeederGatewayClient is implemented in such a way that it logs and raises;
        # this suppreses the logging
        with contextlib.redirect_stderr(None):
            block = asyncio.run(feeder_gateway_client.get_block(block_number=block_id))
            block_number = block.block_number
    except InvalidURL:
        sys.exit(
            f"Error: Invalid fork-network (must be a URL or one of {{{NETWORK_NAMES}}}). Received: {url}"
        )
    except BadRequest as bad_request:
        if bad_request.status_code == 404:
            msg = f"Error: {url} is not a valid StarkNet sequencer"
        else:
            msg = f"Error: {bad_request}"

        sys.exit(msg)
    except ClientConnectorError as error:
        sys.exit(f"Error: {error}")

    return feeder_gateway_client, block_number


class NonNegativeAction(argparse.Action):
    """
    Action for parsing the non negative int argument.
    """

    def __call__(self, parser, namespace, values, option_string=None):
        error_msg = f"{option_string} must be a positive integer; got: {values}."
        try:
            value = int(values)
        except ValueError:
            parser.error(error_msg)

        if value < 0:
            parser.error(error_msg)

        setattr(namespace, self.dest, value)


def parse_args(raw_args: List[str]):
    """
    Parses CLI arguments.
    """
    parser = argparse.ArgumentParser(
        description="Run a local instance of StarkNet Devnet"
    )
    parser.add_argument(
        "-v",
        "--version",
        help="Print the version",
        action="version",
        version=__version__,
    )
    parser.add_argument(
        "--host",
        help=f"Specify the address to listen at; defaults to {DEFAULT_HOST} "
        "(use the address the program outputs on start)",
        default=DEFAULT_HOST,
    )
    parser.add_argument(
        "--port",
        "-p",
        type=int,
        help=f"Specify the port to listen at; defaults to {DEFAULT_PORT}",
        default=DEFAULT_PORT,
    )
    parser.add_argument(
        "--load-path", help="Specify the path from which the state is loaded on startup"
    )
    parser.add_argument("--dump-path", help="Specify the path to dump to")
    parser.add_argument(
        "--dump-on",
        help=f"Specify when to dump; can dump on: {DUMP_ON_OPTIONS_STRINGIFIED}",
        type=_parse_dump_on,
    )
    parser.add_argument(
        "--lite-mode",
        action="store_true",
        help="Introduces speed-up by skipping block hash calculation"
        " - applies sequential numbering instead (0x0, 0x1, 0x2, ...).",
    )
    parser.add_argument(
        "--accounts",
        action=NonNegativeAction,
        help=f"Specify the number of accounts to be predeployed; defaults to {DEFAULT_ACCOUNTS}",
        default=DEFAULT_ACCOUNTS,
    )
    parser.add_argument(
        "--initial-balance",
        "-e",
        action=NonNegativeAction,
        help="Specify the initial balance of accounts to be predeployed; "
        f"defaults to {DEFAULT_INITIAL_BALANCE:g}",
        default=DEFAULT_INITIAL_BALANCE,
    )
    parser.add_argument(
        "--seed",
        type=int,
        help="Specify the seed for randomness of accounts to be predeployed",
    )
    parser.add_argument(
        "--hide-predeployed-accounts",
        action="store_true",
        help="Prevents from printing the predeployed accounts details",
    )
    parser.add_argument(
        "--start-time",
        action=NonNegativeAction,
        help="Specify the start time of the genesis block in Unix time seconds",
    )
    parser.add_argument(
        "--gas-price",
        "-g",
        action=NonNegativeAction,
        default=DEFAULT_GAS_PRICE,
        help=f"Specify the gas price in wei per gas unit; defaults to {DEFAULT_GAS_PRICE:g}",
    )
    parser.add_argument(
        "--timeout",
        "-t",
        action=NonNegativeAction,
        default=DEFAULT_TIMEOUT,
        help=f"Specify the server timeout in seconds; defaults to {DEFAULT_TIMEOUT}",
    )
    parser.add_argument(
        "--account-class",
        help="Specify the account implementation to be used for predeploying; "
        "should be a path to the compiled JSON artifact; "
        "defaults to OpenZeppelin v1",
        type=_parse_account_class,
        default=DEFAULT_ACCOUNT_PATH,
    )
    parser.add_argument(
        "--fork-network",
        type=_fork_network,
        help="Specify the network to fork: can be a URL (e.g. https://alpha-mainnet.starknet.io) "
        f"or network name (valid names: {', '.join(NETWORK_TO_URL.keys())})",
    )
    parser.add_argument(
        "--fork-block",
        type=_fork_block,
        help="Specify the block number where the --fork-network is forked; defaults to latest",
    )
    parser.add_argument(
        "--chain-id",
        type=_chain_id,
        default=StarknetChainId.TESTNET,
        help=f"Specify the chain id as string: {{{CHAIN_IDS}}}",
    )

    parsed_args = parser.parse_args(raw_args)
    if parsed_args.dump_on and not parsed_args.dump_path:
        sys.exit("Error: --dump-path required if --dump-on present")

    if parsed_args.fork_block and not parsed_args.fork_network:
        sys.exit("Error: --fork-network required if --fork-block present")

    if parsed_args.fork_network:
        parsed_args.fork_block = parsed_args.fork_block or "latest"
        parsed_args.fork_network, parsed_args.fork_block = _get_feeder_gateway_client(
            parsed_args.fork_network, parsed_args.fork_block
        )

    return parsed_args


# pylint: disable=too-few-public-methods
# pylint: disable=too-many-instance-attributes
class DevnetConfig:
    """Class holding configuration specified by user"""

    def __init__(self, args: argparse.Namespace = None):
        # these args are used in tests; in production, this is overwritten in `main`
        self.args = args or parse_args(["--accounts", "0"])
        self.accounts = self.args.accounts
        self.initial_balance = self.args.initial_balance
        self.seed = self.args.seed
        self.start_time = self.args.start_time
        self.gas_price = self.args.gas_price
        self.lite_mode = self.args.lite_mode
        self.account_class = self.args.account_class
        self.hide_predeployed_accounts = self.args.hide_predeployed_accounts
        self.fork_network = self.args.fork_network
        self.fork_block = self.args.fork_block
        self.chain_id = self.args.chain_id
