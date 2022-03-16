import json
import os
import sys

from pathlib import Path
from starkware.starknet.business_logic.internal_transaction_interface import (
    TransactionExecutionInfo,
)

WARP_ROOT = Path(__file__).parents[1]
TMP = WARP_ROOT / "benchmark" / "json"
FILE_NAME = "data"


def steps_in_function_deploy(contract_name: str, result: TransactionExecutionInfo):
    json_path = os.path.abspath(TMP / (FILE_NAME + ".json"))
    if os.path.exists(json_path):
        with open(json_path, "r") as json_file:
            benchmark_data = json.load(json_file)
    else:
        benchmark_data = {}

    benchmark_data.setdefault(contract_name, {})[
        "steps"
    ] = result.call_info.cairo_usage.n_steps

    with open(json_path, "w") as json_file:
        json.dump(benchmark_data, json_file, indent=3)


def steps_in_function_invoke(contract_name: str, result: TransactionExecutionInfo):
    json_path = os.path.abspath(TMP / (FILE_NAME + ".json"))
    if os.path.exists(json_path):
        with open(json_path, "r") as json_file:
            benchmark_data = json.load(json_file)
    else:
        benchmark_data = {}

    benchmark_data.setdefault("_".join(contract_name.split("_")[:-1]), {})[
        "steps"
    ] = result.call_info.cairo_usage.n_steps

    with open(json_path, "w") as json_file:
        json.dump(benchmark_data, json_file, indent=3)


def builtin_instance_count(contract_name: str, result: TransactionExecutionInfo):
    json_path = os.path.abspath(TMP / (FILE_NAME + ".json"))
    if os.path.exists(json_path):
        with open(json_path, "r") as json_file:
            benchmark_data = json.load(json_file)
    else:
        benchmark_data = {}

    benchmark_data.setdefault(contract_name, {})[
        "builtin_instances"
    ] = result.call_info.cairo_usage.builtin_instance_counter

    with open(json_path, "w") as json_file:
        json.dump(benchmark_data, json_file, indent=3)


def create_markdown():
    json_path = os.path.abspath(TMP / (FILE_NAME + ".json"))

    with open(json_path, "r") as json_file:
        benchmark_data = json.load(json_file)

    with open(
        os.path.join(WARP_ROOT, f"benchmark/stats/{FILE_NAME}.md"), "w"
    ) as md_file:
        md_file.write("# Warp-ts status\n\n")
        md_file.write(f"commit: {FILE_NAME}\n\n")

    for contract, data in benchmark_data.items():
        with open(
            os.path.join(WARP_ROOT, f"benchmark/stats/{FILE_NAME}.md"), "a"
        ) as md_file:
            md_file.write(f"## {os.path.basename(contract)}:\n\n")
            md_file.write("| Metric | Value |\n")
            md_file.write("| ----------- | ----------- |\n")

            for metric, value in sorted(data.items()):
                if metric == "builtin_instances":
                    continue
                md_file.write(f"| {metric} | {value} |\n")
            md_file.write(f"\n")

        if "builtin_instances" in data:
            with open(
                os.path.join(WARP_ROOT, f"benchmark/stats/{FILE_NAME}.md"), "a"
            ) as md_file:
                md_file.write("| Builtin | Instances |\n")
                md_file.write("| ----------- | ----------- |\n")

                for builtin, count in sorted(data["builtin_instances"].items()):
                    md_file.write(f"| {builtin} | {count} |\n")

                md_file.write(f"\n")


if __name__ == "__main__":
    if sys.argv[1] != None:
        FILE_NAME = sys.argv[1]
    print(sys.argv[1])
    print(FILE_NAME)
    create_markdown()
