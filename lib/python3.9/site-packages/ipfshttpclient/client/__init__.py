"""IPFS API Bindings for Python.

Classes:

 * Client – a TCP client for interacting with an IPFS daemon
"""

import os
import typing as ty
import warnings

import multiaddr

DEFAULT_ADDR = multiaddr.Multiaddr(os.environ.get("PY_IPFS_HTTP_CLIENT_DEFAULT_ADDR", '/dns/localhost/tcp/5001/http'))
DEFAULT_BASE = str(os.environ.get("PY_IPFS_HTTP_CLIENT_DEFAULT_BASE", 'api/v0'))
DEFAULT_USERNAME: ty.Optional[str] = os.getenv('PY_IPFS_HTTP_CLIENT_DEFAULT_USERNAME', None)
DEFAULT_PASSWORD: ty.Optional[str] = os.getenv('PY_IPFS_HTTP_CLIENT_DEFAULT_PASSWORD', None)

# This range inclusive-exclusive, so the daemon version must match
#   `VERSION_MINIMUM <= version < VERSION_MAXIMUM`
# for it to be considered compatible.
VERSION_MINIMUM   = "0.5.0"
VERSION_BLACKLIST = []
VERSION_MAXIMUM   = "0.9.0"

from . import base
from . import bitswap
from . import block
from . import bootstrap
from . import config
from . import dag
from . import dht
from . import files
from . import key
from . import miscellaneous
from . import name
from . import object
from . import pin
from . import pubsub
from . import repo
#TODO: `from . import stats`
from . import swarm
from . import unstable

from .. import encoding, exceptions, http, multipart, utils


def assert_version(version: str, minimum: str = VERSION_MINIMUM,
                   maximum: str = VERSION_MAXIMUM,
                   blacklist: ty.Iterable[str] = VERSION_BLACKLIST) -> None:
	"""Make sure that the given daemon version is supported by this client
	version.

	Raises
	------
	~ipfshttpclient.exceptions.VersionMismatch

	Parameters
	----------
	version
		The actual version of an IPFS daemon
	minimum
		The minimal IPFS daemon version allowed (inclusive)
	maximum
		The maximum IPFS daemon version allowed (exclusive)
	blacklist
		Versions explicitly disallowed even if in range *minimum* – *maximum*
	"""
	# Convert version strings to integer tuples
	version = list(map(int, version.split('-', 1)[0].split('.')))
	minimum = list(map(int, minimum.split('-', 1)[0].split('.')))
	maximum = list(map(int, maximum.split('-', 1)[0].split('.')))

	if minimum > version or version >= maximum:
		warnings.warn(exceptions.VersionMismatch(version, minimum, maximum))

	for blacklisted in blacklist:
		blacklisted = list(map(int, blacklisted.split('-', 1)[0].split('.')))
		if version == blacklisted:
			warnings.warn(exceptions.VersionMismatch(version, minimum, maximum))


def connect(
		addr: http.addr_t = DEFAULT_ADDR,
		base: str = DEFAULT_BASE, *,
		
		chunk_size: int = multipart.default_chunk_size,
		offline: bool = False,
		session: bool = False,
		
		auth: http.auth_t = None,
		cookies: http.cookies_t = None,
		headers: http.headers_t = {},
		timeout: http.timeout_t = 120,
		
		username: ty.Optional[str] = DEFAULT_USERNAME,
		password: ty.Optional[str] = DEFAULT_PASSWORD
):
	"""Create a new :class:`~ipfshttpclient.Client` instance and connect to the
	daemon to validate that its version is supported as well as applying any
	known workarounds for the given daemon version
	
	Raises
	------
		~ipfshttpclient.exceptions.ErrorResponse
		~ipfshttpclient.exceptions.ConnectionError
		~ipfshttpclient.exceptions.ProtocolError
		~ipfshttpclient.exceptions.StatusError
		~ipfshttpclient.exceptions.TimeoutError
	
	All parameters are identical to those passed to the constructor of the
	:class:`~ipfshttpclient.Client` class.
	"""

	# Create client instance
	client = Client(
		addr, base,
		chunk_size=chunk_size, offline=offline, session=session,
		auth=auth, cookies=cookies, headers=headers, timeout=timeout,
		username=username, password=password,
	)
	
	# Query version number from daemon and validate it
	assert_version(client.apply_workarounds()["Version"])
	
	return client


