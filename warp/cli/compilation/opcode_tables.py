OP_TO_STR = {
    "00": "STOP",
    "01": "ADD",
    "0a": "EXP",
    "64": "PUSH5",
    "65": "PUSH6",
    "66": "PUSH7",
    "67": "PUSH8",
    "68": "PUSH9",
    "69": "PUSH10",
    "6a": "PUSH11",
    "6b": "PUSH12",
    "6c": "PUSH13",
    "6d": "PUSH14",
    "0b": "SIGNEXTEND",
    "6e": "PUSH15",
    "6f": "PUSH16",
    "70": "PUSH17",
    "71": "PUSH18",
    "72": "PUSH19",
    "73": "PUSH20",
    "74": "PUSH21",
    "75": "PUSH22",
    "76": "PUSH23",
    "77": "PUSH24",
    "78": "PUSH25",
    "79": "PUSH26",
    "7a": "PUSH27",
    "7b": "PUSH28",
    "7c": "PUSH29",
    "7d": "PUSH30",
    "7e": "PUSH31",
    "7f": "PUSH32",
    "80": "DUP1",
    "81": "DUP2",
    "82": "DUP3",
    "83": "DUP4",
    "84": "DUP5",
    "85": "DUP6",
    "86": "DUP7",
    "87": "DUP8",
    "88": "DUP9",
    "89": "DUP10",
    "8a": "DUP11",
    "8b": "DUP12",
    "8c": "DUP13",
    "8d": "DUP14",
    "8e": "DUP15",
    "8f": "DUP16",
    "90": "SWAP1",
    "91": "SWAP2",
    "92": "SWAP3",
    "93": "SWAP4",
    "94": "SWAP5",
    "95": "SWAP6",
    "96": "SWAP7",
    "97": "SWAP8",
    "98": "SWAP9",
    "99": "SWAP10",
    "9a": "SWAP11",
    "9b": "SWAP12",
    "9c": "SWAP13",
    "9d": "SWAP14",
    "9e": "SWAP15",
    "9f": "SWAP16",
    "10": "LT",
    "a0": "LOG0",
    "a1": "LOG1",
    "a2": "LOG2",
    "a3": "LOG3",
    "a4": "LOG4",
    "11": "GT",
    "b0": "PUSH",
    "b1": "DUP",
    "b2": "SWAP",
    "12": "SLT",
    "13": "SGT",
    "02": "MUL",
    "14": "EQ",
    "15": "ISZERO",
    "16": "AND",
    "17": "OR",
    "18": "XOR",
    "f0": "CREATE",
    "f1": "CALL",
    "f2": "CALLCODE",
    "f3": "RETURN",
    "f4": "DELEGATECALL",
    "f5": "CREATE2",
    "19": "NOT",
    "fa": "STATICCALL",
    "fd": "REVERT",
    "ff": "SELFDESTRUCT",
    "1a": "BYTE",
    "1b": "SHL",
    "1c": "SHR",
    "1d": "SAR",
    "03": "SUB",
    "20": "SHA3",
    "04": "DIV",
    "30": "ADDRESS",
    "31": "BALANCE",
    "05": "SDIV",
    "32": "ORIGIN",
    "33": "CALLER",
    "34": "CALLVALUE",
    "35": "CALLDATALOAD",
    "36": "CALLDATASIZE",
    "37": "CALLDATACOPY",
    "38": "CODESIZE",
    "39": "CODECOPY",
    "3a": "GASPRICE",
    "3b": "EXTCODESIZE",
    "06": "MOD",
    "3c": "EXTCODECOPY",
    "3d": "RETURNDATASIZE",
    "3e": "RETURNDATACOPY",
    "3f": "EXTCODEHASH",
    "40": "BLOCKHASH",
    "41": "COINBASE",
    "42": "TIMESTAMP",
    "43": "NUMBER",
    "44": "DIFFICULTY",
    "45": "GASLIMIT",
    "07": "SMOD",
    "46": "CHAINID",
    "47": "SELFBALANCE",
    "48": "BASEFEE",
    "08": "ADDMOD",
    "50": "POP",
    "51": "MLOAD",
    "52": "MSTORE",
    "53": "MSTORE8",
    "54": "SLOAD",
    "55": "SSTORE",
    "56": "JUMP",
    "57": "JUMPI",
    "58": "PC",
    "59": "MSIZE",
    "09": "MULMOD",
    "5a": "GAS",
    "5b": "JUMPDEST",
    "60": "PUSH1",
    "61": "PUSH2",
    "62": "PUSH3",
    "63": "PUSH4",
}

