%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.storage import Storage    
from starkware.cairo.common.uint256 import Uint256, uint256_add

@storage_var
func pendingReturns(arg1_low, arg1_high) -> (res : (felt, felt)):
end
@storage_var
func highestBidder() -> (res : (felt, felt)):
end

@storage_var
func highestBid() -> (res : (felt, felt)):
end

func rando() -> (res: felt):
    return (10)
end

@external
func bid{storage_ptr : Storage*, 
        pedersen_ptr : HashBuiltin*, 
        range_check_ptr}(
        sender_len: felt, sender: felt*, value_len, value: felt*):
    alloc_locals
    let (local hBidder_tup: (felt, felt)) = highestBidder.read()
    let (local hBid_tup: (felt,felt)) = highestBid.read()
    let (local pret_tupB: (felt, felt)) = pendingReturns.read(hBidder_tup[0], hBidder_tup[1])
    local pret_uintB : Uint256 = Uint256(pret_tupB[0], pret_tupB[1])
    let (local pretA : Uint256,_) = uint256_add(pret_uintB, Uint256(hBid_tup[0], hBid_tup[1]))
    pendingReturns.write(hBidder_tup[0], hBidder_tup[1], (pretA.low, pretA.high))
    highestBidder.write(([sender],[sender+1]))
    highestBid.write(([value],[value+1]))
    let (local a) = rando() - 10
    return ()
end 