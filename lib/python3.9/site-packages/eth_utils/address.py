from typing import Any, AnyStr

from eth_typing import Address, AnyAddress, ChecksumAddress, HexAddress, HexStr

from .conversions import hexstr_if_str, to_hex
from .crypto import keccak
from .hexadecimal import (
    add_0x_prefix,
    decode_hex,
    encode_hex,
    is_hexstr,
    remove_0x_prefix,
)
from .types import is_bytes, is_text


def is_hex_address(value: Any) -> bool:
    """
    Checks if the given string of text type is an address in hexadecimal encoded form.
    """
    if not is_hexstr(value):
        return False
    else:
        unprefixed = remove_0x_prefix(value)
        return len(unprefixed) == 40


def is_binary_address(value: Any) -> bool:
    """
    Checks if the given string is an address in raw bytes form.
    """
    if not is_bytes(value):
        return False
    elif len(value) != 20:
        return False
    else:
        return True


def is_address(value: Any) -> bool:
    """
    Checks if the given string in a supported value
    is an address in any of the known formats.
    """
    if is_checksum_formatted_address(value):
        return is_checksum_address(value)
    elif is_hex_address(value):
        return True
    elif is_binary_address(value):
        return True
    else:
        return False


def to_normalized_address(value: AnyStr) -> HexAddress:
    """
    Converts an address to its normalized hexadecimal representation.
    """
    try:
        hex_address = hexstr_if_str(to_hex, value).lower()
    except AttributeError:
        raise TypeError(
            "Value must be any string, instead got type {}".format(type(value))
        )
    if is_address(hex_address):
        return HexAddress(HexStr(hex_address))
    else:
        raise ValueError(
            "Unknown format {}, attempted to normalize to {}".format(value, hex_address)
        )


def is_normalized_address(value: Any) -> bool:
    """
    Returns whether the provided value is an address in its normalized form.
    """
    if not is_address(value):
        return False
    else:
        return value == to_normalized_address(value)


def to_canonical_address(address: AnyStr) -> Address:
    """
    Given any supported representation of an address
    returns its canonical form (20 byte long string).
    """
    return Address(decode_hex(to_normalized_address(address)))


def is_canonical_address(address: Any) -> bool:
    """
    Returns `True` if the `value` is an address in its canonical form.
    """
    if not is_bytes(address) or len(address) != 20:
        return False
    return address == to_canonical_address(address)


def is_same_address(left: AnyAddress, right: AnyAddress) -> bool:
    """
    Checks if both addresses are same or not.
    """
    if not is_address(left) or not is_address(right):
        raise ValueError("Both values must be valid addresses")
    else:
        return to_normalized_address(left) == to_normalized_address(right)


def to_checksum_address(value: AnyStr) -> ChecksumAddress:
    """
    Makes a checksum address given a supported format.
    """
    norm_address = to_normalized_address(value)
    address_hash = encode_hex(keccak(text=remove_0x_prefix(HexStr(norm_address))))

    checksum_address = add_0x_prefix(
        HexStr(
            "".join(
                (
                    norm_address[i].upper()
                    if int(address_hash[i], 16) > 7
                    else norm_address[i]
                )
                for i in range(2, 42)
            )
        )
    )
    return ChecksumAddress(HexAddress(checksum_address))


def is_checksum_address(value: Any) -> bool:
    if not is_text(value):
        return False

    if not is_hex_address(value):
        return False
    return value == to_checksum_address(value)


def is_checksum_formatted_address(value: Any) -> bool:

    if not is_hex_address(value):
        return False
    elif remove_0x_prefix(value) == remove_0x_prefix(value).lower():
        return False
    elif remove_0x_prefix(value) == remove_0x_prefix(value).upper():
        return False
    else:
        return True
