// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

function f(uint256 x) pure returns (uint256) {
    return x;
}
function g(uint256 x) pure returns (uint256) {
    return x;
}


function doog(BB storage x) view returns (uint256) {
    return x.b;
}

library Nums {
  function amIReal(int256 t, bool d) external returns (bool) {
    return true;
  }
  function amIReal(uint256 t, bool d) external returns (bool) {
    return false;
  }
  function foo(int256 a) private pure returns (bool) {
    return true;
  }
}

using Nums for uint256;

struct BB {
    uint256 b;
}

function foog(BB memory x) view returns (uint256) {
    return x.b;
}

using {foog} for BB global;
using Nums for BB global;

contract A{
    using {f, g} for uint256;
    using { Nums.foo } for int256;
    function foo(uint256 x) public returns (bool) {
        return x.amIReal(false);
    }
}
