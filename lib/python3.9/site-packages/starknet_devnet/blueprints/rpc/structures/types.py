"""
RPC types
"""

from enum import Enum
from typing import List, Union

from starkware.starknet.definitions.transaction_type import TransactionType
from starkware.starknet.services.api.feeder_gateway.response_objects import BlockStatus
from typing_extensions import Literal, TypedDict

Felt = str

BlockHash = Felt
BlockNumber = int
BlockTag = Literal["latest", "pending"]

Signature = List[Felt]


class BlockHashDict(TypedDict):
    """TypedDict class for BlockId with block hash"""

    block_hash: BlockHash


class BlockNumberDict(TypedDict):
    """TypedDict class for BlockId with block number"""

    block_number: BlockNumber


BlockId = Union[BlockHashDict, BlockNumberDict, BlockTag]

TxnStatus = Literal["PENDING", "ACCEPTED_ON_L2", "ACCEPTED_ON_L1", "REJECTED"]

RpcBlockStatus = Literal["PENDING", "ACCEPTED_ON_L2", "ACCEPTED_ON_L1", "REJECTED"]


def rpc_block_status(block_status: str) -> RpcBlockStatus:
    """
    Convert gateway BlockStatus to RpcBlockStatus
    """
    block_status_map = {
        BlockStatus.PENDING.name: "PENDING",
        BlockStatus.ABORTED.name: "REJECTED",
        BlockStatus.REVERTED.name: "REJECTED",
        BlockStatus.ACCEPTED_ON_L2.name: "ACCEPTED_ON_L2",
        BlockStatus.ACCEPTED_ON_L1.name: "ACCEPTED_ON_L1",
    }
    return block_status_map[block_status]


TxnHash = Felt
Address = Felt
NumAsHex = str

RpcTxnType = Literal["DECLARE", "DEPLOY", "INVOKE", "L1_HANDLER", "DEPLOY_ACCOUNT"]


def rpc_txn_type(transaction_type: str) -> RpcTxnType:
    """
    Convert gateway TransactionType name to RPCTxnType
    """
    txn_type_map = {
        TransactionType.DEPLOY.name: "DEPLOY",
        TransactionType.DECLARE.name: "DECLARE",
        TransactionType.INVOKE_FUNCTION.name: "INVOKE",
        TransactionType.L1_HANDLER.name: "L1_HANDLER",
        TransactionType.DEPLOY_ACCOUNT.name: "DEPLOY_ACCOUNT",
    }
    if transaction_type not in txn_type_map:
        raise RpcError(
            code=-1,
            message=f"Current implementation does not support {transaction_type} transaction type",
        )
    return txn_type_map[transaction_type]


class RpcError(Exception):
    """
    Error message returned by rpc
    """

    def __init__(self, code, message):
        super().__init__(message)
        self.code = code
        self.message = message


class RpcErrorCode(Enum):
    """
    Constants used in JSON-RPC protocol
    https://www.jsonrpc.org/specification
    """

    INVALID_REQUEST = -32600
    METHOD_NOT_FOUND = -32601
    INVALID_PARAMS = -32602
    INTERNAL_ERROR = -32603
