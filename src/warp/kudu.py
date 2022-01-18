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

exec_name = "kudu"


def get_system_suffix(system: str) -> Optional[str]:
    system = system.lower()
    if system == "linux":
        return "linux"
    elif system == "darwin":
        version = platform.mac_ver()[0]
        major, minor = map(int, version.split(".")[:2])
        if major >= 11:
            return "macos_11"
        elif (major, minor) == (10, 14):
            return "macos_10_14"
        elif (major, minor) == (10, 15):
            return "macos_10_15"
    return None


@contextmanager
def kudu_exe() -> Generator[pathlib.Path, None, None]:
    suffix = get_system_suffix(platform.system())
    if not suffix:
        raise RuntimeError(f"Unsupported OS: {platform.platform()}")
    with as_file(files("warp") / "bin" / suffix / exec_name) as exe:
        st_mode = os.stat(exe).st_mode
        os.chmod(exe, stat.S_IEXEC | st_mode)
        yield exe


def main(argv):
    with kudu_exe() as exe:
        res = subprocess.run([exe, *argv[1:]], stdout=sys.stdout, stderr=sys.stderr)
    sys.exit(res.returncode)


if __name__ == "__main__":
    main(sys.argv)
