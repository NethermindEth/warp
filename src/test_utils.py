from __future__ import annotations
import os
from utils import from_abi, build_dict, read_file_json, get_selectors

WARP_ROOT = os.path.abspath(os.path.join(__file__, "../.."))

def test_selectors(contracts: List[str] = ["link", "weth", "weth10"]):
    for abi in contracts:
        abi_path = os.path.join(WARP_ROOT, "tests", "utils", f"{abi}.abi")
        func_selectors = get_selectors(abi_path)
        print(func_selectors)
        opcodes_path = os.path.join(WARP_ROOT, "tests", "utils", f"{abi}.opcode")
        with open(opcodes_path) as f:
            opcodes = f.read()
        opcodes = opcodes.lower()
        for k, v in func_selectors.items():
            # solidity and vyper remove leading zeros when you use the
            # --opcodes flag to ouptut the opcodes from the compiled contract.
            if "0" in v[2:]:
                v = "0x" + v[2:].lstrip("0")
            assert v in opcodes, f"failed with {v} in file {abi}"
            if v not in opcodes:
                return 0
    return 1
