# Warp

Warp brings Ethereum Virtual Machine to StarkNet, making it possible to run Ethereum [Smart Contracts](https://ethereum.org/en/developers/docs/smart-contracts/) as StarkNet contracts.

# Installation

You'll need to install Cairo first. Make sure your using a python venv with python 3.7. Cairo depends on GMP, which can be installed with `sudo apt install -y libgmp3-dev` or `brew install gmp` if you're on Mac. Once you've done that, head into vendor/cairo-lang and run:
```
sh build.sh
pip install cairo-lang-0.3.0.zip
```

# Usage

You can transpile your Solidity/Vyper contracts with `warp transpile CONTRACT`. To deploy the transpiled Cairo contract to Starknet use: `warp deploy CONTRACT.cairo`. To invoke a public/external method use: `warp invoke --contract CONTRACT.cairo --address ADDRESS --function FUNCTION_NAME --inputs "INPUTS"`. The `--inputs` flag requires its argument to be a string and have each value separated by a space. You can check the status of your transaction with `warp status TX_ID`.
