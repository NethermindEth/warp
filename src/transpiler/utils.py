from __future__ import annotations

def is_valid_uintN(n: int, x: int):
    return 0 <= x < 2 ** n
