from transpiler.Operation import Operation
from transpiler.StackValue import Uint256
from transpiler.Operations.EnforcedStack import EnforcedStack
from transpiler.Operations.Unary import Unary
from transpiler.utils import get_low_high

# The view functions get_storage_low/high will are used
# for starknet testing.
STORAGE_DECLS = """
@storage_var
func evm_storage(low: felt, high: felt, part: felt) -> (res : felt):
end

func s_load{
        storage_ptr: Storage*, range_check_ptr, pedersen_ptr: HashBuiltin*}(
        low: felt, high: felt) -> (res : Uint256):
    let (low_r) = evm_storage.read(low, high, 1)
    let (high_r) = evm_storage.read(low, high, 2)
    return (Uint256(low_r, high_r))
end

func s_store{
        storage_ptr: Storage*, range_check_ptr, pedersen_ptr: HashBuiltin*}(
        low: felt, high: felt, value_low : felt, value_high : felt):
    evm_storage.write(low=low, high=high, part=1, value=value_low)
    evm_storage.write(low=low, high=high, part=2, value=value_high)
    return ()
end

@view
func get_storage_low{
        storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_low) = evm_storage.read(low=low, high=high, part=1)
    return (res=storage_val_low)
end

@view
func get_storage_high{
        storage_ptr : Storage*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        low : felt, high : felt) -> (res : felt):
    let (storage_val_high) = evm_storage.read(low=low, high=high, part=2)
    return (res=storage_val_high)
end
"""


class SStore(EnforcedStack):
    def __init__(self):
        super().__init__(n_args=2, has_output=False)

    def generate_cairo_code(self, loc, value):
        loc_low, loc_high = get_low_high(loc)
        value_low, value_high = get_low_high(value)
        return [
            f"s_store(low={loc_low}, high={loc_high}, "
            f"value_low={value_low}, value_high={value_high})",
            "local pedersen_ptr : HashBuiltin* = pedersen_ptr",
            "local storage_ptr : Storage* = storage_ptr",
        ]

    def process_structural_changes(self, evmToCairo):
        evmToCairo.requires_storage = True


class SLoad(Unary):
    # return zero'd values if we are trying to load from an
    # uninitialized storage slot
    def generate_cairo_code(self, loc, res):
        loc_low, loc_high = get_low_high(loc)
        return [
            f"let (local {res} : Uint256) = s_load(low={loc_low}, high={loc_high})",
            "local pedersen_ptr : HashBuiltin* = pedersen_ptr",
            "local storage_ptr : Storage* = storage_ptr",
            ]

    def process_structural_changes(self, evmToCairo):
        evmToCairo.requires_storage = True
