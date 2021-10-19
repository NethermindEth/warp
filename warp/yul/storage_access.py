from __future__ import annotations

import re
from dataclasses import dataclass
from typing import Iterable, Optional

from yul.WarpException import warp_assert

GETTER_PATTERN = re.compile(r"getter_fun_(\S*)(_(\d+))?")
SETTER_PATTERN = re.compile(r"setter_fun_(\S*)(_(\d+))?")


def extract_var_from_getter(getter: str) -> Optional[str]:
    match = re.fullmatch(GETTER_PATTERN, getter)
    if not match:
        return None
    return match.group(1)


def extract_var_from_setter(setter: str) -> Optional[str]:
    match = re.fullmatch(SETTER_PATTERN, setter)
    if not match:
        return None
    return match.group(1)


@dataclass(frozen=True, order=True)
class StorageVar:
    name: str
    arg_types: tuple[str]
    res_type: str


def generate_getter_body(getter_var: str, args: Iterable[str]) -> str:
    args_repr = ", ".join(f"{x}.low, {x}.high" for x in args)
    return f"let (res) = {getter_var}.read({args_repr})\nreturn (res)"


def generate_setter_body(setter_var: str, args: Iterable[str]) -> str:
    *access_args, value_arg = args
    args_repr = ", ".join(f"{x}.low, {x}.high" for x in access_args)
    if access_args:
        args_repr += ", "
    return f"{setter_var}.write({args_repr}{value_arg})\nreturn ()"


def generate_storage_var_declaration(var: StorageVar) -> str:
    warp_assert(
        all(x == "Uint256" for x in var.arg_types),
        "We don't support storage variables parameterized by types other than Uint256",
    )
    warp_assert(
        var.res_type == "Uint256",
        "We don't support storage variables that return types other than Uint256",
    )
    args_repr = ", ".join(
        f"arg{i}_low, arg{i}_high" for i, typ in enumerate(var.arg_types)
    )
    return (
        f"@storage_var\n"
        f"func {var.name}({args_repr}) -> (res: {var.res_type}):\n"
        f"end\n"
    )
