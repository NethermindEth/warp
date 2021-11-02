from typing import List, Optional

from eth_utils import function_abi_to_4byte_selector
from web3 import Web3
from yul.utils import cairoize_bytes


def get_evm_calldata(
    abi: dict, abi_original: dict, bytecode, fn_name: str, inputs: List[int]
) -> str:
    w3 = Web3()
    contract_abi_original = w3.eth.contract(abi=abi_original, bytecode=bytecode)
    contract = w3.eth.contract(abi=abi, bytecode=bytecode)
    for f in contract_abi_original.all_functions():
        if f.function_identifier == fn_name:
            selector = function_abi_to_4byte_selector(f.abi).hex()
    calldata = "0x" + selector + contract.encodeABI(fn_name=fn_name, args=inputs)[10:]
    return calldata


def evm_to_cairo_calldata(
    abi: dict,
    abi_original: dict,
    bytecode: str,
    fn_name: str,
    inputs: List[int],
    address: Optional[int] = None,
):
    evm_calldata = get_evm_calldata(
        abi=abi,
        abi_original=abi_original,
        bytecode=bytecode,
        fn_name=fn_name,
        inputs=inputs,
    )
    cairo_input, unused_bytes = cairoize_bytes(bytes.fromhex(evm_calldata[2:]))
    calldata_size = (len(cairo_input) * 16) - unused_bytes
    if address is None:
        return [calldata_size, len(cairo_input), *cairo_input]
    else:
        return [calldata_size, len(cairo_input), *cairo_input, address]
