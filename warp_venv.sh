#/usr/bin/env sh

PYTHON_BIN=$1
SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
echo $SCRIPT_DIR
echo $SCRIPT_DIR
echo $SCRIPT_DIR
echo $PWD
pwd

$PYTHON_BIN -m venv "$SCRIPT_DIR"/warp_venv
. $SCRIPT_DIR/warp_venv/bin/activate

pip install cairo-lang==0.8.2.1

deactivate
