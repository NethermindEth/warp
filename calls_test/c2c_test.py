import asyncio
import functools
import pytest
import os

from starkware.starknet.compiler.compile import compile_starknet_files
from starkware.starknet.testing.state import StarknetState

import solcx
from web3.contract import Contract

from eth_utils import combomethod, encode_hex, function_abi_to_4byte_selector, is_text

from typing import Any, List, Optional, Sequence, Tuple, Type, Union

from eth_abi.codec import ABICodec
from eth_typing import Address, HexStr
from eth_utils import combomethod, encode_hex, function_abi_to_4byte_selector, is_text
from eth_utils.toolz import pipe
from hexbytes import HexBytes
from web3 import Web3
from web3._utils.abi import (
    filter_by_argument_count,
    filter_by_name,
    get_abi_input_types,
    get_aligned_abi_inputs,
    get_fallback_func_abi,
    get_receive_func_abi,
    map_abi_data,
    merge_args_and_kwargs,
)
from web3._utils.encoding import to_hex
from web3._utils.function_identifiers import FallbackFn, ReceiveFn
from web3._utils.normalizers import (
    abi_address_to_hex,
    abi_bytes_to_bytes,
    abi_ens_resolver,
    abi_string_to_text,
)
from web3.types import ABI, ABIFunction

warp_root = os.path.abspath(os.path.join(__file__, "../.."))
test_dir = __file__

async def test_starknet():
    contract_file = test_dir[:-8] + ".cairo"
    solidity_file = test_dir[:-8] + ".sol"
    cairo_path = f"{warp_root}/warp/cairo-src"
    caller = compile_starknet_files(
        [contract_file], debug_info=True, cairo_path=[cairo_path]
    )
    callee = compile_starknet_files(
        ["/home/greg/dev/warp/calls_test/callee.cairo"], debug_info=True, cairo_path=[cairo_path]
    )

    starknet = await StarknetState.empty()
    caller_addr = await starknet.deploy(contract_definition=caller)
    callee_addr = await starknet.deploy(contract_definition=callee)
    evm_calldata = get_evm_calldata(solidity_file, "WARP", "callMe", [callee_addr])

    cairo_input, unused_bytes = cairoize_bytes(bytes.fromhex(evm_calldata[2:]))
    calldata_size = (len(cairo_input) * 16) - unused_bytes
    calldata = [calldata_size, len(cairo_input)] + cairo_input 
    calldata.append(callee_addr)

    assert calldata_size == 36
    assert len(cairo_input) == 3

    res = await starknet.invoke_raw(
        contract_address=caller_addr,
        selector="fun_ENTRY_POINT",
        calldata=calldata,
    )
    print(res)

    # assert res.retdata == [1, 0]

def cairoize_bytes(bs):
    """Represent bytes as an array of 128-bit big-endian integers and
    return a number of unused bytes in the last array cell.
    """
    unused_bytes = -len(bs) % 16
    bs = bs.ljust(len(bs) + unused_bytes, b"\x00")
    arr = [int.from_bytes(bs[i : i + 16], "big") for i in range(0, len(bs), 16)]
    return (arr, unused_bytes)

def encode_abi(
    web3: "Web3",
    abi: ABIFunction,
    arguments: Sequence[Any],
    data: Optional[HexStr] = None,
) -> HexStr:
    argument_types = get_abi_input_types(abi)
    for idx, t in enumerate(argument_types):
        if t == "address":
            argument_types[idx] = "uint256"
    normalizers = [
        abi_ens_resolver(web3),
        abi_address_to_hex,
        abi_bytes_to_bytes,
        abi_string_to_text,
    ]
    normalized_arguments = map_abi_data(
        normalizers,
        argument_types,
        arguments,
    )
    encoded_arguments = web3.codec.encode_abi(
        argument_types,
        normalized_arguments,
    )

    if data:
        return to_hex(HexBytes(data) + encoded_arguments)
    else:
        return encode_hex(encoded_arguments)


