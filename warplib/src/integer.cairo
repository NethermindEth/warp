// FIXME: merge imports using "use bla::{foo, bar}" syntax, when
// updated to Cairo 1.1
use integer::BoundedInt;
use integer::downcast;
use integer::u256;
use integer::upcast;
use option::OptionTrait;

trait Integer<T> {
    // basically, 2^(width - 1), but precomputed, because there is no
    // way to compute that efficiently at the moment
    fn signed_upper_bound() -> T;
}

impl Integer8 of Integer<u8> {
    fn signed_upper_bound() -> u8 {
        0x80
    }
}

impl Integer16 of Integer<u16> {
    fn signed_upper_bound() -> u16 {
        0x8000
    }
}

impl Integer32 of Integer<u32> {
    fn signed_upper_bound() -> u32 {
        0x80000000
    }
}

impl Integer64 of Integer<u64> {
    fn signed_upper_bound() -> u64 {
        0x8000000000000000
    }
}

impl Integer128 of Integer<u128> {
    fn signed_upper_bound() -> u128 {
        0x80000000000000000000000000000000
    }
}

impl Integer256 of Integer<u256> {
    fn signed_upper_bound() -> u256 {
        u256 { low: 0, high: Integer::signed_upper_bound() }
    }
}

// FIXME: remove, when we update to Cairo 1.1, use builtin BitNot instead
fn bitnot<T, impl BoundedIntT: BoundedInt<T>, impl SubT: Sub<T>>(x: T) -> T {
    BoundedInt::max() - x
}

// FIXME: remove, when core implementations are available
impl U8BitAnd of BitAnd<u8> {
    #[inline(always)]
    fn bitand(lhs: u8, rhs: u8) -> u8 {
        downcast(upcast::<u8, u128>(lhs) & upcast(rhs)).unwrap()
    }
}

impl U16BitAnd of BitAnd<u16> {
    #[inline(always)]
    fn bitand(lhs: u16, rhs: u16) -> u16 {
        downcast(upcast::<u16, u128>(lhs) & upcast(rhs)).unwrap()
    }
}

impl U32BitAnd of BitAnd<u32> {
    #[inline(always)]
    fn bitand(lhs: u32, rhs: u32) -> u32 {
        downcast(upcast::<u32, u128>(lhs) & upcast(rhs)).unwrap()
    }
}

impl U64BitAnd of BitAnd<u64> {
    #[inline(always)]
    fn bitand(lhs: u64, rhs: u64) -> u64 {
        downcast(upcast::<u64, u128>(lhs) & upcast(rhs)).unwrap()
    }
}
