#!/usr/bin/env python

import os
import pathlib
import platform
import stat
import subprocess
import sys
from contextlib import contextmanager
from typing import Generator, Optional

from importlib_resources import as_file, files

exec_name = "nethersolc"


def get_system_suffix(system: str) -> Optional[str]:
    system = system.lower()
    if system == "linux":
        return "linux"
    elif system == "darwin":
        return "darwin"
    return None


@contextmanager
def nethersolc_exe() -> Generator[pathlib.Path, None, None]:
    suffix = get_system_suffix(platform.system())
    if not suffix:
        raise RuntimeError(f"Unsupported OS: {platform.platform()}")
    with as_file(files("warp") / "bin" / suffix / exec_name) as exe:
        st_mode = os.stat(exe).st_mode
        os.chmod(exe, stat.S_IEXEC | st_mode)
        yield exe


def main(argv):
    with nethersolc_exe() as exe:
        res = subprocess.run([exe, *argv[1:]], stdout=sys.stdout, stderr=sys.stderr)
    sys.exit(res.returncode)


if __name__ == "__main__":
    main(sys.argv)
