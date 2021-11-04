import asyncio
import json
import os
import platform
import shutil
import sysconfig
from ast import literal_eval
from enum import Enum
from tempfile import NamedTemporaryFile

import click
import pkg_resources
from cli.commands import _deploy, _invoke, _status
from yul.main import transpile_from_solidity
from yul.utils import get_low_high


class Command(Enum):
    INVOKE = 0
    CALL = 1
    DEPLOY = 2
    STATUS = 3


@click.group()
def warp():
    pass


WARP_CONFIG_DIR = os.path.abspath(os.path.join(os.path.expanduser("~"), ".warp"))
KUDU_INIT = os.path.abspath(os.path.join(WARP_CONFIG_DIR, ".kudu_init"))


@warp.command()
@click.argument("file_path", type=click.Path(exists=True))
@click.argument("contract_name")
def transpile(file_path, contract_name):
    path = click.format_filename(file_path)
    output = transpile_from_solidity(file_path, contract_name)
    with open(f"{file_path[:-4]}.json", "w") as f:
        json.dump(output, f)
    click.echo(f"The transpilation output has been written to {path[:-4]}.json")


@warp.command()
@click.option(
    "--program",
    required=True,
    type=click.Path(exists=True, dir_okay=False),
    help="the path to the transpiled program JSON file",
)
@click.option("--address", required=True, help="contract address")
@click.option(
    "--function",
    required=True,
    help="the name of the function to invoke, as defined in the Solidity contract",
)
@click.option("--inputs", required=True, help="Function Arguments")
def invoke(program, address, function, inputs):
    inputs = literal_eval(inputs)
    contract_base = program[: -len(".json")]
    with open(program, "r") as f:
        program_info = json.load(f)
    asyncio.run(_invoke(contract_base, program_info, address, function, inputs))


@warp.command()
@click.argument(
    "program",
    nargs=1,
    required=True,
    type=click.Path(exists=True, dir_okay=False),
)
@click.option("--constructor_args", required=False, default="[]")
def deploy(program, constructor_args):
    """Deploy PROGRAM.

    PROGRAM is the path to the transpiled program JSON file.

    """
    try:
        constructor_args = literal_eval(constructor_args)
    except ValueError:
        pass
    assert program.endswith(".json")
    contract_base = program[: -len(".json")]
    with open(program, "r") as pf:
        program_info = json.load(pf)
    tmp = NamedTemporaryFile(mode="w", delete=False)
    cairo_path = tmp.name
    tmp.write(program_info["cairo_code"])
    tmp.close()
    try:
        asyncio.run(_deploy(cairo_path, contract_base, program_info, constructor_args))
    finally:
        os.remove(tmp.name)


@warp.command()
@click.argument("tx_id", nargs=1, required=True)
def status(tx_id):
    asyncio.run(_status(tx_id))


def init_kudu():
    os.mkdir(WARP_CONFIG_DIR)
    try:
        base_env_dir = os.environ["VIRTUAL_ENV"]
        new_kudu_exe = os.path.join(base_env_dir, "bin/kudu")
    except KeyError:
        raise Exception(
            "Please use a python venv, see https://github.com/NethermindEth/warp#installation-gear for detials"
        )
    if platform.system() == "Linux":
        kudu_pkg_dir = os.path.join(
            pkg_resources.get_distribution("sol-warp").location, "bin/linux/kudu"
        )
    elif platform.system() == "Darwin":
        v, _, _ = platform.mac_ver()
        v = float(".".join(v.split(".")[:2]))
        if v < 11:
            if v < 10.14:
                raise RuntimeError(
                    "Unsupported MacOS version, please update to version 10.14 or higher"
                )
            if v >= 10.14 and v < 10.15:
                kudu_pkg_dir = os.path.join(
                    pkg_resources.get_distribution("sol-warp").location,
                    "bin/macos/10/14/kudu",
                )
            else:
                kudu_pkg_dir = os.path.join(
                    pkg_resources.get_distribution("sol-warp").location,
                    "bin/macos/10/kudu",
                )

        elif v >= 11:
            kudu_pkg_dir = os.path.join(
                pkg_resources.get_distribution("sol-warp").location, "bin/macos/11/kudu"
            )
        else:
            raise RuntimeError("Unsupported MacOS version")
    if os.path.exists(new_kudu_exe):
        os.remove(new_kudu_exe)
    shutil.copy2(kudu_pkg_dir, new_kudu_exe)
    with open(KUDU_INIT, "w") as f:
        f.write("1")


def main():
    if not os.path.exists(KUDU_INIT):
        init_kudu()
    warp()
