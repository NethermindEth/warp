import os, sys
import click
from web3 import Web3
from cli.compilation.Compile import Vyper, Solidity
from starkware.cairo.lang.compiler.parser import parse_file
from transpiler.EvmToCairo import EvmToCairo, parse_ops_direct


@click.group()
def warp():
    pass


def _transpile(opcodes):
    evm_to_cairo = EvmToCairo(cur_evm_pc=0)
    operations = parse_ops_direct(tuple(opcodes))
    for op in operations:
        op.inspect_program(operations)

    for op in operations:
        evm_to_cairo.process_operation(op)
    return parse_file(evm_to_cairo.finish(True)).format()


@warp.command()
@click.argument("contract_path", nargs=1, type=click.Path(exists=True))
def transpile(contract_path):
    if contract_path.endswith("vy"):
        path = os.path.abspath(click.format_filename(contract_path))
        contract = Vyper(path)
        cairo_str = _transpile(contract.opcodes)
        with open(f"{path[:-3]}", "w") as f:
            f.write(cairo_str)
    elif contract_path.endswith("sol"):
        path = os.path.abspath(click.format_filename(contract_path))
        filename = os.path.basename(path)
        contract = Solidity(path)
        cairo_str = _transpile(contract.opcodes)
        with open(f"{path[:-3]}", "w") as f:
            f.write(cairo_str)


cli = click.CommandCollection(sources=[warp])


def main():
    warp()
