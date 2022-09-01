import json
import sys
import os

from starkware.starknet.core.os.class_hash import compute_class_hash
from starkware.cairo.lang.vm.crypto import pedersen_hash
from starkware.starknet.services.api.contract_class import ContractClass

def get_class_hash(path: str) -> str:
    with open(path) as f:
        compiled = f.read()
    return hex(compute_class_hash(ContractClass.loads(compiled),pedersen_hash))
 
if __name__ == '__main__':
    abs_path = os.path.abspath(sys.argv[1])
    print(get_class_hash(abs_path))