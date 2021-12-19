%builtins output range_check bitwise

from evm.array import array_create_from_memory
from evm.memory import mload, mstore
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.default_dict import default_dict_finalize, default_dict_new
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.uint256 import Uint256

func main{output_ptr : felt*, range_check_ptr, bitwise_ptr : BitwiseBuiltin*}():
    alloc_locals
    let (memory_dict) = default_dict_new(0)
    let dict_start = memory_dict
    with memory_dict:
        # we don't do assertions here, since if one fails we can't observe others
        mstore(4, Uint256(5000, 0xabcd * 256 ** 14 + 0x123456))
        mstore(36, Uint256(0xdeadbeef, 0xcafebabe))
        let (array) = array_create_from_memory(4, 64)
        serialize_word(array[0])
        serialize_word(array[1])
        serialize_word(array[2])
        serialize_word(array[3])
        let (array) = array_create_from_memory(36, 32)
        serialize_word(array[0])
        serialize_word(array[1])
    end
    default_dict_finalize(dict_start, memory_dict, 0)
    return ()
end
