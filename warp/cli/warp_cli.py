import os, sys
import click
from web3 import Web3
from cli.compilation.Compile import Vyper, Solidity
from cli.commands import _call, _invoke
from cli.commands import _transpile


@click.group()
def warp():
    pass


@warp.command()
@click.argument("contract_path", nargs=1, type=click.Path(exists=True))
def transpile(contract_path):
    if contract_path.endswith("vy"):
        path = os.path.abspath(click.format_filename(contract_path))
        contract = Vyper(path)
        cairo_str = _transpile(contract.opcodes)
        with open(f"{path[:-3]}.cairo", "w") as f:
            f.write(cairo_str)
    elif contract_path.endswith("sol"):
        path = os.path.abspath(click.format_filename(contract_path))
        filename = os.path.basename(path)
        contract = Solidity(path)
        with open(f"{path[:-4]}.opcode", "w") as f:
            f.write(contract.opcodes_str)

        cairo_str = _transpile(
            f"{path[:-4]}.opcode",
        )
        with open(f"{path[:-4]}.cairo", "w") as f:
            f.write(cairo_str)


@warp.command()
@click.option("--address", required=True, type=click.Path(exists=True))
@click.option("--abi", required=True, type=click.Path(exists=True))
@click.option("--function", required=True, type=click.Path(exists=True))
@click.option("--inputs", required=True, type=click.Path(exists=True))
def invoke(address, abi, function, inputs):
    _invoke(address, abi, function, inputs)


@warp.command()
@click.option("--address", required=True, type=click.Path(exists=True))
@click.option("--abi", required=True, type=click.Path(exists=True))
@click.option("--function", required=True, type=click.Path(exists=True))
def call(address, abi, function):
    _call(address, abi, function)


cli = click.CommandCollection(sources=[warp])


def main():
    warp()
