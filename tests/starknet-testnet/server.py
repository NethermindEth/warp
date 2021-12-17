import json
import os

from flask import Flask, jsonify, request
from flask_cors import CORS
from starknet_wrapper import StarknetWrapper

app = Flask(__name__)
CORS(app)

starknet_wrapper = StarknetWrapper()
warp_root = os.path.abspath(os.path.join(__file__, "../../.."))
cairo_contracts_path = os.path.abspath(
    os.path.join(warp_root, "tests", "hardhat", "contracts", "cairo")
)
warp_cairo_libs = os.path.abspath(os.path.join(warp_root, "warp", "cairo-src"))
cairo_artifcats = os.path.abspath(
    os.path.join(warp_root, "tests", "hardhat", "artifacts", "cairo")
)


@app.route("/gateway/add_transaction", methods=["POST"])
async def add_transaction():
    """
    Endpoint for accepting DEPLOY and INVOKE_FUNCTION transactions.
    """
    data = request.get_json()
    prog_info_path = os.path.join(cairo_artifcats, data["program_info"])
    with open(prog_info_path) as f:
        program_info = json.load(f)
    state = await starknet_wrapper.get_state()
    if data["tx_type"] == "deploy":
        from starkware.starknet.compiler.compile import compile_starknet_files
        from starkware.starknet.services.api.contract_definition import (
            ContractDefinition,
        )
        from yul.starknet_utils import deploy_contract

        input = data["constructor_input"]
        contract_def: ContractDefinition = compile_starknet_files(
            [os.path.join(cairo_contracts_path, data["cairo_contract"])],
            debug_info=False,
            disable_hint_validation=True,
            cairo_path=[warp_cairo_libs],
        )
        contract_address: int = await deploy_contract(
            state, program_info, contract_def, *input
        )
        starknet_wrapper.address2contract_wrapper[hex(contract_address)] = contract_def
        return jsonify({"contract_address": hex(contract_address)})
    else:
        from yul.starknet_utils import invoke_method

        input = [int(x) for x in data["input"]]
        res = await invoke_method(
            state, program_info, data["address"], data["function"], *input
        )
        return jsonify({"return_data": res.retdata})


def main():
    from util import parse_args

    # reduce startup logging
    os.environ["WERKZEUG_RUN_MAIN"] = "true"

    args = parse_args()
    app.run(**vars(args))


if __name__ == "__main__":
    main()
