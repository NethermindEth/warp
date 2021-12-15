%builtins output range_check bitwise

from evm.memory import mload8, mstore8
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
        mstore8(20, 5)
        let (local b20) = mload8(20)
    end

    serialize_word(b20)

    local output_ptr : felt* = output_ptr

    default_dict_finalize(dict_start, memory_dict, 0)
    return ()
end
