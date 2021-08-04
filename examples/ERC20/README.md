# Instructions

`ERC20.sol` is a simple ERC20 contract. You may notice that it doesn't use things like `msg.sender` or `msg.value`, this is because these variables rely on Ethereum L1 state, which doesn't make sense in the context of StarkNet. This won't be the case forever though, once StarkNet has implemented analogous semantics, you won't have to worry about leavning them out.

`warp transpile ERC20.sol` will generate the transpiled Cairo contract `ERC20.cairo`. `warp deploy ERC20.cairo` will compile your Cairo contract and deploy it to StarkNet, the contract's address will be printed to stdout, and will also be saved in a file called `CONTRACT_NAME_ADDRESS.txt`, with `CONTRACT_NAME` being `ERC20` in this case. To invoke a contract method, use `warp invoke --contract CONTRACT.cairo --address ADDRESS --function FUNCTION --inputs INPUTS`. Here, `FUNCTION` referrs to the function name in the SOLIDITY contract. Here is an example of a sequence of commands to transpile, deploy and invoke the `approve` function:
```
warp transpile ERC20.sol
warp deploy ERC20.cairo
warp invoke --contract ERC20.cairo --address 0x02f05eb5226e359adbc774a7330d4d9ff7d53ff29f48a78ffcab625742548aeb --function approve --inputs "0xe5D55458358185A017ac9A0bC4Abc079A51AE813 100 0x497F300c628cd37Bc4f2E1A2864b11570E0f22A8"
```
Notice how the --inputs are surrounded by quotes and have a space separating each input argument. You can check the status of the deployment/invoke with `warp status TX_ID`, where TX_ID is printed to stdout after deployment/invoking.