"""Python IPFS HTTP CLIENT library"""


from .version import __version__

###################################
# Import stable HTTP CLIENT parts #
###################################
from . import exceptions

from .client import DEFAULT_ADDR, \
					DEFAULT_BASE, \
					DEFAULT_USERNAME, \
					DEFAULT_PASSWORD
from .client import VERSION_MINIMUM, VERSION_MAXIMUM
from .client import Client, assert_version, connect
