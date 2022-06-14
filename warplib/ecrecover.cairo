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

from warplib.maths.eq import warp_eq

# NOTE: This function returns an ethereum address
func ecrecover_eth{range_check_ptr, bitwise_ptr : BitwiseBuiltin*, keccak_ptr : felt*}(
    msg_hash_ : Uint256, v : felt, r_ : Uint256, s_ : Uint256
) -> (address : felt):
    alloc_locals
    let (v_is_27) = warp_eq(v, 27)
    let (v_is_28) = warp_eq(v, 28)

    if v_is_27 + v_is_28 == 0:
      return (0)
    end

    let v = v - 27

    let (msg_hash : BigInt3) = uint256_to_bigint(msg_hash_)
    let (r : BigInt3) = uint256_to_bigint(r_)
    let (s : BigInt3) = uint256_to_bigint(s_)

    let (public_key_point : EcPoint) = recover_public_key(msg_hash, r, s, v)
    let (eth_address) = public_key_point_to_eth_address{keccak_ptr=keccak_ptr}(public_key_point)

    return (eth_address)
end
