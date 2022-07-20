
pragma solidity ^0.8.14;

contract Uint256Contract {
    uint public x;
    constructor (uint x_) {
        x = x_;
    }
    function getX() public view returns (uint256) {
        return x;
    }
}

contract Uint8Contract {
    uint8 public x;
    constructor (uint8 x_) {
        x = x_;
    }
    function getX() public view returns (uint8) {
        return x;
    }
}
contract DynArrayContract {
    uint[] public x ;
    constructor (uint[] memory x_) {
        x = x_;
    }
    function getX() public view returns (uint[] memory) {
        return x;
    }
}
contract StaticArrayContract {
    uint8[3] public x;
    constructor (uint8[3] memory x_) {
        x = x_;
    }
    function getX() public view returns (uint8[3] memory) {
        return x;
    }
}

struct S {
    uint8 m1;
    uint8 m2;
}

contract StructContract {
    S public x;
    constructor (S memory x_){
        x = x_;
    }

    function getX() public view returns (S memory) {
        return x;
    }
}

contract WARP {
    Uint256Contract u256;
    Uint8Contract u8;
    DynArrayContract dac;
    StaticArrayContract sac;
    StructContract sc;

    function createUint256Contract(uint x_) public {
        u256 = new Uint256Contract(x_);
    }

    function createUint8Contract(uint8 x_) public {
        u8 = new Uint8Contract(x_);
    }

    function createDynArrayContract(uint[] memory x_) public {
        dac = new DynArrayContract(x_);
    }

    function createStaticArrayContract(uint8[3] memory x_) public {
        sac = new StaticArrayContract(x_);
    }

    function createStructContract(S memory x_) public {
        sc = new StructContract(x_);
    }

    function getUint256X() public view returns (uint256){
        return u256.x();
    }

    function getUint8X() public view returns (uint8){
        return u8.x();
    }

    function getDynArrayX() public view returns (uint256[] memory){
        return dac.getX();
    }

    function getStaticArrayX() public view returns (uint8[3] memory){
        return sac.getX();
    }

    function getStructX() public view returns (S memory){
        // This is bugged
        // S memory s = sc.getX();
        (uint8 s1, uint8 s2) = sc.x();
        S memory s = S(s1, s2);
        return s;
    }
}
