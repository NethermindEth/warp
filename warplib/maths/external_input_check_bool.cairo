from starkware.cairo.common.math_cmp import is_le_felt

func warp_external_input_check_bool{range_check_ptr}(x : felt):
    let (inRange : felt) = is_le_felt(x, 1)
    with_attr error_message(
            "Error: value out-of-bounds. Boolean values passed to must be in range (0, 1]."):
        assert 1 = inRange
    end
    return ()
end
