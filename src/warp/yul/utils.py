from __future__ import annotations

import json
import os
import re
import subprocess
from typing import Sequence

from warp.nethersolc import nethersolc_exe
from warp.yul.WarpException import WarpException

UPPERCASE_PATTERN = re.compile(r"[A-Z]")


def spit(fname, content):
    """Writes 'content' to the file named 'fname'"""
    with open(fname, "w") as f:
        f.write(content)


def remove_prefix(text, prefix):
    if text.startswith(prefix):
        return text[len(prefix) :]
    return text


def snakify(camel_case: str) -> str:
    """ThisCaseWord -> this_case_word"""
    return remove_prefix(
        UPPERCASE_PATTERN.sub(lambda m: f"_{m.group(0).lower()}", camel_case), "_"
    )


def camelize(snake_case: str) -> str:
    """this_case_word -> ThisCaseWord"""
    parts = snake_case.split("_")
    if not parts:
        return snake_case
    if any(x == "" for x in parts):
        raise ValueError(
            f"Can't camelize {snake_case}."
            " It probably contains several consecutive underscores."
        )
    return "".join(x.capitalize() for x in parts)


def get_solc_json(requests: Sequence[str], filepath: os.PathLike) -> dict:
    with nethersolc_exe() as exe:
        try:
            output_result = subprocess.run(
                [exe, "--optimize", "--combined-json", ",".join(requests), filepath],
                check=True,
                capture_output=True,
            )
        except subprocess.CalledProcessError as e:
            err_msg = f"nethersolc call failed: {e.stderr.decode('utf-8')}"
            raise WarpException(err_msg) from e

    return json.loads(output_result.stdout)


def get_requests(filepath, target_contract, requests) -> Sequence:
    output = get_solc_json(requests, filepath)
    for contract, values in output["contracts"].items():
        name = contract[contract.find(":") + 1 :]
        if name == target_contract:
            return tuple(values[x] for x in requests)
    raise WarpException(f"Contract {target_contract} is not found in {filepath}")


def cairoize_bytes(bs: bytes, shifted=False) -> tuple[list[int], int]:
    """Represent bytes as an array of 128-bit big-endian integers and
    return a number of unused bytes in the last array cell.

    'shifted' indicates if 'bs' should be shifted 12-bytes to the
    right, so as to be suitable as Warp calldata.

    """
    if shifted:
        bs = b"\x00" * 12 + bs
    unused_bytes = -len(bs) % 16
    bs = bs.ljust(len(bs) + unused_bytes, b"\x00")
    arr = [int.from_bytes(bs[i : i + 16], "big") for i in range(0, len(bs), 16)]
    return (arr, unused_bytes)
