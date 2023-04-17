from __future__ import absolute_import
import struct

import six


SIZE = 16
IS_PATH = False


def to_bytes(proto, string):
    try:
        return struct.pack('>H', int(string, 10))
    except ValueError as exc:
        six.raise_from(ValueError("Not a base 10 integer"), exc)
    except struct.error as exc:
        six.raise_from(ValueError("Integer not in range(65536)"), exc)


def to_string(proto, buf):
    if len(buf) != 2:
        raise ValueError("Invalid integer length (must be 2 bytes / 16 bits)")
    return six.text_type(struct.unpack('>H', buf)[0])
