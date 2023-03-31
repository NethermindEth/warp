use warplib::maths::le::warp_le;

fn warp_external_input_check_address(x: felt252) {
    // The StarkNet address upper bound is 2**251 - 256, in max is stored its hex representation
    let max: felt252 = 0x7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
    
    assert(warp_le(x, max), 'Starknet address out-of-bounds');
}
