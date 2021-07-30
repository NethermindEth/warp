import abc

from transpiler.Operation import Operation
from transpiler.StackValue import UINT256_BOUND, Uint256, Str
from transpiler.Imports import Imports

# Important: per yellow paper, the representation of uint256 as bytes
# is big-endian.


class MemoryAccess(Operation):
    def proceed(self, state):
        try:
            address = state.stack.pop().get_low_bits()
        except:
            address = f"{state.stack.pop()}.low"
        access_operations = self._do_memory_access(address, state)
        return [
            "local pedersen_ptr : HashBuiltin* = pedersen_ptr",
            "local memory_dict : DictAccess* = memory_dict",
            "local storage_ptr : Storage* = storage_ptr",
            f"let (local msize) = update_msize(msize, {address}, {self.access_width()})",
            *access_operations,
        ]

    def required_imports(self):
        return {"evm.utils": {"update_msize"}, **self._memory_access_imports()}

    @classmethod
    @abc.abstractmethod
    def access_width(cls) -> int:
        pass

    @abc.abstractmethod
    def _do_memory_access(self, address, state):
        pass

    @classmethod
    @abc.abstractmethod
    def _memory_access_imports(cls) -> Imports:
        pass


class MStore(MemoryAccess):
    @classmethod
    def access_width(cls):
        return 32

    def _do_memory_access(self, address, state):
        value = state.stack.pop()
        return [
            f"mstore(offset={address}, value={value})",
        ]

    @classmethod
    def _memory_access_imports(cls):
        return {
            "evm.memory": {"mstore"},
            "starkware.cairo.common.dict_access": {"DictAccess"},
        }


class MStore8(MemoryAccess):
    @classmethod
    def access_width(cls):
        return 1

    def _do_memory_access(self, address, state):
        value = state.stack.pop()
        return [
            f"let (local byte, _) = extract_lowest_byte({value})",
            f"mstore8(offset={address}, byte=byte)",
        ]

    @classmethod
    def _memory_access_imports(cls):
        return {
            "evm.memory": {"mstore8"},
            "evm.uint256": {"extract_lowest_byte"},
        }


class MLoad(MemoryAccess):
    @classmethod
    def access_width(cls):
        return 32

    def _do_memory_access(self, address, state):
        res_ref_name = state.request_fresh_name()
        state.stack.push_ref(res_ref_name)
        return [
            f"let (local {res_ref_name} : Uint256) = mload({address})",
        ]

    @classmethod
    def _memory_access_imports(cls):
        return {"evm.memory": {"mload"}}


class MSize(Operation):
    def proceed(self, state):
        res_ref_name = state.request_fresh_name()
        state.stack.push_ref(res_ref_name)
        # the yellow paper defines msize as the memory size in bytes,
        # but rounded to the closest greater word boundary, i.e. a
        # 32-multiple. Also, it's most probably < 2**64.
        return [
            "let (local immediate) = round_up_to_multiple(msize, 32)",
            f"local {res_ref_name} : Uint256 = Uint256(immediate, 0)",
        ]

    def required_imports(self):
        return {"evm.utils": {"round_up_to_multiple", "get_max"}}
