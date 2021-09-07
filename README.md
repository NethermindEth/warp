# Warp

Warp brings EVM compatible languages to StarkNet, making it possible to transpile Ethereum smart contracts to Cairo, and use them on StarkNet.

## Table of Contents :clipboard:

- [Installation](#installation-gear)
- [Usage](#usage-computer)
- [Want to contribute?](#want-to-contribute-thumbsup)
- [License](#license-warning)

## Installation :gear:

Linux:
```
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python3.7
sudo apt install -y python3.7-dev
sudo apt install -y libgmp3-dev
python3.7 -m venv ~/warp_demo
source ~/warp_demo/bin/activate
pip install wheel
pip install ecdsa fastecdsa sympy
pip install cairo-lang==0.4.0
make warp
```
MacOs:
```
brew install python@3.7
brew install gmp
python3.7 -m venv ~/warp_demo
source ~/warp_demo/bin/activate
pip install wheel
pip install ecdsa fastecdsa sympy
pip install cairo-lang==0.4.0
make warp
```
## Usage :computer:

You can transpile your Solidity/Vyper contracts with:

```
warp transpile CONTRACT
```

To deploy the transpiled Cairo contract to Starknet use:
```
warp deploy CONTRACT.cairo
```

To invoke a public/external method use:
```
warp invoke --contract CONTRACT.cairo --address ADDRESS --function FUNCTION_NAME --inputs "INPUTS"
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
