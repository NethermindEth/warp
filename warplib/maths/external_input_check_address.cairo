
fn warp_external_input_check_address(x: felt) {
    // The L2 address upper bound is 2**256 - 256, in max is stored its hex representation
    let max: felt = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
    assert( x <= max, 'Error: value out-of-bounds');
}
