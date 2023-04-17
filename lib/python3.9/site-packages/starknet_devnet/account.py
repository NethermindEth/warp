"""
Account class and its predefined constants.
"""

from starkware.cairo.lang.vm.crypto import pedersen_hash
from starkware.starknet.core.os.contract_address.contract_address import (
    calculate_contract_address_from_hash,
)
from starkware.starknet.public.abi import get_selector_from_name
from starkware.starknet.testing.contract import StarknetContract
from starkware.starknet.testing.starknet import Starknet

from starknet_devnet.contract_class_wrapper import ContractClassWrapper
from starknet_devnet.util import Uint256


class Account:
    """Account contract wrapper."""

    # pylint: disable=too-many-arguments
    def __init__(
        self,
        starknet_wrapper,
        private_key: int,
        public_key: int,
        initial_balance: int,
        account_class_wrapper: ContractClassWrapper,
    ):
        self.starknet_wrapper = starknet_wrapper
        self.private_key = private_key
        self.public_key = public_key
        self.contract_class = account_class_wrapper.contract_class
        self.class_hash_bytes = account_class_wrapper.hash_bytes

        # salt and class_hash have frozen values that make the constructor_calldata
        # the only thing that affects the account address
        self.address = calculate_contract_address_from_hash(
            salt=20,
            class_hash=1803505466663265559571280894381905521939782500874858933595227108099796801620,
            constructor_calldata=[public_key],
            deployer_address=0,
        )
        self.initial_balance = initial_balance

    def to_json(self):
        """Return json account"""
        return {
            "initial_balance": self.initial_balance,
            "private_key": hex(self.private_key),
            "public_key": hex(self.public_key),
            "address": hex(self.address),
        }

    async def deploy(self) -> StarknetContract:
        """Deploy this account."""
        starknet: Starknet = self.starknet_wrapper.starknet
        contract_class = self.contract_class
        await starknet.state.state.set_contract_class(
            self.class_hash_bytes, contract_class
        )
        await starknet.state.state.deploy_contract(self.address, self.class_hash_bytes)

        await starknet.state.state.set_storage_at(
            self.address, get_selector_from_name("Account_public_key"), self.public_key
        )

        # set initial balance
        fee_token_address = starknet.state.general_config.fee_token_address
        balance_address = pedersen_hash(
            get_selector_from_name("ERC20_balances"), self.address
        )
        initial_balance_uint256 = Uint256.from_felt(self.initial_balance)
        await starknet.state.state.set_storage_at(
            fee_token_address, balance_address, initial_balance_uint256.low
        )
        await starknet.state.state.set_storage_at(
            fee_token_address, balance_address + 1, initial_balance_uint256.high
        )
