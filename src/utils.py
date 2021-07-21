from __future__ import annotations
from eth_hash.auto import keccak
import os
import json


def is_valid_uintN(n: int, x: int):
    return 0 <= x < 2 ** n


def read_file_json(file_name: str) -> List[str]:
    with open(file_name) as f:
        data = f.readlines()
    abi = []
    for line in data:
        if not "[" in line:
            continue
        else:
            abi.extend(json.loads(line))
    return abi


def build_dict(sigs: List[str]) -> Dict[str, str]:
    table = {}
    for sig in sigs:
        table[sig[: sig.find("(")]] = "0x" + keccak(sig.encode()).hex()[:8]
    return table


def from_abi(file_name: str) -> List[str]:
    sigs = []
    data = read_file_json(file_name)
    for item in data:
        if item["type"] != "function":
            continue
        else:
            name = item["name"] + "("
            if len(item["inputs"]) == 0:
                name += ")"
                sigs.append(name)
                continue
            for idx, x in enumerate(item["inputs"]):
                if (idx == len(item["inputs"]) - 1) or item["inputs"] == "":
                    name += x["type"] + ")"
                else:
                    name += x["type"] + ","
            sigs.append(name)
    return sigs


def get_selectors(file_name: str) -> Dict[str, str]:
    sigs = from_abi(file_name)
    return build_dict(sigs)
