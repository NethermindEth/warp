// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract WARP {
    struct S {
        uint8 a;
        uint8 b;
    }
    struct C {
        uint8[] a;
    }

    function deleteFelt() public pure returns (uint8) {
        uint8 a = 7;
        delete a;
        return  a;
    }

    function deleteUint() public pure returns (uint) {
        uint a = 11;
        delete a;
        return  a;
    }

    function deleteS() public pure returns (S memory) {
        S memory a = S(3, 5);
        delete a;
        return a;
    }
/* Uncomment this once storage -> calldata copy is implemented
    function deleteC(uint8[] memory val) public pure returns (C memory){
        C memory c = C(val);

        delete c;

        return c;
    }

    function deleteCnotArray(uint8[] memory val) public pure returns (uint8){
        C memory c = C(val);
        c.a[0] = 1;

        uint8[] memory b = c.a;

        delete c;

        return b[0] + b[1] + b[2];
    }

    function deleteDArray(uint8[] memory a) public pure returns (uint) {
        delete a;
        return a.length;
    }

    function copyDeleteDArray(uint8[] memory a) public pure returns (uint) {
        uint8[] memory b = a;
        delete a;
        return b.length + b[0];
    }
 */
    // Uncomment this once they are supported
    // function deleteSArray() public pure returns (S memory) {
        // S[] memory a = new S[](2);
        // a[0] = S(1,2);
        // a[1] = S(3,4);
        // S memory s = a[1];

        // delete a;

        // return s;
    // }

    // function delete2dArray() public pure returns (uint) {
        // uint8[][] memory a = new uint8[][](5);
        // uint8[][] memory d = a;
        // a[0] = new uint8[](3);
        // a[0][0] = 1;
        // a[1] = new uint8[](4);
        // a[1][0] = 2;
        // uint8[] memory b = a[0];
        // uint8[] memory c = a[1];

        // delete a;

        // return b.length + c.length + a.length + d.length + b[0][0] + a[0][0];
    // }
}
