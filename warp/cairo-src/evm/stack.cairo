from starkware.cairo.common.uint256 import Uint256

struct StackItem:
    # Represents an EVM stack item. Contains the item value and a
    # pointer to the next value.
    member value : Uint256
    member next : StackItem*
end
