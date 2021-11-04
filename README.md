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
Make sure your Solidity compiler version is >= 0.8.0

Linux:
```
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python3.7
sudo apt install -y python3.7-dev
sudo apt install -y libgmp3-dev
sudo apt install -y libboost-all-dev
sudo apt-get install -y python3.7-venv
python3.7 -m venv ~/warp
source ~/warp/bin/activate
```
MacOs:
```
brew install python@3.7
brew install gmp
brew install boost
python3.7 -m venv ~/warp
source ~/warp/bin/activate
```

Install Warp:
```
pip install sol-warp
```

## Usage :computer:

You can transpile your Solidity contracts with:

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

Here's an example that shows you the format of the inputs for `inputs`:

Let's say we want to call the following Solidity function in a contract that we've transpiled & deployed on StarkNet:

```solidity
struct Person {
    uint age;
    uint height;
}
function validate(address _ownerCheck, Person calldata _person, uint _ownerCellNumberCheck) 
  public view returns (bool) {
    return (owner == _ownerCheck && ownerAge == _person.age 
        && ownerCellNumber == _ownerCellNumberCheck);
}
```
The command to call this function would be:
```bash
warp invoke --program CONTRACT.json --address ADDRESS --function validate \
        --inputs "0x07964d2123425737cd3663bec47c68db37dc61d83fee74fc192d50a59fb7ab56 26 200 7432533831"
```
The `--inuputs` flag, if not empty, should always be a string with each argument separated by a space. As you can see, we passed the Person struct values in the same order as their declaration (i.e `age` first, `person` second). If the first argument to the
```validate``` function was an array of uint's, then we'd pass it in as you'd expect:
```bash
--inputs = "42 1722 7 26 200 7432533831"
```


You can check the status of your transaction with:

```
warp status TX_HASH
```

## Want to contribute? :thumbsup:

Your contributions are always welcome, see [contribution guidelines](CONTRIBUTING.md).

## License

[Apache License](LICENSE) Version 2.0, January 2004.
