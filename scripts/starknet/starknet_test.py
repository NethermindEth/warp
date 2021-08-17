from __future__ import annotations
import aiohttp
import asyncio
import json
import math
import ntpath
import os, sys
import subprocess
from typing import Any, Dict, Optional, Union
from http import HTTPStatus
from eth_hash.auto import keccak
from starkware.starknet.definitions import fields
from starkware.starknet.cli.starknet_cli import deploy
from starkware.starknet.services.api.gateway.transaction import Transaction
from starkware.starknet.services.api.contract_definition import ContractDefinition
from starkware.starknet.services.api.gateway.transaction import Deploy, InvokeFunction

WARP_ROOT = os.path.abspath(os.path.join(__file__, "../../.."))

from transpiler.EvmToCairo import EvmToCairo, parse_operations
from transpiler.utils import cairoize_bytes

from starkware.cairo.lang.compiler.parser import parse_file

starknet_dir = os.path.join(WARP_ROOT, "tests", "starknet")
OPCODES_PATH = os.path.join(starknet_dir, "opcodes")
ARTIFACTS_DIR = os.path.join(starknet_dir, "artifacts")
TEST_ENV = os.getenv("STARKNET_ENV")


def tx_accepted():
    return True


def tx_not_received():
    return False


def tx_received():
    return False


def tx_pending():
    return True


stat_resp = {
    "ACCEPTED_ONCHAIN": tx_accepted,
    "NOT_RECEIVED": tx_not_received,
    "RECEIVED": tx_received,
    "PENDING": tx_pending,
}


def get_selector(args: str) -> int:
    return int.from_bytes(keccak(args.encode("ascii")), "big") & (2 ** 250 - 1)


def transpile_opcodes(warp_root, opcode_groups):
    contracts = []
    count = 1
    for opcode_group in opcode_groups:
        opcodes_file_path = os.path.join(ARTIFACTS_DIR, f"opcodes_group_{count}.opcode")
        cairo_file_path = os.path.join(ARTIFACTS_DIR, f"generated_{count}.cairo")
        evm_to_cairo = EvmToCairo(cur_evm_pc=0)

        with open(opcodes_file_path, "r") as opcodes_file:
            operations = list(parse_operations(opcodes_file))
            for op in operations:
                op.inspect_program(operations)

            for op in operations:
                evm_to_cairo.process_operation(op)

        with open(cairo_file_path, "w") as cairo_file:
            cairo_file.writelines(parse_file(evm_to_cairo.finish(True)).format())

        contracts.append(cairo_file_path)
        count += 1
    return contracts


def get_opcode_files(opcodes_path, n_groups):
    opcodes = [os.path.join(opcodes_path, f) for f in os.listdir(opcodes_path)]
    opcodes.sort()
    ret = []
    l = len(opcodes) // n_groups
    rem = len(opcodes) % l
    # TEMP: for example
    if n_groups == 2:
        return [opcodes[:l], opcodes[l:]]
    else:
        for x in range(0, len(opcodes) - rem, l):
            ret.append(opcodes[x : x + l])
        if rem != 0:
            ret[n_groups - 1] += opcodes[len(opcodes) - rem : len(opcodes)]
        return ret


def get_gold_result(opcode_name):
    opcode = ntpath.basename(opcode_name)
    with open(os.path.join(OPCODES_PATH, "gold", f"{opcode}.gold.result")) as f:
        data = f.readlines()
        return int(data[1]), int(data[2])


def group_opcodes(warp_root, opcodes_grouped):
    storage_tables = []
    group_count = 1
    for op_group in opcodes_grouped:
        file_path = os.path.join(ARTIFACTS_DIR, f"opcodes_group_{group_count}.opcode")
        storage_table_file = os.path.join(
            ARTIFACTS_DIR, f"storage_table_group_{group_count}.json"
        )
        storage_addr_count = 0
        storage_table = {}
        grouped_opcodes = []
        l = len(op_group)
        for opcode in op_group:
            current_file = ""
            if os.path.isdir(opcode):
                continue
            with open(opcode, "rt") as f:
                grouped_opcodes += f.readlines()
                if not grouped_opcodes[-1].endswith("\n"):
                    grouped_opcodes[-1] += "\n"
                current_file = ntpath.basename(f.name)
            push_bytes = int(math.ceil(len(hex(storage_addr_count)[2:]) / 2))
            grouped_opcodes += [
                f"PUSH{push_bytes} {hex(storage_addr_count)}\n",
                "SSTORE\n",
            ]
            # i doubt we will ever have more than 2^128 tests
            low_gold, high_gold = get_gold_result(opcode)
            storage_table[f"{current_file}"] = {
                "storage_addr_low": storage_addr_count,
                "gold_res_low": low_gold,
                "gold_res_high": high_gold,
            }
            storage_addr_count += 1

        if not os.path.isdir(os.path.dirname(file_path)):
            os.mkdir(os.path.dirname(file_path))

        with open(file_path, "w") as f:
            f.writelines(grouped_opcodes)

        with open(storage_table_file, "w") as f:
            json.dump(storage_table, f, indent=4)
        group_count += 1
        storage_tables.append(storage_table)
    return storage_tables


def golden_test(result, gold_result, opcode):
    assert (
        int(result) == gold_result
    ), f"""
 ✗ {opcode} Test Failed
 Expected: {gold_result}
 Got:      {int(result)}"""
    print(
        f"""
 ✓ {opcode}
"""
    )


