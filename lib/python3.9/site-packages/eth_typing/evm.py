from typing import (
    NewType,
    TypeVar,
    Union,
)

from .encoding import (
    HexStr,
)

Hash32 = NewType('Hash32', bytes)
BlockNumber = NewType('BlockNumber', int)
BlockIdentifier = Union[BlockNumber, Hash32]

Address = NewType('Address', bytes)
HexAddress = NewType('HexAddress', HexStr)
ChecksumAddress = NewType('ChecksumAddress', HexAddress)
AnyAddress = TypeVar('AnyAddress', Address, HexAddress, ChecksumAddress)
