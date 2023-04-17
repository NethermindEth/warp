from __future__ import absolute_import
import os

import six

from . import LENGTH_PREFIXED_VAR_SIZE


SIZE = LENGTH_PREFIXED_VAR_SIZE
IS_PATH = True


if hasattr(os, "fsencode") and hasattr(os, "fsdecode"):
    fsencode = os.fsencode
    fsdecode = os.fsdecode
else:  # pragma: no cover (PY2)
    import sys

    def fsencode(path):
        if not isinstance(path, six.binary_type):
            path = path.encode(sys.getfilesystemencoding())
        return path

    def fsdecode(path):
        if not isinstance(path, six.text_type):
            path = path.decode(sys.getfilesystemencoding())
        return path


def to_bytes(proto, string):
    return fsencode(string)


def to_string(proto, buf):
    return fsdecode(buf)
