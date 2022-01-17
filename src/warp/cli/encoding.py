from __future__ import annotations

from typing import Any, Sequence

from eth_abi.codec import ABICodec
from eth_abi.exceptions import EncodingTypeError
from eth_abi.registry import registry as default_registry
from web3._utils.abi import (
    get_abi_input_types,
    get_aligned_abi_inputs,
    get_constructor_abi,
    merge_args_and_kwargs,
)
from web3._utils.contracts import get_function_info
from web3.types import ABI, ABIFunction

from warp.yul.utils import cairoize_bytes


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


EMPTY_CTOR_ABI = ABIFunction(
    type="constructor",
    inputs=[],
)


def get_ctor_evm_calldata(abi: ABI, inputs: Sequence[Any]) -> bytes:
    ctor_abi = get_constructor_abi(abi) or EMPTY_CTOR_ABI
    arguments = merge_args_and_kwargs(ctor_abi, inputs, {})
    _, aligned_arguments = get_aligned_abi_inputs(ctor_abi, arguments)
    argument_types = get_abi_input_types(ctor_abi)
    encoded_arguments = WARP_CODEC.encode_abi(argument_types, aligned_arguments)
    return encoded_arguments


def get_evm_calldata(abi: ABI, fn_name: str, inputs: Sequence[Any]) -> bytes:
    fn_info = get_function_info(fn_name, WARP_CODEC, contract_abi=abi, args=inputs)
    fn_abi, selector, arguments = fn_info
    argument_types = get_abi_input_types(fn_abi)
    encoded_arguments = WARP_CODEC.encode_abi(argument_types, arguments)
    return bytes.fromhex(selector[2:]) + encoded_arguments


def get_cairo_calldata(evm_calldata: bytes) -> Sequence[int]:
    cairo_input, unused_bytes = cairoize_bytes(evm_calldata, shifted=True)
    calldata_size = (len(cairo_input) * 16) - unused_bytes
    return [calldata_size, len(cairo_input), *cairo_input]
