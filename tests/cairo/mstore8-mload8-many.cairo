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
        mstore8(0, 1)
        mstore8(3, 2)
        mstore8(5, 4)
        mstore8(20, 8)
        mstore8(22, 12)

        let (local b0) = mload8(0)
        let (local b2) = mload8(2)
        let (local b3) = mload8(3)
        let (local b4) = mload8(4)
        let (local b5) = mload8(5)
        let (local b20) = mload8(20)
        let (local b22) = mload8(22)
        let (local b17) = mload8(17)
        let (local b115) = mload8(115)
    end

    serialize_word(b0)  # 1
    serialize_word(b2)  # 0
    serialize_word(b3)  # 2
    serialize_word(b4)  # 0
    serialize_word(b5)  # 4
    serialize_word(b17)  # 0
    serialize_word(b20)  # 8
    serialize_word(b22)  # 12
    serialize_word(b115)  # 0

    local output_ptr : felt* = output_ptr

    default_dict_finalize(dict_start, memory_dict, 0)
    return ()
end
