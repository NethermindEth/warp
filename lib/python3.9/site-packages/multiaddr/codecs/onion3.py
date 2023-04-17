from __future__ import absolute_import
import base64
import struct

import six


SIZE = 296
IS_PATH = False


def to_bytes(proto, string):
    addr = string.split(":")
    if len(addr) != 2:
        raise ValueError("Does not contain a port number")

    # onion3 address without the ".onion" substring
    if len(addr[0]) != 56:
        raise ValueError("Invalid onion3 host address length (must be 56 characters)")
    try:
        onion3_host_bytes = base64.b32decode(addr[0].upper())
    except Exception as exc:
        six.raise_from(ValueError("Cannot decode {0!r} as base32: {1}".format(addr[0], exc)), exc)

    # onion3 port number
    try:
        port = int(addr[1], 10)
    except ValueError as exc:
        six.raise_from(ValueError("Port number is not a base 10 integer"), exc)
    if port not in range(1, 65536):
        raise ValueError("Port number is not in range(1, 65536)")

    return b''.join((onion3_host_bytes, struct.pack('>H', port)))


def to_string(proto, buf):
    addr_bytes, port_bytes = (buf[:-2], buf[-2:])
    addr = base64.b32encode(addr_bytes).decode('ascii').lower()
    port = six.text_type(struct.unpack('>H', port_bytes)[0])
    return u':'.join([addr, port])
