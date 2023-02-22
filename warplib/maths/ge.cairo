
fn warp_ge(lhs: felt, rhs: felt) -> felt {
    if lhs >= rhs {
        return 1;
    }
    else {
        return 0;
    }
}

fn warp_ge256(op1: u256, op2: u256) -> felt {
    if op1 >= op2 {
        return 1;
    }
    else {
        return 0;
    }
}
