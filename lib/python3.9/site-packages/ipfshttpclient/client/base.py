import functools
import sys
import typing as ty

import multiaddr  # type: ignore[import]

from . import DEFAULT_ADDR, DEFAULT_BASE, DEFAULT_USERNAME, DEFAULT_PASSWORD

from .. import multipart, http, utils
from ..http_common import ClientSyncBase


#XXX: Review if this is still necessary after requiring Python 3.8.
if ty.TYPE_CHECKING:
	import typing_extensions as ty_ext
else:
	ty_ext = utils

# Ensure that proper types show up when generating documentation without hard-depending on
# the cid package.
if "cid" in sys.modules:
	import cid  # type: ignore[import]
	cid_t = ty.Union[str, cid.CIDv0, cid.CIDv1]
elif not ty.TYPE_CHECKING:
	cid_t = str

multiaddr_t = ty.Union[str, multiaddr.Multiaddr]


# Alias JSON types
json_dict_t = utils.json_dict_t
json_list_t = utils.json_list_t
json_primitive_t = utils.json_primitive_t
json_value_t = utils.json_value_t

#XXX: The following would be more useful with https://github.com/python/mypy/issues/4441
if ty.TYPE_CHECKING:
	# Lame workaround for type checkers
	CommonArgs = ty.Union[bool, http.auth_t, http.cookies_t, http.reqdata_sync_t,
	                      http.headers_t, http.timeout_t]
elif hasattr(ty, "TypedDict"):
	# This is what type checkers should actually use
	CommonArgs = ty.TypedDict("CommonArgs", {
		"offline": bool,
		"auth": http.auth_t,
		"cookies": http.cookies_t,
		"data": http.reqdata_sync_t,
		"headers": http.headers_t,
		"timeout": http.timeout_t,
	})
else:
	CommonArgs = ty.Dict[str, ty.Any]

#XXX: work around https://github.com/python/mypy/issues/731: no recursive structural types yet
response_item_t = ty.Union[
	json_primitive_t,
	"ResponseBase",
	"_response_item_list_t"
]


class _response_item_list_t(ty.List[response_item_t]):
	pass


class ResponseBase(ty.Mapping[str, response_item_t]):
	"""Base class for wrapping IPFS node API responses
	
	Original JSON properties are exposed using dict item syntax ``response[key]``.
	To access the raw parsed JSON object use the :meth:`as_json` method.
	"""
	__slots__ = ("_raw",)
	#_raw: json_dict_t
	
	_repr_attr_display = list()  # type: ty.Sequence[str]
	_repr_json_hidden  = set()  # type: ty.Container[str]
	
	def __init__(self, response: json_dict_t):
		self._raw = response
	
	def __getitem__(self, name: str) -> response_item_t:
		return self._wrap_result(self._raw[name])
	
	@classmethod
	def _wrap_result(cls, value: json_value_t) -> response_item_t:
		if isinstance(value, dict):
			result = ResponseBase(value)  # type: response_item_t
		elif isinstance(value, list):
			result = _response_item_list_t()  # Part of workaround
			for v in value:
				result.append(cls._wrap_result(v))
		else:
			result = value
		return result
	
	def __iter__(self) -> ty.Iterator[str]:
		return iter(self._raw)
	
	def __len__(self) -> int:
		return len(self._raw)
	
	def __repr__(self) -> str:
		attr_str_parts = []  # type: ty.List[str]
		for name in type(self)._repr_attr_display:
			attr_str_parts.append("{0}={1!r}".format(name, getattr(self, name)))
		
		json_hidden = type(self)._repr_json_hidden
		attr_json_parts = []  # type: ty.List[str]
		for name, value in filter(lambda i: i[0] not in json_hidden, self._raw.items()):
			attr_json_parts.append("{0!r}: {1!r}".format(name, value))
		
		#arg_str: str
		if attr_str_parts and attr_json_parts:
			arg_str = "{0}, **{{{1}}}".format(", ".join(attr_str_parts), ", ".join(attr_json_parts))
		elif attr_str_parts:
			arg_str = ", ".join(attr_str_parts)
		else:
			arg_str = "{{{0}}}".format(", ".join(attr_json_parts))
		
		return "<{0.__module__}.{0.__qualname__}: {1}>".format(type(self), arg_str)
	
	def as_json(self) -> json_dict_t:
		"""Returns the original parsed JSON object as returned by the remote IPFS node
		
		In general, try to avoid modifying the returned dictionary if plan on
		subsequently using this response object.
		"""
		return self._raw


T = ty.TypeVar("T")
R = ty.TypeVar("R")

wrap_cb_t = ty.Callable[[T], R]


def ident(value: T) -> R:
	return ty.cast(R, value)


