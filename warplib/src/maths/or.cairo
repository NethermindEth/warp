func warp_or(lhs: felt, rhs: felt) -> (res: felt) {
    let val = lhs + rhs;
    if (val == 0) {
        return (0,);
    }
    return (1,);
}
