"""Classes for encoding and decoding datastreams into object values"""
import abc
import codecs
import typing as ty
import json

from . import exceptions
from . import utils


if ty.TYPE_CHECKING:
	import typing_extensions as ty_ext
else:
	from . import utils as ty_ext


T = ty.TypeVar("T")


def empty_gen() -> ty.Generator[T, None, None]:
	"""A generator that yields nothing"""
	if False:  # pragma: no branch
		yield ty.cast(T, None)  # type: ignore[unreachable]


class Encoding(ty.Generic[T], metaclass=abc.ABCMeta):
	"""Abstract base for a data parser/encoder interface"""
	#name: str
	is_stream = False  # type: bool
	
	@abc.abstractmethod
	def parse_partial(self, raw: bytes) -> ty.Generator[T, ty.Any, ty.Any]:
		"""Parses the given data and yields all complete data sets that can
		be built from this.
		
		Raises
		------
		~ipfshttpclient.exceptions.DecodingError
		
		Parameters
		----------
		raw
			Data to be parsed
		"""
	
	def parse_finalize(self) -> ty.Generator[T, ty.Any, ty.Any]:
		"""Finalizes parsing based on remaining buffered data and yields the
		remaining data sets
		
		Raises
		------
		   ~ipfshttpclient.exceptions.DecodingError
		"""
		return empty_gen()
	
	@abc.abstractmethod
	def encode(self, obj: T) -> bytes:
		"""Serializes the given Python object to a bytes string

		Raises
		------
		~ipfshttpclient.exceptions.EncodingError

		Parameters
		----------
		obj
			Object to be encoded
		"""


class Dummy(Encoding[bytes]):
	"""Dummy parser/encoder that does nothing"""
	name = "none"
	is_stream = True
	
	def parse_partial(self, raw: bytes) -> ty.Generator[bytes, ty.Any, ty.Any]:
		"""Yields the data passed into this method
		
		Parameters
		----------
		raw
			Any kind of data
		"""
		yield raw
	
	def encode(self, obj: bytes) -> bytes:
		"""Returns the bytes representation of the data passed into this
		function
		
		Parameters
		----------
		obj
			Any Python object
		"""
		return obj


