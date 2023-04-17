"""
Postman routes.
"""

import json

from flask import Blueprint, jsonify, request
from starkware.starknet.business_logic.transaction.objects import InternalL1Handler
from starkware.starknet.definitions.error_codes import StarknetErrorCode
from starkware.starkware_utils.error_handling import StarkErrorCode

from starknet_devnet.blueprints.base import hex_converter
from starknet_devnet.blueprints.rpc.utils import rpc_felt
from starknet_devnet.state import state
from starknet_devnet.util import StarknetDevnetException, to_int_array

postman = Blueprint("postman", __name__, url_prefix="/postman")


def validate_load_messaging_contract(request_dict: dict):
    """Ensure `data` is valid Starknet function call. Returns an `InvokeFunction`."""

    network_url = request_dict.get("networkUrl")
    if network_url is None:
        error_message = "L1 network or StarknetMessaging contract address not specified"
        raise StarknetDevnetException(
            code=StarkErrorCode.MALFORMED_REQUEST,
            message=error_message,
            status_code=400,
        )

    return network_url


@postman.route("/load_l1_messaging_contract", methods=["POST"])
async def load_l1_messaging_contract():
    """
    Loads a MockStarknetMessaging contract. If one is already deployed in the L1 network specified by the networkUrl argument,
    in the address specified in the address argument in the POST body, it is used, otherwise a new one will be deployed.
    The networkId argument is used to check if a local testnet instance or a public testnet should be used.
    """

    request_dict = json.loads(request.data.decode("utf-8"))
    network_url = validate_load_messaging_contract(request_dict)
    contract_address = request_dict.get("address")
    network_id = request_dict.get("networkId")

    result_dict = await state.starknet_wrapper.load_messaging_contract_in_l1(
        network_url, contract_address, network_id
    )
    return jsonify(result_dict)


@postman.route("/flush", methods=["POST"])
async def flush():
    """
    Handles all pending L1 <> L2 messages and sends them to the other layer
    """

    result_dict = await state.starknet_wrapper.postman_flush()
    return jsonify(result_dict)


@postman.route("/send_message_to_l2", methods=["POST"])
async def send_message_to_l2():
    """L1 to L2 message mock endpoint"""
    request_json = request.json or {}

    # Generate transactions
    transaction = InternalL1Handler.create(
        contract_address=hex_converter(request_json, "l2_contract_address"),
        entry_point_selector=hex_converter(request_json, "entry_point_selector"),
        calldata=[
            hex_converter(request_json, "l1_contract_address"),
            *hex_converter(request_json, "payload", to_int_array),
        ],
        nonce=hex_converter(request_json, "nonce"),
        chain_id=state.starknet_wrapper.get_state().general_config.chain_id.value,
    )

    result = await state.starknet_wrapper.mock_message_to_l2(transaction)
    return jsonify({"transaction_hash": rpc_felt(result)})


@postman.route("/consume_message_from_l2", methods=["POST"])
async def consume_message_from_l2():
    """L2 to L1 message mock endpoint"""
    request_json = request.json or {}

    from_address = hex_converter(request_json, "l2_contract_address")
    to_address = hex_converter(request_json, "l1_contract_address")
    payload = hex_converter(request_json, "payload", to_int_array)

    try:
        result = await state.starknet_wrapper.consume_message_from_l2(
            from_address, to_address, payload
        )
        return jsonify({"message_hash": result})
    except AssertionError as err:
        raise StarknetDevnetException(
            code=StarknetErrorCode.L1_TO_L2_MESSAGE_ZEROED_COUNTER,
            message="Message is fully consumed or does not exist.",
            status_code=500,
        ) from err
