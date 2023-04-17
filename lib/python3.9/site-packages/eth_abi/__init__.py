import sys
import warnings

import pkg_resources

from eth_abi.abi import (  # NOQA
    decode,
    decode_abi,
    decode_single,
    encode,
    encode_abi,
    encode_single,
    is_encodable,
    is_encodable_type,
)

if sys.version_info[1] == 6:
    # reference setup.py -> python_requires
    warnings.warn(
        "eth-abi version 3.0.0 will no longer support Python 3.6",
        category=DeprecationWarning,
        stacklevel=2
    )

__version__ = pkg_resources.get_distribution('eth-abi').version
