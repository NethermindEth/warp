pragma solidity ^0.8.14;

struct Simple {
    uint8 m1;
    uint8[3] m2;
}


contract ExternalContract {
    Simple public s;
    uint16[3] public t;
    constructor (Simple memory s_, uint16[3] memory t_) {
        s = s_;
        t = t_;
    }

    function getS() public view returns (Simple memory) {
        return s;
    }
    function getT() public view returns (uint16[3] memory) {
        return t;
    }

}

contract WARP {
    ExternalContract ec;

    function setProduct(Simple memory s_, uint16[3] memory t_) external {
        ec = new ExternalContract(s_, t_);
    }

    function getS() public view returns (
        Simple memory
    ) {
        Simple memory s = ec.getS();
        return s;
    }

    function getT() public view returns (uint16[3] memory) {
        uint16[3] memory t = ec.getT();
        return t;
    }
}
