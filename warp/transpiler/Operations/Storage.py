from transpiler.Operation import Operation
from transpiler.StackValue import Uint256

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


class SStore(Operation):
    def proceed(self, state):
        loc = state.stack.pop()
        value = state.stack.pop()
        instruction = self.bind_to_res(loc, value)
        return [
            instruction,
        ]

    def bind_to_res(self, loc, value):
        loc_low, loc_high = get_var_name(loc)
        value_low, value_high = get_var_name(value)
        return f"s_store(low={loc_low}, high={loc_high}, value_low={value_low}, value_high={value_high})"
        


class SLoad(Operation):
    def proceed(self, state):
        loc = state.stack.pop()
        res_ref_name = f"tmp{state.n_locals}"
        instruction = self.bind_to_res(loc, res_ref_name)
        state.stack.push_ref(res_ref_name)
        state.n_locals += 1
        return [
            instruction,
        ]

    # return zero'd values if we are trying to load from an
    # uninitialized storage slot
    def bind_to_res(self, loc, res):
        loc_low, loc_high = get_var_name(loc)
        return f"let (local {res} : Uint256) = s_load(low={loc_low}, high={loc_high})"


def get_var_name(loc):
    if isinstance(loc, Uint256):
        return loc.get_low_high()
    else:
        return f"{loc}.low", f"{loc}.high"
