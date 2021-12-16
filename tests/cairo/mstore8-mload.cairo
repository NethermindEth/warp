%builtins output range_check bitwise

from evm.memory import mload, mstore8
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.dict import dict_read
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.serialize import serialize_word

func main{output_ptr : felt*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals

    let (memory_dict) = default_dict_new(0)
    local dict_start : DictAccess* = memory_dict

    with memory_dict:
        # we don't do assertions here, since if one fails we can't observe others
        mstore8(0, 1)
        mstore8(3, 2)
        mstore8(5, 4)
        mstore8(20, 8)
        mstore8(22, 12)

        let (local w0) = mload(0)
        let (local w2) = mload(2)
    end

    serialize_word(w0.low)
    serialize_word(w0.high)
    serialize_word(w2.low)
    serialize_word(w2.high)

    local output_ptr : felt* = output_ptr

    default_dict_finalize(dict_start, memory_dict, 0)
    return ()
end
