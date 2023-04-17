"""
Global state singletone
"""

from pickle import UnpicklingError

from starkware.starkware_utils.error_handling import StarkErrorCode

from .devnet_config import DevnetConfig
from .dump import Dumper
from .starknet_wrapper import StarknetWrapper
from .util import StarknetDevnetException, check_valid_dump_path


class State:
    """
    Stores starknet wrapper and dumper
    """

    def __init__(self):
        self.set_starknet_wrapper(StarknetWrapper(DevnetConfig()))

    def set_starknet_wrapper(self, starknet_wrapper: StarknetWrapper):
        """Sets starknet wrapper and creates new instance of dumper"""
        self.starknet_wrapper = starknet_wrapper
        self.dumper = Dumper(starknet_wrapper)

    async def reset(self):
        """Reset the starknet wrapper and dumper instances"""
        previous_config = self.starknet_wrapper.config
        self.set_starknet_wrapper(StarknetWrapper(previous_config))
        await self.starknet_wrapper.initialize()

    def load(self, load_path: str):
        """Load a previously dumped state if specified."""
        try:
            self.set_starknet_wrapper(StarknetWrapper.load(load_path))
        except (FileNotFoundError, UnpicklingError) as error:
            message = f"Error: Cannot load from {load_path}. Make sure the file exists and contains a Devnet dump."
            raise StarknetDevnetException(
                code=StarkErrorCode.INVALID_REQUEST, message=message, status_code=400
            ) from error

    def set_dump_options(self, dump_path: str, dump_on: str):
        """Assign dumping options from args to state."""
        if dump_path:
            try:
                check_valid_dump_path(dump_path)
            except ValueError as error:
                raise StarknetDevnetException(
                    code=StarkErrorCode.INVALID_REQUEST, message=str(error)
                ) from error

        self.dumper.dump_path = dump_path
        self.dumper.dump_on = dump_on


state = State()
