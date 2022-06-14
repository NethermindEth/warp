struct S {
  uint256 x;
}

struct R {
    uint256 x;
}

struct T {
    uint8 x;
}

contract A {

    struct T {
        uint256 x;
        uint256 y;
    }

    function main(R calldata blah) public returns(R memory) {
      f(S(1), R(1), T(3,4));
      return (R(4));
    }
}

contract WARP {
    struct R1 {
        uint256[] z;
    }

    function test1() public returns (uint256) {
      return f(S(1), R(1), A.T(3,8));
    }

    function test2(R calldata blah) public returns(R memory) {
      return (R(4));
    }

    function test3(A.T calldata ignore) public returns (A.T memory) {
      return A.T(3,8);
    }
}

function f(S memory s, R memory b, A.T memory r) returns (uint256) {
  require(s.x == 1);
  require(b.x == 1);
  require(r.x == 3);
  require(s.x + b.x == 2);
  return s.x + b.x + r.x;
}
