from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable

from warp.yul.WarpException import warp_assert


@dataclass(frozen=True, order=True)
class StorageVar:
    name: str
    arg_types: tuple[str]
    res_type: str


def generate_getter_body(
    getter_var: str, args: Iterable[str], return_name: str = "res"
) -> str:
    args_repr = ", ".join(args)
    return (
        f"let ({return_name}) = {getter_var}.read({args_repr})\nreturn ({return_name})"
    )


def generate_setter_body(setter_var: str, args: Iterable[str]) -> str:
    args_repr = ", ".join(args)
    return f"{setter_var}.write({args_repr})\nreturn ()\n"


def generate_storage_var_declaration(var: StorageVar) -> str:
    warp_assert(
        all(x == "Uint256" for x in var.arg_types),
        "We don't support storage variables parameterized by types other than Uint256",
    )
    warp_assert(
        var.res_type == "Uint256",
        "We don't support storage variables that return types other than Uint256",
    )
    args_repr = ", ".join(f"arg{i} : {typ}" for i, typ in enumerate(var.arg_types))
    return (
        f"@storage_var\n"
        f"func {var.name}({args_repr}) -> (res: {var.res_type}):\n"
        f"end\n"
    )
