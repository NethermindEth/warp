from __future__ import annotations

from contextlib import contextmanager


class NameGenerator:
    def __init__(self):
        self.n_loops = -1
        self.n_leaves = -1
        self.n_subexpressions = -1
        self.n_blocks = -1
        self.n_ifs = -1

    def make_loop_names(self) -> tuple[str, str, str]:
        self.n_loops += 1
        return (
            self._prefixed(f"loop_{self.n_loops}"),
            self._prefixed(f"loop_body_{self.n_loops}"),
            self._prefixed(f"break_{self.n_loops}"),
        )

    def make_leave_name(self) -> str:
        self.n_leaves += 1
        return self._prefixed(f"leave_{self.n_leaves}")

    def make_subexpr_name(self) -> str:
        self.n_subexpressions += 1
        return self._prefixed(f"subexpr_{self.n_subexpressions}")

    def make_block_name(self) -> str:
        self.n_blocks += 1
        return self._prefixed(f"block_{self.n_blocks}")

    def make_if_name(self) -> str:
        self.n_ifs += 1
        return self._prefixed(f"if_{self.n_ifs}")

    @contextmanager
    def new_block(self):
        old_n_subexpressions = self.n_subexpressions
        self.n_subexpressions = -1
        try:
            yield None
        finally:
            self.n_subexpressions = old_n_subexpressions

    def _prefixed(self, name: str) -> str:
        return "__warp_" + name
