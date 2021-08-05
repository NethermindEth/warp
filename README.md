# Warp

Warp brings EVM compatible languages to StarkNet, making it possible to transpile Ethereum smart contracts to Cairo, and use them on StarkNet.

## Table of Contents :clipboard:

- [Installation](#installation-gear)
- [Usage](#usage-computer)
- [Want to contribute?](#want-to-contribute-thumbsup)
- [License](#license-warning)

## Installation :gear:

You'll need to install Cairo first. Make sure you're using a python venv with python 3.7. Cairo depends on GMP, which can be installed with `sudo apt install -y libgmp3-dev` or `brew install gmp` if you're on Mac. You'll need to install the following too:

```
pip install ecdsa fastecdsa sympy
```

Once you've done that, head into vendor/cairo-lang and run:

```
sh build.sh
pip install cairo-lang-0.3.0.zip
```

If you get errors relating to missing header files or bdist_wheel after installing python3.7 and trying to install Cairo, run the following commands:
```
sudo apt-get install -y python3.7-dev
pip install wheel
```
Once that is finished, run `make warp` in the repo's root directory.

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
