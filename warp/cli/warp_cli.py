import os, sys
import asyncio
import click
from enum import Enum
from yul.main import generate_cairo
from yul.utils import get_low_high
from cli.commands import _call, _invoke, _deploy, _status


class Command(Enum):
    INVOKE = 0
    CALL = 1
    DEPLOY = 2
    STATUS = 3


@click.group()
def warp():
    pass


@warp.command()
@click.argument("contract_path", nargs=2, type=click.Path(exists=False))
def transpile(contract_path):
    path = os.path.abspath(click.format_filename(contract_path[0]))
    filename = os.path.basename(path)
    cairo_str = generate_cairo(contract_path[0], contract_path[1])
    with open(f"{path[:-4]}.cairo", "w") as f:
        f.write(cairo_str)
    click.echo(f"The generated Cairo contract has been written to {path[:-4]}.cairo")
    return None


return_args = {}


@warp.command()
@click.option("--contract", required=True, help="path to transpiled cairo contract")
@click.option("--address", required=True, help="contract address")
@click.option(
    "--function",
    required=True,
    help="the name of the function to invoke, as defined in the SOLIDITY/VYPER contract",
)
@click.option("--inputs", required=True, help="Function Arguments")
def invoke(contract, address, function, inputs):
    inputs = inputs.split(" ")
    # high & low bits
    split_inputs = []
    for idx, input in enumerate(inputs):
        if input.isdigit():
            try:
                to_split = int(input, 16) if input.startswith("0x") else int(input)
                low, high = get_low_high(to_split)
                split_inputs += [int(low), int(high)]
                inputs[idx] = int(input, 16) if input.startswith("0x") else int(input)
            except ValueError:
                raise ValueError(
                    f"Invalid input value: '{input}'. Expected a decimal or hexadecimal integer."
                )
    return_args["address"] = address
    return_args["function"] = function
    return_args["contract"] = contract
    return_args["cairo_inputs"] = split_inputs
    return_args["evm_inputs"] = inputs
    return_args["type"] = Command.INVOKE


@warp.command()
@click.option("--address", required=True, type=click.Path(exists=True))
@click.option("--abi", required=True, type=click.Path(exists=True))
@click.option("--function", required=True, type=click.Path(exists=True))
def call(address, abi, function):
    _call(address, abi, function)


@warp.command()
@click.argument("contract", nargs=1, required=True, type=click.Path(exists=True))
def deploy(contract):
    """
    Name of the Cairo contract to deploy
    """
    return_args["contract"] = contract
    return_args["type"] = Command.DEPLOY


@warp.command()
@click.argument("status", nargs=1, required=True)
def status(status):
    return_args["id"] = status
    return_args["type"] = Command.STATUS


cli = click.CommandCollection(sources=[warp])


def main():
    try:
        warp()
    # This is how we make handling async code with
    # click MUCH simpler. click will always throw SystemExit
    # after leaving its main loop.
    except SystemExit as e:
        if return_args != {}:
            if return_args["type"] is Command.INVOKE:
                asyncio.run(
                    _invoke(
                        return_args["contract"],
                        return_args["address"],
                        return_args["function"],
                        return_args["cairo_inputs"],
                        return_args["evm_inputs"],
                    )
                )
            elif return_args["type"] is Command.DEPLOY:
                asyncio.run(_deploy(return_args["contract"]))
            elif return_args["type"] is Command.STATUS:
                asyncio.run(_status(return_args["id"]))
        # An Error to log
        elif e.args[0] != 0:
            click.echo(e.args[0])
    except BaseException as e:
        click.echo(e)
