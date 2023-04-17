from typing import Any, Callable, Dict, Generator, List, Tuple
import warnings

from .decorators import return_arg_type
from .functional import to_dict
from .toolz import compose, curry

Formatters = Callable[[List[Any]], List[Any]]


@return_arg_type(2)
def apply_formatter_at_index(
    formatter: Callable[..., Any], at_index: int, value: List[Any]
) -> Generator[List[Any], None, None]:
    if at_index + 1 > len(value):
        raise IndexError(
            "Not enough values in iterable to apply formatter.  Got: {0}. "
            "Need: {1}".format(len(value), at_index + 1)
        )
    for index, item in enumerate(value):
        if index == at_index:
            yield formatter(item)
        else:
            yield item


def combine_argument_formatters(*formatters: List[Callable[..., Any]]) -> Formatters:
    warnings.warn(
        DeprecationWarning(
            "combine_argument_formatters(formatter1, formatter2)([item1, item2])"
            "has been deprecated and will be removed in a subsequent major version "
            "release of the eth-utils library. Update your calls to use "
            "apply_formatters_to_sequence([formatter1, formatter2], [item1, item2]) "
            "instead."
        )
    )

    _formatter_at_index = curry(apply_formatter_at_index)
    return compose(
        *(
            _formatter_at_index(formatter, index)
            for index, formatter in enumerate(formatters)
        )
    )


@return_arg_type(1)
def apply_formatters_to_sequence(
    formatters: List[Any], sequence: List[Any]
) -> Generator[List[Any], None, None]:
    if len(formatters) > len(sequence):
        raise IndexError(
            "Too many formatters for sequence: {} formatters for {!r}".format(
                len(formatters), sequence
            )
        )
    elif len(formatters) < len(sequence):
        raise IndexError(
            "Too few formatters for sequence: {} formatters for {!r}".format(
                len(formatters), sequence
            )
        )
    else:
        for formatter, item in zip(formatters, sequence):
            yield formatter(item)


def apply_formatter_if(
    condition: Callable[..., bool], formatter: Callable[..., Any], value: Any
) -> Any:
    if condition(value):
        return formatter(value)
    else:
        return value


@to_dict
def apply_formatters_to_dict(
    formatters: Dict[Any, Any], value: Dict[Any, Any]
) -> Generator[Tuple[Any, Any], None, None]:
    for key, item in value.items():
        if key in formatters:
            try:
                yield key, formatters[key](item)
            except (TypeError, ValueError) as exc:
                raise type(exc)(
                    "Could not format value %r as field %r" % (item, key)
                ) from exc
        else:
            yield key, item


@return_arg_type(1)
def apply_formatter_to_array(
    formatter: Callable[..., Any], value: List[Any]
) -> Generator[List[Any], None, None]:
    for item in value:
        yield formatter(item)


def apply_one_of_formatters(
    formatter_condition_pairs: Tuple[Tuple[Callable[..., Any], Callable[..., Any]]],
    value: Any,
) -> Any:
    for condition, formatter in formatter_condition_pairs:
        if condition(value):
            return formatter(value)
    else:
        raise ValueError(
            "The provided value did not satisfy any of the formatter conditions"
        )


@to_dict
def apply_key_map(
    key_mappings: Dict[Any, Any], value: Dict[Any, Any]
) -> Generator[Tuple[Any, Any], None, None]:
    key_conflicts = (
        set(value.keys())
        .difference(key_mappings.keys())
        .intersection(v for k, v in key_mappings.items() if v in value)
    )
    if key_conflicts:
        raise KeyError(
            "Could not apply key map due to conflicting key(s): {}".format(
                key_conflicts
            )
        )

    for key, item in value.items():
        if key in key_mappings:
            yield key_mappings[key], item
        else:
            yield key, item
