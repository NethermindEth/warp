import abc
import socket
import sys
import tarfile
import typing as ty
import urllib.parse

import multiaddr  # type: ignore[import]
from multiaddr.protocols import (P_DNS, P_DNS4, P_DNS6,  # type: ignore[import]
                                 P_HTTP, P_HTTPS, P_IP4, P_IP6, P_TCP, P_UNIX)

from . import encoding
from . import exceptions
from . import utils


AF_UNIX = getattr(socket, "AF_UNIX", NotImplemented)


if ty.TYPE_CHECKING:
	import http.cookiejar  # noqa: F401
	from typing_extensions import Literal, Protocol  # noqa: F401
else:
	Protocol = utils.Protocol


if sys.version_info >= (3, 8):  #PY38+
	ty_Literal_json = ty.Literal["json"]
	ty_Literal_none = ty.Literal["none"]
else:  #PY37-
	ty_Literal_json = ty_Literal_none = str


class Closable(Protocol):
	def close(self) -> None:
		...


T_co = ty.TypeVar("T_co", covariant=True)
S = ty.TypeVar("S", bound=Closable)


addr_t = ty.Union[multiaddr.Multiaddr, bytes, str]
auth_t = ty.Optional[ty.Tuple[ty.Union[str, bytes], ty.Union[str, bytes]]]
cookies_t = ty.Optional[ty.Union[
	"http.cookiejar.CookieJar",
	ty.Dict[str, str]
]]
headers_t = ty.Optional[ty.Union[
	ty.Dict[str, str],
	ty.Dict[bytes, bytes],
	ty.Sequence[ty.Tuple[str, str]],
	ty.Sequence[ty.Tuple[bytes, bytes]],
]]
params_t = ty.Optional[ty.Sequence[ty.Tuple[str, str]]]
reqdata_sync_t = ty.Optional[ty.Iterator[bytes]]
timeout_t = ty.Optional[ty.Union[
	float,
	ty.Tuple[float, float],
]]
workarounds_t = ty.Optional[ty.Set[str]]


def _notify_stream_iter_closed() -> None:
	pass  # Mocked by unit tests to check if the decode iterator is closed at proper times


class StreamDecodeIteratorSync(ty.Generic[T_co]):
	"""Wrapper around a bytes generator that decodes and yields data as it is
	received, automatically closing all attached resources when the input stream
	ceases
	
	Parameters
	----------
	closables
		List of objects to `.close()` once this iterator has been exhausted or
		is manually closed
	response
		Generator returning the bytes to decode and yield
		
		Will be closed in addition to all objects in *closables* when the time comes.
	parser
		Decoder (see :class:`~ipfshttpclient.encoding.Encoding`) that takes
		the bytes yielded by *response* and emits decoded Python objects.
	"""
	def __init__(
			self,
			closables: ty.List[Closable],
			response: ty.Generator[bytes, ty.Any, ty.Any],
			parser: encoding.Encoding[T_co]
	):
		self._closables = closables  # type: ty.List[Closable]
		self._parser = parser  # type: ty.Optional[encoding.Encoding[T_co]]
		self._response_iter = response  # type: ty.Optional[ty.Generator[bytes, ty.Any, ty.Any]]
		self._parser_iter = None  # type: ty.Optional[ty.Generator[T_co, ty.Any, ty.Any]]

	def __iter__(self) -> "StreamDecodeIteratorSync[T_co]":
		return self

	def __next__(self) -> T_co:
		while True:
			# Try reading from current parser iterator
			parser_iter = self._parser_iter
			if parser_iter is not None:
				try:
					result = next(parser_iter)  # type: T_co
					
					# Detect late error messages that occured after some data
					# has already been sent
					if isinstance(result, dict) and result.get("Type") == "error":
						msg = result["Message"]
						raise exceptions.PartialErrorResponse(msg)
					
					return result
				except StopIteration:
					self._parser_iter = parser_iter = None
					
					# Forward exception to caller if we do not expect any
					# further data
					if self._response_iter is None:
						self.close()
						raise
			
			# Iterator fuse to prevent crash after EOS/.close()
			if self._response_iter is None:
				self.close()
				raise StopIteration()
			
			assert self._parser is not None
			try:
				data = next(self._response_iter)  # type: bytes
				
				# Create new parser iterator using the newly received data
				if len(data) > 0:
					self._parser_iter = self._parser.parse_partial(data)
			except StopIteration:
				# No more data to receive – destroy response iterator and
				# iterate over the final fragments returned by the parser
				self._response_iter = None
				self._parser_iter   = self._parser.parse_finalize()
	
	def __enter__(self) -> "StreamDecodeIteratorSync[T_co]":
		return self
	
	def __exit__(self, *a: ty.Any) -> None:
		self.close()
	
	def close(self) -> None:
		# Clean up any open iterators first
		if self._response_iter is not None:
			self._response_iter.close()
		if self._parser_iter is not None:
			self._parser_iter.close()
		self._response_iter = None
		self._parser_iter   = None
		
		# Clean up response object and parser
		for closable in self._closables:
			closable.close()
		self._closables.clear()
		self._parser = None
		
		_notify_stream_iter_closed()


