# NOTE
Warp is under heavy development and is currently not stable. A stable release will be released in the coming weeks.

# Warp

Warp brings Solidity to StarkNet, making it possible to transpile Ethereum smart contracts to Cairo, and use them on StarkNet.

## Table of Contents :clipboard:

- [Installation](#installation-gear)
- [Usage](#usage-computer)
- [Want to contribute?](#want-to-contribute-thumbsup)
- [License](#license-warning)

## Installation :gear:

Prerequisites:

Install [Kudu](https://github.com/NethermindEth/kudu), our tool to generate the Yul AST, and add it to your PATH.

Linux:
```
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python3.7
sudo apt install -y python3.7-dev
sudo apt install -y libgmp3-dev
sudo apt-get install -y python3.7-venv
python3.7 -m venv ~/warp_demo
source ~/warp_demo/bin/activate
cd warp
make warp
```
MacOs:
```
brew install python@3.7
brew install gmp
python3.7 -m venv ~/warp_demo
source ~/warp_demo/bin/activate
cd warp
make warp
```
## Usage :computer:

You can transpile your Solidity/Vyper contracts with:

```
warp transpile FILE_PATH CONTRACT_NAME
```

`CONTRACT_NAME` is the name of the primary contract (non-interface, non-library, non-abstract contract) that you wish to transpile

To deploy the transpiled program to Starknet use:
```
warp deploy CONTRACT.json
```

To invoke a public/external method use:
```
warp invoke --program CONTRACT.json --address ADDRESS --function FUNCTION_NAME --inputs "INPUTS"
```

The `--inputs` flag requires its argument to be a string and have each value separated by a space.

You can check the status of your transaction with:

```
warp status TX_ID
```

## Want to contribute? :thumbsup:

Your contributions are always welcome, see [contribution guidelines](CONTRIBUTING.md).

## License

[Apache License](LICENSE) Version 2.0, January 2004.
