import os
import json
import asyncio
import aiohttp
import subprocess
from web3 import Web3
from http import HTTPStatus
from eth_hash.auto import keccak
from typing import Any, Dict, Optional, Union
from starkware.starknet.definitions import fields
from starkware.cairo.lang.compiler.parser import parse_file
from starkware.starknet.services.api.gateway.transaction import (
    InvokeFunction,
    Transaction,
    Deploy,
)
from starkware.starknet.services.api.contract_definition import ContractDefinition
from transpiler.utils import cairoize_bytes
from yul.main import generate_cairo

WARP_ROOT = os.path.abspath(os.path.join(__file__, "../.."))
artifacts_dir = os.path.join(os.path.abspath("."), "artifacts")


def get_selector_cairo(args: str) -> int:
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


# returns true/false on transaction success/failure
async def _invoke(source_name, address, function, inputs):
    with open(
        os.path.join(artifacts_dir, f"{source_name[:-6]}_selector_jumpdests.json")
    ) as f:
        jumpdests = json.load(f)
    with open(os.path.join(artifacts_dir, f"{source_name[:-6]}_abi.json")) as f:
        cairo_abi = json.load(f)
    with open(os.path.join(artifacts_dir, f"{source_name[:-6]}_sol_abi.json")) as f:
        evm_abi = json.load(f)
    with open(
        os.path.join(artifacts_dir, f"{source_name[:-6]}_bytecode"),
        "r",
    ) as f:
        bytecode = f.read()

    w3 = Web3()
    evm_contract = w3.eth.contract(abi=evm_abi, bytecode=bytecode)
    evm_calldata = evm_contract.encodeABI(fn_name=function, args=inputs)
    cairo_input, unused_bytes = cairoize_bytes(bytes.fromhex(evm_calldata[2:]))
    calldata_size = (len(cairo_input) * 16) - unused_bytes
    try:
        address = int(address, 16)
    except ValueError:
        raise ValueError("Invalid address format.")

    selector = get_selector_cairo("main")
    calldata = [calldata_size, unused_bytes, len(cairo_input)] + cairo_input
    tx = InvokeFunction(
        contract_address=address, entry_point_selector=selector, calldata=calldata
    )

    response = await send_req(
        method="POST", url="https://alpha1.starknet.io/gateway/add_transaction", tx=tx
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

    selector = get_selector_cairo(function)
    calldata = inputs
    tx = InvokeFunction(
        contract_address=address, entry_point_selector=selector, calldata=calldata
    )

    url = "https://alpha1.starknet.io/feeder_gateway/call_contract?blockId=null"
    async with aiohttp.ClientSession() as session:
        async with session.request(method="POST", url=url, data=tx.dumps()) as response:
            raw_resp = await response.text()
            resp = json.loads(raw_resp)
        return resp["result"][0]


def starknet_compile(contract):
    compiled = os.path.join(artifacts_dir, f"{contract[:-6]}_compiled.json")
    abi = os.path.join(artifacts_dir, f"{contract[:-6]}_abi.json")
    process = subprocess.Popen(
        [
            "starknet-compile",
            "--disable_hint_validation",
            f"{contract}",
            "--output",
            compiled,
            "--abi",
            abi,
            "--cairo_path",
            f"{WARP_ROOT}/cairo-src",
        ]
    )
    output = process.wait()
    if output == 1:
        raise Exception("Compilation failed")
    return compiled, abi


async def _deploy(contract_path):
    contract_name = contract_path[:-6]
    compiled_contract, abi = starknet_compile(contract_path)
    address = fields.ContractAddressField.get_random_value()
    with open(compiled_contract) as f:
        cont = f.read()

    contract_definition = ContractDefinition.loads(cont)
    url = "https://alpha1.starknet.io/gateway/add_transaction"
    tx = Deploy(contract_address=address, contract_definition=contract_definition)

    async with aiohttp.ClientSession() as session:
        async with session.request(
            method="POST", url=url, data=Transaction.Schema().dumps(obj=tx)
        ) as response:
            text = await response.text()
            if response.status != HTTPStatus.OK:
                print(response.status)

            tx_id = json.loads(text)["tx_id"]
            print(
                f"""\
Deploy transaction was sent.
Contract address: 0x{address:064x}.
Transaction ID: {tx_id}.

Contract Address Has Been Written to {os.path.abspath(contract_name)}_ADDRESS.txt
"""
            )
    with open(f"{os.path.abspath(contract_name)}_ADDRESS.txt", "w") as f:
        f.write(f"0x{address:064x}")
    return f"0x{address:064x}"


async def _status(tx_id):
    status = f"https://alpha1.starknet.io/feeder_gateway/get_transaction_status?transactionId={tx_id}"
    res = await send_req("GET", status)
    print(json.loads(res))
