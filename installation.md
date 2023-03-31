# Installation

The first step is to make sure you have all required external [dependencies](dependencies.md) installed.

Then perform the following instructions in order:

1. Add the warp package from npm.

```bash
yarn global add @nethermindeth/warp
```

2. Ensure the package was added by checking the version number:

```bash
warp version
```

3. Install the dependencies:

```bash
warp install --verbose
```

Use the `--python` flag to pass the path to `python3.9` binary, if the above command complains.

```bash
warp install --python <path/to/python3.9> --verbose
```

4. Test the installation worked by transpiling an example ERC20 contract:

```bash
warp transpile example_contracts/ERC20.sol
```
