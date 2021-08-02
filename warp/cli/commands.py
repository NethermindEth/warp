import json
from typing import Any, Dict, Optional, Union
import aiohttp
import asyncio
from starkware.starknet.services.api.gateway.transaction import (
    InvokeFunction,
    Transaction,
)
from transpiler.EvmToCairo import EvmToCairo, parse_operations
from eth_hash.auto import keccak
import os, sys
from starkware.cairo.lang.compiler.parser import parse_file

TEST_ENV = ""
artifacts_dir = os.path.join(os.path.expanduser("~"), ".warp", "artifacts")


def get_selector(args: str) -> int:
    return int.from_bytes(keccak(args.encode("ascii")), "big") & (2 ** 250 - 1)


async def send_req(method, url, tx: Optional[Union[str, Dict[str, Any]]] = None):
    if tx is not None:
        async with aiohttp.ClientSession() as session:
            async with session.request(
                method=method, url=url, data=Transaction.Schema().dumps(obj=tx)
            ) as response:
                text = await response.text()
                return text
    else:
        async with aiohttp.ClientSession() as session:
            async with session.request(method=method, url=url, data=None) as response:
                text = await response.text()
                return text


def _transpile(file):
    evm_to_cairo = EvmToCairo(cur_evm_pc=0)
    with open(file, "r") as opcodes_file:
        operations = list(parse_operations(opcodes_file))
        for op in operations:
            op.inspect_program(operations)

        for op in operations:
            evm_to_cairo.process_operation(op)

    os.remove(file)
    return parse_file(evm_to_cairo.finish(True)).format()


# returns true/false on transaction success/failure
async def _invoke(address, abi, function, inputs):
    with open(os.path.join(artifacts_dir, "selector_jumpdests.json")) as f:
        jumpdests = json.load(f)
    for k, v in jumpdests.items():
        if function in v["signature"]:
            jump_dest = v["jumpdest"]
            break
    else:
        sys.exit("You did not enter a correct function name")

    with open(abi) as f:
        abi = json.load(f)

    try:
        address = int(address, 16)
    except ValueError:
        raise ValueError("Invalid address format.")

    selector = get_selector("main")
    calldata = inputs
    tx = InvokeFunction(
        contract_address=address, entry_point_selector=selector, calldata=calldata
    )

    response = await send_req(
        method="POST", url=f"{TEST_ENV}/gateway/add_transaction", tx=tx
    )
    tx_id = json.loads(response)["tx_id"]
    print(
        f"""\
Invoke transaction was sent.
Contract address: 0x{address:064x}.
Transaction ID: {tx_id}."""
    )
    return True


async def _call(address, abi, function, inputs) -> bool:
    with open(abi) as f:
        abi = json.load(f)

    try:
        address = int(address, 16)
    except ValueError:
        raise ValueError("Invalid address format.")

    selector = get_selector(function)
    calldata = inputs
    tx = InvokeFunction(
        contract_address=address, entry_point_selector=selector, calldata=calldata
    )

    url = f"{TEST_ENV}/feeder_gateway/call_contract?blockId=null"
    async with aiohttp.ClientSession() as session:
        async with session.request(method="POST", url=url, data=tx.dumps()) as response:
            raw_resp = await response.text()
            resp = json.loads(raw_resp)
        return resp["result"][0]