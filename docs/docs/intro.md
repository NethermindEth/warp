---
title: Welcome
sidebar_position: 1
---

# Welcome to Warp!

Warp is a transpiler from Solidity to Cairo. It allows you to deploy your Solidity contracts on Starknet.

# Quickstart

> **Note:**
> Executing Warp using Docker works only for x86 architecture. If you're using ARM architecture (such as Apple's M1) you can find warp installation instructions [here](https://nethermindeth.github.io/warp/docs/getting_started/a-usage-and-installation).

> **Note:**
> The method refers to warp for cairo 0. If you are looking for cairo 1 warp see [installing from source](https://nethermindeth.github.io/warp/docs/contribution_guidelines/a-installing-from-source).

The easiest way to start with warp is using docker. To do that navigate to the directory where you store your contracts and run command:

```
docker run --rm -v "$PWD:/dapp" nethermind/warp transpile <contract-path>
```

You can find docker installation guide [here](https://docs.docker.com/get-docker/).
