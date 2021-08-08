
TYPE_MAP_VY = {
    "address": {
        "type": "Uint256",
        "big": True,
    },
    "uint256": {
        "type": "Uint256",
        "big": True,
    },
    "bool": {
        "type": "felt",
        "big": False,
    },
}
#external fucs can't take uint256 args
EXT_TYPE_MAP_VY = {
    "address": {
        "type": "Uint256,",
        "big": True,
    },
    "uint256": {
        "type": "Uint256",
        "big": True,
    },
    "bool": {
        "type": "felt",
        "big": False,
    },
}

decorator_map = {
    "external": "@external",
    "internal": "",
    "view": "@view"
}

class Bool:
    def __init__(self):
        pass
