%builtins range_check
from starkware.cairo.common.uint256 import Uint256

func test() -> (res :(felt, felt)): 
    return (res=(1,2))
end

func main{range_check_ptr}():
    alloc_locals
    let (local b : (felt,felt)) = test()
    let (local a : Uint256) = 
end