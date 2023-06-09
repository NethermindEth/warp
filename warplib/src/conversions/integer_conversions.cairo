use array::ArrayImpl;
use integer::{downcast, upcast, u128_try_from_felt252, BoundedInt};
use option::OptionTrait;
use starknet::ContractAddress;
use traits::{Into, TryInto};

use warplib::integer::{bitnot, Integer};

fn u256_from_felts(low_felt: felt252, high_felt: felt252) -> u256 {
    let low_u128: u128 = get_u128_try_from_felt_result(low_felt);
    let high_u128: u128 = get_u128_try_from_felt_result(high_felt);
    return u256 { low: low_u128, high: high_u128 };
}

fn u256_to_felt252(x: u256) -> felt252 {
    let MAX_FELT = u256_from_felt252(-1);
    if x > MAX_FELT {
        panic_with_felt252('Overflow in u256_to_felt252')
    }
    // hex is 2**128
    u128_to_felt252(x.low) + 0x100000000000000000000000000000000 * u128_to_felt252(x.high)
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

fn unsafe_contract_address_from_u256(x: u256) -> ContractAddress {
    match x.try_into() {
        Option::Some(felt_x) =>
            match starknet::contract_address_try_from_felt252(felt_x) {
                Option::Some(address) => address,
                Option::None(_) =>
                    panic_with_felt252('the felt cannot be an address'),
            },
        Option::None(_) => panic_with_felt252('the u256 does not fit in felt'),
    }
}

// FIXME: Should have been possible without our special Integer trait,
// but NumericLiteral doesn't quite work yet. Without being able to
// create constants of our generic type, we can't do anything.
fn signed_upcast<
    FromType,
    impl IntegerFrom: Integer<FromType>,
    impl BoundedIntFrom: BoundedInt<FromType>,
    impl SubFrom: Sub<FromType>,
    impl PartialOrdFrom: PartialOrd<FromType>,
    impl CopyFrom: Copy<FromType>,
    impl DropFrom: Drop<FromType>,
    ToType,
    impl BoundedIntTo: BoundedInt<ToType>,
    impl SubTo: Sub<ToType>,
>(x: FromType) -> ToType {
    if x < Integer::signed_upper_bound() {
        upcast(x)
    } else {
        bitnot(upcast(bitnot(x)))
    }
}

fn cutoff_downcast<
    FromType,
    impl BitAndFrom: BitAnd<FromType>,
    ToType,
    impl BoundedIntTo: BoundedInt<ToType>,
>(x: FromType) -> ToType {
    downcast(x & upcast(BoundedInt::<ToType>::max())).unwrap()
}
