import platform
import subprocess
import sys


def pip_freeze() -> str:
    result = subprocess.run("pip freeze".split(), stdout=subprocess.PIPE)
    return "pip freeze result:\n%s" % result.stdout.decode()


def python_version() -> str:
    return "Python version:\n%s" % sys.version


def platform_info() -> str:
    return "Operating System: %s" % platform.platform()


def get_environment_summary() -> str:
    return "\n\n".join([python_version(), platform_info(), pip_freeze()])
