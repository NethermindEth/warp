from web3 import Web3
from solcx import compile_files
from cli.StarkNetEvmContract import get_evm_calldata
from transpiler.utils import cairoize_bytes

compiled_sol = compile_files("/home/greg/dev/warp/calls_test/c2c.sol")

contract_id, contract_interface = compiled_sol.popitem()
# get bytecode / bin
bytecode = contract_interface["bin"]

abi = contract_interface["abi"]

w3 = Web3()


contract = w3.eth.contract(abi=abi, bytecode=bytecode)

evm_calldata = get_evm_calldata(
    src_path="/home/greg/dev/warp/calls_test/c2c.sol",
    main_contract="WARP",
    fn_name="callMe",
    inputs=["0x07cdd76577f25748600a640f93496d53ace3cdba2d583a11262462a9aae00056"],
)
print(evm_calldata)

cairo_input, unused_bytes = cairoize_bytes(bytes.fromhex(evm_calldata[2:]))
print(unused_bytes)

calldata_size = (len(cairo_input) * 16) - unused_bytes
calldata = [calldata_size, len(cairo_input)] + cairo_input
print(calldata)
