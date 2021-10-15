from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable, Callable

from yul.implicits import print_implicit
from yul.storage_access import (
    generate_getter_body,
    generate_setter_body,
    StorageVar,
)


class FunctionGenerator:
    def __init__(self):
        self.definitions: dict[str, str] = {}

    def create_function(self, name: str, definition: Callable[[], str]) -> None:
        self.definitions.setdefault(name, definition())


@dataclass
class FunctionInfo:
    name: str
    implicits: set[str]


class CairoFunctions:
    def __init__(self, generator: FunctionGenerator):
        self.generator = generator
        self.storage_vars: set[StorageVar] = set()

    def get_definitions(self) -> Iterable[str]:
        yield from self.generator.definitions.values()

    def constant_function(self, constant: int) -> FunctionInfo:
        name = f"__warp_constant_{constant}"

        def inner():
            high, low = divmod(constant, 2 ** 128)
            return "\n".join(
                [
                    f"func {name}() -> (res: Uint256):",
                    f"return (Uint256(low={low}, high={high}))",
                    f"end\n",
                ]
            )

        self.generator.create_function(name, inner)
        return FunctionInfo(name=name, implicits=set())

    def sload_function(self) -> FunctionInfo:
        name = "sload"
        implicits = {"storage_ptr", "range_check_ptr", "pedersen_ptr"}

        def inner():
            implicits_str = (
                "{" + ", ".join(print_implicit(x) for x in sorted(implicits)) + "}"
            )
            return "\n".join(
                [
                    f"func {name}{implicits_str}(key: Uint256) -> (value: Uint256):",
                    generate_getter_body("evm_storage", ("key",)),
                    "end\n",
                ]
            )

        self.generator.create_function(name, inner)
        self.storage_vars.add(
            StorageVar(name="evm_storage", arg_types=("Uint256",), res_type="Uint256")
        )
        return FunctionInfo(name=name, implicits=implicits)

    def sstore_function(self) -> FunctionInfo:
        name = "sstore"
        implicits = {"storage_ptr", "range_check_ptr", "pedersen_ptr"}

        def inner():
            implicits_str = (
                "{" + ", ".join(print_implicit(x) for x in sorted(implicits)) + "}"
            )
            return "\n".join(
                [
                    f"func {name}{implicits_str}(key: Uint256, value: Uint256):",
                    generate_setter_body("evm_storage", ("key", "value")),
                    "end\n",
                ]
            )

        self.generator.create_function(name, inner)
        self.storage_vars.add(
            StorageVar(name="evm_storage", arg_types=("Uint256",), res_type="Uint256")
        )
        return FunctionInfo(name=name, implicits=implicits)


    def stubbing_function(self) -> FunctionInfo:
        name = f"__warp_stub"

        def inner():
            return "\n".join(
                [
                    f"func {name}() -> (res: Uint256):",
                    f"assert 1 = 0",
                    f"jmp rel 0",
                    f"end\n",
                ]
            )

        self.generator.create_function(name, inner)
        return FunctionInfo(name=name, implicits=set())

