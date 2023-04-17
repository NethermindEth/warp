"""
RPC base route
API Specification v0.1.0
https://github.com/starkware-libs/starknet-specs/releases/tag/v0.1.0
"""

from __future__ import annotations

import inspect
from typing import Callable, Dict, List, Tuple, Union

from flask import Blueprint, request

from starknet_devnet.blueprints.rpc.blocks import (
    block_hash_and_number,
    block_number,
    get_block_transaction_count,
    get_block_with_tx_hashes,
    get_block_with_txs,
)
from starknet_devnet.blueprints.rpc.call import call
from starknet_devnet.blueprints.rpc.classes import (
    get_class,
    get_class_at,
    get_class_hash_at,
)
from starknet_devnet.blueprints.rpc.misc import chain_id, get_events, get_nonce, syncing
from starknet_devnet.blueprints.rpc.state import get_state_update
from starknet_devnet.blueprints.rpc.storage import get_storage_at
from starknet_devnet.blueprints.rpc.structures.types import RpcError, RpcErrorCode
from starknet_devnet.blueprints.rpc.transactions import (
    add_declare_transaction,
    add_deploy_account_transaction,
    add_deploy_transaction,
    add_invoke_transaction,
    estimate_fee,
    get_transaction_by_block_id_and_index,
    get_transaction_by_hash,
    get_transaction_receipt,
    pending_transactions,
)
from starknet_devnet.blueprints.rpc.utils import rpc_error, rpc_response

methods = {
    "getBlockWithTxHashes": get_block_with_tx_hashes,
    "getBlockWithTxs": get_block_with_txs,
    "getStateUpdate": get_state_update,
    "getStorageAt": get_storage_at,
    "getTransactionByHash": get_transaction_by_hash,
    "getTransactionByBlockIdAndIndex": get_transaction_by_block_id_and_index,
    "getTransactionReceipt": get_transaction_receipt,
    "getClass": get_class,
    "getClassHashAt": get_class_hash_at,
    "getClassAt": get_class_at,
    "getBlockTransactionCount": get_block_transaction_count,
    "call": call,
    "estimateFee": estimate_fee,
    "blockNumber": block_number,
    "blockHashAndNumber": block_hash_and_number,
    "chainId": chain_id,
    "pendingTransactions": pending_transactions,
    "syncing": syncing,
    "getEvents": get_events,
    "getNonce": get_nonce,
    "addInvokeTransaction": add_invoke_transaction,
    "addDeclareTransaction": add_declare_transaction,
    "addDeployTransaction": add_deploy_transaction,
    "addDeployAccountTransaction": add_deploy_account_transaction,
}

rpc = Blueprint("rpc", __name__, url_prefix="/rpc")


@rpc.route("", methods=["POST"])
async def base_route():
    """
    Base route for RPC calls
    """

    message_id = None
    try:
        method, params, message_id = parse_body(request.json)
        result = await (
            method(*params) if isinstance(params, list) else method(**params)
        )
        if inspect.iscoroutinefunction(result):
            result = await result
    except TypeError as type_error:
        return rpc_error(message_id=message_id, code=22, message=str(type_error))
    except RpcError as error:
        return rpc_error(message_id=message_id, code=error.code, message=error.message)

    return rpc_response(message_id=message_id, content=result)


def parse_body(body: dict) -> Tuple[Callable, Union[List, dict], int]:
    """
    Parse rpc call body to function name, params and message id
    """
    try:
        method_name = body["method"].replace("starknet_", "")
        params: Union[List, dict] = body.get("params") or {}
        message_id = body["id"]
    except RuntimeError as error:
        raise RpcError(
            code=RpcErrorCode.INVALID_REQUEST.value, message="Invalid request"
        ) from error

    if method_name not in methods:
        raise RpcError(
            code=RpcErrorCode.METHOD_NOT_FOUND.value, message="Method not found"
        )

    if not isinstance(params, (List, Dict)):
        raise RpcError(code=RpcErrorCode.INVALID_PARAMS.value, message="Invalid params")

    return methods[method_name], params, message_id
