from __future__ import annotations
import os
from utils import from_abi, read_file_json, get_selectors

WARP_ROOT = os.path.abspath(os.path.join(__file__, "../../.."))

TEST_CONTRACTS = ["link", "weth", "weth10"]


def test_get_selectors(contracts: List[str] = TEST_CONTRACTS):
    for abi in contracts:
        abi_path = os.path.join(WARP_ROOT, "tests", "utils", f"{abi}.abi")
        func_selectors = get_selectors(abi_path)
        opcodes_path = os.path.join(WARP_ROOT, "tests", "utils", f"{abi}.opcode")
        with open(opcodes_path) as f:
            opcodes = f.read()
        opcodes = opcodes.lower()
        for k in func_selectors.keys():
            # solidity and vyper remove leading zeros when you use the
            # --opcodes flag to ouptut the opcodes from the compiled contract.
            if "0" in k[2:]:
                k = "0x" + k[2:].lstrip("0")
            assert k in opcodes, f"failed with {k} in file {abi}"
            if k not in opcodes:
                return 0
    return 1
