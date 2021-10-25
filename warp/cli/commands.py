import json
import os
import subprocess
import sys
from http import HTTPStatus
from typing import Any, Dict, Optional, Union

import aiohttp
from cli.StarkNetEvmContract import get_evm_calldata
from eth_hash.auto import keccak
from starkware.starknet.definitions import fields
from starkware.starknet.services.api.contract_definition import ContractDefinition
from starkware.starknet.services.api.gateway.transaction import (
    Deploy,
    InvokeFunction,
    Transaction,
)
from yul.utils import cairoize_bytes

WARP_ROOT = os.path.abspath(os.path.join(__file__, "../.."))


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
async def _invoke(program_info: dict, address, function, evm_inputs):
    try:
        address = int(address, 16)
    except ValueError as e:
        raise ValueError("Invalid address format.") from e
    abi = program_info["sol_abi"]
    bytecode = program_info["sol_bytecode"]
    evm_calldata = get_evm_calldata(abi, bytecode, function, evm_inputs)
    cairo_input, unused_bytes = cairoize_bytes(bytes.fromhex(evm_calldata[2:]))
    calldata_size = (len(cairo_input) * 16) - unused_bytes
    selector = get_selector_cairo("fun_ENTRY_POINT")
    calldata = [calldata_size, unused_bytes, len(cairo_input), *cairo_input, address]
    tx = InvokeFunction(
        contract_address=address,
        entry_point_selector=selector,
        calldata=calldata,
        signature=[],
    )

    response = await send_req(
        method="POST", url="https://alpha3.starknet.io/gateway/add_transaction", tx=tx
    )
    tx_hash = json.loads(response)["transaction_hash"]
    print(
        f"""\
Invoke transaction was sent.
Contract address: 0x{address:064x}.
Transaction hash: {tx_hash}."""
    )
    return True


def starknet_compile(cairo_path, contract_base):
    compiled = f"{contract_base}_compiled.json"
    process = subprocess.Popen(
        [
            "starknet-compile",
            "--disable_hint_validation",
            f"{cairo_path}",
            "--output",
            compiled,
            "--cairo_path",
            f"{WARP_ROOT}/cairo-src",
        ]
    )
    output = process.wait()
    if output == 1:
        raise Exception("Compilation failed")
    return compiled


async def _deploy(cairo_path, contract_base):
    compiled_contract = starknet_compile(cairo_path, contract_base)
    address = fields.ContractAddressField.get_random_value()
    with open(compiled_contract) as f:
        cont = f.read()

    contract_definition = ContractDefinition.loads(cont)
    url = "https://alpha3.starknet.io/gateway/add_transaction"
    tx = Deploy(
        contract_address_salt=fields.ContractAddressSalt.get_random_value(),
        contract_definition=contract_definition,
        constructor_calldata=[],
    )

    async with aiohttp.ClientSession() as session:
        async with session.request(
            method="POST", url=url, data=Transaction.Schema().dumps(obj=tx)
        ) as response:
            text = await response.text()
            if response.status != HTTPStatus.OK:
                sys.exit(f"FAIL:\n{response}")
            tx_hash = json.loads(text)["transaction_hash"]
    address_path = f"{os.path.abspath(contract_base)}_ADDRESS.txt"
    with open(address_path, "w") as f:
        f.write(f"0x{address:064x}")
    print(
        f"""\
Deploy transaction was sent.
Contract address: 0x{address:064x}.
Transaction hash: {tx_hash}.

Contract Address Has Been Written to {address_path}
"""
    )


async def _status(tx_hash):
    status = f"https://alpha3.starknet.io/feeder_gateway/get_transaction_status?transactionHash={tx_hash}"
    res = await send_req("GET", status)
    print(json.loads(res))
