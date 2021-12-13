pragma solidity ^0.8.6;

interface IFriend {
    function call_friend(IFriend friend) external view returns (uint);

    function tell_number(IFriend friend) external view returns (uint);
}

contract Friend is IFriend {
    uint _number;

    constructor(uint number) {
        _number = number;
    }

    function call_friend(IFriend friend) external view returns (uint) {
        return friend.tell_number(this);
    }

    function tell_number(IFriend friend) external view returns (uint) {
        require(msg.sender == address(friend));
        return _number;
    }
}
