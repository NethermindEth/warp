import json
import os
import subprocess
from typing import Any, Dict, Optional, Sequence, Union

import aiohttp
from starkware.starknet.services.api.gateway.transaction import Transaction

from warp.cli.encoding import (
    get_cairo_calldata,
    get_ctor_evm_calldata,
    get_evm_calldata,
)

WARP_ROOT = os.path.abspath(os.path.join(__file__, "../.."))


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
async def _invoke(
    contract_base, program_info: dict, address, function, evm_inputs, network: str
):
    evm_calldata = get_evm_calldata(program_info["sol_abi"], function, evm_inputs)
    cairo_calldata = get_cairo_calldata(evm_calldata)
    starknet_invoke(contract_base, address, cairo_calldata, network)
    return True


def starknet_invoke(
    contract_base, address, cairo_calldata: Sequence[int], network: str
):
    abi = f"{contract_base}_abi.json"
    inputs = " ".join(map(str, cairo_calldata))
    print(
        os.popen(
            f"starknet invoke "
            f"--address {address} "
            f"--abi {abi} "
            f"--function __main "
            f"--inputs {inputs} "
            f"--network {network} "
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


async def _deploy(
    cairo_path, contract_base, program_info, constructor_args, network: str
):
    evm_calldata = get_ctor_evm_calldata(program_info["sol_abi"], constructor_args)
    cairo_calldata = get_cairo_calldata(evm_calldata)
    starknet_deploy(contract_base, cairo_path, cairo_calldata, network)


def starknet_deploy(
    contract_base, cairo_path, cairo_calldata: Sequence[int], network: str
):
    compiled_contract = starknet_compile(cairo_path, contract_base)
    inputs = " ".join(map(str, cairo_calldata))
    print(
        os.popen(
            f"starknet deploy "
            f"--contract {contract_base}_compiled.json "
            f"--inputs {inputs} "
            f"--network {network} "
        ).read()
    )

    return compiled_contract


async def _status(tx_hash):
    status = f"https://alpha3.starknet.io/feeder_gateway/get_transaction_status?transactionHash={tx_hash}"
    res = await send_req("GET", status)
    print(json.loads(res))
