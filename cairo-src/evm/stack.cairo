from starkware.cairo.common.uint256 import Uint256

struct StackItem:
    member value : Uint256
    member next : StackItem*
end
