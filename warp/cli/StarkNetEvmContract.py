import solcx
import json
from web3 import Web3


def get_evm_calldata(src_path: str, main_contract: str, fn_name: str, inputs) -> str:
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
            lol = f"{abi}"
            abiStr = lol.replace("\'address\'", "\'uint256\'")
            abiStr = abiStr.replace('\'','\"')
            abi = json.loads(abiStr)

    if abi is None:
        raise Exception("could not find abi of given contract name")
    if bytecode is None:
        raise Exception("could not find bytecode of given contract name")

    w3 = Web3()
    contract = w3.eth.contract(abi=abi, bytecode=bytecode)
    return contract.encodeABI(fn_name=fn_name, args=inputs)
