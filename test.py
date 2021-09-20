import json
from web3 import Web3


def print_calldata():
    with open("t_abi.json") as f:
        evm_abi = json.load(f)
    with open("t_bytecode") as f:
        bytecode = f.read()
    function = "withdraw"
    inputs = [100, 100000]
    w3 = Web3()
    evm_contract = w3.eth.contract(abi=evm_abi, bytecode=bytecode)
    evm_calldata = evm_contract.encodeABI(fn_name=function, args=inputs)
    print(evm_calldata)


print_calldata()
