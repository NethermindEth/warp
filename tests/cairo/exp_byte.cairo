%builtins output

from starkware.cairo.common.serialize import serialize_word

from evm.memory import exp_byte

func main{output_ptr : felt*}():
    alloc_locals

    let (local d0) = exp_byte(0)
    let (local d1) = exp_byte(1)
    let (local d2) = exp_byte(2)
    let (local d3) = exp_byte(3)
    let (local d4) = exp_byte(4)
    # ...
    let (local d15) = exp_byte(15)
    let (local d16) = exp_byte(16)

    serialize_word(d0)
    serialize_word(d1)
    serialize_word(d2)
    serialize_word(d3)
    serialize_word(d4)
    serialize_word(d15)
    serialize_word(d16)

    return ()
end
