// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.0;

// Experimental Dai token to test Warp transpiler

contract Dai {

  mapping (address => uint256) public wards;
  function rely(address usr) external {
    wards[usr] = 1;
    emit Rely(usr);
  }
  function deny(address usr) external {
    wards[usr] = 0;
    emit Deny(usr);
  }

  // --- ERC20 Data ---
  uint8   public constant decimals = 18;
  uint256 public totalSupply;

  mapping (address => uint256)                      public balanceOf;
  mapping (address => mapping (address => uint256)) public allowance;
  mapping (address => uint256)                      public nonces;

  event Approval(address  owner, address  spender, uint256 value);
  event Transfer(address  from, address  to, uint256 value);
  event Rely(address  usr);
  event Deny(address  usr);

  function getAllowance(address owner, address spender) external view returns (uint256) {
    return allowance[owner][spender];
  }

  function getBalance(address owner) external view returns (uint256) {
    return balanceOf[owner];
  }

  // --- Math ---
  function _add(uint256 x, uint256 y) internal pure returns (uint256 z) {
    require((z = x + y) >= x);
    return z;
  }
  function _sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
    require((z = x - y) <= x);
    return z;
  }

  constructor() public {
    wards[msg.sender] = 1;
    emit Rely(msg.sender);
  }


  // --- ERC20 Mutations ---
  function transfer(address to, uint256 value) external returns (bool) {
    require(to != address(0), "Dai/invalid-address");
    uint256 balance = balanceOf[msg.sender];
    require(balance >= value, "Dai/insufficient-balance");

    balanceOf[msg.sender] = balance - value;
    balanceOf[to] += value;

    emit Transfer(msg.sender, to, value);

    return true;
  }


  function transferFrom(address from, address to, uint256 value) external returns (bool) {
    // require(to != address(0), "Dai/invalid-address");
    uint256 balance = balanceOf[from];
    // require(balance >= value, "Dai/insufficient-balance");

    uint256 allowed = allowance[from][msg.sender];
    allowance[from][msg.sender] = allowed - value;

    balanceOf[from] = balance - value;
    balanceOf[to] += value;

    emit Transfer(from, to, value);

    return true;
  }


  function approve(address spender, uint256 value) external returns (bool) {
    allowance[msg.sender][spender] = value;

    emit Approval(msg.sender, spender, value);

    return true;
  }

  function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
    uint256 newValue = _add(allowance[msg.sender][spender], addedValue);
    allowance[msg.sender][spender] = newValue;

    emit Approval(msg.sender, spender, newValue);

    return true;
  }


  function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
    uint256 allowed = allowance[msg.sender][spender];
    require(allowed >= subtractedValue, "Dai/insufficient-allowance");
    allowed = allowed - subtractedValue;
    allowance[msg.sender][spender] = allowed;

    emit Approval(msg.sender, spender, allowed);

    return true;
  }

  // --- Mint/Burn ---
  function mint(address to, uint256 value) external returns (bool) {
    require(to != address(0), "Dai/invalid-address");
    balanceOf[to] = balanceOf[to] + value; // note: we don't need an overflow check here b/c balanceOf[to] <= totalSupply and there is an overflow check below
    totalSupply   = _add(totalSupply, value);
    return true;
  }
}