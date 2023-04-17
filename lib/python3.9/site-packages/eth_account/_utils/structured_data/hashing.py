from itertools import (
    groupby,
)
import json
from operator import (
    itemgetter,
)

from eth_abi import (
    encode_abi,
    is_encodable,
    is_encodable_type,
)
from eth_abi.grammar import (
    parse,
)
from eth_utils import (
    ValidationError,
    keccak,
    to_tuple,
    toolz,
)

from .validation import (
    validate_structured_data,
)


def get_dependencies(primary_type, types):
    """
    Perform DFS to get all the dependencies of the primary_type.
    """
    deps = set()
    struct_names_yet_to_be_expanded = [primary_type]

    while len(struct_names_yet_to_be_expanded) > 0:
        struct_name = struct_names_yet_to_be_expanded.pop()

        deps.add(struct_name)
        fields = types[struct_name]
        for field in fields:
            if field["type"] not in types:
                # We don't need to expand types that are not user defined (customized)
                continue
            elif field["type"] in deps:
                # skip types that we have already encountered
                continue
            else:
                # Custom Struct Type
                struct_names_yet_to_be_expanded.append(field["type"])

    # Don't need to make a struct as dependency of itself
    deps.remove(primary_type)

    return tuple(deps)


def field_identifier(field):
    """
    Convert a field dict into a typed-name string.

    Given a ``field`` of the format {'name': NAME, 'type': TYPE},
    this function converts it to ``TYPE NAME``
    """
    return "{0} {1}".format(field["type"], field["name"])


def encode_struct(struct_name, struct_field_types):
    return "{0}({1})".format(
        struct_name,
        ','.join(map(field_identifier, struct_field_types)),
    )


def encode_type(primary_type, types):
    """
    Serialize types into an encoded string.

    The type of a struct is encoded as name ‖ "(" ‖ member₁ ‖ "," ‖ member₂ ‖ "," ‖ … ‖ memberₙ ")"
    where each member is written as type ‖ " " ‖ name.
    """
    # Getting the dependencies and sorting them alphabetically as per EIP712
    deps = get_dependencies(primary_type, types)
    sorted_deps = (primary_type,) + tuple(sorted(deps))

    result = ''.join(
        [
            encode_struct(struct_name, types[struct_name])
            for struct_name in sorted_deps
        ]
    )
    return result


def hash_struct_type(primary_type, types):
    return keccak(text=encode_type(primary_type, types))


def is_array_type(type):
    # Identify if type such as "person[]" or "person[2]" is an array
    abi_type = parse(type)
    return abi_type.is_array


@to_tuple
def get_depths_and_dimensions(data, depth):
    """
    Yields 2-length tuples of depth and dimension of each element at that depth.
    """
    if not isinstance(data, (list, tuple)):
        # Not checking for Iterable instance, because even Dictionaries and strings
        # are considered as iterables, but that's not what we want the condition to be.
        return ()

    yield depth, len(data)

    for item in data:
        # iterating over all 1 dimension less sub-data items
        yield from get_depths_and_dimensions(item, depth + 1)


def get_array_dimensions(data):
    """
    Given an array type data item, check that it is an array and return the dimensions as a tuple.

    Ex: get_array_dimensions([[1, 2, 3], [4, 5, 6]]) returns (2, 3)
    """
    depths_and_dimensions = get_depths_and_dimensions(data, 0)
    # re-form as a dictionary with `depth` as key, and all of the dimensions found at that depth.
    grouped_by_depth = {
        depth: tuple(dimension for depth, dimension in group)
        for depth, group in groupby(depths_and_dimensions, itemgetter(0))
    }

    # validate that there is only one dimension for any given depth.
    invalid_depths_dimensions = tuple(
        (depth, dimensions)
        for depth, dimensions in grouped_by_depth.items()
        if len(set(dimensions)) != 1
    )
    if invalid_depths_dimensions:
        raise ValidationError(
            '\n'.join(
                [
                    "Depth {0} of array data has more than one dimensions: {1}".
                    format(depth, dimensions)
                    for depth, dimensions in invalid_depths_dimensions
                ]
            )
        )

    dimensions = tuple(
        toolz.first(set(dimensions))
        for depth, dimensions in sorted(grouped_by_depth.items())
    )

    return dimensions


