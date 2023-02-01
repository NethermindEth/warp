import os
import sys

from starkware.starknet.services.api.contract_class import ContractClass
from generateMarkdown import (
    builtin_instance_count,
    json_size_count,
    steps_in_function_deploy,
    steps_in_function_invoke,
    contract_name_map,
)

from flask import Flask, jsonify, request
from flask_cors import CORS
from starknet_wrapper import StarknetWrapper
from starkware.starkware_utils.error_handling import StarkException
from starkware.starknet.definitions.error_codes import StarknetErrorCode

app = Flask(__name__)
CORS(app)
BENCHMARK = False

starknet_wrapper = StarknetWrapper()


@app.route("/ping", methods=["GET"])
def ping():
    return jsonify({"return_data": "pong"})


@app.route("/pingpost", methods=["POST"])
async def pingpost():
    return jsonify({"return_data": "pong"})


@app.route("/deploy", methods=["POST"])
async def deploy():
    data = request.get_json()
    state = await starknet_wrapper.get_state()
    input = [int(x) for x in data["input"]]
    compiled_cairo = open(data["compiled_cairo"]).read()
    contract_def: ContractClass = ContractClass.loads(compiled_cairo)

    try:
        [contract_address, execution_info] = await state.deploy(contract_def, input)
        print("-----Deploy info-----")
        print(execution_info)
        print("----------\n")
        starknet_wrapper.address2contract[hex(contract_address)] = contract_def
        if BENCHMARK:
            steps_in_function_deploy(data["compiled_cairo"], execution_info)
            builtin_instance_count(data["compiled_cairo"], execution_info)
            json_size_count(data["compiled_cairo"])
            contract_name_map[contract_address] = data["compiled_cairo"]
        return jsonify(
            {
                "class_hash": hex(
                    int.from_bytes(execution_info.call_info.class_hash, "big")
                ),
                "contract_address": hex(contract_address),
                "execution_info": {
                    "steps": execution_info.call_info.execution_resources.n_steps
                },
                "transaction_info": {
                    "threw": False,
                },
            }
        )
    except StarkException as err:
        print(err)
        if err.code == StarknetErrorCode.TRANSACTION_FAILED:
            return jsonify(
                {"transaction_info": {"threw": True, "message": err.message}}
            )
        else:
            raise err


@app.route("/declare", methods=["POST"])
async def declare():
    data = request.get_json()
    assert data is not None, "Requested data is `None` when trying to declare"

    state = await starknet_wrapper.get_state()
    compiled_cairo = open(data["compiled_cairo"]).read()
    contract_class = ContractClass.loads(compiled_cairo)

    try:
        class_hash, execution_info = await state.declare(contract_class)
        print("-----Declare info-----")
        print(execution_info)
        print("-----------\n")
        # BENCHMARK needed here?
        assert class_hash is not None
        return jsonify(
            {
                "class_hash": hex(int.from_bytes(class_hash, "big")),
                "transaction_info": {"threw": False},
            }
        )
    except StarkException as err:
        print(err)
        if err.code == StarknetErrorCode.TRANSACTION_FAILED:
            return jsonify(
                {"transaction_info": {"threw": True, "message": err.message}}
            )
        else:
            raise err


@app.route("/invoke", methods=["POST"])
async def invoke():
    data = request.get_json()
    state = await starknet_wrapper.get_state()

    try:
        execution_info = await state.execute_entry_point_raw(
            contract_address=data["address"],
            selector=data["function"],
            calldata=[int(x) for x in data["input"]],
            caller_address=int(data["caller_address"], 0),
        )
        print("-----Invoke info-----")
        print(execution_info)
        print("----------\n")
        if BENCHMARK:
            steps_in_function_invoke(data["function"], execution_info)

        # Can add extra fields in here if and when tests need them
        return jsonify(
            {
                "execution_info": {"steps": execution_info.execution_resources.n_steps},
                "transaction_info": {
                    "threw": False,
                    "return_data": [str(x) for x in execution_info.retdata],
                },
                "events": [
                    {
                        "order": event.order,
                        "keys": [str(x) for x in event.keys],
                        "data": [str(x) for x in event.data],
                    }
                    for event in execution_info.events
                ],
            }
        )
    except StarkException as err:
        print(err)
        if (
            err.code == StarknetErrorCode.TRANSACTION_FAILED
            or err.code == StarknetErrorCode.OUT_OF_RESOURCES
        ):
            return jsonify(
                {"transaction_info": {"threw": True, "message": err.message}}
            )
        else:
            raise err


def main():
    from util import parse_args

    args = parse_args()

    print(vars(args))

    app.run(**vars(args))


if __name__ == "__main__":
    if len(sys.argv) >= 2 and sys.argv[1] == "benchmark":
        BENCHMARK = True
        os.makedirs(os.path.join(os.getcwd(), "benchmark/json"), exist_ok=True)
        os.makedirs(os.path.join(os.getcwd(), "benchmark/stats"), exist_ok=True)
    main()
