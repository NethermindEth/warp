use integer::u128_try_from_felt252;
use serde::BoolSerde;
use array::ArrayImpl;
use option::OptionTrait;
use option::OptionTraitImpl;

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

/// Conversions.
fn felt252_into_bool(val: felt252) -> bool {
    if val == 0 {
        false
    }
    else if val == 1 {
        true
    }
    else {
        panic_with_felt252('Failed felt to bool conversion')
    }
}

fn bool_into_felt252(val: bool) -> felt252 {
    if val {
        1
    } else {
        0
    }
}
