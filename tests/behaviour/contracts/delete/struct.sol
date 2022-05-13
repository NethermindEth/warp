pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

    struct Point {
        uint x;
        uint y;
    }

    struct Circle{
        Point center;
        uint r;
    }
    
contract WARP {

    Circle fig = Circle(Point(1, 0), 5);

    function deleteCircle() public {
        delete fig;
    }

    function deletePoint() public {
        delete fig.center;
    }

    function deleteRadius() public {
        delete fig.r;
    }

    function getRadius() public view returns (uint){
        return fig.r;
    }

    function getPoint() public view returns (uint, uint) {
        return (fig.center.x, fig.center.y);
    }

    function setRadius(uint radius) public {
        fig.r = radius;
    }

    function setPoint(uint x, uint y) public {
        fig.center.x = x;
        fig.center.y = y;
    }
}