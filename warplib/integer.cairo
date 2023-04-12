use integer::u128_try_from_felt252;
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

/// Conversions.
impl Felt252IntoBool of Into::<felt252, bool> {
    fn into(self: felt252) -> bool {
        self == 1
    }
}
impl BoolIntoFelt252 of Into::<bool, felt252> {
    fn into(self: bool) -> felt252 {
        if self { return 1; } else { return 0; }
    }
}