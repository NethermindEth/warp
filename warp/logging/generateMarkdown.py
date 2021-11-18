import json
import os
import sys

from starkware.starknet.business_logic.internal_transaction_interface import (
    TransactionExecutionInfo,
)


def human_readable_size(size, decimal_places=3):
    for unit in ["B", "KiB", "MiB", "GiB", "TiB"]:
        if size < 1024.0:
            break
        size /= 1024.0
    return f"{size:.{decimal_places}f}{unit}"


def size_of_file(contract_name, file, fileName):
    json_path = os.path.abspath(
        os.path.join(__file__, "../../../benchmark/tmp/", fileName + ".json")
    )
    if os.path.exists(json_path):
        with open(json_path, "r") as json_file:
            function_steps = json.load(json_file)
    else:
        function_steps = {}
    bytes = os.path.getsize(file)
    function_steps.setdefault(contract_name, {})[
        "Cairo file size"
    ] = human_readable_size(bytes)

    with open(json_path, "w") as json_file:
        json.dump(function_steps, json_file, indent=3)


def bytecode_details(contract_name, bytecode, file_name):
    json_path = os.path.abspath(
        os.path.join(__file__, "../../../benchmark/tmp/", file_name + ".json")
    )
    if os.path.exists(json_path):
        with open(json_path, "r") as json_file:
            function_steps = json.load(json_file)
    else:
        function_steps = {}

    function_steps.setdefault(contract_name, {})["Bytecode size"] = human_readable_size(
        sys.getsizeof(bytecode)
    )
    function_steps[contract_name]["Bytecode length"] = len(bytecode)

    with open(json_path, "w") as json_file:
        json.dump(function_steps, json_file, indent=3)


def steps_in_function(
    contract_name, function_name, result: TransactionExecutionInfo, file_name
):
    json_path = os.path.abspath(
        os.path.join(__file__, "../../../benchmark/tmp/", file_name + ".json")
    )
    if os.path.exists(json_path):
        with open(json_path, "r") as json_file:
            function_steps = json.load(json_file)
    else:
        function_steps = {}

    function_steps.setdefault(contract_name, {})[
        f"Steps in {function_name}"
    ] = result.call_info.cairo_usage.n_steps

    with open(json_path, "w") as json_file:
        json.dump(function_steps, json_file, indent=3)


def create_markdown():
    json_path = os.path.abspath(os.path.join(__file__, "../../../benchmark/tmp"))
    function_steps = {}

    for file in os.listdir(json_path):
        if not file.endswith(".json"):
            continue

        with open(os.path.join(json_path, file), "r") as json_file:
            file_dict = json.load(json_file)
        function_steps.update(file_dict)

    warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
    with open(os.path.join(warp_root, "benchmark/stats/stats.md"), "w") as md_file:
        md_file.write("# Warp status\n")

    for contract, data in function_steps.items():
        with open(os.path.join(warp_root, "benchmark/stats/stats.md"), "a") as md_file:
            md_file.write(f"### {os.path.basename(contract)}:\n")
            md_file.write("| Name | Value |\n")
            md_file.write("| ----------- | ----------- |\n")

        for function, steps in sorted(data.items()):
            with open(
                os.path.join(warp_root, "benchmark/stats/stats.md"), "a"
            ) as md_file:
                md_file.write(f"| {function} | {steps} |\n")


if __name__ == "__main__":
    create_markdown()
