pragma solidity ^0.8.14;


contract Uint256Contract {
    uint public x;
    constructor (uint x_) {
        x = x_;
    }
}

contract WARP {
    mapping (bytes32 => Uint256Contract) saltToContract;

    function createUint256Contract(bytes32 salt, uint x_) public {
        Uint256Contract c = new Uint256Contract{salt: salt}(x_);
        saltToContract[salt] = c;
    }

    function getUint256X(bytes32 salt) public view returns (uint256){
        return saltToContract[salt].x();
    }
}
