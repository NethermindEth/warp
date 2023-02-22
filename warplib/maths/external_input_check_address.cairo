
fn warp_external_input_check_address(x: felt) {
    let max: felt = 0x7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    assert( x <= max, 'Error: value out-of-bounds');
}