async def do_golden_test(opcode, test, abi, address):
    args_low = get_storage_args(
        abi,
        address,
        "get_storage_low",
        [int(test["storage_addr_low"]), 0],
    )
    result_low = await invoke_or_call(args_low, call=True)
    golden_test(result_low, int(test["gold_res_low"]), opcode)
    args_high = get_storage_args(
        abi,
        address,
        "get_storage_high",
        [int(test["storage_addr_low"]), 0],
    )
    result_high = await invoke_or_call(args_high, call=True)
    golden_test(result_high, int(test["gold_res_high"]), opcode)


def generate_test_funcs(storage_tables, abis, addresses):
    funcs = ""
    for i in range(len(abis)):
        funcs += (
            "\n"
            + ",\n".join(
                f'\tdo_golden_test("{opcode}", {test}, "{abis[i]}","{addresses[i]}")'
                for opcode, test in storage_tables[i].items()
            )
            + ","
        )
    return funcs


def get_compiled_contracts(contract_list):
    a = []
    for contract in contract_list:
        a.append(f"{contract[:-6]}_compiled.json")
    return a


def get_abis(contract_list):
    a = []
    for contract in contract_list:
        a.append(os.path.join(ARTIFACTS_DIR, f"{contract[:-6]}_abi.json"))
    return a


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


def starknet_compile(contracts):
    processes = []
    for contract in contracts:
        processes.append(
            subprocess.Popen(
                [
                    "starknet-compile",
                    "--disable_hint_validation",
                    f"{contract}",
                    "--output",
                    f"{contract[:-6]}_compiled.json",
                    "--abi",
                    f"{contract[:-6]}_abi.json",
                    "--cairo_path",
                    f"{WARP_ROOT}/warp/cairo-src",
                ]
            )
        )
    output = [p.wait() for p in processes]
    if 1 in output:
        raise Exception("Compilation failed")
    return 0


async def tx_status(tx_id):
    status = f"{TEST_ENV}/feeder_gateway/get_transaction_status?transactionId={tx_id}"
    res = await send_req("GET", status)
    return json.loads(res)["tx_status"], json.loads(res)


async def wait_tx_confirmed(tx_id):
    while True:
        status, full = await tx_status(tx_id)
        print(status)
        print(full)
        if status == "REJECTED":
            print("REJECTED")
            sys.exit("Transaction rejected")
        if status == "PENDING":
            return True
        await asyncio.sleep(2)


async def deploy(compiled_contract):
    address = fields.ContractAddressField.get_random_value()
    with open(compiled_contract) as f:
        cont = f.read()

    contract_definition = ContractDefinition.loads(cont)
    url = f"{TEST_ENV}/gateway/add_transaction"
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
Transaction ID: {tx_id}."""
            )
    deploy_status = await wait_tx_confirmed(tx_id)
    return f"0x{address:064x}"


# returns true/false on transaction success/failure
async def invoke_or_call(args, call: bool) -> bool:
    with open(args["abi"]) as f:
        abi = json.load(f)

    try:
        address = int(args["address"], 16)
    except ValueError:
        raise ValueError("Invalid address format.")
    for abi_entry in abi:
        if abi_entry["type"] == "function" and abi_entry["name"] == args["function"]:
            break
    else:
        raise Exception(f'Function {args["function"]} not found.')

    selector = get_selector(args["function"])
    try:
        calldata = args["inputs"]
    except KeyError:
        calldata = []
    tx = InvokeFunction(
        contract_address=address, entry_point_selector=selector, calldata=calldata
    )

    if call:
        url = f"{TEST_ENV}/feeder_gateway/call_contract?blockId=null"
        async with aiohttp.ClientSession() as session:
            async with session.request(
                method="POST", url=url, data=tx.dumps()
            ) as response:
                raw_resp = await response.text()
                resp = json.loads(raw_resp)
            return resp["result"][0]
    else:
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
        tx_result = await wait_tx_confirmed(tx_id)
        return True


def initialize_entry_args(abis, addresses):
    bs = b"\x01\x02\x03\x04\x05\x06"
    payload, unused_bytes = cairoize_bytes(bs)
    payload_len = len(payload)
    return [
        {
            "abi": abi,
            "address": address,
            "function": "main",
            "inputs": [3, unused_bytes, payload_len, *payload],
        }
        for abi, address in zip(abis, addresses)
    ]


def get_storage_args(abi, address, function, inputs):
    return {
        "abi": abi,
        "address": address,
        "function": function,
        "inputs": inputs,
    }


async def main():
    ops_gather_into_n = get_opcode_files(OPCODES_PATH, 2)
    test_tables = group_opcodes(
        WARP_ROOT,
        ops_gather_into_n,
    )
    contracts = transpile_opcodes(
        WARP_ROOT,
        ops_gather_into_n,
    )
    starknet_compile(contracts)
    compiles = get_compiled_contracts(contracts)
    addresses = await asyncio.gather(
        deploy(compiles[0]),
        deploy(compiles[1]),
    )
    abis = get_abis(contracts)
    entry_args = initialize_entry_args(abis, addresses)
    results = await asyncio.gather(
        invoke_or_call(entry_args[0], call=False),
        invoke_or_call(entry_args[1], call=False),
    )
    return (
        addresses,
        test_tables,
        abis,
    )


if __name__ == "__main__":
    if len(sys.argv) == 2:
        TEST_ENV = sys.argv[1]
    if TEST_ENV is None:
        sys.exit(
            """
Please, either provide a feeder gateway URL as an environment
variable STARKNET_ENV or supply it as a program argument"""
        )
    addresses, tables, abis = asyncio.run(main())
    # executes all tests concurrently, so it takes around 5 seconds
    # instead of 3-4 minutes
    tests = f"""
async def do():
    await asyncio.gather(
{generate_test_funcs(tables, abis, addresses)}
    )
asyncio.run(do())
"""
    exec(tests)