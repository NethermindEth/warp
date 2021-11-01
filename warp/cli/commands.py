import json
import os
import subprocess
from http import HTTPStatus
from typing import Any, Dict, Optional, Union

import aiohttp
import click
from cli.StarkNetEvmContract import get_evm_calldata
from eth_hash.auto import keccak
from starkware.starknet.definitions import fields
from starkware.starknet.services.api.contract_definition import ContractDefinition
from starkware.starknet.services.api.gateway.transaction import (
    Deploy,
    InvokeFunction,
    Transaction,
)
from yul.utils import cairoize_bytes, get_low_high

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
    with open(os.path.join(artifacts_dir, "MAIN_CONTRACT")) as f:
        main_contract = f.read()
    evm_calldata = get_evm_calldata(source_name, main_contract, function, inputs)
    cairo_input, unused_bytes = cairoize_bytes(bytes.fromhex(evm_calldata[2:]))
    calldata_size = (len(cairo_input) * 16) - unused_bytes

    try:
        address = int(address, 16)
    except ValueError:
        raise ValueError("Invalid address format.")

    selector = get_selector_cairo("fun_ENTRY_POINT")
    calldata = [calldata_size, unused_bytes, len(cairo_input)] + cairo_input

    calldata.append(address)
    tx = InvokeFunction(
        contract_address=address, entry_point_selector=selector, calldata=calldata
    )

    response = await send_req(
        method="POST", url="https://alpha3.starknet.io/gateway/add_transaction", tx=tx
    )
    tx_id = json.loads(response)
    print(
        f"""\
Invoke transaction was sent.
Contract address: 0x{address:064x}.
Transaction Hash: {tx_id}."""
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

    url = "https://alpha3.starknet.io/feeder_gateway/call_contract?blockId=null"
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


def flatten(l):
    for i in l:
        if isinstance(i, int):
            yield i
        else:
            yield from flatten(i)


async def _deploy(
    contract_path, has_constructor, dyn_arg_constructor, constructor_args
):
    contract_name = contract_path[:-6]
    with open(contract_path) as f:
        cairo_src = f.read()

    compiled_contract, abi = starknet_compile(contract_path)
    address = fields.ContractAddressField.get_random_value()
    with open(compiled_contract) as f:
        cont = f.read()

    contract_definition = ContractDefinition.loads(cont)
    url = "https://alpha3.starknet.io/gateway/add_transaction"
    if has_constructor and dyn_arg_constructor:
        with open(os.path.join(artifacts_dir, "MAIN_CONTRACT")) as f:
            main_contract = f.read()
        evm_calldata = get_evm_calldata(
            contract_name + "_marked.sol",
            main_contract,
            "__warp_ctorHelper_DynArgs",
            constructor_args,
        )
        os.remove(contract_name + "_marked.sol")
        cairo_input, unused_bytes = cairoize_bytes(bytes.fromhex(evm_calldata[2:]))
        calldata_size = (len(cairo_input) * 16) - unused_bytes
        ctor_calldata = [calldata_size, len(cairo_input)] + cairo_input
        tx = Deploy(
            contract_address_salt=address,
            contract_definition=contract_definition,
            constructor_calldata=ctor_calldata,
        )
    elif has_constructor and not dyn_arg_constructor:
        os.remove(contract_name + "_marked.sol")
        flattened_args = list(flatten(constructor_args))
        split_args = []
        for arg in flattened_args:
            high, low = divmod(arg, 2 ** 128)
            split_args += [low, high]
        tx = Deploy(
            contract_address_salt=address,
            contract_definition=contract_definition,
            constructor_calldata=split_args,
        )
    elif not has_constructor:
        os.remove(contract_name + "_marked.sol")
        tx = Deploy(
            contract_address_salt=address,
            contract_definition=contract_definition,
            constructor_calldata=[],
        )
    else:
        raise Exception(
            "Hit should-be-unreachable else case in commands.py in function _deploy(..), line 149"
        )

    async with aiohttp.ClientSession() as session:
        async with session.request(
            method="POST", url=url, data=Transaction.Schema().dumps(obj=tx)
        ) as response:
            text = await response.text()
            if response.status != HTTPStatus.OK:
                print("FAIL")
                print(response)

            tx_hash = json.loads(text)["transaction_hash"]
            contract_address = json.loads(text)["address"]
            print(
                f"""\
Deploy transaction was sent.
Contract address: {contract_address}.
Transaction Hash: {tx_hash}.

Contract Address Has Been Written to {os.path.abspath(contract_name)}_ADDRESS.txt
"""
            )
    with open(f"{os.path.abspath(contract_name)}_ADDRESS.txt", "w") as f:
        f.write(contract_address)
    return contract_address


async def _status(tx_hash):
    status = f"https://alpha3.starknet.io/feeder_gateway/get_transaction_status?transactionHash={tx_hash}"
    res = await send_req("GET", status)
    print(json.loads(res))
