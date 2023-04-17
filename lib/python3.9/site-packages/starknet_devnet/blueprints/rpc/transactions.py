"""
RPC transaction endpoints
"""

from typing import List

from starkware.starknet.services.api.feeder_gateway.response_objects import (
    TransactionStatus,
)
from starkware.starknet.services.api.gateway.transaction import AccountTransaction
from starkware.starkware_utils.error_handling import StarkException

from starknet_devnet.blueprints.rpc.structures.payloads import (
    RpcBroadcastedDeclareTxn,
    RpcBroadcastedDeployAccountTxn,
    RpcBroadcastedDeployTxn,
    RpcBroadcastedInvokeTxn,
    RpcBroadcastedTxn,
    RpcTransaction,
    make_declare,
    make_deploy,
    make_deploy_account,
    make_invoke_function,
    rpc_fee_estimate,
    rpc_transaction,
)
from starknet_devnet.blueprints.rpc.structures.responses import (
    RpcDeclareTransactionResult,
    RpcDeployAccountTransactionResult,
    RpcDeployTransactionResult,
    RpcInvokeTransactionResult,
    rpc_transaction_receipt,
)
from starknet_devnet.blueprints.rpc.structures.types import BlockId, RpcError, TxnHash
from starknet_devnet.blueprints.rpc.utils import (
    assert_block_id_is_latest_or_pending,
    get_block_by_block_id,
    rpc_felt,
)
from starknet_devnet.state import state
from starknet_devnet.util import StarknetDevnetException


async def get_transaction_by_hash(transaction_hash: TxnHash) -> dict:
    """
    Get the details and status of a submitted transaction
    """
    try:
        result = await state.starknet_wrapper.transactions.get_transaction(
            transaction_hash
        )
    except StarknetDevnetException as ex:
        raise RpcError(code=25, message="Transaction hash not found") from ex

    if result.status == TransactionStatus.NOT_RECEIVED:
        raise RpcError(code=25, message="Transaction hash not found")

    return rpc_transaction(result.transaction)


async def get_transaction_by_block_id_and_index(block_id: BlockId, index: int) -> dict:
    """
    Get the details of a transaction by a given block id and index
    """
    block = await get_block_by_block_id(block_id)

    try:
        transaction_hash: int = block.transactions[index].transaction_hash
    except IndexError as ex:
        raise RpcError(code=27, message="Invalid transaction index in a block") from ex

    return await get_transaction_by_hash(transaction_hash=rpc_felt(transaction_hash))


async def get_transaction_receipt(transaction_hash: TxnHash) -> dict:
    """
    Get the transaction receipt by the transaction hash
    """
    try:
        result = await state.starknet_wrapper.transactions.get_transaction_receipt(
            tx_hash=transaction_hash
        )
    except StarknetDevnetException as ex:
        raise RpcError(code=25, message="Transaction hash not found") from ex

    if result.status == TransactionStatus.NOT_RECEIVED:
        raise RpcError(code=25, message="Transaction hash not found")

    return await rpc_transaction_receipt(result)


async def pending_transactions() -> List[RpcTransaction]:
    """
    Returns the transactions in the transaction pool, recognized by this sequencer
    """
    raise NotImplementedError()


async def add_invoke_transaction(invoke_transaction: RpcBroadcastedInvokeTxn) -> dict:
    """
    Submit a new transaction to be added to the chain
    """
    invoke_function = make_invoke_function(invoke_transaction)

    _, transaction_hash = await state.starknet_wrapper.invoke(
        external_tx=invoke_function
    )
    return RpcInvokeTransactionResult(
        transaction_hash=rpc_felt(transaction_hash),
    )


async def add_declare_transaction(
    declare_transaction: RpcBroadcastedDeclareTxn,
) -> dict:
    """
    Submit a new class declaration transaction
    """
    declare_transaction = make_declare(declare_transaction)

    class_hash, transaction_hash = await state.starknet_wrapper.declare(
        external_tx=declare_transaction
    )
    return RpcDeclareTransactionResult(
        transaction_hash=rpc_felt(transaction_hash),
        class_hash=rpc_felt(class_hash),
    )


async def add_deploy_transaction(deploy_transaction: RpcBroadcastedDeployTxn) -> dict:
    """
    Submit a new deploy contract transaction
    """
    deploy_transaction = make_deploy(deploy_transaction)

    contract_address, transaction_hash = await state.starknet_wrapper.deploy(
        deploy_transaction=deploy_transaction
    )
    return RpcDeployTransactionResult(
        transaction_hash=rpc_felt(transaction_hash),
        contract_address=rpc_felt(contract_address),
    )


async def add_deploy_account_transaction(
    deploy_account_transaction: RpcBroadcastedDeployAccountTxn,
) -> dict:
    """
    Submit a new deploy account transaction
    """
    deploy_account_tx = make_deploy_account(deploy_account_transaction)

    contract_address, transaction_hash = await state.starknet_wrapper.deploy_account(
        external_tx=deploy_account_tx
    )

    status_response = await state.starknet_wrapper.transactions.get_transaction_status(
        hex(transaction_hash)
    )
    if (
        status_response["tx_status"] == "REJECTED"
        and "is not declared" in status_response["tx_failure_reason"].error_message
    ):
        raise RpcError(code=28, message="Class hash not found")

    return RpcDeployAccountTransactionResult(
        transaction_hash=rpc_felt(transaction_hash),
        contract_address=rpc_felt(contract_address),
    )


def make_transaction(txn: RpcBroadcastedTxn) -> AccountTransaction:
    """
    Convert RpcBroadcastedTxn to AccountTransaction
    """
    txn_type = txn["type"]
    if txn_type == "INVOKE":
        return make_invoke_function(txn)
    if txn_type == "DECLARE":
        return make_declare(txn)
    if txn_type == "DEPLOY":
        return make_deploy(txn)
    if txn_type == "DEPLOY_ACCOUNT":
        return make_deploy_account(txn)
    raise NotImplementedError(f"Unexpected type {txn_type}.")


async def estimate_fee(request: RpcBroadcastedTxn, block_id: BlockId) -> dict:
    """
    Estimate the fee for a given StarkNet transaction
    """
    await assert_block_id_is_latest_or_pending(block_id)
    transaction = make_transaction(request)
    try:
        _, fee_response = await state.starknet_wrapper.calculate_trace_and_fee(
            transaction
        )
    except StarkException as ex:
        if "entry_point_selector" in request and (
            f"Entry point {hex(int(request['entry_point_selector'], 16))} not found"
            in ex.message
        ):
            raise RpcError(code=21, message="Invalid message selector") from ex
        if "While handling calldata" in ex.message:
            raise RpcError(code=22, message="Invalid call data") from ex
        if "is not deployed" in ex.message:
            raise RpcError(code=20, message="Contract not found") from ex
        raise RpcError(code=-1, message=ex.message) from ex

    return rpc_fee_estimate(fee_response)
