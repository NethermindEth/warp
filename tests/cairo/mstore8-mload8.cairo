%builtins output range_check

from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.dict import dict_read
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.serialize import serialize_word

from evm.memory import mstore8, mload8

func main{output_ptr : felt*, range_check_ptr}():
    alloc_locals

    let (memory_dict) = default_dict_new(0)
    local dict_start : DictAccess* = memory_dict

    with memory_dict:
        # we don't do assertions here, since if one fails we can't observe others
        mstore8(20, 5)
        let (local b20) = mload8(20)
    end

    serialize_word(b20)

    local output_ptr: felt* = output_ptr

    default_dict_finalize(dict_start, memory_dict, 0)
    return ()
end
