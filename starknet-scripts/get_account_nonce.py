
from starkware.starknet.cli.starknet_cli import load_account_from_args, handle_network_param, get_feeder_gateway_client
from starkware.starknet.wallets.account import DEFAULT_ACCOUNT_DIR
from starkware.cairo.lang.version import __version__
from starkware.starknet.services.api.feeder_gateway.response_objects import PENDING_BLOCK_ID


import argparse
import sys
import traceback
import asyncio


async def get_nonce(address: int, args:argparse.Namespace) -> int:
    feeder_gateway_client = get_feeder_gateway_client(args)
    return await feeder_gateway_client.get_nonce(
        contract_address=address, block_hash=None, block_number=PENDING_BLOCK_ID
    )

async def main():
    parser = argparse.ArgumentParser(description="A tool to communicate with StarkNet.")

    parser.add_argument("-v", "--version", action="version", version=f"%(prog)s {__version__}")
    parser.add_argument("--network", type=str, help="The name of the StarkNet network.")
    parser.add_argument(
        "--network_id",
        type=str,
        help="A textual identifier of the network. Used for account management.",
    )
    parser.add_argument(
        "--chain_id",
        type=str,
        help="The chain id (either as a hex number or as a string).",
    )
    wallet_parser_group = parser.add_mutually_exclusive_group(required=False)
    wallet_parser_group.add_argument(
        "--wallet",
        type=str,
        help="The name of the wallet, including the python module and wallet class.",
    )
    wallet_parser_group.add_argument(
        "--no_wallet",
        dest="wallet",
        action="store_const",
        const="",
        help="Perform a direct contract call without an account contract.",
    )
    parser.add_argument(
        "--account",
        type=str,
        default="__default__",
        help=(
            "The name of the account. If not given, the default account "
            "(as defined by the wallet) is used."
        ),
    )
    parser.add_argument(
        "--account_dir",
        type=str,
        help=f"The directory containing the account files (default: '{DEFAULT_ACCOUNT_DIR}').",
    )
    parser.add_argument(
        "--flavor",
        type=str,
        choices=["Debug", "Release", "RelWithDebInfo"],
        help="Build flavor.",
    )
    parser.add_argument(
        "--show_trace",
        action="store_true",
        help="Print the full Python error trace in case of an internal error.",
    )

    parser.add_argument("--gateway_url", type=str, help="The URL of a StarkNet gateway.")
    parser.add_argument(
        "--feeder_gateway_url", type=str, help="The URL of a StarkNet feeder gateway."
    )
    parser.add_argument("command", choices=['get_nonce'])
    args, _ = parser.parse_known_args()

    ret = handle_network_param(args)
    if ret != 0:
        return ret

    try:
        account = await load_account_from_args(args)
        account_info = account.get_account_information()
        print(await get_nonce(int(account_info["address"], 16), args))
    except Exception as exc:
        print(f"Error: {type(exc).__name__}: {exc}", file=sys.stderr)
        if args.show_trace:
            print(file=sys.stderr)
            traceback.print_exc()
        return 1


if __name__ == "__main__":
    asyncio.run(main())

