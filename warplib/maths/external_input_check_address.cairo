use warplib::maths::le::warp_le;
use starknet::ContractAddress;
use starknet::contract_address_to_felt252;

fn warp_external_input_check_address(x: ContractAddress) {
    // The StarkNet address upper bound is 2**251 - 256, in max is stored its hex representation
    let max: felt252 = 0x7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
    let x_felt252: felt252 = contract_address_to_felt252(x);
    assert(warp_le(x_felt252, max), 'Starknet address out-of-bounds');
}
