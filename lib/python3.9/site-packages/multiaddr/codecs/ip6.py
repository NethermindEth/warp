from __future__ import absolute_import

import netaddr
import six

from ._util import packed_net_bytes_to_int


SIZE = 128
IS_PATH = False


def to_bytes(proto, string):
    return netaddr.IPAddress(string, version=6).packed


def to_string(proto, buf):
    ip_addr = netaddr.IPAddress(packed_net_bytes_to_int(buf), version=6)
    return six.text_type(ip_addr)
