class WarpException(Exception):
    def __init__(self, msg):
        super().__init__(msg)


def warp_assert(condition, msg):
    if not condition:
        raise WarpException(msg)
