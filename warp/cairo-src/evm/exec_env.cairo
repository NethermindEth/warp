# Store environment info, e.g. gas, calldata, value, addresses etc
struct ExecutionEnvironment:
    member calldata_size : felt
    member calldata_len : felt
    member calldata : felt*  # a big-endian 128-bit packed byte array

    # The data returned from a function call
    member returndata_size : felt
    member returndata_len : felt
    member returndata : felt*

    # The data to be returned at the end of this function call
    member to_returndata_size : felt
    member to_returndata_len : felt
    member to_returndata : felt*
end
