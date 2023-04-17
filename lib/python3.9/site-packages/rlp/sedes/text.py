from rlp.exceptions import SerializationError, DeserializationError
from rlp.atomic import Atomic


class Text:
    """A sedes object for encoded text data of certain length.

    :param min_length: the minimal length in encoded characters or `None` for no lower limit
    :param max_length: the maximal length in encoded characters or `None` for no upper limit
    :param allow_empty: if true, empty strings are considered valid even if
                        a minimum length is required otherwise
    """

    def __init__(self, min_length=None, max_length=None, allow_empty=False, encoding='utf8'):
        self.min_length = min_length or 0
        if max_length is None:
            self.max_length = float('inf')
        else:
            self.max_length = max_length
        self.allow_empty = allow_empty
        self.encoding = encoding

    @classmethod
    def fixed_length(cls, l, allow_empty=False):
        """Create a sedes for text data with exactly `l` encoded characters."""
        return cls(l, l, allow_empty=allow_empty)

    @classmethod
    def is_valid_type(cls, obj):
        return isinstance(obj, str)

    def is_valid_length(self, l):
        return any((
            self.min_length <= l <= self.max_length,
            self.allow_empty and l == 0
        ))

    def serialize(self, obj):
        if not self.is_valid_type(obj):
            raise SerializationError('Object is not a serializable ({})'.format(type(obj)), obj)

        if not self.is_valid_length(len(obj)):
            raise SerializationError('Object has invalid length', obj)

        return obj.encode(self.encoding)

    def deserialize(self, serial):
        if not isinstance(serial, Atomic):
            m = 'Objects of type {} cannot be deserialized'
            raise DeserializationError(m.format(type(serial).__name__), serial)

        try:
            text_value = serial.decode(self.encoding)
        except UnicodeDecodeError as err:
            raise DeserializationError(str(err), serial)

        if self.is_valid_length(len(text_value)):
            return text_value
        else:
            raise DeserializationError('{} has invalid length'.format(type(serial)), serial)


text = Text()