class ResponseWrapIterator(ty.Generic[T, R]):
	__slots__ = ("_inner", "_item_wrap_cb")
	#_inner: http.StreamDecodeIteratorSync[T]
	#_item_wrap_cb: wrap_cb_t[T, R]
	
	def __init__(self, inner: http.StreamDecodeIteratorSync[T], item_wrap_cb: wrap_cb_t[T, R]):
		self._inner = inner
		self._item_wrap_cb = item_wrap_cb
	
	def __iter__(self) -> "ResponseWrapIterator[T, R]":
		return self
	
	def __next__(self) -> R:
		return self._item_wrap_cb(next(self._inner))
	
	def __enter__(self) -> "ResponseWrapIterator[T, R]":
		self._inner.__enter__()
		return self
	
	def __exit__(self, *args: ty.Any) -> None:
		self._inner.__exit__(*args)
	
	def close(self) -> None:
		self._inner.close()



class _inner_func_t(ty_ext.Protocol, ty.Generic[T]):
	def __call__(self, *args: ty.Any, **kwargs: ty.Any) \
	    -> ty.Union[ty.List[T], http.StreamDecodeIteratorSync[T]]:
		...


class _returns_multiple_wrapper2_t(ty_ext.Protocol, ty.Generic[T, R]):
	@ty.overload
	def __call__(self, *args: ty.Any, stream: utils.Literal_True, **kwargs: ty.Any) -> ty.List[R]:
		...
	
	@ty.overload
	def __call__(self, *args: ty.Any, stream: utils.Literal_False = ..., **kwargs: ty.Any) \
	    -> ResponseWrapIterator[T, R]:
		...


class _returns_multiple_wrapper1_t(ty_ext.Protocol, ty.Generic[T, R]):
	def __call__(self, func: _inner_func_t[T]) -> _returns_multiple_wrapper2_t[T, R]:
		...


def returns_multiple_items(item_wrap_cb: wrap_cb_t[T, R] = ident, *, stream: bool = False) \
    -> _returns_multiple_wrapper1_t[T, R]:
	def wrapper1(func: _inner_func_t[T]) -> _returns_multiple_wrapper2_t[T, R]:
		@functools.wraps(func)
		def wrapper2(*args: ty.Any, **kwargs: ty.Any) \
		    -> ty.Union[ty.List[R], ResponseWrapIterator[T, R]]:
			result = func(*args, **kwargs)
			if isinstance(result, list):
				return [item_wrap_cb(r) for r in result]
			assert kwargs.get("stream", False) or stream, (
				"Called IPFS HTTP-Client function should only ever return a list, "
				"when not streaming a response"
			)
			return ResponseWrapIterator(result, item_wrap_cb)
		return wrapper2  # type: ignore[return-value]
	return wrapper1


class _returns_single_wrapper2_t(ty_ext.Protocol, ty.Generic[T, R]):
	@ty.overload
	def __call__(self, *args: ty.Any, stream: utils.Literal_True, **kwargs: ty.Any) -> R:
		...
	
	@ty.overload
	def __call__(self, *args: ty.Any, stream: utils.Literal_False = ..., **kwargs: ty.Any) \
	    -> ResponseWrapIterator[T, R]:
		...


class _returns_single_wrapper1_t(ty_ext.Protocol, ty.Generic[T, R]):
	def __call__(self, func: _inner_func_t[T]) -> _returns_single_wrapper2_t[T, R]:
		...


def returns_single_item(item_wrap_cb: wrap_cb_t[T, R] = ident, *, stream: bool = False) \
    -> _returns_single_wrapper1_t[T, R]:
	def wrapper1(func: _inner_func_t[T]) -> _returns_single_wrapper2_t[T, R]:
		@functools.wraps(func)
		def wrapper2(*args: ty.Any, **kwargs: ty.Any) -> ty.Union[R, ResponseWrapIterator[T, R]]:
			result = func(*args, **kwargs)
			if isinstance(result, list):
				assert len(result) == 1, ("Called IPFS HTTP-Client function should "
				                          "only ever return one item")
				return item_wrap_cb(result[0])
			
			assert kwargs.get("stream", False) or stream, (
				"Called IPFS HTTP-Client function should only ever return a list "
				"with a single item, when not streaming a response"
			)
			return ResponseWrapIterator(result, item_wrap_cb)
		return wrapper2  # type: ignore[return-value]
	return wrapper1


class _returns_single_wrapper_t(ty_ext.Protocol):
	@ty.overload
	def __call__(self, *args: ty.Any, stream: utils.Literal_True, **kwargs: ty.Any) \
	    -> ResponseWrapIterator[None, None]:
		...
	
	@ty.overload
	def __call__(self, *args: ty.Any, stream: utils.Literal_False = ..., **kwargs: ty.Any) -> None:
		...


