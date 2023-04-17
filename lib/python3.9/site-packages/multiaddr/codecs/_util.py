if hasattr(int, 'from_bytes'):
    def packed_net_bytes_to_int(b):
        """Convert the given big-endian byte-string to an int."""
        return int.from_bytes(b, byteorder='big')
else:  # pragma: no cover (PY2)
    def packed_net_bytes_to_int(b):
        """Convert the given big-endian byte-string to an int."""
        return int(b.encode('hex'), 16)
