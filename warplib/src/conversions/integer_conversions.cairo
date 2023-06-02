use integer::u128_try_from_felt252;
use integer::u256_from_felt252;
use integer::u128_to_felt252;
use array::ArrayImpl;
use option::OptionTrait;
use option::OptionTraitImpl;
use starknet::ContractAddress;
use traits::Into;
use traits::TryInto;

fn u256_from_felts(low_felt: felt252, high_felt: felt252) -> u256 {
    let low_u128: u128 = get_u128_try_from_felt_result(low_felt);
    let high_u128: u128 = get_u128_try_from_felt_result(high_felt);
    return u256 { low: low_u128, high: high_u128 };
}

fn try_u256_to_felt252(x: u256) -> felt252 {
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