class Json(Encoding[utils.json_value_t]):
	"""JSON parser/encoder that handles concatenated JSON"""
	name = 'json'
	
	def __init__(self) -> None:
		self._buffer    = []  # type: ty.List[ty.Optional[str]]
		self._decoder1  = codecs.getincrementaldecoder('utf-8')()
		self._decoder2  = json.JSONDecoder()
		self._lasterror = None  # type: ty.Optional[ValueError]
	
	# It works just fine and I don't want to rewrite it just because mypy doesn't understand…
	@ty.no_type_check
	def parse_partial(self, data: bytes) -> ty.Generator[utils.json_value_t, ty.Any, ty.Any]:
		"""Incrementally decodes JSON data sets into Python objects.
		
		Raises
		------
		~ipfshttpclient.exceptions.DecodingError
		"""
		try:
			# Python requires all JSON data to text strings
			lines = self._decoder1.decode(data, False).split("\n")
			
			# Add first input line to last buffer line, if applicable, to
			# handle cases where the JSON string has been chopped in half
			# at the network level due to streaming
			if len(self._buffer) > 0 and self._buffer[-1] is not None:
				self._buffer[-1] += lines[0]
				self._buffer.extend(lines[1:])
			else:
				self._buffer.extend(lines)
		except UnicodeDecodeError as error:
			raise exceptions.DecodingError('json', error) from error
		
		# Process data buffer
		index = 0
		try:
			# Process each line as separate buffer
			#PERF: This way the `.lstrip()` call becomes almost always a NOP
			#      even if it does return a different string it will only
			#      have to allocate a new buffer for the currently processed
			#      line.
			while index < len(self._buffer):
				while self._buffer[index]:
					# Make sure buffer does not start with whitespace
					#PERF: `.lstrip()` does not reallocate if the string does
					#      not actually start with whitespace.
					self._buffer[index] = self._buffer[index].lstrip()
					
					# Handle case where the remainder of the line contained
					# only whitespace
					if not self._buffer[index]:
						self._buffer[index] = None
						continue
					
					# Try decoding the partial data buffer and return results
					# from this
					#
					# Use `pragma: no branch` as the final loop iteration will always
					# raise if parsing didn't work out, rather then falling through
					# to the `yield obj` line.
					data = self._buffer[index]
					for index2 in range(index, len(self._buffer)):  # pragma: no branch
						# If decoding doesn't succeed with the currently
						# selected buffer (very unlikely with our current
						# class of input data) then retry with appending
						# any other pending pieces of input data
						# This will happen with JSON data that contains
						# arbitrary new-lines: "{1:\n2,\n3:4}"
						if index2 > index:
							data += "\n" + self._buffer[index2]
						
						try:
							(obj, offset) = self._decoder2.raw_decode(data)
						except ValueError:
							# Treat error as fatal if we have already added
							# the final buffer to the input
							if (index2 + 1) == len(self._buffer):
								raise
						else:
							index = index2
							break
					
					# Decoding succeeded – yield result and shorten buffer
					yield obj
					if offset < len(self._buffer[index]):
						self._buffer[index] = self._buffer[index][offset:]
					else:
						self._buffer[index] = None
				index += 1
		except ValueError as error:
			# It is unfortunately not possible to reliably detect whether
			# parsing ended because of an error *within* the JSON string, or
			# an unexpected *end* of the JSON string.
			# We therefor have to assume that any error that occurs here
			# *might* be related to the JSON parser hitting EOF and therefor
			# have to postpone error reporting until `parse_finalize` is
			# called.
			self._lasterror = error
		finally:
			# Remove all processed buffers
			del self._buffer[0:index]
	
	def parse_finalize(self) -> ty.Generator[utils.json_value_t, ty.Any, ty.Any]:
		"""Raises errors for incomplete buffered data that could not be parsed
		because the end of the input data has been reached.
		
		Raises
		------
		~ipfshttpclient.exceptions.DecodingError
		"""
		try:
			try:
				# Raise exception for remaining bytes in bytes decoder
				self._decoder1.decode(b'', True)
			except UnicodeDecodeError as error:
				raise exceptions.DecodingError('json', error) from error

			# Late raise errors that looked like they could have been fixed if
			# the caller had provided more data
			if self._buffer and self._lasterror:
				raise exceptions.DecodingError('json', self._lasterror) from self._lasterror
		finally:
			# Reset state
			self._buffer    = []
			self._lasterror = None
			self._decoder1.reset()
		
		return empty_gen()
	
	def encode(self, obj: utils.json_value_t) -> bytes:
		"""Returns ``obj`` serialized as JSON formatted bytes
		
		Raises
		------
		~ipfshttpclient.exceptions.EncodingError
		
		Parameters
		----------
		obj
			JSON serializable Python object
		"""
		try:
			result = json.dumps(obj, sort_keys=True, indent=None,
			                    separators=(',', ':'), ensure_ascii=False)
			return result.encode("utf-8")
		except (UnicodeEncodeError, TypeError) as error:
			raise exceptions.EncodingError('json', error) from error


# encodings supported by the IPFS api (default is JSON)
__encodings = {
	Dummy.name: Dummy,
	Json.name: Json,
}  # type: ty.Dict[str, ty.Type[Encoding[ty.Any]]]


@ty.overload
def get_encoding(name: ty_ext.Literal["none"]) -> Dummy:
	...

@ty.overload  # noqa: E302
def get_encoding(name: ty_ext.Literal["json"]) -> Json:
	...

def get_encoding(name: str) -> Encoding[ty.Any]:  # noqa: E302
	"""Returns an Encoder object for the given encoding name
	
	Raises
	------
	~ipfshttpclient.exceptions.EncoderMissingError
	
	Parameters
	----------
	name
		Encoding name. Supported options:
		
		 * ``"none"``
		 * ``"json"``
	"""
	try:
		return __encodings[name.lower()]()
	except KeyError:
		raise exceptions.EncoderMissingError(name) from None
