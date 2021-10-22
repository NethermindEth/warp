import solcx

uint256_types = ["address", "bool", "int", "fixed", "ufixed", "uint"]
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
            for input in function["inputs"]:
                if not input["type"] in uint256_types:
                    raise Exception(
                        "Remote contract argument type not supported", input["type"]
                    )
            input_rep = ", ".join([i["name"] + ": Uint256" for i in function["inputs"]])

            for output in function["outputs"]:
                if not output["type"] in uint256_types:
                    raise Exception(
                        "Remote contract return type not supported", input["type"]
                    )
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
    return ""

