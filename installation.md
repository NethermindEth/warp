# Installation

> **Note:**
> Execute Warp using Docker works only for x86 architecture, x64 architectures will be supported soon.

<hr> 
Without any virtual environment activated perform the following in order:

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

## Dependencies

In case of having any issues during installation, please make sure you have all required external [dependencies](dependencies.md) installed.
