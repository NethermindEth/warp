pragma solidity ^0.8.14;

struct S {
    uint8 m1;
    uint8 m2;
}

contract Product {
    uint public x;
    uint8 public y;
    uint[] public z;
    S public w;
    uint8[3] public v;
    constructor (uint x_, uint8 y_, uint[] memory z_, S memory w_, uint8[3] memory v_) {
        x = x_;
        y = y_;
        z = z_;
        w = w_;
        v = v_;
    }

    function getZ() public view returns (uint[] memory) {
        return z;
    }

    function getV() public view returns (uint8[3] memory) {
        return v;
    }

}

contract WARP {
    Product[] products;

    function createProduct(
        uint x_, uint8 y_, uint[] memory z_, S memory w_, uint8[3] memory v_
    ) public {
        Product p = new Product(x_, y_, z_, w_, v_);
        products.push(p);
    }

    function getProduct(uint index) public view returns (
        uint x, uint8 y, uint[] memory z, uint8[3] memory v, S memory w
    ) {
        Product p = products[index];
        x = p.x();
        y = p.y();
        z = p.getZ(); // This are bugged
        (uint8 w1, uint8 w2) = p.w();
        w = S(w1, w2);
        v = p.getV();  // This are bugged

        return (x, y, z, v, w);
    }
}
