

pendingReturns: public(HashMap[address, uint256])
@storage_var
func pendingReturns(arg1_low, arg1_high) -> (res : (felt, felt)):
end

highestBidder: public(address)
@storage_var
func highestBidder() -> (res : (felt, felt)):
end

highestBid: public(uint256)
@storage_var
func highestBid() -> (res : (felt, felt)):
end

def bid(sender: address, value: uint256):
    # Track the refund for the previous high bidder
    self.pendingReturns[self.highestBidder] += self.highestBid
    # Track new high bid
    self.highestBidder = sender
    self.highestBid = value
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
    return ()
end 