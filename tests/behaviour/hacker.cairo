%lang starknet
%builtins range_check

from starkware.cairo.common.alloc import alloc

@external
func __main(calldata_size : felt, calldata_len : felt, calldata : felt*) -> (
        returndata_size : felt, returndata_len : felt, returndata : felt*):
    let (returndata) = alloc()
    assert returndata[0] = 2 ** 128
    return (16, 1, returndata)
end
