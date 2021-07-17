%builtins output range_check

from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from starkware.cairo.common.dict import dict_read
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.uint256 import Uint256

from evm.memory import mstore, mload

func main{output_ptr : felt*, range_check_ptr}():
    alloc_locals

    let (memory_dict) = default_dict_new(0)
    local dict_start : DictAccess* = memory_dict

    with memory_dict:
        # we don't do assertions here, since if one fails we can't observe others
        mstore(0, Uint256(10000, 5000))

        # check with 'python scripts/utils/mload.py -m "M 0 10000 5000" -o 0'
        let (local w0) = mload(0)
        # check with 'python scripts/utils/mload.py -m "M 0 10000 5000" -o 15'
        let (local w15) = mload(15)

        mstore(3, Uint256(0, 1193046))

        # check with 'python scripts/utils/mload.py -m "M 0 10000 5000 3 0 1193046" -o 0/15'
        let (local w0_2) = mload(0)
        let (local w15_2) = mload(15)
    end

    serialize_word(w0.low)
    serialize_word(w0.high)
    serialize_word(w15.low)
    serialize_word(w15.high)
    serialize_word(w0_2.low)
    serialize_word(w0_2.high)
    serialize_word(w15_2.low)
    serialize_word(w15_2.high)

    local output_ptr: felt* = output_ptr

    default_dict_finalize(dict_start, memory_dict, 0)
    return ()
end
