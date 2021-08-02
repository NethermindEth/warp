from __future__ import annotations
import os, sys
from typing import Dict, List

WARP_ROOT = os.path.abspath(os.path.join(__file__, "../../../.."))
sys.path.append(os.path.join(WARP_ROOT, "src"))
from eth_hash.auto import keccak
from cli.compilation.Contract import Contract, Language
import json


def get_contract_lang(file_path) -> Language:
    if file_path.endswith("vy"):
        return Language.VYPER
    elif file_path.endswith("sol"):
        return Language.SOL
    else:
        raise Exception(
            "The language you are trying to transpile is not supported... YET"
        )


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


def get_func_sigs(abi: List[Dict[str, str]]) -> Dict[str, int]:
    sigs = {}
    for item in abi:
        if item["type"] != "function":
            continue
        else:
            name = item["name"] + "("
            if len(item["inputs"]) == 0:
                name += ")"
                if item["stateMutability"] == "payable":
                    sigs[name] = 1
                else:
                    sigs[name] = 0
                continue
            for idx, x in enumerate(item["inputs"]):
                if (idx == len(item["inputs"]) - 1) or item["inputs"] == "":
                    name += x["type"] + ")"
                else:
                    name += x["type"] + ","
            if item["stateMutability"] == "payable":
                sigs[name] = 1
            else:
                sigs[name] = 0
    return sigs


# CALLVALUE
# DUP1
# ISZERO
# PUSH2 0x0201
# JUMPI
# PUSH1 0x00
# DUP1
# REVERT
def is_payable_check_seq(opcodes: List[str], language: Language):
    if language is Language.SOL:
        return (
            opcodes[0] == "CALLVALUE"
            and opcodes[1] == "ISZERO"
            and "PUSH" in opcodes[2]
            and opcodes[4] == "JUMPI"
            and "PUSH" in opcodes[5]
            and opcodes[7] == "DUP1"
            and opcodes[8] == "REVERT"
            and opcodes[9] == "JUMPDEST"
        )
    return False


# DUP1
# PUSH4
# 0x6FDDE03
# EQ
# PUSH2
# 0xEA
# JUMPI
def is_entry_seq(opcodes: List[str], language: Language) -> bool:
    if language is Language.SOL:
        if opcodes[0] != "DUP1":
            return False
        else:
            return (
                opcodes[0] == "DUP1"
                and opcodes[1] == "PUSH4"
                and opcodes[3] == "EQ"
                and "PUSH" in opcodes[4]
                and opcodes[6] == "JUMPI"
            )
    elif language is Language.VYPER:
        if opcodes[0] != "PUSH4":
            return False
        else:
            return (
                opcodes[0] == "PUSH4"
                and opcodes[2] == "DUP2"
                and opcodes[3] == "EQ"
                and opcodes[4] == "ISZERO"
                and "PUSH" in opcodes[5]
                and opcodes[7] == "JUMPI"
            )


def get_selectors(abi: List[Dict[str, str]], base_source_dir) -> Dict[str, str]:
    file_name = os.path.join(os.path.expanduser("~"), ".warp", "artifacts", "selectors.json")
    sigs = get_func_sigs(abi)
    selectors = {}
    for sig in sigs.keys():
        selector = "0x" + keccak(sig.encode("ascii")).hex()[:8]
        selectors[selector] = {
            "signature": sig,
            "payable": sigs[sig],
        }
    with open(file_name, "w") as f:
        json.dump(selectors, f, indent=4)
    return selectors


def get_jumpdest_offset(language):
    if language is Language.VYPER:
        increment = 8
        jumpdest_pos_offset = 6
        return jumpdest_pos_offset, increment
    elif language is Language.SOL:
        increment = 7
        jumpdest_pos_offset = 5
        return jumpdest_pos_offset, increment
    else:
        print(language)


def get_selector_jumpdests(
    contract: Contract, base_source_dir
) -> Dict[str, Dict[str, int]]:
    file_name = os.path.join(os.path.expanduser("~"), ".warp", "artifacts", "selector_jumpdests.json")
    selector_jumpdests = {}
    selectors = list(contract.selectors.keys())
    jumpdest_pos_offset, increment = get_jumpdest_offset(contract.lang)
    idx = 0
    while len(selectors) > 0:
        if idx + increment >= len(contract.opcodes):
            break
        seq = contract.opcodes[idx : idx + increment]
        is_entry = is_entry_seq(seq, contract.lang)
        if is_entry and seq[2] in selectors:
            try:
                selector = contract.opcodes[idx + 2].lower()
                func_sig = contract.selectors[selector]["signature"]
                selector_jumpdests[selector] = {
                    "signature": func_sig,
                    "payable": contract.selectors[selector]["payable"],
                    "jumpdest": contract.opcodes[idx + jumpdest_pos_offset],
                }
                selectors.remove(selector)
                contract.opcodes[idx : idx + increment] = [
                    "NOOP" for i in range(increment)
                ]
                idx += increment
                continue
            except KeyError:
                print("Inside key error")
                continue
        idx += 1
    with open(file_name, "w") as f:
        json.dump(selector_jumpdests, f, indent=4)
    return selector_jumpdests