@to_tuple
def flatten_multidimensional_array(array):
    for item in array:
        if isinstance(item, (list, tuple)):
            # Not checking for Iterable instance, because even Dictionaries and strings
            # are considered as iterables, but that's not what we want the condition to be.
            yield from flatten_multidimensional_array(item)
        else:
            yield item


@to_tuple
def _encode_data(primary_type, types, data):
    # Add typehash
    yield "bytes32", hash_struct_type(primary_type, types)

    # Add field contents
    for field in types[primary_type]:
        value = data[field["name"]]
        if field["type"] == "string":
            if not isinstance(value, str):
                raise TypeError(
                    "Value of `{0}` ({2}) in the struct `{1}` is of the type `{3}`, but expected "
                    "string value".format(
                        field["name"],
                        primary_type,
                        value,
                        type(value),
                    )
                )
            # Special case where the values need to be keccak hashed before they are encoded
            hashed_value = keccak(text=value)
            yield "bytes32", hashed_value
        elif field["type"] == "bytes":
            if not isinstance(value, bytes):
                raise TypeError(
                    "Value of `{0}` ({2}) in the struct `{1}` is of the type `{3}`, but expected "
                    "bytes value".format(
                        field["name"],
                        primary_type,
                        value,
                        type(value),
                    )
                )
            # Special case where the values need to be keccak hashed before they are encoded
            hashed_value = keccak(primitive=value)
            yield "bytes32", hashed_value
        elif field["type"] in types:
            # This means that this type is a user defined type
            hashed_value = keccak(primitive=encode_data(field["type"], types, value))
            yield "bytes32", hashed_value
        elif is_array_type(field["type"]):
            # Get the dimensions from the value
            array_dimensions = get_array_dimensions(value)
            # Get the dimensions from what was declared in the schema
            parsed_type = parse(field["type"])
            for i in range(len(array_dimensions)):
                if len(parsed_type.arrlist[i]) == 0:
                    # Skip empty or dynamically declared dimensions
                    continue
                if array_dimensions[i] != parsed_type.arrlist[i][0]:
                    # Dimensions should match with declared schema
                    raise TypeError(
                        "Array data `{0}` has dimensions `{1}` whereas the "
                        "schema has dimensions `{2}`".format(
                            value,
                            array_dimensions,
                            tuple(map(lambda x: x[0], parsed_type.arrlist)),
                        )
                    )

            array_items = flatten_multidimensional_array(value)
            array_items_encoding = [
                encode_data(parsed_type.base, types, array_item)
                for array_item in array_items
            ]
            concatenated_array_encodings = b''.join(array_items_encoding)
            hashed_value = keccak(concatenated_array_encodings)
            yield "bytes32", hashed_value
        else:
            # First checking to see if type is valid as per abi
            if not is_encodable_type(field["type"]):
                raise TypeError(
                    "Received Invalid type `{0}` in the struct `{1}`".format(
                        field["type"],
                        primary_type,
                    )
                )

            # Next see if the data fits the specified encoding type
            if is_encodable(field["type"], value):
                # field["type"] is a valid type and this value corresponds to that type.
                yield field["type"], value
            else:
                raise TypeError(
                    "Value of `{0}` ({2}) in the struct `{1}` is of the type `{3}`, but expected "
                    "{4} value".format(
                        field["name"],
                        primary_type,
                        value,
                        type(value),
                        field["type"],
                    )
                )


def encode_data(primaryType, types, data):
    data_types_and_hashes = _encode_data(primaryType, types, data)
    data_types, data_hashes = zip(*data_types_and_hashes)
    return encode_abi(data_types, data_hashes)


def load_and_validate_structured_message(structured_json_string_data):
    structured_data = json.loads(structured_json_string_data)
    validate_structured_data(structured_data)

    return structured_data


def hash_domain(structured_data):
    return keccak(
        encode_data(
            "EIP712Domain",
            structured_data["types"],
            structured_data["domain"]
        )
    )


def hash_message(structured_data):
    return keccak(
        encode_data(
            structured_data["primaryType"],
            structured_data["types"],
            structured_data["message"]
        )
    )
