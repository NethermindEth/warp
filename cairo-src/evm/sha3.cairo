from evm.array import create_from_memory
from evm.utils import update_msize
from evm.uint256 import Uint256
from starkware.cairo.common.dict_access import DictAccess

func sha{
    range_check_ptr, 
    memory_dict : DictAccess*, msize}(
    offset, length) -> (res : Uint256):
    alloc_locals
    let (local msize) = update_msize(msize, offset, length)
    let (local memval) = create_from_memory(offset, length)
    local high
    local low
    %{
        from Crypto.Hash import keccak
        keccak_hash = keccak.new(digest_bits=256)
        arr = []
        arr_length = ids.length//16 if ids.length % 16 == 0 else ids.length//16+1
        for i in range(arr_length):
            arr.append(memory[ids.memval+i])
        keccak_input = bytearray()
        for i in range(arr_length-1):
            keccak_input += arr[i].to_bytes(16,"big")
        keccak_input += arr[-1].to_bytes(16,"big") if ids.length % 16 == 0 else arr[-1].to_bytes(ids.length % 16,"big")
        keccak_hash.update(keccak_input)
        hashed = keccak_hash.digest()
        ids.high = int.from_bytes(hashed[:16],"big")
        ids.low = int.from_bytes(hashed[16:32],"big")
    %}
    return (res=Uint256(low,high))
end