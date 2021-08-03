import os
import sys
import math
from pathlib import Path
import json
WARP_ROOT = os.path.abspath(os.path.join(__file__, "../../.."))
sys.path.append(os.path.join(WARP_ROOT, "src"))
from transpiler.EvmToCairo import EvmToCairo, parse_operations
from starkware.cairo.lang.compiler.parser import parse_file

starknet_dir = os.path.join(WARP_ROOT, "tests", "starknet")
OPCODES_PATH = os.path.join(starknet_dir, "opcodes")
ARTIFACTS_DIR = os.path.join(starknet_dir, "artifacts")

def transpile_opcodes(warp_root, opcode_groups):
    contracts = []
    count = 1
    for opcode_group in opcode_groups:
        opcodes_file_path = os.path.join(ARTIFACTS_DIR, f"opcodes_group_{count}.opcode")
        cairo_file_path = os.path.join(ARTIFACTS_DIR, f"generated_{count}.cairo")
        evm_to_cairo = EvmToCairo(cur_evm_pc=0)

        with open(opcodes_file_path, "r") as opcodes_file:
            for op in parse_operations(opcodes_file):
                evm_to_cairo.process_operation(op)

        with open(cairo_file_path, "w") as cairo_file:
            cairo_file.writelines(parse_file(evm_to_cairo.finish(True)).format())

        contracts.append(cairo_file_path)
        count += 1
    return contracts


def get_opcode_files(opcodes_path, n_groups):
    opcodes = [os.path.join(opcodes_path, f) for f in os.listdir(opcodes_path)]
    opcodes.sort()
    l = len(opcodes) // n_groups
    # TEMP: for example
    if n_groups == 2:
        return [opcodes[:l], opcodes[l:]]
    else:
        return [opcodes[x : x + l] for x in range(0, len(opcodes), l)]


def get_gold_result(opcode_name):
    opcode = os.path.basename(opcode_name)
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
                current_file = os.path.basename(f.name)
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


# insane hack, I know, but it makes the test 28x faster
# python needs macros
def generate_test_funcs(storage_tables, abis, addresses):
    funcs = ""
    for i in range(len(abis)):
        funcs += "\n" + ",\n".join(
            f'\tdo_golden_test("{opcode}", {test}, "{abis[i]}","{addresses[i]}")'
            for opcode, test in storage_tables[i].items()
        ) + ","
    return funcs



def get_compiled_contracts(contract_list):
    a = []
    for contract in contract_list:
        a.append(f"{contract[:-6]}_compiled.json")
    return a


def get_abis(contract_list):
    a = []
    count = 1
    for contract in contract_list:
        a.append(os.path.join(ARTIFACTS_DIR, f"{contract[:-6]}_abi.json"))
    return a

