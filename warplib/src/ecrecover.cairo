%lang starknet

from starkware.cairo.common.cairo_secp.signature import (
    recover_public_key,
    public_key_point_to_eth_address,
)
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_secp.bigint import BigInt3, uint256_to_bigint
from starkware.cairo.common.cairo_secp.ec import EcPoint

from warplib.maths.eq import warp_eq, warp_eq256
from warplib.maths.lt import warp_lt256

// This equals to 115792089237316195423570985008687907852837564279074904382605163141518161494337
// Would be nicer if structs were allowed here.
const SECP256K1_N_HIGH = 0xfffffffffffffffffffffffffffffffe;
const SECP256K1_N_LOW = 0xbaaedce6af48a03bbfd25e8cd0364141;

// NOTE: This function returns an ethereum address
func ecrecover_eth{range_check_ptr, bitwise_ptr: BitwiseBuiltin*, keccak_ptr: felt*}(
    msg_hash_: Uint256, v: felt, r_: Uint256, s_: Uint256
) -> (address: felt) {
    alloc_locals;
    let (v_is_27) = warp_eq(v, 27);
    let (v_is_28) = warp_eq(v, 28);

    // Expect one of them to be 1 (true)
    if (v_is_27 + v_is_28 == 0) {
        return (0,);
    }

    let v = v - 27;

    let (r_eq_0) = warp_eq256(r_, Uint256(0, 0));
    let (s_eq_0) = warp_eq256(s_, Uint256(0, 0));

    // Expect both of these to be 0 (false)
    if (r_eq_0 + s_eq_0 != 0) {
        return (0,);
    }

    let (r_lt_n) = warp_lt256(r_, Uint256(SECP256K1_N_LOW, SECP256K1_N_HIGH));
    let (s_lt_n) = warp_lt256(s_, Uint256(SECP256K1_N_LOW, SECP256K1_N_HIGH));

    // Expect both of these to be 1 (true)
    if (r_lt_n + s_lt_n != 2) {
        return (0,);
    }

    let (msg_hash: BigInt3) = uint256_to_bigint(msg_hash_);
    let (r: BigInt3) = uint256_to_bigint(r_);
    let (s: BigInt3) = uint256_to_bigint(s_);

    let (public_key_point: EcPoint) = recover_public_key(msg_hash, r, s, v);
    let (eth_address) = public_key_point_to_eth_address{keccak_ptr=keccak_ptr}(public_key_point);

    return (eth_address,);
}
