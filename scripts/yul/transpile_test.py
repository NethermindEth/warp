import difflib
import os
import pytest
import sys

from yul.main import generate_cairo

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = os.path.join(warp_root, "tests", "yul")
tests = [
    os.path.join(test_dir, item)
    for item in os.listdir(test_dir)
    if item.endswith(".sol")
]
cairo_suffix = ".cairo"
main_contract = "WARP"


@pytest.mark.parametrize(("solidity_file"), tests)
def test_transpilation(solidity_file):
    gen_cairo_code = generate_cairo(solidity_file, main_contract).splitlines()

    cairo_file_path = solidity_file[:-4] + cairo_suffix
    try:
        with open(cairo_file_path, "r") as cairo_file:
            cairo_code = cairo_file.read().splitlines()
            cairo_file.close()
    except OSError as e:
        print(
            f"Troubles with reading {cairo_file_path}: {e}. "
            f"Treating the file as empty",
            file=sys.stderr,
        )
        cairo_code = []

    temp_file_path = f"{cairo_file_path}.temp"
    marked_sol_file = solidity_file[:-4] + "_marked.sol"
    os.remove(marked_sol_file)
    with open(temp_file_path, "w") as temp_file:
        print(*gen_cairo_code, file=temp_file, sep="\n")
    gen_cairo_code = clean(gen_cairo_code)
    cairo_code = clean(cairo_code)
    compare_codes(gen_cairo_code, cairo_code)
    os.remove(temp_file_path)


def compare_codes(lines1, lines2):
    d = difflib.unified_diff(lines1, lines2, n=1, lineterm="")

    message = "\n".join([line for line in d])
    assert len(message) == 0, message


def clean(lines):
    res = []
    for line in lines:
        l = line.strip()
        if len(l) > 0:
            res.append(l)

    return res
