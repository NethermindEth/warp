pragma solidity ^0.8.6;
contract C {
    uint public i;
    uint public k;

    constructor(uint newI, uint newK) {
        i = newI;
        k = newK;
    }
}
// ====
// compileViaYul: also
// ----
// constructor(): 2, 0 ->
// gas irOptimized: 104227
// gas legacy: 117158
// i() -> 2
// k() -> 0
