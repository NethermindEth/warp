contract A {
  function f() public returns (uint8) {
    return 5;
  }
}

contract B is A {
  function g() public returns (uint8, uint8, uint8) {
    return (this.f(), A.f(), super.f());
  }
}