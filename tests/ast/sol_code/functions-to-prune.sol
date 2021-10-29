pragma solidity >=0.8.6;

contract WARP {
    function funD() public { }
    function funB() internal {
        funD();
    }
    function funC() internal { }
    function funE() public { }
    function funG() internal { }
    function funF() internal {
        funG();
        funH();
    }
    function funH() internal { }
    function funA() public  {
        funB();
        funC();
        funG();
    }
}