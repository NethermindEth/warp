from __future__ import annotations

from dataclasses import dataclass
from typing import Callable, Iterable

from warp.yul.implicits import print_implicit
from warp.yul.storage_access import (
    StorageVar,
    generate_getter_body,
    generate_setter_body,
)


class FunctionGenerator:
    """Utility to create multi-use functions."""

    def __init__(self):
        self.definitions: dict[str, str] = {}

    def create_function(self, name: str, definition: Callable[[], str]) -> None:
        """Creates definition of a function named 'name', unless it already
        exists.

        'definition' is a function generator.

        """
        self.definitions.setdefault(name, definition())


@dataclass
class FunctionInfo:
    """Represents all information necessary to make a call to a particular Cairo function.

    'name' is a name of the function.
    'implicits' is a sequence of implicits needed by the functions.
    'kwarg_names' is a sequence of names of the arguments of the function.

    """

    name: str
    implicits: tuple[str, ...]
    kwarg_names: tuple[str, ...]


class CairoFunctions:
    """A collection of functions generators. All function generators can
    be used to generate a function and get all information necessary
    to make a call to it (via 'FunctionInfo'). No function is generated
    twice.

    """

    def __init__(self, generator: FunctionGenerator):
        self.generator = generator
        self.storage_vars: set[StorageVar] = set()

    def get_definitions(self) -> Iterable[str]:
        """Returns all generated function definitions. Note, it doesn't
        include generated 'StorageVar's.

        """
        yield from self.generator.definitions.values()

    def constant_function(self, constant: int) -> FunctionInfo:
        """Creates a function that always returns a specified 'constant'."""
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
        return FunctionInfo(name=name, implicits=(), kwarg_names=())

    def identity_function(self, types: list[str]):
        name = f"__warp_identity_{'__'.join(types)}"
        args = ", ".join([f"arg{i} : {tp}" for (i, tp) in enumerate(types)])
        returns = ", ".join([f"arg{i}" for i in range(len(types))])

        def inner():
            return "\n".join(
                [
                    f"func {name}({args}) -> ({args}):",
                    f"return ({returns})",
                    f"end\n",
                ]
            )

        self.generator.create_function(name, inner)
        return FunctionInfo(name=name, implicits=(), kwarg_names=())

    def sload_function(self) -> FunctionInfo:
        """Creates a function that fetches a Uint256 from the emulated Ethereum
        storage, as well as a 'StorageVar' representing the said storage.

        """
        name = "sload"
        implicits = ("range_check_ptr", "pedersen_ptr", "syscall_ptr")

        def inner():
            implicits_str = (
                "{" + ", ".join(print_implicit(x) for x in sorted(implicits)) + "}"
            )
            return "\n".join(
                [
                    f"func {name}{implicits_str}(key: Uint256) -> (value: Uint256):",
                    generate_getter_body("evm_storage", ("key",), "value"),
                    "end\n",
                ]
            )

        self.generator.create_function(name, inner)
        self.storage_vars.add(
            StorageVar(name="evm_storage", arg_types=("Uint256",), res_type="Uint256")
        )
        return FunctionInfo(name=name, implicits=implicits, kwarg_names=("key",))

    def sstore_function(self) -> FunctionInfo:
        """Creates a function that stores a Uint256 from the emulated Ethereum
        storage, as well as a 'StorageVar' representing the said storage.

        """
        name = "sstore"
        implicits = ("range_check_ptr", "pedersen_ptr", "syscall_ptr")

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
        return FunctionInfo(
            name=name, implicits=implicits, kwarg_names=("key", "value")
        )

    def stubbing_function(self) -> FunctionInfo:
        """Creates a function that takes no arguments and returns a single
        value. The function doesn't actually compute anything but just
        reverts.

        """
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
        return FunctionInfo(name=name, implicits=(), kwarg_names=())

    def returndata_size_function(self) -> FunctionInfo:
        name = f"returndata_size"
        implicits = ("exec_env",)

        def inner():
            implicits_str = (
                "{" + ", ".join(print_implicit(x) for x in sorted(implicits)) + "}"
            )
            return "\n".join(
                [
                    f"func {name}{implicits_str}() -> (res: Uint256):",
                    "return (Uint256(low=exec_env.returndata_size, high=0))",
                    "end\n",
                ]
            )

        self.generator.create_function(name, inner)
        return FunctionInfo(name=name, implicits=implicits, kwarg_names=())
