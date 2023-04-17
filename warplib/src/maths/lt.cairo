use integer::u256_from_felt252;

fn warp_lt(lhs: felt252, rhs: felt252) -> bool {
    let lhs_u256 = u256_from_felt252(lhs);
    let rhs_u256 = u256_from_felt252(rhs);
    return warp_lt256(lhs_u256, rhs_u256);
}

fn warp_lt256(op1: u256, op2: u256) -> bool {
    return op1 < op2;
}
