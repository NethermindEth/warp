# 0x711941b11a8236b8cca42b664e19342ac7300abb1dc44957763cb65877c2708 - Balance Hash
# Declare this file as a StarkNet contract.
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

# Define a storage variable.
@storage_var
func balance() -> (res : felt):
end

@contract_interface
namespace IBalanceContract:
    func library_call_increase_balance(amount : felt):
    end

    func get_balance() -> (res : felt):
    end
end

@external
func increase_my_balance{syscall_ptr : felt*, range_check_ptr}(
    class_hash : felt, amount : felt
):
    # Increase the local balance variable using a function from a
    # different contract class using a library call.
    IBalanceContract.library_call_increase_balance(
        class_hash, amount
    )
    return ()
end