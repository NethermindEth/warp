// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "./base.sol";

contract  Base {
   struct S {
        uint8 id1;
        uint8 id2;
    }
}

contract  WARP is Base {
    S  s;

    function identity(S memory _input) external pure returns (S memory) {
        return _input;
    }

    function swap(S memory _input) external pure returns (S memory) {
        return S(_input.id2, _input.id1);
    }

    function set(S memory _input) external returns (uint8) {
        s = _input;
        return s.id1;
    }

}
