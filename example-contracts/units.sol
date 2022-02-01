pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

contract WARP {
  function sumEther() pure public returns (uint256) {
    uint256 amount = 0;
    amount += 123 wei;
    amount += 45 gwei;
    amount += 6 ether;
    return amount;
  }

  function sumTime() pure public returns (uint256) {
    uint256 time = 0;
    time += 12 seconds;
    time += 34 minutes;
    time += 56 hours;
    time += 78 days;
    time += 90 weeks;
    return time;
  }

  function referenceValues() pure public returns (bool) {
    assert(1 wei == 1);
    assert(1 gwei == 1e9);
    assert(1 ether == 1e18);
    assert(1 wei == 1e-18 ether);
    assert(1 wei == 1e-9 gwei);
    assert(1 seconds == 1);
    assert(1 minutes == 60 seconds);
    assert(1 hours == 60 minutes);
    assert(1 days == 24 hours);
    assert(1 weeks == 7 days);
    assert(2e800 gwei - 2e809 == 0);
    assert(1.2 gwei == 1200000000);
    assert(10.1 gwei == 10.1e9);
    return true;
  }
}