@ty.overload
def stream_decode_full(
		response: Closable,
		response_iter: ty.Generator[bytes, ty.Any, ty.Any],
		parser: encoding.Dummy
) -> bytes:
	...

@ty.overload  # noqa: E302
def stream_decode_full(
		closables: ty.List[Closable],
		response: ty.Generator[bytes, ty.Any, ty.Any],
		parser: encoding.Json
) -> ty.List[utils.json_dict_t]:
	...

def stream_decode_full(  # type: ignore[misc]  # noqa: E302
		closables: ty.List[Closable],
		response: ty.Generator[bytes, ty.Any, ty.Any],
		parser: encoding.Encoding[T_co]
) -> ty.Union[ty.List[T_co], bytes]:
	with StreamDecodeIteratorSync(closables, response, parser) as response_iter:
		# Collect all responses
		result = list(response_iter)  # type: ty.List[T_co]
		
		# Return byte streams concatenated into one message, instead of split
		# at arbitrary boundaries
		if parser.is_stream:
			return b"".join(result)  # type: ignore[arg-type]
		return result


class ReadableStreamWrapper:
	"""Bytes iterator wrapper that exposes a fileobj compatible `.read(n=None)`
	and `.close()` interface"""
	def __init__(self, generator: ty.Generator[bytes, ty.Any, ty.Any]):
		self._buffer    = bytearray()
		self._generator = generator
	
	def read(self, length: ty.Optional[int] = None) -> bytes:
		# Handle “take all” mode
		if length is None:
			buffer = self._buffer
			for chunk in self._generator:
				buffer.extend(chunk)
			
			try:
				return bytes(buffer)
			finally:
				buffer.clear()
		
		# Handle buffered mode if the current buffer is not empty
		#
		# This may return short reads, but we don't care as that is valid as long
		# as at least 1 byte is returned.
		if len(self._buffer) > 0:
			try:
				return bytes(self._buffer[0:length])
			finally:
				del self._buffer[0:length]
		
		# Handle buffered mode if we need to request new data from the iterator
		try:
			chunk = b""
			while len(chunk) < 1:
				chunk = next(self._generator)
		except StopIteration:
			return b""
		else:
			try:
				return bytes(chunk[0:length])
			finally:
				self._buffer.extend(chunk[length:])
	
	def close(self) -> None:
		self._generator.close()
		self._buffer.clear()


