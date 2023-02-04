#/usr/bin/env sh

PYTHON_BIN=$1
SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

$PYTHON_BIN -m venv "$SCRIPT_DIR"/warp_venv
. $SCRIPT_DIR/warp_venv/bin/activate

pip install cairo-lang==0.10.3

deactivate
