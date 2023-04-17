use integer::u128_try_from_felt252;
use integer::u128_to_felt252;
use integer::u256_from_felt252;
use option::OptionTrait;

fn u256_from_felts(low_felt: felt252, high_felt: felt252) -> u256 {
    let low_u128: u128 = get_u128_try_from_felt_result(low_felt);
    let high_u128: u128 = get_u128_try_from_felt_result(high_felt);
    return u256{ low: low_u128, high: high_u128 };
}

fn get_u128_try_from_felt_result(value: felt252) -> u128 {
    let resp = u128_try_from_felt252(value);
    assert(resp.is_some(), 'Felts too large for u256');
    return resp.unwrap();
}

fn u256_to_felt252_safe(val: u256) -> felt252 {
    let low_felt252 = u128_to_felt252(val.low);
    let high_felt252 = u128_to_felt252(val.high);

    let two_pow_128 = 0x100000000000000000000000000000000;
    let value_felt252 = low_felt252 + high_felt252 * two_pow_128;

    let unsafe_value = u256_from_felt252(value_felt252);
    assert(val == unsafe_value, 'Value too large for felt');

    value_felt252
}
