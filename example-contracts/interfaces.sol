pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

interface Token {
    enum TokenType { Fungible, NonFungible }
    struct Coin { string obverse; string reverse; }
    function transfer(address recipient, uint amount) external;
    function coincoin(Coin memory recipient, Coin memory amount) external;
}
