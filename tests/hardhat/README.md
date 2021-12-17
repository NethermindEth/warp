# Run Tests

Each contract/directory in the `contracts` directory, has a corresponding test script in the `test` directory.
First start the StarkNet testnet server: `python starknet-testnet/server.py`.
To run the tests, simply use:
```shell
yarn test
```
For a good example of the structure of the testing script, have a look at `test/Token.ts`.
