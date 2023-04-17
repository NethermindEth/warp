"""
Classes for storing and handling transactions.
"""

from typing import Dict, List

from services.everest.business_logic.transaction_execution_objects import (
    TransactionFailureReason,
)
from starkware.starknet.business_logic.transaction.objects import InternalTransaction
from starkware.starknet.definitions.error_codes import StarknetErrorCode
from starkware.starknet.services.api.feeder_gateway.response_objects import (
    Event,
    FunctionInvocation,
    L2ToL1Message,
    StarknetBlock,
    TransactionExecution,
    TransactionInfo,
    TransactionReceipt,
    TransactionStatus,
    TransactionTrace,
)
from starkware.starknet.testing.starknet import (
    StarknetCallInfo,
    TransactionExecutionInfo,
)
from web3 import Web3

from .origin import Origin
from .util import StarknetDevnetException


# pylint: disable=too-many-instance-attributes
class DevnetTransaction:
    """Represents the devnet transaction"""

    def __init__(
        self,
        internal_tx: InternalTransaction,
        status: TransactionStatus,
        execution_info: TransactionExecutionInfo,
        transaction_hash: int = None,
    ):
        self.block = None
        self.execution_info = execution_info
        if status != TransactionStatus.REJECTED and execution_info.call_info:
            self.execution_resources = execution_info.call_info.execution_resources
        else:
            self.execution_resources = None
        self.internal_tx = internal_tx
        self.status = status
        self.transaction_failure_reason = None
        self.transaction_index = 0
        self.transaction_hash = transaction_hash

        if transaction_hash is None:
            self.transaction_hash = internal_tx.hash_value

    def __get_actual_fee(self) -> int:
        """Returns the actual fee"""
        return (
            self.execution_info.actual_fee
            if hasattr(self.execution_info, "actual_fee")
            else 0
        )

    def __get_events(self) -> List[Event]:
        """Returns the events"""
        if isinstance(self.execution_info, StarknetCallInfo):
            return self.execution_info.raw_events

        return self.execution_info.get_sorted_events()

    def __get_l2_to_l1_messages(self) -> List[L2ToL1Message]:
        """Returns the l2 to l1 messages"""
        l2_to_l1_messages = []

        if not hasattr(self.execution_info.call_info, "l2_to_l1_messages"):
            return l2_to_l1_messages

        contract_address = self.execution_info.call_info.contract_address

        for l2_to_l1_message in self.execution_info.get_sorted_l2_to_l1_messages():
            l2_to_l1_messages.append(
                L2ToL1Message(
                    from_address=contract_address,
                    to_address=Web3.toChecksumAddress(hex(l2_to_l1_message.to_address)),
                    payload=l2_to_l1_message.payload,
                )
            )

        return l2_to_l1_messages

    def __get_block_hash(self) -> int:
        """Returns the block hash"""
        return self.block.block_hash if self.block else None

    def __get_block_number(self) -> int:
        """Returns the block number"""
        return self.block.block_number if self.block else None

    def set_block(self, block: StarknetBlock):
        """Sets the block hash and number of the transaction"""
        self.block = block

    def set_failure_reason(self, error_message: str):
        """Sets the failure reason of the transaction"""
        self.transaction_failure_reason = TransactionFailureReason(
            code=StarknetErrorCode.TRANSACTION_FAILED.name, error_message=error_message
        )

    def get_signature(self) -> List[int]:
        """Returns the signature"""
        return (
            self.internal_tx.signature if hasattr(self.internal_tx, "signature") else []
        )

    def get_tx_info(self) -> TransactionInfo:
        """Returns the transaction info"""
        return TransactionInfo.create(
            status=self.status,
            transaction=self.internal_tx,
            transaction_index=self.transaction_index,
            block_hash=self.__get_block_hash(),
            block_number=self.__get_block_number(),
            transaction_failure_reason=self.transaction_failure_reason,
        )

    def get_receipt(self) -> TransactionReceipt:
        """Returns the transaction receipt"""
        tx_info = self.get_tx_info()

        return TransactionReceipt.from_tx_info(
            transaction_hash=self.transaction_hash,
            tx_info=tx_info,
            actual_fee=self.__get_actual_fee(),
            events=self.__get_events(),
            execution_resources=self.execution_resources,
            l2_to_l1_messages=self.__get_l2_to_l1_messages(),
        )

    def get_trace(self) -> TransactionTrace:
        """Returns the transaction trace"""
        validate_invocation = FunctionInvocation.from_optional_internal(
            getattr(self.execution_info, "validate_info", None)
        )

        function_invocation = (
            self.execution_info.call_info
            if isinstance(self.execution_info.call_info, FunctionInvocation)
            else FunctionInvocation.from_optional_internal(
                self.execution_info.call_info
            )
        )

        fee_transfer_invocation = FunctionInvocation.from_optional_internal(
            getattr(self.execution_info, "fee_transfer_info", None)
        )

        return TransactionTrace(
            validate_invocation=validate_invocation,
            function_invocation=function_invocation,
            fee_transfer_invocation=fee_transfer_invocation,
            signature=self.get_signature(),
        )

    def get_execution(self) -> TransactionExecution:
        """Returns the transaction execution"""
        return TransactionExecution(
            transaction_hash=self.internal_tx.hash_value,
            transaction_index=self.transaction_index,
            actual_fee=self.__get_actual_fee(),
            events=self.__get_events(),
            execution_resources=self.execution_resources,
            l2_to_l1_messages=self.__get_l2_to_l1_messages(),
            l1_to_l2_consumed_message=None,
        )


