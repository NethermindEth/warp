To get the dependencies:

```bash
yarn
```

Compile the project:

```bash
yarn tsc
```

To transpile a contract:

```bash
bin/warp transpile example-contracts/ERC20.sol
```

To test run warp on all example contracts:

```bash
bin/warp test
```

For this to work, you must be able to run

```bash
starknet-compile
```

Instructions to set this up can be found at https://www.cairo-lang.org/docs/quickstart.html

To examine a solidity file in unwarped AST form:

```bash
bin/warp analyse example-contracts/ERC20.sol
```

---New tests---
The old tests check for successfully compiling cairo code
The new tests check for correctly running cairo code

First, in a separate terminal, start a starknet-testnet server:

```bash
yarn testnet
```

then to run the tests:

```bash
yarn test
```
