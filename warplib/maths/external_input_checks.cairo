# AUTO-GENERATED
from starkware.cairo.common.math_cmp import is_le_felt
from starkware.cairo.common.uint256 import Uint256

func warp_external_input_check_int8{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**8."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int16{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**16."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int24{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**24."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int32{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**32."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int40{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**40."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int48{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**48."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int56{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**56."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int64{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**64."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int72{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**72."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int80{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**80."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int88{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**88."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int96{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**96."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int104{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**104."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int112{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**112."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int120{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**120."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int128{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**128."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int136{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**136."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int144{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**144."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int152{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**152."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int160{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**160."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int168{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**168."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int176{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**176."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int184{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**184."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int192{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**192."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int200{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**200."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int208{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**208."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int216{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**216."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int224{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**224."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int232{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(
        x, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**232."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int240{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(
        x, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**240."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int248{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(
        x, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
    with_attr error_message("Error: value out-of-bounds. Value must be less than 2**248."):
        assert 1 = inRange
    end
    return ()
end

func warp_external_input_check_int256{range_check_ptr}(x : Uint256):
    alloc_locals
    let (inRangeHigh : felt) = is_le_felt(x.high, 0xffffffffffffffffffffffffffffffff)
    let (inRangeLow : felt) = is_le_felt(x.low, 0xffffffffffffffffffffffffffffffff)
    with_attr error_message(
            "Error: value out-of-bounds. Values passed to high and low members of Uint256 must be less than 2**128."):
        assert 1 = (inRangeHigh * inRangeLow)
    end
    return ()
end