def find_matching_fun_abi(
    abi: ABI,
    abi_codec: ABICodec,
    fn_identifier: Optional[Union[str, Type[FallbackFn], Type[ReceiveFn]]] = None,
    args: Optional[Sequence[Any]] = None,
    kwargs: Optional[Any] = None,
) -> ABIFunction:
    args = args or tuple()
    kwargs = kwargs or dict()
    num_arguments = len(args) + len(kwargs)

    if fn_identifier is FallbackFn:
        return get_fallback_func_abi(abi)

    if fn_identifier is ReceiveFn:
        return get_receive_func_abi(abi)

    if not is_text(fn_identifier):
        raise TypeError("Unsupported function identifier")

    name_filter = functools.partial(filter_by_name, fn_identifier)
    arg_count_filter = functools.partial(filter_by_argument_count, num_arguments)

    function_candidates = pipe(abi, name_filter, arg_count_filter)

    if len(function_candidates) == 1:
        return function_candidates[0]
    raise Exception("Failed to find matching function in contract ABI")


def get_fun_info(
    fn_name: str,
    abi_codec: ABICodec,
    contract_abi: Optional[ABI] = None,
    fn_abi: Optional[ABIFunction] = None,
    args: Optional[Sequence[Any]] = None,
    kwargs: Optional[Any] = None,
) -> Tuple[ABIFunction, HexStr, Tuple[Any, ...]]:
    if args is None:
        args = tuple()
    if kwargs is None:
        kwargs = {}

    if fn_abi is None:
        fn_abi = find_matching_fun_abi(contract_abi, abi_codec, fn_name, args, kwargs)

    fn_selector = encode_hex(function_abi_to_4byte_selector(fn_abi))  # type: ignore

    fn_arguments = merge_args_and_kwargs(fn_abi, args, kwargs)

    _, aligned_fn_arguments = get_aligned_abi_inputs(fn_abi, fn_arguments)

    return fn_abi, fn_selector, aligned_fn_arguments

class StarkNetEVMContract(Contract):
    def __init__(self):
        self.web3 = Web3()
        # the address given to the Contract constructoris completely arbitrary.
        # We can put any CheckSum valid address here. It doesn't matter because
        # the address of a contract has no effect whatsoever on the abi encoded calldata.
        super().__init__(Address("0xf00b8484c9B78136c6AE8773223CFF9bE7a3Af45"))

    @combomethod
    def encodeABI(
        cls,
        fn_name: str,
        args: Optional[Any] = None,
        kwargs: Optional[Any] = None,
        data: Optional[HexStr] = None,
    ) -> HexStr:
        """
        Encodes the arguments using the Ethereum ABI for the contract function
        that matches the given name and arguments..

        :param data: defaults to function selector
        """
        fn_abi, fn_selector, fn_arguments = get_fun_info(
            fn_name,
            cls.web3.codec,
            contract_abi=cls.abi,
            args=args,
            kwargs=kwargs,
        )

        if data is None:
            data = fn_selector

        return encode_abi(cls.web3, fn_abi, fn_arguments, data)


def get_evm_calldata(
    src_path: str, main_contract: str, fn_name: str, inputs: List[str]
) -> str:
    with open(src_path) as f:
        src = f.read()
    compiled = solcx.compile_source(src, output_values=["abi", "bin"])

    abi = None
    bytecode = None
    for contractName, contract in compiled.items():
        name = contractName[contractName.find(":") + 1 :]
        if name == main_contract:
            abi = contract["abi"]
            bytecode = contract["bin"]

    if abi is None:
        raise Exception("could not find abi of given contract name")
    if bytecode is None:
        raise Exception("could not find bytecode of given contract name")

    w3 = Web3()
    evm_contract_factoryClass = StarkNetEVMContract()
    evm_contract = evm_contract_factoryClass.factory(w3, abi=abi, bytecode=bytecode)
    evm_calldata = evm_contract.encodeABI(fn_name=fn_name, args=inputs)

    return evm_calldata


asyncio.run(test_starknet())