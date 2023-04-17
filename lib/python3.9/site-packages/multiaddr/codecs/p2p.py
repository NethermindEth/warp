from __future__ import absolute_import

import base58
import six

from . import LENGTH_PREFIXED_VAR_SIZE


SIZE = LENGTH_PREFIXED_VAR_SIZE
IS_PATH = False


def to_bytes(proto, string):
    # the address is a base58-encoded string
    if six.PY2 and isinstance(string, unicode):  # pragma: no cover (PY2)  # noqa: F821
        string = string.encode("ascii")
    mm = base58.b58decode(string)
    if len(mm) < 5:
        raise ValueError("P2P MultiHash too short: len() < 5")
    return mm


def to_string(proto, buf):
    return base58.b58encode(buf).decode('ascii')
