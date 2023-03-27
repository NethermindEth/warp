// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract WARP {
    struct S {
        uint a;
        uint8 b;
    }

    struct C {
        uint c;
        S d;
    }

    function t0(uint8[3] calldata b, uint i) public pure returns (uint8){
        return b[i];
    }

    function t1(S[2] calldata a, uint i) public pure returns (S memory){
        return a[i];
    }

    function t2(C[2] calldata a, uint i) public pure returns (C memory){
        return a[i];
    }

    function t3(uint8[5] calldata a, uint i, uint j, uint k) public pure returns (uint8){
        return a[i] + a[j] + a[k];
    }

    function t4(uint8[2][2] calldata c, uint i) public pure returns (uint8) {
        return c[i][0];
    }

    function t5(uint8[2][2] calldata d, uint i) public pure returns (uint8) {
        return d[0][i];
    }

    function t6(uint8[2][2] calldata e, uint i) public pure returns (uint8) {
        return e[i][i];
    }

    // More nasty nesting
    struct K {
        uint8[3] u;
    }

    struct KK {
        uint8[3] u;
        K k;
    }

    struct KKK {
        KK[3] ku;
    }

    function n0(K calldata k, uint i) public pure returns (uint8) {
        return k.u[i];
    }

    function n1(KK calldata kk, uint i) public pure returns (uint8) {
        return kk.k.u[i];
    }

    function n2(KKK calldata kkk, uint i) public pure returns (uint8) {
        return kkk.ku[i].k.u[i];
    }

    function n3(KKK calldata kkk, uint i) public pure returns (uint8[3] memory) {
        return kkk.ku[i].u;
    }
}
