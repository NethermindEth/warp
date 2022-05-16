// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

struct SourceParent {
    uint a;
    SourceLeaf b;
}

struct SourceLeaf {
    uint c;
}

contract WARP {
    struct Parent {
        Mid1 mid1;
        // mapping (address => Mid2) mid2;
        Mid3[] mid3;
    }

    struct Mid1 {
        Leaf1 l;
    }

    struct Mid2 {
        Leaf1 l;
        uint256 p;
    }

    struct Mid3 {
        Mid2 mid2;
        Leaf2[] leaf2;

    }

    struct Leaf1 {
        uint256 m1;
    }

    struct Leaf2 {
        uint256 m1;
        uint256 m2;
    }

    struct Another {
        address b;
    }
}
