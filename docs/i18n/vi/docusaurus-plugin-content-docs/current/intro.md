---
title: Welcome
sidebar_position: 1
---

# Welcome to Warp 2

We are excited to announce the second version of Warp, now designed to transpile your Solidity code directly into Cairo.

Warp 1 set out to show that compiling Solidity code into Cairo was possible, and paved the way for developers to access the benefits of StarkNet without needing to master Cairo. Using everything we learned from Warp 1, we have written a new version adding vast improvements to contract efficiency and user experience. In this blog, we will talk through the improvements made to Warp, transpile OpenZeppelin’s ERC20 contract, and describe future plans for the project.

### Warp 2 vs Warp 1

Warp 2 improves on the prior version by transpiling directly from Solidity to Cairo. In Warp 1, the Solidity smart contract was first compiled into YUL (Solidity’s intermediate representation) and then transpiled to Cairo. Skipping the YUL intermediary means we don’t have to transpile many low-level calls and rather transpile the higher-level Solidity. Sounds interesting, but what does this mean for users?

- Reduced code size
- Smaller step count when calling functions (functions require less computation)
- Improved Cairo readability
- Unsupported feature messages to know which features in Solidity are not supported
- YUL will always have more instructions than the Solidity it is generated from. As an example, the simple 1-line function in Solidity grows to 6 lines of YUL with additional function calls.

#### Want to know more on Warp 2.0? Read the blog [here](https://medium.com/nethermind-eth/warp-2-0-transpiling-directly-from-solidity-to-cairo-9bf41a6d26ee).
