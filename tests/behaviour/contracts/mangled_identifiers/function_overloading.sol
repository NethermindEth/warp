contract Overloaded {
    function f(uint a) public pure returns (uint) {
        return a;
    }
    function f(uint a, uint b) public pure returns (uint) {
        return a + b;
    }
    function f(uint a, uint b, uint c) public pure returns (uint) {
        return a + b + c;
    }
}
