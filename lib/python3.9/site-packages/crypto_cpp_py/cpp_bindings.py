import ctypes
import os
from pathlib import Path
from typing import Optional, Tuple

from starkware.crypto.signature.signature import inv_mod_curve_size, generate_k_rfc6979

CPP_LIB_BINDING = None
OUT_BUFFER_SIZE = 251


def unload_cpp_lib():
    # pylint: disable=global-statement
    global CPP_LIB_BINDING
    CPP_LIB_BINDING = None


def get_cpp_lib_path():
    return Path(__file__).parents[1]


def get_cpp_lib_file() -> Optional[str]:
    crypto_path = get_cpp_lib_path()
    try:
        filename = next(
            f for f in os.listdir(crypto_path) if f.startswith("libcrypto_c_exports")
        )
        return os.path.join(crypto_path, filename)
    except (StopIteration, FileNotFoundError):
        return None


def load_cpp_lib():
    # pylint: disable=global-statement
    global CPP_LIB_BINDING
    if CPP_LIB_BINDING:
        return

    cpp_lib_file = get_cpp_lib_file()

    CPP_LIB_BINDING = ctypes.cdll.LoadLibrary(cpp_lib_file)
    # Configure argument and return types.
    CPP_LIB_BINDING.Hash.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_void_p]
    CPP_LIB_BINDING.Verify.argtypes = [
        ctypes.c_void_p,
        ctypes.c_void_p,
        ctypes.c_void_p,
        ctypes.c_void_p,
    ]
    CPP_LIB_BINDING.Verify.restype = bool
    CPP_LIB_BINDING.Sign.argtypes = [
        ctypes.c_void_p,
        ctypes.c_void_p,
        ctypes.c_void_p,
        ctypes.c_void_p,
    ]


def cpp_binding_loaded() -> bool:
    return CPP_LIB_BINDING is not None


# A type for the digital signature.
ECSignature = Tuple[int, int]


def cpp_hash(left: int, right: int) -> int:
    load_cpp_lib()
    res = ctypes.create_string_buffer(OUT_BUFFER_SIZE)

    if (
        CPP_LIB_BINDING.Hash(
            left.to_bytes(32, "little", signed=False),
            right.to_bytes(32, "little", signed=False),
            res,
        )
        != 0
    ):
        raise ValueError(res.raw.rstrip(b"\00"))
    return int.from_bytes(res.raw[:32], "little", signed=False)


def cpp_sign(msg_hash, priv_key, seed: Optional[int] = 32) -> ECSignature:
    load_cpp_lib()
    res = ctypes.create_string_buffer(OUT_BUFFER_SIZE)
    k = generate_k_rfc6979(msg_hash, priv_key, seed)
    if (
        CPP_LIB_BINDING.Sign(
            priv_key.to_bytes(32, "little", signed=False),
            msg_hash.to_bytes(32, "little", signed=False),
            k.to_bytes(32, "little", signed=False),
            res,
        )
        != 0
    ):
        raise ValueError(res.raw.rstrip(b"\00"))
    # pylint: disable=invalid-name
    w = int.from_bytes(res.raw[32:64], "little", signed=False)
    s = inv_mod_curve_size(w)
    return int.from_bytes(res.raw[:32], "little", signed=False), s
