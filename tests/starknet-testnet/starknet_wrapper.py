from enum import Enum
from typing import Dict

from starkware.starknet.services.api.contract_definition import ContractDefinition
from starkware.starknet.testing.starknet import Starknet
from util import StarknetDevnetException, TxStatus, fixed_length_hex


class Choice(Enum):
    CALL = "call"
    INVOKE = "invoke"


class StarknetWrapper:
    def __init__(self):
        self.address2contract: Dict[int, ContractDefinition] = {}
        """Maps contract address to contract wrapper."""

        self.transactions = []
        """A chronological list of transactions."""

        self.starknet = None
        self.compiledCairoFiles: list[str] = []

    async def get_starknet(self):
        if not self.starknet:
            self.starknet = await Starknet.empty()
        return self.starknet

    async def get_state(self):
        if not self.starknet:
            self.starknet = await Starknet.empty()
        return self.starknet.state

    def contract_deployed(self, address: int) -> bool:
        return address in self.address2contract

    def get_contract_definition(self, address: int) -> ContractDefinition:
        if not self.contract_deployed(address):
            message = (
                f"No contract at the provided address ({fixed_length_hex(address)})."
            )
            raise StarknetDevnetException(message=message)

        return self.address2contract[address]

    def is_transaction_hash_legal(self, transaction_hash_int: int) -> bool:
        return 0 <= transaction_hash_int < len(self.transactions)

    def get_transaction_status(self, transaction_hash: str):
        transaction_hash_int = int(transaction_hash, 16)

        if self.is_transaction_hash_legal(transaction_hash_int):
            transaction = self.transactions[transaction_hash_int]
            ret = {"tx_status": transaction["status"]}

            if "block_hash" in transaction:
                ret["block_hash"] = transaction["block_hash"]

            failure_key = "transaction_failure_reason"
            if failure_key in transaction:
                ret[failure_key] = transaction[failure_key]

            return ret

        return {"tx_status": TxStatus.NOT_RECEIVED.name}

    def get_transaction(self, transaction_hash: str):
        transaction_hash_int = int(transaction_hash, 16)
        if self.is_transaction_hash_legal(transaction_hash_int):
            return self.transactions[transaction_hash_int]
        return {
            "status": TxStatus.NOT_RECEIVED.name,
            "transaction_hash": transaction_hash,
        }

    def get_code(self, contract_address: int) -> dict:
        if self.contract_deployed(contract_address):
            contract_wrapper = self.address2contract[contract_address]
            return contract_wrapper.code
        return {"abi": {}, "bytecode": []}

    async def get_storage_at(self, contract_address: int, key: int) -> str:
        state = await self.get_state()
        contract_states = state.state.contract_states

        state = contract_states[contract_address]
        if key in state.storage_updates:
            return hex(state.storage_updates[key].value)
        return hex(0)
