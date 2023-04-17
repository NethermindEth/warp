"""
RPC response structures
"""

from typing import List, TypedDict

from starkware.starknet.definitions.transaction_type import TransactionType
from starkware.starknet.services.api.feeder_gateway.response_objects import (
    TransactionReceipt,
    TransactionStatus,
)

from starknet_devnet.blueprints.rpc.structures.types import (
    Address,
    BlockHash,
    BlockNumber,
    Felt,
    RpcTxnType,
    TxnHash,
    TxnStatus,
    rpc_txn_type,
)
from starknet_devnet.blueprints.rpc.utils import rpc_felt
from starknet_devnet.state import state


class RpcInvokeTransactionResult(TypedDict):
    """TypedDict for rpc invoke transaction result"""

    transaction_hash: TxnHash


class RpcDeclareTransactionResult(TypedDict):
    """TypedDict for rpc declare transaction result"""

    transaction_hash: TxnHash
    class_hash: Felt


class RpcDeployTransactionResult(TypedDict):
    """TypedDict for rpc deploy transaction result"""

    transaction_hash: TxnHash
    contract_address: Felt


class RpcDeployAccountTransactionResult(TypedDict):
    """TypedDict for rpc deploy account transaction result"""

    transaction_hash: TxnHash
    contract_address: Felt


class MessageToL1(TypedDict):
    """TypedDict for rpc message from l2 to l1"""

    to_address: Felt
    payload: List[Felt]


class Event(TypedDict):
    """TypedDict for rpc event"""

    from_address: Address
    keys: List[Felt]
    data: List[Felt]


class RpcEventsResult(TypedDict):
    """
    TypedDict for rpc get events result
    """

    events: List[Event]
    continuation_token: str


class RpcBaseTransactionReceipt(TypedDict):
    """TypedDict for rpc transaction receipt"""

    transaction_hash: TxnHash
    actual_fee: Felt
    status: TxnStatus
    block_hash: BlockHash
    block_number: BlockNumber
    type: RpcTxnType
    messages_sent: List[MessageToL1]
    events: List[Event]


RpcInvokeReceipt = RpcBaseTransactionReceipt
RpcDeclareReceipt = RpcBaseTransactionReceipt
RpcL1HandlerReceipt = RpcBaseTransactionReceipt


class RpcDeployReceipt(RpcBaseTransactionReceipt):
    """TypedDict for rpc deploy transaction receipt"""

    contract_address: Felt


class RpcDeployAccountReceipt(RpcBaseTransactionReceipt):
    """TypedDict for rpc deploy account transaction receipt"""

    contract_address: Felt


async def rpc_invoke_receipt(txr: TransactionReceipt) -> RpcInvokeReceipt:
    """
    Convert gateway invoke transaction receipt to rpc format
    """
    return await rpc_base_transaction_receipt(txr)


async def rpc_declare_receipt(txr: TransactionReceipt) -> RpcDeclareReceipt:
    """
    Convert gateway declare transaction receipt to rpc format
    """
    return await rpc_base_transaction_receipt(txr)


async def rpc_deploy_receipt(txr: TransactionReceipt) -> RpcDeployReceipt:
    """
    Convert gateway deploy transaction receipt to rpc format
    """
    base_receipt = await rpc_base_transaction_receipt(txr)
    transaction = await state.starknet_wrapper.transactions.get_transaction(
        hex(txr.transaction_hash)
    )

    receipt: RpcDeployReceipt = {
        "contract_address": rpc_felt(transaction.transaction.contract_address),
        **base_receipt,
    }
    return receipt


async def rpc_deploy_account_receipt(
    txr: TransactionReceipt,
) -> RpcDeployAccountReceipt:
    """
    Convert gateway deploy account transaction receipt to rpc format
    """
    return await rpc_deploy_receipt(txr)


async def rpc_l1_handler_receipt(txr: TransactionReceipt) -> RpcL1HandlerReceipt:
    """
    Convert gateway l1 handler transaction receipt to rpc format
    """
    return await rpc_base_transaction_receipt(txr)


async def rpc_base_transaction_receipt(txr: TransactionReceipt) -> dict:
    """
    Convert gateway transaction receipt to rpc base transaction receipt
    """

    def messages_sent() -> List[MessageToL1]:
        return [
            {
                "to_address": rpc_felt(message.to_address),
                "payload": [rpc_felt(p) for p in message.payload],
            }
            for message in txr.l2_to_l1_messages
        ]

    def events() -> List[Event]:
        _events = []
        for event in txr.events:
            event: Event = {
                "from_address": rpc_felt(event.from_address),
                "keys": [rpc_felt(e) for e in event.keys],
                "data": [rpc_felt(d) for d in event.data],
            }
            _events.append(event)
        return _events

    def status() -> str:
        if txr.status is None:
            return "UNKNOWN"

        mapping = {
            TransactionStatus.NOT_RECEIVED: "UNKNOWN",
            TransactionStatus.ACCEPTED_ON_L2: "ACCEPTED_ON_L2",
            TransactionStatus.ACCEPTED_ON_L1: "ACCEPTED_ON_L1",
            TransactionStatus.RECEIVED: "RECEIVED",
            TransactionStatus.PENDING: "PENDING",
            TransactionStatus.REJECTED: "REJECTED",
        }
        return mapping[txr.status]

    async def txn_type() -> RpcTxnType:
        transaction = await state.starknet_wrapper.transactions.get_transaction(
            hex(txr.transaction_hash)
        )
        return rpc_txn_type(transaction.transaction.tx_type.name)

    receipt: RpcBaseTransactionReceipt = {
        "transaction_hash": rpc_felt(txr.transaction_hash),
        "actual_fee": rpc_felt(txr.actual_fee or 0),
        "status": status(),
        "block_hash": rpc_felt(txr.block_hash) if txr.block_hash is not None else None,
        "block_number": txr.block_number or None,
        "messages_sent": messages_sent(),
        "events": events(),
        "type": await txn_type(),
    }
    return receipt


async def rpc_transaction_receipt(txr: TransactionReceipt) -> dict:
    """
    Convert gateway transaction receipt to rpc format
    """
    tx_mapping = {
        TransactionType.DEPLOY: rpc_deploy_receipt,
        TransactionType.INVOKE_FUNCTION: rpc_invoke_receipt,
        TransactionType.DECLARE: rpc_declare_receipt,
        TransactionType.L1_HANDLER: rpc_l1_handler_receipt,
        TransactionType.DEPLOY_ACCOUNT: rpc_deploy_account_receipt,
    }
    transaction = await state.starknet_wrapper.transactions.get_transaction(
        hex(txr.transaction_hash)
    )
    tx_type = transaction.transaction.tx_type
    return await tx_mapping[tx_type](txr)
