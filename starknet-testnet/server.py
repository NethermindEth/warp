import os
import sys
from generateMarkdown import (
    builtin_instance_count,
    steps_in_function_deploy,
    steps_in_function_invoke,
)

from flask import Flask, jsonify, request
from flask_cors import CORS
from starknet_wrapper import StarknetWrapper

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
    from starkware.starknet.services.api.contract_definition import (
        ContractDefinition,
    )

    data = request.get_json()
    state = await starknet_wrapper.get_state()
    input = [int(x) for x in data["input"]]
    compiled_cairo = open(data["compiled_cairo"]).read()
    contract_def: ContractDefinition = ContractDefinition.loads(compiled_cairo)

    [contract_address, execution_info] = await state.deploy(contract_def, input)
    print("-----Deploy info-----")
    print(execution_info)
    print("----------\n")
    starknet_wrapper.address2contract[hex(contract_address)] = contract_def
    print(BENCHMARK, '==========================================')
    if BENCHMARK:
        steps_in_function_deploy(data["compiled_cairo"], execution_info)
        builtin_instance_count(data["compiled_cairo"], execution_info)
    return jsonify(
        {
            "contract_address": hex(contract_address),
            "execution_info": {
                "steps": execution_info.call_info.execution_resources.n_steps
            },
        }
    )


@app.route("/invoke", methods=["POST"])
async def invoke():
    from starkware.starkware_utils.error_handling import StarkException
    from starkware.starknet.definitions.error_codes import StarknetErrorCode

    data = request.get_json()
    state = await starknet_wrapper.get_state()

    try:
        execution_info = await state.invoke_raw(
            contract_address=data["address"],
            selector=data["function"],
            calldata=[int(x) for x in data["input"]],
            caller_address=int(data["caller_address"], 0),
            max_fee=0,
        )
        print("-----Invoke info-----")
        print(execution_info)
        print("----------\n")
        if BENCHMARK:
            steps_in_function_invoke(data["function"], execution_info)

        # Can add extra fields in here if and when tests need them
        return jsonify(
            {
                "execution_info": {
                    "steps": execution_info.call_info.execution_resources.n_steps
                },
                "transaction_info": {
                    "threw": False,
                    "return_data": [str(x) for x in execution_info.call_info.retdata],
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


def main():
    from util import parse_args

    args = parse_args()

    print(vars(args))

    app.run(**vars(args))


if __name__ == "__main__":
    if "benchmark" in sys.argv:
        BENCHMARK = True
        os.makedirs(os.path.join(os.getcwd(), "benchmark/json"), exist_ok=True)
        os.makedirs(os.path.join(os.getcwd(), "benchmark/stats"), exist_ok=True)
    main()
