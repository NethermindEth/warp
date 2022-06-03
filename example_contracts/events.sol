pragma solidity ^0.8.0;

//SPDX-License-Identifier: MIT

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
        address  _from,
        uint _id
    );

    function log_2(uint _id) external {
        emit Log2(msg.sender, _id);
    }

    event Log3(
        address  _from,
        uint  _id,
        uint  _theAnswerToTheUniverse
    );

    function log_3(uint _id, uint _magic) external {
        emit Log3(msg.sender, _id, _magic);
    }
}
