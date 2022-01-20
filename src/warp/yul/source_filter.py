import dataclasses
import re
import sys
from os.path import exists


@dataclasses.dataclass()
class bcolors:
    HEADER = "\033[95m"
    OKBLUE = "\033[94m"
    OKCYAN = "\033[96m"
    OKGREEN = "\033[92m"
    WARNING = "\033[93m"
    FAIL = "\033[91m"
    ENDC = "\033[0m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"


readme_link = (
    "https://github.com/NethermindEth/warp#solidity-constructs-currently-not-supported"
)
see = f"See {readme_link} for more details."
illegal_patterns = [
    (r"\bmsg.value\b", "Warp doesn't support msg.value."),
    (r"\btx.origin\b", "Warp doesn't support tx.origin."),
    (r"\btx.gasprice\b", "Warp doesn't support tx.gasprice."),
    (r"\bblock.basefee\b", "Warp doesn't support block.basefee."),
    (r"\bblock.chainid\b", "Warp doesn't support block.chainid."),
    (r"\bblock.coinbase\b", "Warp doesn't support block.coinbase."),
    (r"\bblock.difficulty\b", "Warp doesn't support block.difficulty."),
    (r"\bblock.gaslimit\b", "Warp doesn't support block.gaslimit."),
    (r"\bgasleft\b", "Warp doesn't support gasleft."),
    (r"\bselfdestruct\b", "Warp doesn't support selfdestruct."),
    (r"\bblockhash\b", "Warp doesn't support blockhash."),
    (
        r"\bkeccak256\b",
        "Warp doesn't support keccak since it's too slow on starknet. Please consider using the pedersen primitive.",
    ),
    (
        r"\btry\b",
        "Warp doesn't support try/catch.",
    ),
]


def ensure_compilable(sol_src_path: str):
    with open(sol_src_path) as f:
        source = f.read()
        for (regex, error_msg) in illegal_patterns:
            if re.compile(regex).search(source):
                print(
                    bcolors.FAIL
                    + bcolors.BOLD
                    + f"{error_msg}\n\n\t{see}\n"
                    + bcolors.ENDC,
                    file=sys.stderr,
                )
