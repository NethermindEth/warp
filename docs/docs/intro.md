---
title: Welcome
sidebar_position: 1
---

# Welcome to Warp!

Warp is a transpiler from Solidity to Cairo. It allows you to deploy your Solidity contracts on Starknet.

# Quickstart

> **Note:**
> Executing Warp using Docker works only for x86 architecture. If you're using ARM architecture (such as Apple's M1) you can find warp installation instructions [here](https://nethermindeth.github.io/warp/docs/getting_started/a-usage-and-installation).

The easiest way to start with warp is using docker. To do that navigate to the directory where you store your contracts and run command:

```
docker run --rm -v "$PWD:/dapp" nethermind/warp transpile <contract-path>
```

You can find docker installation guide [here](https://docs.docker.com/get-docker/).