STR_TO_OP = {
    "ADD": "01",
    "ADDMOD": "08",
    "ADDRESS": "30",
    "AND": "16",
    "BALANCE": "31",
    "BASEFEE": "48",
    "BLOCKHASH": "40",
    "BYTE": "1a",
    "CALL": "f1",
    "CALLCODE": "f2",
    "CALLDATACOPY": "37",
    "CALLDATALOAD": "35",
    "CALLDATASIZE": "36",
    "CALLER": "33",
    "CALLVALUE": "34",
    "CHAINID": "46",
    "CODECOPY": "39",
    "CODESIZE": "38",
    "COINBASE": "41",
    "CREATE": "f0",
    "CREATE2": "f5",
    "DELEGATECALL": "f4",
    "DIFFICULTY": "44",
    "DIV": "04",
    "DUP1": "80",
    "DUP10": "89",
    "DUP11": "8a",
    "DUP12": "8b",
    "DUP13": "8c",
    "DUP14": "8d",
    "DUP15": "8e",
    "DUP16": "8f",
    "DUP2": "81",
    "DUP3": "82",
    "DUP4": "83",
    "DUP5": "84",
    "DUP6": "85",
    "DUP7": "86",
    "DUP8": "87",
    "DUP9": "88",
    "EQ": "14",
    "EXP": "0a",
    "EXTCODECOPY": "3c",
    "EXTCODEHASH": "3f",
    "EXTCODESIZE": "3b",
    "GAS": "5a",
    "GASLIMIT": "45",
    "GASPRICE": "3a",
    "GT": "11",
    "ISZERO": "15",
    "JUMP": "56",
    "JUMPDEST": "5b",
    "JUMPI": "57",
    "LOG0": "a0",
    "LOG1": "a1",
    "LOG2": "a2",
    "LOG3": "a3",
    "LOG4": "a4",
    "LT": "10",
    "MLOAD": "51",
    "MOD": "06",
    "MSIZE": "59",
    "MSTORE": "52",
    "MSTORE8": "53",
    "MUL": "02",
    "MULMOD": "09",
    "NOT": "19",
    "NUMBER": "43",
    "OR": "17",
    "ORIGIN": "32",
    "PC": "58",
    "POP": "50",
    "PUSH1": "60",
    "PUSH10": "69",
    "PUSH11": "6a",
    "PUSH12": "6b",
    "PUSH13": "6c",
    "PUSH14": "6d",
    "PUSH15": "6e",
    "PUSH16": "6f",
    "PUSH17": "70",
    "PUSH18": "71",
    "PUSH19": "72",
    "PUSH2": "61",
    "PUSH20": "73",
    "PUSH21": "74",
    "PUSH22": "75",
    "PUSH23": "76",
    "PUSH24": "77",
    "PUSH25": "78",
    "PUSH26": "79",
    "PUSH27": "7a",
    "PUSH28": "7b",
    "PUSH29": "7c",
    "PUSH3": "62",
    "PUSH30": "7d",
    "PUSH31": "7e",
    "PUSH32": "7f",
    "PUSH4": "63",
    "PUSH5": "64",
    "PUSH6": "65",
    "PUSH7": "66",
    "PUSH8": "67",
    "PUSH9": "68",
    "RETURN": "f3",
    "RETURNDATACOPY": "3e",
    "RETURNDATASIZE": "3d",
    "REVERT": "fd",
    "SAR": "1d",
    "SDIV": "05",
    "SELFBALANCE": "47",
    "SELFDESTRUCT": "ff",
    "SGT": "13",
    "SHA3": "20",
    "SHL": "1b",
    "SHR": "1c",
    "SIGNEXTEND": "0b",
    "SLOAD": "54",
    "SLT": "12",
    "SMOD": "07",
    "SSTORE": "55",
    "STATICCALL": "fa",
    "STOP": "00",
    "SUB": "03",
    "SWAP1": "90",
    "SWAP10": "99",
    "SWAP11": "9a",
    "SWAP12": "9b",
    "SWAP13": "9c",
    "SWAP14": "9d",
    "SWAP15": "9e",
    "SWAP16": "9f",
    "SWAP2": "91",
    "SWAP3": "92",
    "SWAP4": "93",
    "SWAP5": "94",
    "SWAP6": "95",
    "SWAP7": "96",
    "SWAP8": "97",
    "SWAP9": "98",
    "TIMESTAMP": "42",
    "XOR": "18",
}
