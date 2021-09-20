%builtins output range_check

from starkware.cairo.common.uint256 import Uint256
from evm.array import array_load
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_word
from evm.exec_env import ExecutionEnvironment

func call_data_load{range_check_ptr, exec_env : ExecutionEnvironment}(offset) -> (value : Uint256):
    alloc_locals
    let (local value : Uint256) = array_load(exec_env.input_len, exec_env.input, offset)
    return (value=value)
end

func main{output_ptr : felt*, range_check_ptr}():
    alloc_locals 
    let (input : felt* ) = alloc()
    assert [input] = 3536084758384602065506748758208
    assert [input + 1] = 353608475838460206550674875820802048
    local exec_env : ExecutionEnvironment = ExecutionEnvironment(calldata_size=0, input_len=2, input)
    let (local res : Uint256) = call_data_load{range_check_ptr=range_check_ptr, exec_env=exec_env}(0)
    serialize_word(res.low)
    serialize_word(res.high)
    return ()
end
