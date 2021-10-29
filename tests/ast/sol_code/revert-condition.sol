pragma solidity >=0.8.6;

contract WARP {
    function transfer(uint sender, uint sender_balance, uint recipient, uint amount) public payable returns (bool) {
        require(sender != recipient);
        require(amount <= sender_balance);
        sender_balance -= amount;
        return true;
    }
}