
fn warp_external_input_check_address(x: felt) {
    // The StarkNet address upper bound is 2**251 - 256, in max is stored its hex representation
    let max: felt = 0x7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
    
    assert( x <= max, 'StarkNet address out-of-bounds');
}
