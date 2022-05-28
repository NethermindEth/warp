#/usr/bin/env sh

PYTHON_BIN=$1
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

$PYTHON_BIN -m venv $SCRIPT_DIR/warp_venv
source $SCRIPT_DIR/warp_venv/bin/activate

pip install cairo-lang==0.8.2

deactivate
