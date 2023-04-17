"""
Contains the server implementation and its utility classes and functions.
This file contains monkeypatches used across the project. Advice for monkeypatch atomicity:
- Define a patching function
    - The function should import the places to be patched
    - The function can define the implementation to use for overwriting
- Call the patching function
"""

# pylint: disable=unused-import
# pylint: disable=import-outside-toplevel

import os
import sys

__version__ = "0.4.4"


def _patch_pedersen_hash():
    """
    This is a monkey-patch to improve the performance of the devnet
    We are using c++ code for calculating the pedersen hashes
    instead of python implementation from cairo-lang package
    """

    import starkware.cairo.lang.vm.crypto
    from crypto_cpp_py.cpp_bindings import cpp_hash
    from starkware.crypto.signature.fast_pedersen_hash import pedersen_hash

    def patched_pedersen_hash(left: int, right: int) -> int:
        """
        Pedersen hash function written in c++
        """
        return cpp_hash(left, right)

    setattr(
        sys.modules["starkware.crypto.signature.fast_pedersen_hash"],
        "pedersen_hash",
        patched_pedersen_hash,
    )
    setattr(
        sys.modules["starkware.cairo.lang.vm.crypto"],
        "pedersen_hash",
        patched_pedersen_hash,
    )


_patch_pedersen_hash()


def _patch_copy():
    """Deep copy of a ContractClass takes a lot of time, but it should never be mutated."""

    from copy import copy

    from starkware.starknet.services.api.contract_class import ContractClass

    def simpler_copy(self, memo):  # pylint: disable=unused-argument
        """
        A dummy implementation of ContractClass.__deepcopy__
        """
        return copy(self)

    setattr(ContractClass, "__deepcopy__", simpler_copy)


_patch_copy()


def _patch_cairo_vm():
    """Apply cairo-rs-py monkey patch"""
    from starknet_devnet.cairo_rs_py_patch import cairo_rs_py_monkeypatch

    cairo_rs_py_monkeypatch()

    from .util import warn

    warn("Using Cairo VM: Rust")


_VM_VAR = "STARKNET_DEVNET_CAIRO_VM"
_cairo_vm = os.environ.get(_VM_VAR)

if _cairo_vm == "rust":
    _patch_cairo_vm()

elif not _cairo_vm or _cairo_vm == "python":
    # python VM set by default
    pass

else:
    sys.exit(f"Error: Invalid value of environment variable {_VM_VAR}: '{_cairo_vm}'")
