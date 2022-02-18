pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

struct Point {
    uint x;
    uint y;
}

contract WARP {
    struct Circle{
        Point center;
        uint r;
    }

    Circle fig = Circle(Point(1, 0), 5);

    function reset() public {
        delete fig;
    }

    function getRadious() public view returns (uint){
        return fig.r;
    }

    function getPoint() public view returns (uint, uint) {
        return (fig.center.x, fig.center.y);
    }
}