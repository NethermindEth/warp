import pytest
import os
import json
import difflib

from yul.translator import sol_to_cairo

warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
test_dir = os.path.join(warp_root, "tests", "yul")
tests = [os.path.join(test_dir, item) for item in os.listdir(test_dir) if item.endswith('.sol')]
cairo_suffix = '.gold.cairo'
main_contract = 'WARP'

@pytest.mark.parametrize(("solidity_file"), tests)
def test_transpilation(solidity_file):
    gen_cairo_code = sol_to_cairo(solidity_file, main_contract).splitlines()

    with open(solidity_file + cairo_suffix, 'r') as cairo_file:
        cairo_code = cairo_file.read().splitlines()
        cairo_file.close()

    compare_codes(gen_cairo_code, cairo_code)


def compare_codes(lines1, lines2):
    d = difflib.Differ()
    diff = d.compare(lines1, lines2)
    
    message = ''
    result = False
    for item in diff:
        result |= item.startswith('+') or item.startswith('-')
        message += item + '\n'

    assert not result, message
