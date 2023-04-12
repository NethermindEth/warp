# Dependencies

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
