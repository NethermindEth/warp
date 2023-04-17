"""
The class hierarchy for exceptions is::

    builtins.Exception
     ├── builtins.Warning
     │    └── VersionMismatch
     └── Error
          ├── AddressError
          ├── EncoderError
          │    ├── EncoderMissingError
          │    ├── EncodingError
          │    └── DecodingError
          ├── CommunicationError
          │    ├── ProtocolError
          │    ├── StatusError
          │    ├── ErrorResponse
          │    │    └── PartialErrorResponse
          │    ├── ConnectionError
          │    └── TimeoutError
          └── MatcherSpecInvalidError

"""

import typing as ty

import multiaddr.exceptions  # type: ignore[import]


class Error(Exception):
	"""Base class for all exceptions in this module."""
	__slots__ = ()


class AddressError(Error, multiaddr.exceptions.Error):  # type: ignore[no-any-unimported, misc]
	"""Raised when the provided daemon location Multiaddr does not match any
	of the supported patterns."""
	__slots__ = ("addr",)

	addr: ty.Union[str, bytes]
	
	def __init__(self, addr: ty.Union[str, bytes]) -> None:
		self.addr = addr
		Error.__init__(self, "Unsupported Multiaddr pattern: {0!r}".format(addr))


class VersionMismatch(Warning):
	"""Raised when daemon version is not supported by this client version."""
	__slots__ = ("current", "minimum", "maximum")

	current: ty.Sequence[int]
	minimum: ty.Sequence[int]
	maximum: ty.Sequence[int]
	
	def __init__(self, current: ty.Sequence[int], minimum: ty.Sequence[int],
	             maximum: ty.Sequence[int]) -> None:
		self.current = current
		self.minimum = minimum
		self.maximum = maximum
		
		msg = "Unsupported daemon version '{}' (not in range: {} ≤ … < {})".format(
			".".join(map(str, current)), ".".join(map(str, minimum)), ".".join(map(str, maximum))
		)
		super().__init__(msg)


###############
# encoding.py #
###############
class EncoderError(Error):
	"""Base class for all encoding and decoding related errors."""
	__slots__ = ("encoder_name",)

	encoder_name: str
	
	def __init__(self, message: str, encoder_name: str) -> None:
		self.encoder_name = encoder_name
		
		super().__init__(message)


class EncoderMissingError(EncoderError):
	"""Raised when a requested encoder class does not actually exist."""
	__slots__ = ()
	
	def __init__(self, encoder_name: str) -> None:
		super().__init__("Unknown encoder: '{}'".format(encoder_name), encoder_name)


class EncodingError(EncoderError):
	"""Raised when encoding a Python object into a byte string has failed
	due to some problem with the input data."""
	__slots__ = ("original",)

	original: Exception
	
	def __init__(self, encoder_name: str, original: Exception) -> None:
		self.original = original
		
		super().__init__("Object encoding error: {}".format(original), encoder_name)


class DecodingError(EncoderError):
	"""Raised when decoding a byte string to a Python object has failed due to
	some problem with the input data."""
	__slots__ = ("original",)

	original: Exception
	
	def __init__(self, encoder_name: str, original: Exception) -> None:
		self.original = original
		
		super().__init__("Object decoding error: {}".format(original), encoder_name)


##################
# filescanner.py #
##################

class MatcherSpecInvalidError(Error, TypeError):
	"""
	An attempt was made to build a matcher using matcher_from_spec, but an invalid
	specification was provided.
	"""

	def __init__(self, invalid_spec: ty.Any) -> None:
		super().__init__(
			f"Don't know how to create a Matcher from spec {invalid_spec!r}"
		)


###########
# http.py #
###########
class CommunicationError(Error):
	"""Base class for all network communication related errors."""
	__slots__ = ("original",)

	original: ty.Optional[Exception]
	
	def __init__(self, original: ty.Optional[Exception],
	             _message: ty.Optional[str] = None) -> None:
		self.original = original
		
		if _message:
			msg = _message
		else:
			msg = "{}: {}".format(type(original).__name__, str(original))
		super().__init__(msg)


class ProtocolError(CommunicationError):
	"""Raised when parsing the response from the daemon has failed.
	
	This can most likely occur if the service on the remote end isn't in fact
	an IPFS daemon."""
	__slots__ = ()


class StatusError(CommunicationError):
	"""Raised when the daemon responds with an error to our request."""
	__slots__ = ()


class ErrorResponse(StatusError):
	"""Raised when the daemon has responded with an error message because the
	requested operation could not be carried out."""
	__slots__ = ()
	
	def __init__(self, message: str, original: ty.Optional[Exception]) -> None:
		super().__init__(original, message)


class PartialErrorResponse(ErrorResponse):
	"""Raised when the daemon has responded with an error message after having
	already returned some data."""
	__slots__ = ()
	
	def __init__(self, message: str, original: ty.Optional[Exception] = None) -> None:
		super().__init__(message, original)


class ConnectionError(CommunicationError):
	"""Raised when connecting to the service has failed on the socket layer."""
	__slots__ = ()


class TimeoutError(CommunicationError):
	"""Raised when the daemon didn't respond in time."""
	__slots__ = ()