class DevnetTransactions:
    """
    This class is used to store transactions.
    """

    def __init__(self, origin: Origin):
        self.origin = origin
        self.__instances: Dict[int, DevnetTransaction] = {}

    def __get_transaction_by_hash(self, tx_hash: str) -> DevnetTransaction or None:
        """
        Get a transaction by hash.
        """
        numeric_hash = int(tx_hash, 16)
        return self.__instances.get(numeric_hash)

    def get_count(self):
        """
        Get the number of transactions.
        """
        return len(self.__instances)

    def store(self, tx_hash: int, transaction: DevnetTransaction):
        """
        Store a transaction.
        """
        self.__instances[tx_hash] = transaction

    async def get_transaction(self, tx_hash: str):
        """
        Get a transaction info.
        """
        transaction = self.__get_transaction_by_hash(tx_hash)

        if transaction is None:
            return await self.origin.get_transaction(tx_hash)

        return transaction.get_tx_info()

    async def get_transaction_trace(self, tx_hash: str):
        """
        Get a transaction trace.
        """
        transaction = self.__get_transaction_by_hash(tx_hash)

        if transaction is None:
            return await self.origin.get_transaction_trace(tx_hash)

        if transaction.status == TransactionStatus.REJECTED:
            raise StarknetDevnetException(
                code=StarknetErrorCode.NO_TRACE,
                message=f"Transaction corresponding to hash {int(tx_hash, 16)} has no trace; status: {transaction.status.name}.",
            )

        return transaction.get_trace()

    async def get_transaction_receipt(self, tx_hash: str):
        """
        Get a transaction receipt.
        """
        transaction = self.__get_transaction_by_hash(tx_hash)

        if transaction is None:
            return await self.origin.get_transaction_receipt(tx_hash)

        return transaction.get_receipt()

    async def get_transaction_status(self, tx_hash: str):
        """
        Get a transaction status.
        """
        transaction = self.__get_transaction_by_hash(tx_hash)

        if transaction is None:
            return await self.origin.get_transaction_status(tx_hash)

        tx_info = transaction.get_tx_info()

        status_response = {
            "tx_status": tx_info.status.name,
        }

        # "block_hash" will only exist after transaction enters ACCEPTED_ON_L2
        if (
            transaction.status == TransactionStatus.ACCEPTED_ON_L2
            and transaction.block is not None
        ):
            status_response["block_hash"] = hex(transaction.block.block_hash)

        # "tx_failure_reason" will only exist if the transaction was rejected.
        if transaction.status == TransactionStatus.REJECTED:
            status_response["tx_failure_reason"] = tx_info.transaction_failure_reason

        return status_response
