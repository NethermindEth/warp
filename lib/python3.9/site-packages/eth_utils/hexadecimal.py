# String encodings and numeric representations

import binascii
import re
from typing import Any, AnyStr

from eth_typing import HexStr

from .types import is_string, is_text

_HEX_REGEXP = re.compile("[0-9a-fA-F]*")


def decode_hex(value: str) -> bytes:
    if not is_text(value):
        raise TypeError("Value must be an instance of str")
    non_prefixed = remove_0x_prefix(HexStr(value))
    # unhexlify will only accept bytes type someday
    ascii_hex = non_prefixed.encode("ascii")
    return binascii.unhexlify(ascii_hex)


def encode_hex(value: AnyStr) -> HexStr:
    if not is_string(value):
        raise TypeError("Value must be an instance of str or unicode")
    elif isinstance(value, (bytes, bytearray)):
        ascii_bytes = value
    else:
        ascii_bytes = value.encode("ascii")

    binary_hex = binascii.hexlify(ascii_bytes)
    return add_0x_prefix(HexStr(binary_hex.decode("ascii")))


def is_0x_prefixed(value: Any) -> bool:
    if not is_text(value):
        raise TypeError(
            "is_0x_prefixed requires text typed arguments. Got: {0}".format(repr(value))
        )
    return value.startswith("0x") or value.startswith("0X")


def remove_0x_prefix(value: HexStr) -> HexStr:
    if is_0x_prefixed(value):
        return HexStr(value[2:])
    return value


def add_0x_prefix(value: HexStr) -> HexStr:
    if is_0x_prefixed(value):
        return value
    return HexStr("0x" + value)


def is_hexstr(value: Any) -> bool:
    if not is_text(value):
        return False

    elif value.lower() == "0x":
        return True

    unprefixed_value = remove_0x_prefix(value)
    if len(unprefixed_value) % 2 != 0:
        value_to_decode = "0" + unprefixed_value
    else:
        value_to_decode = unprefixed_value

    if not _HEX_REGEXP.fullmatch(value_to_decode):
        return False

    try:
        # convert from a value like '09af' to b'09af'
        ascii_hex = value_to_decode.encode("ascii")
    except UnicodeDecodeError:
        # Should have already been caught by regex above, but just in case...
        return False

    try:
        # convert to a value like b'\x09\xaf'
        value_as_bytes = binascii.unhexlify(ascii_hex)
    except binascii.Error:
        return False
    except TypeError:
        return False
    else:
        return bool(value_as_bytes)


def is_hex(value: Any) -> bool:
    if not is_text(value):
        raise TypeError(
            "is_hex requires text typed arguments. Got: {0}".format(repr(value))
        )
    elif value.lower() == "0x":
        return True

    unprefixed_value = remove_0x_prefix(value)
    if len(unprefixed_value) % 2 != 0:
        value_to_decode = "0" + unprefixed_value
    else:
        value_to_decode = unprefixed_value

    if not _HEX_REGEXP.fullmatch(value_to_decode):
        return False

    try:
        # convert from a value like '09af' to b'09af'
        ascii_hex = value_to_decode.encode("ascii")
    except UnicodeDecodeError:
        # Should have already been caught by regex above, but just in case...
        return False

    try:
        # convert to a value like b'\x09\xaf'
        value_as_bytes = binascii.unhexlify(ascii_hex)
    except binascii.Error:
        return False
    except TypeError:
        return False
    else:
        return bool(value_as_bytes)
