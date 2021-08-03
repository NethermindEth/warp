import os
import asyncio
import click
from enum import Enum
from cli.compilation.Compile import Vyper, Solidity
from cli.commands import _transpile, _call, _invoke


class Command(Enum):
    INVOKE = 0
    CALL = 1


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
    return None


return_args = {}


@warp.command()
@click.option("--contract", required=True)
@click.option("--address", required=True)
@click.option("--abi", required=True, type=click.Path(exists=True))
@click.option("--function", required=True)
@click.option("--inputs", required=True)
def invoke(contract, address, abi, function, inputs):
    inputs = inputs.split(" ")
    for idx, input in enumerate(inputs):
        if input.isdigit():
            inputs[idx] = int(input)
    return_args["address"] = address
    return_args["abi"] = abi
    return_args["function"] = function
    return_args["contract"] = contract
    return_args["inputs"] = inputs
    return_args["type"] = Command.INVOKE


@warp.command()
@click.option("--address", required=True, type=click.Path(exists=True))
@click.option("--abi", required=True, type=click.Path(exists=True))
@click.option("--function", required=True, type=click.Path(exists=True))
def call(address, abi, function):
    _call(address, abi, function)


cli = click.CommandCollection(sources=[warp])


async def test():
    await asyncio.sleep(1)
    print("DONE!")


def main():
    try:
        warp()
    except:
        if return_args != {}:
            if return_args["type"] is Command.INVOKE:
                asyncio.run(
                    _invoke(
                        return_args["contract"],
                        return_args["address"],
                        return_args["abi"],
                        return_args["function"],
                        return_args["inputs"],
                    )
                )
