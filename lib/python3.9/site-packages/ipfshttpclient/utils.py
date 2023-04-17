"""A module to handle generic operations.
"""
import mimetypes
import os
import sys
import typing as ty
from functools import wraps

if ty.TYPE_CHECKING:
	import typing_extensions as ty_ext
else:
	ty_ext = ty

AnyStr = ty.TypeVar('AnyStr', bytes, str)
T = ty.TypeVar("T")

if sys.version_info >= (3, 8):  #PY38+
	Literal = ty_ext.Literal
	Protocol = ty_ext.Protocol
	
	Literal_True = ty.Literal[True]
	Literal_False = ty.Literal[False]
else:  #PY37-
	class Literal(ty.Generic[T]):
		...
	
	class Protocol:
		...
	
	Literal_True = Literal_False = bool

# `os.PathLike` only has a type param while type checking
if ty.TYPE_CHECKING:
	PathLike = os.PathLike
	PathLike_str = os.PathLike[str]
	PathLike_bytes = os.PathLike[bytes]
else:
	class PathLike(Protocol, ty.Generic[AnyStr]):
		def __fspath__(self) -> AnyStr:
			...

	PathLike_str = PathLike_bytes = os.PathLike

path_str_t = ty.Union[str, PathLike_str]
path_bytes_t = ty.Union[bytes, PathLike_bytes]
path_t = ty.Union[path_str_t, path_bytes_t]
AnyPath = ty.TypeVar("AnyPath", str, PathLike_str, bytes, PathLike_bytes)

path_types = (str, bytes, os.PathLike,)
path_obj_types = (os.PathLike,)


# work around GH/mypy/mypy#731: no recursive structural types yet
json_primitive_t = ty.Union[bool, float, int, str]


# noqa: N802
class json_list_t(ty.List["json_value_t"]):
	pass


# noqa: N802
class json_dict_t(ty.Dict[str, "json_value_t"]):
	pass


json_value_t = ty.Union[
	json_primitive_t,
	json_list_t,
	json_dict_t
]


def maybe_fsencode(val: str, ref: AnyStr) -> AnyStr:
	"""Encodes the string *val* using the system filesystem encoding if *ref*
	is of type :any:`bytes`"""

	if isinstance(ref, bytes):
		return os.fsencode(val)
	else:
		return val


def guess_mimetype(filename: str) -> str:
	"""Guesses the mimetype of a file based on the given ``filename``.
	
	.. code-block:: python
	
		>>> guess_mimetype('example.txt')
		'text/plain'
		>>> guess_mimetype('/foo/bar/example')
		'application/octet-stream'
	
	Parameters
	----------
	filename
		The file name or path for which the mimetype is to be guessed
	"""
	fn = os.path.basename(filename)
	return mimetypes.guess_type(fn)[0] or 'application/octet-stream'


clean_file_t = ty.Union[path_t, ty.IO[bytes], int]


def clean_file(file: clean_file_t) -> ty.Tuple[ty.IO[bytes], bool]:
	"""Returns a tuple containing a file-like object and a close indicator
	
	This ensures the given file is opened and keeps track of files that should
	be closed after use (files that were not open prior to this function call).
	
	Raises
	------
	OSError
		Accessing the given file path failed
	
	Parameters
	----------
	file
		A filepath or file-like object that may or may not need to be
		opened
	"""
	if isinstance(file, int):
		return os.fdopen(file, 'rb', closefd=False), True
	elif not hasattr(file, 'read'):
		file = ty.cast(path_t, file)  # Cannot be ty.IO[bytes] without `.read()`
		return open(file, 'rb'), True
	else:
		file = ty.cast(ty.IO[bytes], file)  # Must be ty.IO[bytes]
		return file, False


def clean_files(files: ty.Union[clean_file_t, ty.Iterable[clean_file_t]]) \
    -> ty.Generator[ty.Tuple[ty.IO[bytes], bool], ty.Any, ty.Any]:
	"""Generates tuples with a file-like object and a close indicator
	
	This is a generator of tuples, where the first element is the file object
	and the second element is a boolean which is True if this module opened the
	file (and thus should close it).
	
	Raises
	------
	OSError
		Accessing the given file path failed
	
	Parameters
	----------
	files
		Collection or single instance of a filepath and file-like object
	"""
	if not isinstance(files, path_types) and not hasattr(files, "read"):
		for f in ty.cast(ty.Iterable[clean_file_t], files):
			yield clean_file(f)
	else:
		yield clean_file(ty.cast(clean_file_t, files))


F = ty.TypeVar("F", bound=ty.Callable[..., ty.Dict[str, ty.Any]])


class return_field(ty.Generic[T]):
	"""Decorator that returns the given field of a json response.
	
	Parameters
	----------
	field
		The response field to be returned for all invocations
	"""
	__slots__ = ("field",)

	field: str
	
	def __init__(self, field: str) -> None:
		self.field = field
	
	def __call__(self, cmd: F) -> ty.Callable[..., T]:
		"""Wraps a command so that only a specified field is returned.
		
		Parameters
		----------
		cmd
			A command that is intended to be wrapped
		"""
		@wraps(cmd)
		def wrapper(*args: ty.Any, **kwargs: ty.Any) -> T:
			"""Returns the specified field as returned by the wrapped function
			
			Parameters
			----------
			args
				Positional parameters to pass to the wrapped callable
			kwargs
				Named parameter to pass to the wrapped callable
			"""
			res = cmd(*args, **kwargs)  # type: ty.Dict[str, T]
			return res[self.field]
		return wrapper