class Client(files.Base, miscellaneous.Base):
	"""The main IPFS HTTP client class
	
	Allows access to an IPFS daemon instance using its HTTP API by exposing an
	`IPFS Interface Core <https://github.com/ipfs/interface-ipfs-core/tree/master/SPEC>`__
	compatible set of methods.
	
	It is possible to instantiate this class directly, using the same parameters
	as :func:`connect`, to prevent the client from checking for an active and
	compatible version of the daemon. In general however, calling
	:func:`connect` should be preferred.
	
	In order to reduce latency between individual API calls, this class may keep
	a pool of TCP connections between this client and the API daemon open
	between requests. The only caveat of this is that the client object should
	be closed when it is not used anymore to prevent resource leaks.
	
	The easiest way of using this “session management” facility is using a
	context manager::
	
		with ipfshttpclient.connect() as client:
			print(client.version())  # These calls…
			print(client.version())  # …will reuse their TCP connection
	
	A client object may be re-opened several times::
	
		client = ipfshttpclient.connect()
		print(client.version())  # Perform API call on separate TCP connection
		with client:
			print(client.version())  # These calls…
			print(client.version())  # …will share a TCP connection
		with client:
			print(client.version())  # These calls…
			print(client.version())  # …will share a different TCP connection
	
	When storing a long-running :class:`Client` object use it like this::
	
		class Consumer:
			def __init__(self):
				self._client = ipfshttpclient.connect(session=True)
			
			# … other code …
			
			def close(self):  # Call this when you're done
				self._client.close()
	"""
	
	# Fix up docstring so that Sphinx doesn't ignore the constructors parameter list
	__doc__ += "\n\n" + "\n".join(l[1:] for l in base.ClientBase.__init__.__doc__.split("\n"))
	
	bitswap   = base.SectionProperty(bitswap.Section)
	block     = base.SectionProperty(block.Section)
	bootstrap = base.SectionProperty(bootstrap.Section)
	config    = base.SectionProperty(config.Section)
	dag       = base.SectionProperty(dag.Section)
	dht       = base.SectionProperty(dht.Section)
	key       = base.SectionProperty(key.Section)
	name      = base.SectionProperty(name.Section)
	object    = base.SectionProperty(object.Section)
	pin       = base.SectionProperty(pin.Section)
	pubsub    = base.SectionProperty(pubsub.Section)
	repo      = base.SectionProperty(repo.Section)
	swarm     = base.SectionProperty(swarm.Section)
	unstable  = base.SectionProperty(unstable.Section)
	
	
	######################
	# SESSION MANAGEMENT #
	######################
	
	def __enter__(self):
		self._client.open_session()
		return self
	
	def __exit__(self, exc_type, exc_value, traceback):
		self.close()
	
	def close(self):
		"""Close any currently open client session and free any associated
		resources.
		
		If there was no session currently open this method does nothing. An open
		session is not a requirement for using a :class:`~ipfshttpclient.Client`
		object and as such all method defined on it will continue to work, but
		a new TCP connection will be established for each and every API call
		invoked. Such a usage should therefor be avoided and may cause a warning
		in the future. See the class's description for details.
		"""
		self._client.close_session()
	
	
	###########
	# HELPERS #
	###########
	
	def apply_workarounds(self):
		"""Query version information of the referenced daemon and enable any
		   workarounds known for the corresponding version
		
		Returns
		-------
			dict
				The version information returned by the daemon
		"""
		version_info = self.version()
		
		version = tuple(map(int, version_info["Version"].split('-', 1)[0].split('.')))
		
		self._workarounds.clear()
		
		return version_info
	
	@utils.return_field('Hash')
	@base.returns_single_item(dict)
	def add_bytes(self, data: bytes, **kwargs):
		"""Adds a set of bytes as a file to IPFS.

		.. code-block:: python

			>>> client.add_bytes(b"Mary had a little lamb")
			'QmZfF6C9j4VtoCsTp4KSrhYH47QMd3DNXVZBKaxJdhaPab'

		Also accepts and will stream generator objects.

		Parameters
		----------
		data
			Content to be added as a file

		Returns
		-------
			str
				Hash of the added IPFS object
		"""
		body, headers = multipart.stream_bytes(data, chunk_size=self.chunk_size)
		return self._client.request('/add', decoder='json',
		                            data=body, headers=headers, **kwargs)

	@utils.return_field('Hash')
	@base.returns_single_item(dict)
	def add_str(self, string, **kwargs):
		"""Adds a Python string as a file to IPFS.

		.. code-block:: python

			>>> client.add_str(u"Mary had a little lamb")
			'QmZfF6C9j4VtoCsTp4KSrhYH47QMd3DNXVZBKaxJdhaPab'

		Also accepts and will stream generator objects.

		Parameters
		----------
		string : str
			Content to be added as a file

		Returns
		-------
			str
				Hash of the added IPFS object
		"""
		body, headers = multipart.stream_text(string, chunk_size=self.chunk_size)
		return self._client.request('/add', decoder='json',
		                            data=body, headers=headers, **kwargs)

	def add_json(self, json_obj, **kwargs):
		"""Adds a json-serializable Python dict as a json file to IPFS.

		.. code-block:: python

			>>> client.add_json({'one': 1, 'two': 2, 'three': 3})
			'QmVz9g7m5u3oHiNKHj2CJX1dbG1gtismRS3g9NaPBBLbob'

		Parameters
		----------
		json_obj : dict
			A json-serializable Python dictionary

		Returns
		-------
			str
				Hash of the added IPFS object
		"""
		return self.add_bytes(encoding.Json().encode(json_obj), **kwargs)
	
	
	@base.returns_single_item()
	def get_json(self, cid, **kwargs):
		"""Loads a json object from IPFS.

		.. code-block:: python

			>>> client.get_json('QmVz9g7m5u3oHiNKHj2CJX1dbG1gtismRS3g9NaPBBLbob')
			{'one': 1, 'two': 2, 'three': 3}

		Parameters
		----------
		cid : Union[str, cid.CIDv0, cid.CIDv1]
		   CID of the IPFS object to load

		Returns
		-------
			object
				Deserialized IPFS JSON object value
		"""
		return self.cat(cid, decoder='json', **kwargs)