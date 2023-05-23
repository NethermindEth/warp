// FIXME: merge imports using "use bla::{foo, bar}" syntax, when
// updated to Cairo 1.1
use array::ArrayImpl;
use integer::BoundedInt;
use integer::downcast;
use integer::u128_try_from_felt252;
use integer::upcast;
use option::OptionTrait;
use serde::BoolSerde;
use starknet::ContractAddress;
use traits::Into;
use traits::TryInto;

use warplib::integer::Integer;
use warplib::integer::bitnot;

fn u256_from_felts(low_felt: felt252, high_felt: felt252) -> u256 {
    let low_u128: u128 = get_u128_try_from_felt_result(low_felt);
    let high_u128: u128 = get_u128_try_from_felt_result(high_felt);
    return u256 { low: low_u128, high: high_u128 };
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

// Cairo-1.1 corelib code from the RC
// FIXME: remove, when updated
impl U256TryIntoFelt252 of TryInto<u256, felt252> {
    fn try_into(self: u256) -> Option<felt252> {
        let FELT252_PRIME_HIGH = 0x8000000000000110000000000000000_u128;
        if self.high > FELT252_PRIME_HIGH {
            return Option::None(());
        }
        if self.high == FELT252_PRIME_HIGH {
            // since FELT252_PRIME_LOW is 1.
            if self.low != 0 {
                return Option::None(());
            }
        }
        Option::Some(
            self.high.into() * 0x100000000000000000000000000000000_felt252 + self.low.into()
        )
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