def multiaddr_to_url_data(addr: addr_t, base: str  # type: ignore[no-any-unimported]
) -> ty.Tuple[str, ty.Optional[str], socket.AddressFamily, bool]:
	try:
		multi_addr = multiaddr.Multiaddr(addr)
	except multiaddr.exceptions.ParseError as error:
		raise exceptions.AddressError(addr) from error

	addr_iter = iter(multi_addr.items())
	
	# Parse the `host`, `family`, `port` & `secure` values from the given
	# multiaddr, raising on unsupported `addr` values
	try:
		# Read host value
		proto, host = next(addr_iter)
		family = socket.AF_UNSPEC
		host_numeric = proto.code in (P_IP4, P_IP6)
		
		uds_path: ty.Optional[str] = None

		if proto.code in (P_IP4, P_DNS4):
			family = socket.AF_INET
		elif proto.code in (P_IP6, P_DNS6):
			family = socket.AF_INET6
		elif proto.code == P_UNIX and AF_UNIX is not NotImplemented:
			family = AF_UNIX
			uds_path = host
		elif proto.code != P_DNS:
			raise exceptions.AddressError(addr)
		
		if family == AF_UNIX:
			assert uds_path is not None
			netloc = urllib.parse.quote(uds_path, safe="")
		else:
			# Read port value for IP-based transports
			proto, port = next(addr_iter)
			if proto.code != P_TCP:
				raise exceptions.AddressError(addr)
			
			# Pre-format network location URL part based on host+port
			if ":" in host and not host.startswith("["):
				netloc = "[{0}]:{1}".format(host, port)
			else:
				netloc = "{0}:{1}".format(host, port)
		
		# Read application-level protocol name
		secure = False
		try:
			proto, value = next(addr_iter)
		except StopIteration:
			pass
		else:
			if proto.code == P_HTTPS:
				secure = True
			elif proto.code != P_HTTP:
				raise exceptions.AddressError(addr)
		
		# No further values may follow; this also exhausts the iterator
		was_final = all(False for _ in addr_iter)
		if not was_final:
			raise exceptions.AddressError(addr)
	except StopIteration:
		raise exceptions.AddressError(addr) from None
	
	if not base.endswith("/"):
		base += "/"
	
	# Convert the parsed `addr` values to a URL base and parameters for the
	# HTTP library
	base_url = urllib.parse.SplitResult(
		scheme   = "http" if not secure else "https",
		netloc   = netloc,
		path     = base,
		query    = "",
		fragment = ""
	).geturl()
	
	return base_url, uds_path, family, host_numeric


def map_args_to_params(
		args: ty.Sequence[str],
		opts: ty.Mapping[str, str], *,
		offline: bool = False
) -> ty.List[ty.Tuple[str, str]]:
	params = []  # type: ty.List[ty.Tuple[str, str]]
	
	if offline:
		params.append(('offline', 'true'))
	
	params.extend(opts.items())
	
	for arg in args:
		params.append(('arg', arg))
	
	return params


