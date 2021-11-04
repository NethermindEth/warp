import json
import os
import subprocess
import sys
from http import HTTPStatus
from typing import Any, Dict, List, Optional, Union

import aiohttp
import click
from cli.StarkNetEvmContract import evm_to_cairo_calldata, get_evm_calldata
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
async def _invoke(contract_base, program_info: dict, address, function, evm_inputs):
    calldata_evm = get_evm_calldata(
        program_info["sol_abi"],
        program_info["sol_abi_original"],
        program_info["sol_bytecode"],
        function,
        evm_inputs,
    )
    cairo_input, unused_bytes = cairoize_bytes(bytes.fromhex(calldata_evm[2:]))
    calldata_size = (len(cairo_input) * 16) - unused_bytes
    calldata = [calldata_size, len(cairo_input)] + cairo_input + [address]
    calldata = " ".join(str(x) for x in calldata)
    starknet_invoke(contract_base, address, calldata)
    return True


def starknet_invoke(contract_base, address, inputs):
    abi = f"{contract_base}_abi.json"
    print(
        os.popen(
            f"starknet invoke "
            f"--address {address} "
            f"--abi {abi} "
            f"--function fun_ENTRY_POINT "
            f"--inputs {inputs} "
            f"--network alpha "
        ).read()
    )


def starknet_compile(cairo_path, contract_base):
    compiled = f"{contract_base}_compiled.json"
    abi = f"{contract_base}_abi.json"
    process = subprocess.Popen(
        [
            "starknet-compile",
            cairo_path,
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
    return compiled


async def _deploy(cairo_path, contract_base, program_info, constructor_args):
    if "constructor" in program_info["dynamic_argument_functions"]:
        calldata_evm = get_evm_calldata(
            program_info["sol_abi"],
            program_info["sol_abi_original"],
            program_info["sol_bytecode"],
            "__warp_ctorHelper_DynArgs",
            constructor_args,
        )
        cairo_input, unused_bytes = cairoize_bytes(bytes.fromhex(calldata_evm[2:]))
        calldata_size = (len(cairo_input) * 16) - unused_bytes
        calldata = [calldata_size, len(cairo_input)] + cairo_input
    else:
        calldata = constructor_args
    starknet_deploy(contract_base, cairo_path, calldata)


def starknet_deploy(
    contract_base,
    cairo_path,
    calldata: Optional[List[int]] = None,
):
    compiled_contract = starknet_compile(cairo_path, contract_base)
    inputs = calldata or []
    inputs_str = " ".join(map(str, inputs))
    print(
        os.popen(
            f"starknet deploy "
            f"--contract {contract_base}_compiled.json "
            f"--inputs {inputs_str} "
            f"--network alpha "
        ).read()
    )

    return compiled_contract


async def _status(tx_hash):
    status = f"https://alpha3.starknet.io/feeder_gateway/get_transaction_status?transactionHash={tx_hash}"
    res = await send_req("GET", status)
    print(json.loads(res))


def flatten(l):
    for i in l:
        if isinstance(i, int):
            yield i
        else:
            yield from flatten(i)
