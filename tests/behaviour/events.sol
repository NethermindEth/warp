pragma solidity ^0.8.0;

contract WARP {
    event Log0();

    function log_0() external {
        emit Log0();
    }
    event Log1(
        address _from,
        uint _id
    );

    function log_1(uint _id) external {
        emit Log1(msg.sender, _id);
    }

    event Log2(
        address indexed _from,
        uint _id
    );

    function log_2(uint _id) external {
        emit Log2(msg.sender, _id);
    }

    event Log3(
        address indexed _from,
        uint indexed _id,
        uint indexed _theAnswerToTheUniverse
    );

    function log_3(uint _id, uint _magic) external {
        emit Log3(msg.sender, _id, _magic);
    }

    event Log4(
        address indexed _from,
        uint indexed _id,
        uint indexed _theAnswerToTheUniverse,
        string _infiniteImprobabilityDrive
    );

    function log_4(uint _id, uint _magic) external {
        emit Log4(msg.sender, _id, _magic, "heartOfGold");
    }
}
