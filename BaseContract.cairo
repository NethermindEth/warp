# 0x04fc2e03094be53f5037550c2e1b0ce87141dddfad42be7c98f36bc4546e9542 - Base Contract Address
# Declare this file as a StarkNet contract.
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

# Define a storage variable.
@storage_var
func balance() -> (res : felt):
end

@contract_interface
namespace IBalanceContract:
    func increase_balance(amount : felt):
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
        class_hash=class_hash, amount=amount
    )
    return ()
end

# Returns the current balance.
@view
func get_balance{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}() -> (res : felt):
    let (res) = balance.read()
    return (res=res)
end
