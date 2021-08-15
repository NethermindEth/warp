from starkware.cairo.common.dict import DictAccess

from evm.array import create_from_memory as array_create_from_memory
from evm.utils import ceil_div, serialize_array

struct Output:
    member array : felt*  # 128-bit packed byte array
    member n_bytes : felt
end

func create_from_memory{memory_dict : DictAccess*, range_check_ptr}(offset, length) -> (
        output : Output):
    let (array) = array_create_from_memory(offset, length)
    return (Output(array=array, n_bytes=length))
end

func serialize_output{output_ptr : felt*, range_check_ptr}(output : Output):
    alloc_locals
    if output.active == 0:
        return ()
    end
    let (length) = ceil_div(output.n_bytes, 16)
    local range_check_ptr = range_check_ptr
    serialize_array(output.array, length)
    return ()
end
