import solcx

uint256_types = ["address", "bool", "int", "fixed", "ufixed", "uint", "uint256"]
uint256_types += ["uint" + str(x * 8) for x in range(1, 33)]


def get_cairo_interfaces(source: str):
    compiled_contracts = solcx.compile_source(source)
    contract_location_ids = list(compiled_contracts.keys())

    interface_contracts = []

    interface_ABIs = []

    if len(contract_location_ids) > 0:
        contract_dict = compiled_contracts[contract_location_ids[0]]
        for node in contract_dict["ast"]["nodes"]:
            if "contractKind" in node:
                if node["contractKind"] == "interface":
                    interface_contracts.append(node["name"])
    else:
        return ""

    contracts = filter(
        lambda id: id.split(":")[1] in interface_contracts, contract_location_ids
    )

    for contract in contracts:
        abi = compiled_contracts[contract]["abi"]
        functions = filter(lambda declaration: declaration["type"] == "function", abi)
        function_reps = []

        for function in functions:
            # for input in function["inputs"]:
            #     if not input["type"] in uint256_types:
            #         raise Exception(
            #             "Remote contract argument type not supported", input["type"]
            #         )
            input_rep = ", ".join([i["name"] + ": Uint256" for i in function["inputs"]])

            # for output in function["outputs"]:
                # if not output["type"] in uint256_types:
                #     print(output)
                #     raise Exception(
                #         "Remote contract return type not supported", input["type"]
                #     )
            output_rep = ", ".join(
                (o["name"] if o["name"] else "res" + str(i)) + ": Uint256"
                for (i, o) in enumerate(function["outputs"])
            )

            function_reps.append(
                f'    func {function["name"]}({input_rep})'
                + (f" -> ({output_rep})" if output_rep else "")
                + ":\n    end"
            )
        functions_rep = "\n\n".join(function_reps)
        interface_ABIs.append(
            f"""@contract_interface
namespace Interface{contract.split(":")[1]}:
{functions_rep}
end"""
        )

    # return "\n\n".join([GenericCallInterface] + interface_ABIs + [WARP_CALLS])
    return "\n\n".join([GenericCallInterface] + [WARP_CALLS])


WARP_CALLS = """
func calculate_data_len{range_check_ptr}(calldata_size) -> (calldata_len):
    let (calldata_len_, rem) = unsigned_div_rem(calldata_size, 8)
    if rem != 0:
        return (calldata_len = calldata_len_ + 1)
    else:
        return (calldata_len = calldata_len_)
    end
end

func warp_call{syscall_ptr: felt*, storage_ptr: Storage*, exec_env: ExecutionEnvironment, memory_dict : DictAccess*, range_check_ptr}(
        gas : Uint256, address : Uint256, value : Uint256, in : Uint256, insize : Uint256,
        out : Uint256, outsize : Uint256) -> (success : Uint256):
    alloc_locals
    local memory_dict : DictAccess* = memory_dict

    # TODO will 128 bits be enough for addresses
    let (local mem : felt*) = array_create_from_memory{memory_dict=memory_dict, range_check_ptr=range_check_ptr}(in.low, insize.low)
    local memory_dict : DictAccess* = memory_dict
    let (calldata_len_, rem) = unsigned_div_rem(insize.low, 8)
    let (calldata_len) = calculate_data_len(insize.low)
    let (local success, local return_size, local return_ : felt*) = GenericCallInterface.fun_ENTRY_POINT(
        address.low, insize.low, calldata_len, mem)
    local syscall_ptr : felt* = syscall_ptr
    local storage_ptr : Storage* = storage_ptr
    array_copy_to_memory(return_size, return_, 0, out.low, outsize.low)
    let (returndata_len) = calculate_data_len(insize.low)
    local exec_env: ExecutionEnvironment = ExecutionEnvironment(
        calldata_size=exec_env.calldata_size, calldata_len=exec_env.calldata_len, calldata=exec_env.calldata,
        returndata_size=return_size, returndata_len=returndata_len, returndata=return_
    )
    return (Uint256(success, 0))
end

func warp_static_call{syscall_ptr: felt*, storage_ptr: Storage*, exec_env: ExecutionEnvironment, memory_dict : DictAccess*, range_check_ptr}(
        gas : Uint256, address : Uint256, in : Uint256, insize : Uint256, out : Uint256,
        outsize : Uint256) -> (success : Uint256):
    return warp_call(gas, address, Uint256(0,0), in, insize, out, outsize)
end
"""

GenericCallInterface = """
@contract_interface
namespace GenericCallInterface:
    func fun_ENTRY_POINT(calldata_size: felt, calldata_len: felt, calldata : felt*) -> (success: felt, returndata_len: felt, returndata: felt*):
    end
end
"""
