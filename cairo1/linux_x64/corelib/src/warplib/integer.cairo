use integer::u128_try_from_felt;
use option::OptionTrait;

fn u256_from_felts(low_felt: felt, high_felt: felt) -> u256 {
    let low_u128: u128 = get_u128_try_from_felt_result(low_felt);
    let high_u128: u128 = get_u128_try_from_felt_result(high_felt);
    return u256{ low: low_u128, high: high_u128 };
}

fn get_u128_try_from_felt_result(value: felt) -> u128 {
    let resp = u128_try_from_felt(value);
    assert(resp.is_some(), 'Felts too large for u256');
    return resp.unwrap();
}

