from typing import Any

from eth_utils import (
    encode_hex,
    is_bytes,
    is_integer,
    ValidationError,
)
from eth_utils.toolz import curry

from eth_keys.constants import (
    SECPK1_N,
)


def validate_integer(value: Any) -> None:
    if not is_integer(value) or isinstance(value, bool):
        raise ValidationError("Value must be a an integer.  Got: {0}".format(type(value)))


def validate_bytes(value: Any) -> None:
    if not is_bytes(value):
        raise ValidationError("Value must be a byte string.  Got: {0}".format(type(value)))


@curry
def validate_gte(value: Any, minimum: int) -> None:
    validate_integer(value)
    if value < minimum:
        raise ValidationError(
            "Value {0} is not greater than or equal to {1}".format(
                value, minimum,
            )
        )


@curry
def validate_lte(value: Any, maximum: int) -> None:
    validate_integer(value)
    if value > maximum:
        raise ValidationError(
            "Value {0} is not less than or equal to {1}".format(
                value, maximum,
            )
        )


validate_lt_secpk1n = validate_lte(maximum=SECPK1_N - 1)


def validate_bytes_length(value: bytes, expected_length: int, name: str) -> None:
    actual_length = len(value)
    if actual_length != expected_length:
        raise ValidationError(
            "Unexpected {name} length: Expected {expected_length}, but got {actual_length} "
            "bytes".format(
                name=name,
                expected_length=expected_length,
                actual_length=actual_length,
            )
        )


def validate_message_hash(value: Any) -> None:
    validate_bytes(value)
    validate_bytes_length(value, 32, "message hash")


def validate_uncompressed_public_key_bytes(value: Any) -> None:
    validate_bytes(value)
    validate_bytes_length(value, 64, "uncompressed public key")


def validate_compressed_public_key_bytes(value: Any) -> None:
    validate_bytes(value)
    validate_bytes_length(value, 33, "compressed public key")
    first_byte = value[0:1]
    if first_byte not in (b"\x02", b"\x03"):
        raise ValidationError(
            "Unexpected compressed public key format: Must start with 0x02 or 0x03, but starts "
            "with {first_byte}".format(
                first_byte=encode_hex(first_byte),
            )
        )


def validate_private_key_bytes(value: Any) -> None:
    validate_bytes(value)
    validate_bytes_length(value, 32, "private key")


def validate_recoverable_signature_bytes(value: Any) -> None:
    validate_bytes(value)
    validate_bytes_length(value, 65, "recoverable signature")


def validate_non_recoverable_signature_bytes(value: Any) -> None:
    validate_bytes(value)
    validate_bytes_length(value, 64, "non recoverable signature")


def validate_signature_v(value: int) -> None:
    validate_integer(value)
    validate_gte(value, minimum=0)
    validate_lte(value, maximum=1)


def validate_signature_r_or_s(value: int) -> None:
    validate_integer(value)
    validate_gte(value, 0)
    validate_lt_secpk1n(value)
