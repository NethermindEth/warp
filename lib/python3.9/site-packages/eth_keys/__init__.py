from __future__ import absolute_import

import sys
import warnings


if sys.version_info.major < 3:
    warnings.simplefilter('always', DeprecationWarning)
    warnings.warn(DeprecationWarning(
        "The `eth-keys` library is dropping support for Python 2.  Upgrade to Python 3."
    ))
    warnings.resetwarnings()


from .main import (  # noqa: F401
    KeyAPI,
    lazy_key_api as keys,
)
