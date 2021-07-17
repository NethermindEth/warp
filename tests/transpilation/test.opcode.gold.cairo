%builtins output range_check

from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.uint256 import Uint256, uint256_eq, uint256_mod

func main{output_ptr : felt*, range_check_ptr}():
    alloc_locals
    local range_check_ptr = range_check_ptr
    let (local res) = uint256_mod(
        Uint256(1329228233469404301140538677505568768, 0), Uint256(1208925819614629174706175, 0))
    serialize_word(res.low)
    return ()
end
    