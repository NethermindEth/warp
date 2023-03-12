
### Dependencies

<hr> 
 
1. You will need [z3](https://github.com/Z3Prover/z3) and [gmp](https://gmplib.org/#DOWNLOAD)
   installed to use Warp.
  
- Install command on macOS:
```bash
brew install z3 gmp
```

If you're on an arm based Apple machine (m1/m2 mac) you'll need to install `gmp` and export some
environment variables

```
export CFLAGS=-I`brew --prefix gmp`/include
export LDFLAGS=-L`brew --prefix gmp`/lib
```

- Install command on Ubuntu:

```bash
sudo apt install libz3-dev libgmp3-dev
```

2. Install Python3.9 with dev dependencies (`python3.9 python3.9-venv python3.9-dev`) into your base env.
   If you do not have the dev dependencies installed the installation will fail.
   <br>

- Install commands on MacOS:

```bash
brew install python@3.9
```

With python3.9 already installed you have venv covered:

> If you are using Python 3.3 or newer (...) venv is included in the Python standard library and requires no additional installation.

Then you can install dev package using pip:

```bash
pip install python-dev-tools
```

- Install commands on Ubuntu:

```bash
sudo apt install python3.9 python3.9-venv python3.9-dev
```

Or you can just install python3.9 and then install python-dev-tools using pip.

### Warp Installation Method 1:

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

<br>

### Warp Installation Method 2 (from source/for devs):

<hr>

Make sure you have the [dependencies](#dependencies) installed first.

With a virtual environment (recommended Python3.9) activated:

1. Clone this repo and change directory into the `warp` folder.

2. Install the JavaScript dependencies:

```bash
yarn
```

3. Install the Python dependencies:

```bash
pip install -r requirements.txt
```

If you are using a M1 chipped Mac and getting a `'gmp.h' file not found` error when installing Cairo run the following:

```bash
CFLAGS=-I`brew --prefix gmp`/include LDFLAGS=-L`brew --prefix gmp`/lib pip install ecdsa fastecdsa sympy
```

Then run the pip command above again.

4. Compile the project:

```bash
yarn warplib
```

5. Test the installation worked by transpiling an example ERC20 contract:

```bash
bin/warp transpile example_contracts/ERC20.sol
```
