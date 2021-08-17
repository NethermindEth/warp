from starkware.cairo.common.dict import DictAccess

from evm.array import array_create_from_memory
from evm.utils import ceil_div

struct Output:
    # The structure represents EVM output data. It contains of
    # bit-packed array along with the total number of bytes in the
    # array.
    member array : felt*  # 128-bit packed byte array
    member n_bytes : felt
end

func output_create_from_memory{memory_dict : DictAccess*, range_check_ptr}(offset, length) -> (
        output : Output):
    # Create 'Output' from memory bytes, starting with 'offset' and
    # finishing with 'offset + length'. The upper bound is exclusive.
    let (array) = array_create_from_memory(offset, length)
    return (Output(array=array, n_bytes=length))
end
