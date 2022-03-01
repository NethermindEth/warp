pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

interface Token {
    enum TokenType { Fungible, NonFungible }
    struct Coin { string obverse; string reverse; }
    function transfer(address recipient, uint amount) external;
    function coincoin(Coin memory recipient, Coin memory amount) external;
}

struct TokenWrapper {
    address a;
    Token t;
}

contract WARP {
    function main(address add, Token t, TokenWrapper memory tw) external {
        Token(add).transfer(add, 4);
        t.transfer(address(t), 4);
        Token(tw.a).transfer(add, 4);
        tw.t.transfer(add, 4);
    }
}
