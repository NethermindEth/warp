from __future__ import annotations

from typing import Dict, Set

Imports = Dict[str, Set[str]]


def format_names(import_names: set[str]) -> str:
    """Create an import names list, e.g. '(name1, name2)' in 'from module
    import (name1, name2)'.

    """
    if len(import_names) == 0:
        raise ValueError("Import names list can't be empty")
    if len(import_names) == 1:
        return next(iter(import_names))

    sorted_names = sorted(import_names)
    import_line_fmt = "    {0},"
    import_lines = [import_line_fmt.format(name) for name in sorted_names]
    return "(\n" + "\n".join(import_lines) + "\n)"


def format_imports(imports: Imports) -> str:
    sorted_imports = sorted(imports.items())
    return "\n".join(
        f"from {module} import {format_names(names)}"
        for module, names in sorted_imports
    )


def merge_imports(imports: Imports, new_imports: Imports):
    for module, names in new_imports.items():
        imports[module].update(names)
