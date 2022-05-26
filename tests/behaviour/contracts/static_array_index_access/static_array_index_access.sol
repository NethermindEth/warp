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

    /*
    function t2(uint8[3][3] calldata c, uint i) public pure returns (uint8) {
        return c[i][0];
    }
    function t3(uint8[3][3] calldata d, uint i) public pure returns (uint8) {
        return d[0][i];
    }
    function t4(uint8[3][3] calldata e, uint i) public pure returns (uint8) {
        return e[i][i];
    }
   

    function t5(uint8[3] calldata f, uint i) public pure returns (uint8) {
        uint8[3] memory g = f;
        return g[i];
    }
     */ 
}