class ClientSyncBase(ty.Generic[S], metaclass=abc.ABCMeta):
	"""An HTTP client for interacting with the IPFS daemon
	
	Parameters
	----------
	addr
		The address where the IPFS daemon may be reached
	base
		The path prefix for API calls
	offline
		Ask daemon to operate in “offline mode” – that is, it should not consult
		the network when unable to find resources locally, but fail instead
	workarounds
		List of daemon workarounds to apply
	auth
		HTTP basic authentication `(username, password)` tuple to send along with
		each request to the API daemon
	cookies
		HTTP cookies to send along with each request to the API daemon
	headers
		Custom HTTP headers to send along with each request to the API daemon
	timeout
		The default number of seconds to wait when establishing a connection to
		the daemon and waiting for returned data before throwing
		:exc:`~ipfshttpclient.exceptions.TimeoutError`; if the value is a tuple
		its contents will be interpreted as the values for the connection and
		receiving phases respectively, otherwise the value will apply to both
		phases; if the value is ``None`` then all timeouts will be disabled
	"""
	__slots__ = ("_session", "workarounds")

	_session: ty.Optional[S]
	workarounds: ty.Set[str]
	
	def __init__(self, addr: addr_t, base: str, *,  # type: ignore[no-any-unimported]
	             offline: bool = False,
	             workarounds: workarounds_t = None,
	             auth: auth_t = None,
	             cookies: cookies_t = None,
	             headers: headers_t = None,
	             timeout: timeout_t = None) -> None:
		self._session = None
		self.workarounds = workarounds if workarounds else set()
		
		#XXX: Figure out what stream-channels is and if we still need it
		params = map_args_to_params((), {
			"stream-channels": "true",
		}, offline=offline)
		
		# Initialize child
		self._init(
			addr,
			base,
			
			auth=auth,
			cookies=cookies,
			headers=headers,
			params=params,
			timeout=timeout,
		)
	
	@abc.abstractmethod
	def _init(self, addr: addr_t, base: str, *,  # type: ignore[no-any-unimported]
	          auth: auth_t,
	          cookies: cookies_t,
	          headers: headers_t,
	          params: params_t,
	          timeout: timeout_t) -> None:
		...
	
	@abc.abstractmethod
	def _make_session(self) -> S:
		...
	
	def _access_session(self) -> ty.Tuple[ty.List[Closable], S]:
		if self._session is not None:
			return [], self._session
		else:
			session = self._make_session()
			return [session], session
	
	def open_session(self) -> None:
		"""Open a persistent backend session that allows reusing HTTP
		connections between individual HTTP requests.
		
		It is an error to call this function if a session is already open."""
		assert self._session is None
		self._session = self._make_session()
	
	def close_session(self) -> None:
		"""Close a session opened by
		:meth:`~ipfshttpclient.http.HTTPClient.open_session`.
		
		If there is no session currently open (ie: it was already closed), then
		this method does nothing."""
		if self._session is not None:
			self._session.close()
			self._session = None
	
	@abc.abstractmethod
	def _request(
			self, method: str, path: str, params: ty.Sequence[ty.Tuple[str, str]], *,
			auth: auth_t,
			data: reqdata_sync_t,
			headers: headers_t,
			timeout: timeout_t,
			chunk_size: ty.Optional[int]
	) -> ty.Tuple[ty.List[Closable], ty.Generator[bytes, ty.Any, ty.Any]]:
		...
	
	#XXX: There must be some way to make the following shorter…
	@ty.overload
	def request(
			self, path: str,
			args: ty.Sequence[str] = [], *,
			opts: ty.Mapping[str, str] = {},
			decoder: ty_Literal_none = "none",
			stream: utils.Literal_False = False,
			offline: bool = False,
			auth: auth_t = None,
			cookies: cookies_t = None,
			data: reqdata_sync_t = None,
			headers: headers_t = None,
			timeout: timeout_t = None
	) -> bytes:
		...
	
	@ty.overload
	def request(
			self, path: str,
			args: ty.Sequence[str] = [], *,
			opts: ty.Mapping[str, str] = {},
			decoder: ty_Literal_none = "none",
			stream: utils.Literal_True,
			offline: bool = False,
			auth: auth_t = None,
			cookies: cookies_t = None,
			data: reqdata_sync_t = None,
			headers: headers_t = None,
			timeout: timeout_t = None
	) -> StreamDecodeIteratorSync[bytes]:
		...
	
	@ty.overload
	def request(
			self, path: str,
			args: ty.Sequence[str] = [], *,
			opts: ty.Mapping[str, str] = {},
			decoder: ty_Literal_json,
			stream: utils.Literal_False = False,
			offline: bool = False,
			auth: auth_t = None,
			cookies: cookies_t = None,
			data: reqdata_sync_t = None,
			headers: headers_t = None,
			timeout: timeout_t = None
	) -> ty.List[utils.json_dict_t]:
		...
	
	@ty.overload
	def request(
			self, path: str,
			args: ty.Sequence[str] = [], *,
			opts: ty.Mapping[str, str] = {},
			decoder: ty_Literal_json,
			stream: utils.Literal_True,
			offline: bool = False,
			auth: auth_t = None,
			cookies: cookies_t = None,
			data: reqdata_sync_t = None,
			headers: headers_t = None,
			timeout: timeout_t = None
	) -> StreamDecodeIteratorSync[utils.json_dict_t]:
		...
	
	
	def request(
			self, path: str,
			args: ty.Sequence[str] = [], *,
			opts: ty.Mapping[str, str] = {},
			decoder: ty.Union[ty_Literal_json, ty_Literal_none] = "none",
			stream: bool = False,
			offline: bool = False,
			auth: auth_t = None,
			cookies: cookies_t = None,
			data: reqdata_sync_t = None,
			headers: headers_t = None,
			timeout: timeout_t = None
	) -> ty.Optional[ty.Union[
		StreamDecodeIteratorSync[bytes],
		StreamDecodeIteratorSync[utils.json_dict_t],
		bytes,
		ty.List[utils.json_dict_t],
	]]:
		"""Sends an HTTP request to the IPFS daemon
		
		This function returns the contents of the HTTP response from the IPFS
		daemon.
		
		Raises
		------
		~ipfshttpclient.exceptions.ErrorResponse
		~ipfshttpclient.exceptions.ConnectionError
		~ipfshttpclient.exceptions.ProtocolError
		~ipfshttpclient.exceptions.StatusError
		~ipfshttpclient.exceptions.TimeoutError
		
		Parameters
		----------
		path
			The command path relative to the given base
		decoder
			The name of the encoder to use to parse the HTTP response
		stream
			Whether to return an iterable yielding the received items incrementally
			instead of receiving and decoding all items up-front before returning
			them
		args
			Positional parameters to be sent along with the HTTP request
		opts
			Query string parameters to be sent along with the HTTP request
		offline
			Whether to request to daemon to handle this request in “offline-mode”
		auth
			Authentication data to send along with this request as
			``(username, password)`` tuple
		cookies
			HTTP cookies to send along with each request to the API daemon
		data
			Iterable yielding data to stream from the client to the daemon
		headers
			Custom HTTP headers to pass send along with the request
		timeout
			How many seconds to wait for the server to send data
			before giving up
			
			Set this to :py:`math.inf` to disable timeouts entirely.
		"""
		method = "POST"
		parser = encoding.get_encoding(decoder)
		
		closables, res = self._request(
			method, path, map_args_to_params(args, opts, offline=offline),
			auth=auth, data=data, headers=headers, timeout=timeout,
			chunk_size=None,
		)  # type: ty.Tuple[ty.List[Closable], ty.Generator[bytes, ty.Any, ty.Any]]
		try:
			if stream:
				# Decode each item as it is read
				return StreamDecodeIteratorSync(closables, res, parser)  # type: ignore[misc]
			else:
				# Decode received item immediately
				return stream_decode_full(closables, res,
				                          parser)  # type: ignore[arg-type]
		except:
			# Extra cleanup code for closables
			#
			# At the time of writing, there does not appear to be any way to
			# trigger this loop in practice, but we keep it for as extra level
			# of defence in case things slightly change later-on.
			for closable in closables:  # pragma: no cover
				closable.close()
			
			raise
	
	def download(
			self, path: str, target: utils.path_t = ".",
			args: ty.Sequence[str] = [], *,
			opts: ty.Mapping[str, str] = {},
			compress: bool = False,
			offline: bool = False,
			auth: auth_t = None,
			cookies: cookies_t = None,
			data: reqdata_sync_t = None,
			headers: headers_t = None,
			timeout: timeout_t = None
	) -> None:
		"""Downloads a directory from the IPFS daemon
		
		Downloads a file or files from IPFS into the current working
		directory, or the directory given by ``target``.
		
		Raises
		------
		~ipfshttpclient.exceptions.ErrorResponse
		~ipfshttpclient.exceptions.ConnectionError
		~ipfshttpclient.exceptions.ProtocolError
		~ipfshttpclient.exceptions.StatusError
		~ipfshttpclient.exceptions.TimeoutError
		
		Parameters
		----------
		path
			The command path relative to the given base
		target
			The local path where downloaded files should be stored at
			
			Defaults to the current working directory.
		args
			Positional parameters to be sent along with the HTTP request
		opts
			Query string parameters to be sent along with the HTTP request
		compress
			Whether the downloaded file should be GZip compressed by the
			daemon before being sent to the client
			
			This may greatly speed up things if data is sent across slower networks
			like the internet but is a major bottleneck when communicating with the
			daemon on ``localhost``.
		offline
			Whether to request to daemon to handle this request in “offline-mode”
		auth
			Authentication data to send along with this request as
			``(username, password)`` tuple
		cookies
			HTTP cookies to send along with each request to the API daemon
		data
			Iterable yielding data to stream from the client to the daemon
		headers
			Custom HTTP headers to pass send along with the request
		timeout
			How many seconds to wait for the server to send data
			before giving up
			
			Set this to :py:`math.inf` to disable timeouts entirely.
		"""
		opts2: ty.Dict[str, str] = dict(opts.items())
		opts2["archive"] = "true"
		opts2["compress"] = "true" if compress else "false"
		
		closables, res = self._request(
			"POST", path, map_args_to_params(args, opts2, offline=offline),
			auth=auth, data=data, headers=headers, timeout=timeout,
			chunk_size=tarfile.RECORDSIZE,
		)
		try:
			# try to stream download as a tar file stream
			mode = 'r|gz' if compress else 'r|'
			
			fileobj = ReadableStreamWrapper(res)  # type: ty.IO[bytes]  # type: ignore[assignment]
			with tarfile.open(fileobj=fileobj, mode=mode) as tf:
				tf.extractall(path=target)
		finally:
			for closable in closables:
				closable.close()
