// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


contract WARP {
    function subtractionFromZeroResultInNegativeValue() public pure returns (int, int8) {
        int underflow = 0;
        int8 underflow8 = 0;
        unchecked {
            underflow = underflow - 1;
            underflow8 = underflow8 - 2;
        }
        assert(underflow == -1);
        assert(underflow8 == -2);
        return (underflow, underflow8);
    }

    function overflowsAreUnchecked() public pure returns (int, int, int8, int8) {
        int overflow = type(int).max;
        int underflow = type(int).min;
        int8 overflow8 = type(int8).max;
        int8 underflow8 = type(int8).min;

        assembly {
            overflow := add(overflow, 2)
            underflow := sub(underflow, 1)
            overflow8 := add(overflow8, 1)
            underflow8 := sub(underflow8, 2)
        }

        assert(overflow == type(int).min + 1);
        assert(underflow == type(int).max);
        assert(overflow8 == type(int8).min);
        assert(underflow8 == type(int8).max - 1);

        return (overflow, underflow, overflow8, underflow8);
    }
}
