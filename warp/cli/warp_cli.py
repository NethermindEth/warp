import asyncio
import json
import os
import shutil
import sysconfig
from ast import literal_eval
from enum import Enum
from tempfile import NamedTemporaryFile
import pkg_resources

import click
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
    click.echo(inputs)
    click.echo(function)
    with open(program, "r") as f:

        program_info = json.load(f)
    asyncio.run(_invoke(program_info, address, function, inputs))


@warp.command()
@click.argument(
    "program",
    nargs=1,
    required=True,
    type=click.Path(exists=True, dir_okay=False),
)
@click.option("--constructor_args", required=False, default="\0")
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


def main():
    try:
        base_env_dir = os.environ['VIRTUAL_ENV']
        new_kudu_exe = os.path.join(base_env_dir,"bin/kudu")
    except KeyError:
        base_env_dir = sysconfig.get_path('scripts', f'{os.name}_user')
        new_kudu_exe = os.path.join(base_env_dir,"kudu")
    kudu_pkg_dir = os.path.join(pkg_resources.get_distribution("sol-warp").location, "bin/kudu")
    if os.path.exists(new_kudu_exe):
        os.remove(new_kudu_exe)
    shutil.copy2(kudu_pkg_dir, new_kudu_exe)
    warp()
