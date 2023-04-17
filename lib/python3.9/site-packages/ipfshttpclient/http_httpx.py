"""HTTP client for API requests based on HTTPx

This will be supplemented by an asynchronous version based on HTTPx's
asynchronous API soon™.
"""

import math
import socket
import typing as ty

import httpcore
import httpx

from . import encoding
from . import exceptions
from .http_common import (
	ClientSyncBase, multiaddr_to_url_data,
	
	addr_t, auth_t, cookies_t, headers_t, params_t, reqdata_sync_t, timeout_t,
	Closable,
)


if ty.TYPE_CHECKING:
	import httpx._types
	import typing_extensions
	
	# By using the precise types from HTTPx we'll also get type errors if our
	# types become somehow incompatible with the ones from that library
	RequestArgs = typing_extensions.TypedDict("RequestArgs", {
		"auth": "httpx._types.AuthTypes",
		"cookies": "httpx._types.CookieTypes",
		"headers": "httpx._types.HeaderTypes",
		"timeout": "httpx._types.TimeoutTypes",
		"params": "httpx._types.QueryParamTypes",
	}, total=False)
else:
	RequestArgs = ty.Dict[str, ty.Any]


def map_args_to_httpx(
		*,
		auth: auth_t = None,
		cookies: cookies_t = None,
		headers: headers_t = None,
		params: params_t = None,
		timeout: timeout_t = None,
) -> RequestArgs:
	kwargs: RequestArgs = {}
	
	if auth is not None:
		kwargs["auth"] = auth
	
	if cookies is not None:
		kwargs["cookies"] = cookies
	
	if headers is not None:
		kwargs["headers"] = headers
	
	if timeout is not None:
		if isinstance(timeout, tuple):
			kwargs["timeout"] = (
				timeout[0] if timeout[0] < math.inf else None,
				timeout[1] if timeout[1] < math.inf else None,
				None,
				None,
			)
		else:
			kwargs["timeout"] = timeout if timeout < math.inf else None
	
	if params is not None:
		kwargs["params"] = list(params)
	
	return kwargs


class ClientSync(ClientSyncBase[httpx.Client]):
	__slots__ = ("_session_base", "_session_kwargs", "_session_laddr", "_session_uds_path")
	_session_base: "httpx._types.URLTypes"
	_session_kwargs: RequestArgs
	_session_laddr: ty.Optional[str]
	_session_uds_path: ty.Optional[str]
	
	def _init(self, addr: addr_t, base: str, *,  # type: ignore[no-any-unimported]
	          auth: auth_t,
	          cookies: cookies_t,
	          headers: headers_t,
	          params: params_t,
	          timeout: timeout_t) -> None:
		base_url: str
		uds_path: ty.Optional[str]
		family: socket.AddressFamily
		host_numeric: bool
		base_url, uds_path, family, host_numeric = multiaddr_to_url_data(addr, base)
		
		self._session_laddr = None
		self._session_uds_path = None
		if family != socket.AF_UNSPEC:
			if family == socket.AF_INET:
				self._session_laddr = "0.0.0.0"
			elif family == socket.AF_INET6:
				self._session_laddr = "::"
			elif family == socket.AF_UNIX:
				self._session_uds_path = uds_path
			else:
				assert False, ("multiaddr_to_url_data should only return a socket "
				               "address family of AF_INET, AF_INET6 or AF_UNSPEC")
		
		self._session_base = base_url
		self._session_kwargs = map_args_to_httpx(
			auth=auth,
			cookies=cookies,
			headers=headers,
			params=params,
			timeout=timeout,
		)
	
	def _make_session(self) -> httpx.Client:
		connection_pool = httpcore.SyncConnectionPool(
			local_address = self._session_laddr,
			uds = self._session_uds_path,
			
			#XXX: Argument values duplicated from httpx._client.Client._init_transport:
			keepalive_expiry          = 5.0,  #XXX: Value duplicated from httpx._client.KEEPALIVE_EXPIRY
			max_connections           = 100,  #XXX: Value duplicated from httpx._config.DEFAULT_LIMITS
			max_keepalive_connections = 20,   #XXX: Value duplicated from httpx._config.DEFAULT_LIMITS
			ssl_context               = httpx.create_ssl_context(trust_env=True),
		)
		return httpx.Client(**self._session_kwargs,
		                    base_url  = self._session_base,
		                    transport = connection_pool)
	
	def _do_raise_for_status(self, response: httpx.Response) -> None:
		try:
			response.raise_for_status()
		except httpx.HTTPError as error:
			content: ty.List[object] = []
			try:
				decoder: encoding.Json = encoding.get_encoding("json")
				for chunk in response.iter_bytes():
					content += list(decoder.parse_partial(chunk))
				content += list(decoder.parse_finalize())
			except exceptions.DecodingError:
				pass
			
			# If we have decoded an error response from the server,
			# use that as the exception message; otherwise, just pass
			# the exception on to the caller.
			if len(content) == 1 \
			   and isinstance(content[0], dict) \
			   and "Message" in content[0]:
				msg: str = content[0]["Message"]
				raise exceptions.ErrorResponse(msg, error) from error
			else:
				raise exceptions.StatusError(error) from error
	
	def _request(
			self, method: str, path: str, params: ty.Sequence[ty.Tuple[str, str]], *,
			auth: auth_t,
			data: reqdata_sync_t,
			headers: headers_t,
			timeout: timeout_t,
			chunk_size: ty.Optional[int],
	) -> ty.Tuple[ty.List[Closable], ty.Generator[bytes, ty.Any, ty.Any]]:
		# Ensure path is relative so that it is resolved relative to the base
		while path.startswith("/"):
			path = path[1:]
		
		try:
			# Determine session object to use
			closables: ty.List[Closable]
			session: httpx.Client
			closables, session = self._access_session()
			
			# Do HTTP request (synchronously) and map exceptions
			try:
				res: httpx.Response = session.stream(
					method=method,
					url=path,
					**map_args_to_httpx(
						params=params,
						auth=auth,
						headers=headers,
						timeout=timeout,
					),
					data=data,
				).__enter__()
				closables.insert(0, res)
			except (httpx.ConnectTimeout, httpx.ReadTimeout, httpx.WriteTimeout) as error:
				raise exceptions.TimeoutError(error) from error
			except httpx.NetworkError as error:
				raise exceptions.ConnectionError(error) from error
			except httpx.ProtocolError as error:
				raise exceptions.ProtocolError(error) from error
			
			# Raise exception for response status
			# (optionally incorporating the response message, if available)
			self._do_raise_for_status(res)
			
			return closables, res.iter_bytes()  # type: ignore[return-value]  #FIXME: httpx
		except:
			for closable in closables:
				closable.close()
			raise