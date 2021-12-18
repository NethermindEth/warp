# Store environment info, e.g. gas, calldata, value, addresses etc
struct ExecutionEnvironment:
    # The calldata group of members is special. It represents EVM
    # calldata bytes, packed into a big-endian 128-bit felt array,
    # shifted 12 bytes to the left. The reason for the shift is to
    # optimize for the hot-path. Most of the calldata read positions
    # follow the same pattern: 'n * 32 + 4' (the first four bytes in
    # calldata in Solidity represent a function selector). Thus, most
    # of the calldata reads are /unaligned/ in regards to bit
    # packing. In order to align them, we perform the 12-byte shift.

    member calldata_size : felt  # the total number of bytes in calldata, including the shift.
    member calldata_len : felt  # the length of the calldata array
    member calldata : felt*

    # The data returned from a function call
    member returndata_size : felt
    member returndata_len : felt
    member returndata : felt*

    # The data to be returned at the end of this function call
    member to_returndata_size : felt
    member to_returndata_len : felt
    member to_returndata : felt*
end
