use integer::u256_from_felt252;
use integer::u128_to_felt252;

fn u256_to_felt252(x: u256) -> felt252 {
    let MAX_FELT = u256_from_felt252(-1);
    if x > MAX_FELT {
        panic_with_felt252('Overflow in u256_to_felt252')
    }
    u128_to_felt252(x.low) + 0x100000000000000000000000000000000 * u128_to_felt252(x.high)
}
