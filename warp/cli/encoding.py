from __future__ import annotations

from typing import Any, Optional, Sequence

from eth_abi.codec import ABICodec
from eth_abi.exceptions import EncodingTypeError
from eth_abi.registry import registry as default_registry
from web3._utils.abi import get_abi_input_types
from web3._utils.contracts import get_function_info
from yul.utils import cairoize_bytes


def encode_address(x):
    if not isinstance(x, int):
        raise EncodingTypeError()
    return x.to_bytes(32, byteorder="big")


def decode_address(stream):
    return stream.read(32)


WARP_REGISTRY = default_registry.copy()
WARP_REGISTRY.unregister("address")
WARP_REGISTRY.register("address", encoder=encode_address, decoder=decode_address)
WARP_CODEC = ABICodec(WARP_REGISTRY)


def get_evm_calldata(abi: dict, fn_name: str, inputs: Sequence[Any]) -> str:
    fn_info = get_function_info(fn_name, WARP_CODEC, contract_abi=abi, args=inputs)
    fn_abi, selector, arguments = fn_info
    argument_types = get_abi_input_types(fn_abi)
    encoded_arguments = WARP_CODEC.encode_abi(argument_types, arguments)
    return selector + encoded_arguments.hex()


def evm_to_cairo_calldata(
    abi: dict,
    fn_name: str,
    inputs: Sequence[Any],
    address: Optional[int] = None,
):
    evm_calldata = get_evm_calldata(abi=abi, fn_name=fn_name, inputs=inputs)
    cairo_input, unused_bytes = cairoize_bytes(bytes.fromhex(evm_calldata[2:]))
    calldata_size = (len(cairo_input) * 16) - unused_bytes
    if address is None:
        return [calldata_size, len(cairo_input), *cairo_input]
    else:
        return [calldata_size, len(cairo_input), *cairo_input, address]
