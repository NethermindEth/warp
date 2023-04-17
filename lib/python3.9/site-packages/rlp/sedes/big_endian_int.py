from eth_utils import (
    int_to_big_endian,
    big_endian_to_int,
)

from rlp.exceptions import DeserializationError, SerializationError


class BigEndianInt(object):
    """A sedes for big endian integers.

    :param l: the size of the serialized representation in bytes or `None` to
              use the shortest possible one
    """

    def __init__(self, l=None):
        self.l = l

    def serialize(self, obj):
        if isinstance(obj, bool) or not isinstance(obj, int):
            raise SerializationError('Can only serialize integers', obj)
        if self.l is not None and obj >= 256**self.l:
            raise SerializationError('Integer too large (does not fit in {} '
                                     'bytes)'.format(self.l), obj)
        if obj < 0:
            raise SerializationError('Cannot serialize negative integers', obj)

        if obj == 0:
            s = b''
        else:
            s = int_to_big_endian(obj)

        if self.l is not None:
            return b'\x00' * max(0, self.l - len(s)) + s
        else:
            return s

    def deserialize(self, serial):
        if self.l is not None and len(serial) != self.l:
            raise DeserializationError('Invalid serialization (wrong size)',
                                       serial)
        if self.l is None and len(serial) > 0 and serial[0:1] == b'\x00':
            raise DeserializationError('Invalid serialization (not minimal '
                                       'length)', serial)

        serial = serial or b'\x00'
        return big_endian_to_int(serial)


big_endian_int = BigEndianInt()
