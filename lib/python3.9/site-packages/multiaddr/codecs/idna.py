from __future__ import absolute_import

import idna

from . import LENGTH_PREFIXED_VAR_SIZE


SIZE = LENGTH_PREFIXED_VAR_SIZE
IS_PATH = False


def to_bytes(proto, string):
    return idna.encode(string, uts46=True)


def to_string(proto, buf):
    return idna.decode(buf)
