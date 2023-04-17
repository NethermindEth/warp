import abc


class Atomic(metaclass=abc.ABCMeta):
    """ABC for objects that can be RLP encoded as is."""
    pass


Atomic.register(bytes)
Atomic.register(bytearray)
