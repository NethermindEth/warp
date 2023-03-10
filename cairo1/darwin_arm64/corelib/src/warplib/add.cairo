
use integer::u128_from_felt;

fn warp_add(num: u128, num2: felt) -> u128 {
    num + u128_from_felt(num2)
}
