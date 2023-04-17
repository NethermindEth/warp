"""
Fee token and its predefined constants.
"""

from starkware.python.utils import to_bytes
from starkware.solidity.utils import load_nearby_contract
from starkware.starknet.compiler.compile import get_selector_from_name
from starkware.starknet.services.api.contract_class import ContractClass
from starkware.starknet.services.api.gateway.transaction import InvokeFunction
from starkware.starknet.testing.contract import StarknetContract
from starkware.starknet.testing.starknet import Starknet

from starknet_devnet.sequencer_api_utils import InternalInvokeFunction
from starknet_devnet.util import Uint256, str_to_felt


class FeeToken:
    """Wrapper of token for charging fees."""

    CONTRACT_CLASS: ContractClass = None  # loaded lazily

    # Precalculated
    # HASH = to_bytes(compute_class_hash(contract_class=FeeToken.get_contract_class()))
    HASH = 3000409729603134799471314790024123407246450023546294072844903167350593031855
    HASH_BYTES = to_bytes(HASH)

    # Taken from
    # https://github.com/starknet-community-libs/starknet-addresses/blob/df19b17d2c83f11c30e65e2373e8a0c65446f17c/bridged_tokens/goerli.json
    ADDRESS = 0x49D36570D4E46F48E99674BD3FCC84644DDD6B96F7C741B1562B82F9E004DC7
    SYMBOL = "ETH"
    NAME = "ether"

    contract: StarknetContract = None

    def __init__(self, starknet_wrapper):
        self.starknet_wrapper = starknet_wrapper

    @classmethod
    def get_contract_class(cls):
        """Returns contract class via lazy loading."""
        if not cls.CONTRACT_CLASS:
            cls.CONTRACT_CLASS = ContractClass.load(
                load_nearby_contract("ERC20_Mintable_OZ_0.2.0")
            )
        return cls.CONTRACT_CLASS

    async def deploy(self):
        """Deploy token contract for charging fees."""
        starknet: Starknet = self.starknet_wrapper.starknet
        contract_class = FeeToken.get_contract_class()

        await starknet.state.state.set_contract_class(
            FeeToken.HASH_BYTES, contract_class
        )

        # pylint: disable=protected-access
        starknet.state.state.cache._class_hash_writes[
            FeeToken.ADDRESS
        ] = FeeToken.HASH_BYTES
        # replace with await starknet.state.state.deploy_contract

        # mimic constructor
        await starknet.state.state.set_storage_at(
            FeeToken.ADDRESS,
            get_selector_from_name("ERC20_name"),
            str_to_felt(FeeToken.NAME),
        )
        await starknet.state.state.set_storage_at(
            FeeToken.ADDRESS,
            get_selector_from_name("ERC20_symbol"),
            str_to_felt(FeeToken.SYMBOL),
        )
        await starknet.state.state.set_storage_at(
            FeeToken.ADDRESS,
            get_selector_from_name("ERC20_decimals"),
            18,
        )

        self.contract = StarknetContract(
            state=starknet.state,
            abi=contract_class.abi,
            contract_address=FeeToken.ADDRESS,
            deploy_call_info=None,
        )

    async def get_balance(self, address: int) -> int:
        """Return the balance of the contract under `address`."""
        response = await self.contract.balanceOf(address).call()

        balance = Uint256(
            low=response.result.balance.low, high=response.result.balance.high
        ).to_felt()
        return balance

    @classmethod
    def get_mint_transaction(cls, to_address: int, amount: Uint256):
        """Construct a transaction object representing minting request"""
        transaction_data = {
            "entry_point_selector": hex(get_selector_from_name("mint")),
            "calldata": [
                str(to_address),
                str(amount.low),
                str(amount.high),
            ],
            "signature": [],
            "contract_address": hex(cls.ADDRESS),
        }
        return InvokeFunction.load(transaction_data)

    async def mint(self, to_address: int, amount: int, lite: bool):
        """
        Mint `amount` tokens at address `to_address`.
        Returns the `tx_hash` (as hex str) if not `lite`; else returns `None`
        """
        amount_uint256 = Uint256.from_felt(amount)

        tx_hash = None
        transaction = self.get_mint_transaction(to_address, amount_uint256)
        starknet: Starknet = self.starknet_wrapper.starknet
        if lite:
            internal_tx = InternalInvokeFunction.from_external(
                transaction, starknet.state.general_config
            )
            await starknet.state.execute_tx(internal_tx)
        else:
            _, tx_hash_int = await self.starknet_wrapper.invoke(transaction)
            tx_hash = hex(tx_hash_int)

        return tx_hash
