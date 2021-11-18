import json
import os
import sys


def human_readable_size(size, decimal_places=3):
    for unit in ["B", "KiB", "MiB", "GiB", "TiB"]:
        if size < 1024.0:
            break
        size /= 1024.0
    return f"{size:.{decimal_places}f}{unit}"


def sizeOfFile(contractName, file, fileName):
    jsonPath = os.path.abspath(
        os.path.join(__file__, "../../../benchmark/", fileName + ".json")
    )
    if os.path.exists(jsonPath):
        functionSteps = json.load(open(jsonPath, "r"))
    else:
        functionSteps = {}
    bytes = os.path.getsize(file)
    if contractName not in functionSteps.keys():
        functionSteps[contractName] = {}
    functionSteps[contractName]["Cairo file size"] = human_readable_size(bytes)

    json.dump(functionSteps, open(jsonPath, "w"), indent=3)


def bytecodeDetails(contractName, bytecode, fileName):
    jsonPath = os.path.abspath(
        os.path.join(__file__, "../../../benchmark/", fileName + ".json")
    )
    if os.path.exists(jsonPath):
        functionSteps = json.load(open(jsonPath, "r"))
    else:
        functionSteps = {}

    if contractName not in functionSteps.keys():
        functionSteps[contractName] = {}
    functionSteps[contractName]["Bytecode size"] = human_readable_size(
        sys.getsizeof(bytecode)
    )
    functionSteps[contractName]["Bytecode length"] = len(bytecode)

    json.dump(functionSteps, open(jsonPath, "w"), indent=3)
    pass


def stepsInFunction(contractName, functionName, result, fileName):
    jsonPath = os.path.abspath(
        os.path.join(__file__, "../../../benchmark/", fileName + ".json")
    )
    if os.path.exists(jsonPath):
        functionSteps = json.load(open(jsonPath, "r"))
    else:
        functionSteps = {}

    if contractName not in functionSteps.keys():
        functionSteps[contractName] = {}
    functionSteps[contractName][
        f"Steps in {functionName}"
    ] = result.call_info.cairo_usage.n_steps

    json.dump(functionSteps, open(jsonPath, "w"), indent=3)


def createMarkdown():
    jsonPath = os.path.abspath(os.path.join(__file__, "../../../benchmark"))
    functionSteps = {}

    for file in os.listdir(jsonPath):
        if not file.endswith(".json"):
            continue

        fileDict = json.load(open(os.path.join(jsonPath, file), "r"))
        functionSteps.update(fileDict)

    warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
    mdFile = open(os.path.join(warp_root, "benchmark/stats/stats.md"), "w")
    mdFile.write("# Warp status\n")

    for contract, data in functionSteps.items():
        mdFile.write(f"### {os.path.basename(contract)}:\n")
        mdFile.write("| Name | Value |\n")
        mdFile.write("| ----------- | ----------- |\n")

        for function, steps in sorted(data.items()):
            mdFile.write(f"| {function} | {steps} |\n")


if __name__ == "__main__":
    createMarkdown()
