"""Starknet ContractClass wrapper utilities"""

import os
from dataclasses import dataclass

from starkware.python.utils import to_bytes
from starkware.starknet.services.api.contract_class import ContractClass


@dataclass
class ContractClassWrapper:
    """Wrapper of ContractClass"""

    contract_class: ContractClass
    hash_bytes: bytes


DEFAULT_ACCOUNT_PATH = os.path.abspath(
    os.path.join(
        __file__,
        os.pardir,
        "accounts_artifacts",
        "OpenZeppelin",
        "0.5.1",
        "Account.cairo",
        "Account.json",
    )
)
DEFAULT_ACCOUNT_HASH_BYTES = to_bytes(
    2177626953842241688342849477958144159584215338353441986251810208376165874783
)
