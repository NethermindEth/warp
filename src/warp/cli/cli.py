import asyncio
import json
import os
from ast import literal_eval
from enum import Enum
from tempfile import NamedTemporaryFile

import click


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
@click.option("--cairo-output", is_flag=True)
@click.option(
    "--yul-optimizations",
    help="A string input for setting the sequence of optimizer steps",
)
def transpile(file_path, contract_name, cairo_output, yul_optimizations):
    """
    FILE_PATH: Path to your solidity contract\n
    CONTRACT_NAME: Name of the primary contract (non-interface, non-library, non-abstract contract) that you wish to transpile

    Generates a JSON file containing the transpiled contract and relevant information.
    """
    from warp.yul.main import transpile_from_solidity

    path = click.format_filename(file_path)

    if isinstance(yul_optimizations, str):
        output = transpile_from_solidity(file_path, contract_name, yul_optimizations)
    else:
        output = transpile_from_solidity(file_path, contract_name)

    if cairo_output:
        cairo_code = output["cairo_code"]
        with open(f"{file_path[:-4]}.cairo", "w") as cairo_file:
            cairo_file.write(cairo_code)
        path = f"{path[:-4]}.cairo"
    else:
        with open(f"{file_path[:-4]}.json", "w") as f:
            json.dump(output, f)
        path = f"{path[:-4]}.json"
    click.echo(f"The transpilation output has been written to {path}")


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
@click.option(
    "--inputs",
    required=True,
    help=(
        "function arguments passed as a python literal enclosed in double quotes. "
        "Either [] or () can be used for grouping as Solidity structs or arrays"
    ),
)
@click.option(
    "--network",
    envvar="STARKNET_NETWORK",
    required=True,
    help="A StarkNet network to use. "
    "Either specify it as the option value or set an environment variable STARKNET_NETWORK.",
)
def invoke(program, address, function, inputs, network):
    """
    Invoke the given function from a contract on StarkNet
    """
    from warp.cli.commands import _invoke

    inputs = literal_eval(inputs)
    contract_base = program[: -len(".json")]
    with open(program, "r") as f:
        program_info = json.load(f)
    asyncio.run(
        _invoke(contract_base, program_info, address, function, inputs, network)
    )


@warp.command()
@click.argument(
    "program", nargs=1, required=True, type=click.Path(exists=True, dir_okay=False)
)
@click.option("--constructor_args", required=False, default="[]")
@click.option(
    "--network",
    envvar="STARKNET_NETWORK",
    required=True,
    help="A StarkNet network to use. "
    "Either specify it as the option value or set an environment variable STARKNET_NETWORK.",
)
def deploy(program, constructor_args, network):
    """
    PROGRAM: path to the transpiled program JSON file.

    Compiles the given Cairo program info file and deploys it to StarkNet.
    Contract's address is printed to stdout.
    """
    from warp.cli.commands import _deploy

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
        asyncio.run(
            _deploy(
                cairo_path,
                contract_base,
                program_info,
                constructor_args,
                network,
            )
        )
    finally:
        os.remove(tmp.name)


@warp.command()
@click.argument("tx_hash", nargs=1, required=True)
def status(tx_hash):
    """
    TX_HASH: The transaction hash printed to stdout after invoking/deployment.\n
    To check the status of the invoke/deployment.
    """
    from warp.cli.commands import _status

    asyncio.run(_status(tx_hash))


def main():
    warp()
