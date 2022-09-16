from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256

func warp_external_input_check_address{range_check_ptr}(x: felt) {
    let inRange: felt = is_le_felt(
        x, 0x7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    );
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**251.") {
        assert 1 = inRange;
    }
    return ();
}