def returns_no_item(func: _inner_func_t[ty.NoReturn]) -> _returns_single_wrapper_t:
	@functools.wraps(func)
	def wrapper(*args: ty.Any, **kwargs: ty.Any) \
	    -> ty.Union[None, ResponseWrapIterator[None, None]]:
		result = func(*args, **kwargs)
		if isinstance(result, (list, bytes, object)):
			assert not result, ("Called IPFS HTTP-Client function should never "
			                    "return a non-empty item")
			return None
		assert kwargs.get("stream", False), (  # type: ignore[unreachable]
			"Called IPFS HTTP-Client function should only ever return an empty "
			"object, when not  streaming a response"
		)
		return ResponseWrapIterator(result, ident)
	return wrapper  # type: ignore[return-value]


S = ty.TypeVar("S", bound="SectionBase")


class SectionProperty(ty.Generic[S]):
	def __init__(self, cls: ty.Type[S]):
		self.__prop_cls__ = cls
	
	@ty.overload
	def __get__(self, client_object: "ClientBase", type: None = None) -> S:
		...
	
	@ty.overload
	def __get__(self, client_object: None, type: ty.Type["ClientBase"]) -> ty.Type[S]:
		...
	
	def __get__(
			self, client_object: ty.Optional["ClientBase"],
			type: ty.Optional[ty.Type["ClientBase"]] = None
	) -> ty.Union[ty.Type[S], S]:
		if client_object is not None:  # We are invoked on object
			try:
				return client_object.__prop_objs__[self]  # type: ignore
			except AttributeError:
				client_object.__prop_objs__ = {  # type: ignore
					self: self.__prop_cls__(client_object)
				}
				return client_object.__prop_objs__[self]  # type: ignore
			except KeyError:
				client_object.__prop_objs__[self] = self.__prop_cls__(client_object)  # type: ignore
				return client_object.__prop_objs__[self]  # type: ignore
		else:  # We are invoked on the class
			return self.__prop_cls__


class SectionBase:
	# Accept parent object from property descriptor
	def __init__(self, parent: "ClientBase") -> None:
		self.__parent = parent

	# Proxy the parent's properties
	@property
	def _client(self) -> ClientSyncBase[ty.Any]:
		return self.__parent._client

	@property
	def chunk_size(self) -> int:
		return self.__parent.chunk_size

	@chunk_size.setter
	def chunk_size(self, value: int) -> None:
		self.__parent.chunk_size = value


class ClientBase:
	def __init__(  # type: ignore[no-any-unimported]
			self,
			addr: http.addr_t = DEFAULT_ADDR,
			base: str = DEFAULT_BASE, *,
			
			chunk_size: int = multipart.default_chunk_size,
			offline: bool = False,
			session: bool = False,
			
			auth: http.auth_t = None,
			cookies: http.cookies_t = None,
			headers: http.headers_t = {},  # type: ignore[assignment]  # False positive
			timeout: http.timeout_t = 120,
			
			username: ty.Optional[str] = DEFAULT_USERNAME,
			password: ty.Optional[str] = DEFAULT_PASSWORD
	):
		"""
		Arguments
		---------
		addr
			The `Multiaddr <dweb:/ipns/multiformats.io/multiaddr/>`_ describing the
			API daemon location, as used in the *API* key of `go-ipfs Addresses
			section
			<https://github.com/ipfs/go-ipfs/blob/master/docs/config.md#addresses>`_
			
			Supported addressing patterns are currently:
			
			 * ``/{dns,dns4,dns6,ip4,ip6}/<host>/tcp/<port>`` (HTTP)
			 * ``/{dns,dns4,dns6,ip4,ip6}/<host>/tcp/<port>/http`` (HTTP)
			 * ``/{dns,dns4,dns6,ip4,ip6}/<host>/tcp/<port>/https`` (HTTPS)
			
			Additional forms (proxying) may be supported in the future.
		base
			The HTTP URL path prefix (or “base”) at which the API is exposed on the
			API daemon
		chunk_size
			The size of data chunks passed to the operating system when uploading
			files or text/binary content
		offline
			Ask daemon to operate in “offline mode” – that is, it should not consult
			the network when unable to find resources locally, but fail instead
		session
			Create this :class:`~ipfshttpclient.Client` instance with a session
			already open? (Useful for long-running client objects.)
		auth
			HTTP basic authentication `(username, password)` tuple to send along with
			each request to the API daemon
		cookies
			HTTP cookies to send along with each request to the API daemon
		headers
			Custom HTTP headers to send along with each request to the API daemon
		timeout
			Connection timeout (in seconds) when connecting to the API daemon
			
			If a tuple is passed its contents will be interpreted as the values for
			the connecting and receiving phases respectively, otherwise the value will
			apply to both phases.
			
			The default value is implementation-defined. A value of `math.inf`
			disables the respective timeout.
		"""
		
		self.chunk_size = chunk_size
		
		if auth is None and (username or password):
			assert username and password
			auth = (username, password)
		
		self._client = http.build_client_sync(
			addr=addr,
			base=base,
			offline=offline,
			auth=auth,
			cookies=cookies,
			headers=headers,
			timeout=timeout
		)

		if session:
			self._client.open_session()
		
		self._workarounds = self._client.workarounds
