%builtins range_check

from evm.memory import mload_
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.uint256 import (
    Uint256, uint256_and, uint256_eq, uint256_not, uint256_shl, uint256_shr, uint256_sub)

func get_calldata{range_check_ptr, memory_dict : DictAccess*, msize}(mem_start : felt, 
        mem_read_len : felt, carry : felt*, carry_len : felt) -> (res : felt*):
    if mem_read_len == 0:
        return (res=carry)
    end
    assert [carry + carry_len] = mload_(mem_start)
    return get_calldata(mem_start=mem_start+32, mem_read_len=mem_read_len-32,carry=carry,carry_len=carry_len+1)
end


func main():
    alloc_locals
    local a = 21
    assert a = 21
    return ()
end