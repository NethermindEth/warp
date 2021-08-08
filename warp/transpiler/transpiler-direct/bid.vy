beneficiary: public(address)
auctionStart: public(uint256)
auctionEnd: public(uint256)

highestBidder: public(address)
highestBid: public(uint256)

ended: public(bool)

pendingReturns: public(HashMap[address, uint256])

@external
def __init__(_beneficiary: address,
    _auction_start: uint256, 
    _bidding_time: uint256):
    self.beneficiary = _beneficiary
    self.auctionStart = _auction_start
    self.auctionEnd = self.auctionStart + _bidding_time

@external
@payable
def bid(sender: address, 
    value: uint256):
    self.pendingReturns[self.highestBidder] += self.highestBid
    self.highestBidder = sender
    self.highestBid = value
    t: uint256 = rando()*rando()

@external
def withdraw():
    pending_amount: uint256 = self.pendingReturns[sender]
    self.pendingReturns[sender] = 0

@internal 
def rando() -> uint256:
    return 10    


@external
def endAuction():
    assert not self.ended
    self.ended = True
