from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math import split_felt
from starkware.starknet.common.syscalls import get_caller_address

func get_caller_data_uint256{syscall_ptr : felt*, range_check_ptr}() -> (caller_data: Uint256):
  alloc_locals
  let (local caller_address) = get_caller_address()
  let (local high, local low) = split_felt(caller_address)
  let caller_data = Uint256(low=low, high=high)

  return (caller_data=caller_data)
end

#--------------call_data_load

func segment0{
        storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr, msize,
        memory_dict : DictAccess*}(exec_env : ExecutionEnvironment*, stack : StackItem*) -> (
        stack : StackItem*, output : Output):
    alloc_locals
    let stack0 = stack
    let (local __fp__, _) = get_fp_and_pc()
    let (local tmp0 : Uint256) = array_load(exec_env.input_len, exec_env.input, 0)
    local newitem0 : StackItem = StackItem(value=Uint256(3, 0), next=stack0)
    local newitem1 : StackItem = StackItem(value=Uint256(65535, 0), next=&newitem0)
    local newitem2 : StackItem = StackItem(value=tmp0, next=&newitem1)
    return (&newitem2, Output(cast(0, felt*), 0))
end

func call_data_load{storage_ptr : Storage*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        calldata_size, unused_bytes, input_len : felt, input : felt*):
    alloc_locals
    let (local __fp__, _) = get_fp_and_pc()
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(
        calldata_size=calldata_size,
        input_len=input_len,
        input=input,
        )

    let (local memory_dict : DictAccess*) = default_dict_new(0)
    local memory_start : DictAccess* = memory_dict

    tempvar msize = 0

    local stack0 : StackItem
    assert stack0 = StackItem(value=Uint256(-1, 0), next=&stack0)  # Points to itself.

    let (local stack, local output) = segment0{
        storage_ptr=storage_ptr,
        pedersen_ptr=pedersen_ptr,
        range_check_ptr=range_check_ptr,
        msize=msize,
        memory_dict=memory_dict}(&exec_env, &stack0)

    return ()
end