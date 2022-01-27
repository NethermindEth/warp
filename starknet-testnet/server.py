import json
import os

from flask import Flask, jsonify, request
from flask_cors import CORS
from starknet_wrapper import StarknetWrapper

app = Flask(__name__)
CORS(app)

starknet_wrapper = StarknetWrapper()


@app.route("/ping", methods=["GET"])
def ping():
    return jsonify({"return_data": "pong"})


@app.route("/pingpost", methods=["POST"])
async def pingpost():
    return jsonify({"return_data": "pong"})


@app.route("/deploy", methods=["POST"])
async def deploy():
    from starkware.starknet.services.api.contract_definition import (
        ContractDefinition,
    )
    from starknet_utils import deploy_contract

    data = request.get_json()
    state = await starknet_wrapper.get_state()
    # input = data["input"]
    compiled_cairo = open(data["compiled_cairo"]).read()
    contract_def: ContractDefinition = ContractDefinition.loads(compiled_cairo)

    # TODO Include input
    [contract_address, execution_info] = await state.deploy(contract_def, [])
    print("-----Deploy info-----")
    print(execution_info)
    print("----------\n")
    starknet_wrapper.address2contract[hex(contract_address)] = contract_def
    return jsonify({"contract_address": hex(contract_address)})


@app.route("/invoke", methods=["POST"])
async def invoke():
    data = request.get_json()
    state = await starknet_wrapper.get_state()

    res = await state.invoke_raw(
        contract_address=data["address"],
        selector=data["function"],
        calldata=data["input"],
        caller_address=0,
    )
    # Can add extra fields in here if and when tests need them
    return jsonify({"transaction_info": {"return_data": res.retdata}})


def main():
    from util import parse_args

    # reduce startup logging
    os.environ["WERKZEUG_RUN_MAIN"] = "true"

    args = parse_args()
    app.run(**vars(args))


if __name__ == "__main__":
    main()
