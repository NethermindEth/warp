import os, sys
import click
from web3 import Web3
from cli.compilation.Compile import Vyper, Solidity
from starkware.cairo.lang.compiler.parser import parse_file
from transpiler.EvmToCairo import EvmToCairo, parse_operations


@click.group()
def warp():
    pass


def _transpile(file):
    evm_to_cairo = EvmToCairo(cur_evm_pc=0)
    with open(file, "r") as opcodes_file:
        operations = list(parse_operations(opcodes_file))
        for op in operations:
            op.inspect_program(operations)

        for op in operations:
            evm_to_cairo.process_operation(op)

    os.remove(file)
    return parse_file(evm_to_cairo.finish(True)).format()


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


        cairo_str = _transpile(f"{path[:-4]}.opcode",)
        with open(f"{path[:-4]}.cairo", "w") as f:
            f.write(cairo_str)


cli = click.CommandCollection(sources=[warp])


def main():
    warp()
