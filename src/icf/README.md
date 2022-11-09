## Interface Call Forwarder

This is a feature for the WARP transpiler to enable interaction between non-warped cairo contracts with a warped cairo contract _(cairo file generated after transpilation of a solidity contract)_.

Assume you have a cairo contract `add.cairo`.

```c++
%lang starknet

@view
func add(a: felt, b: felt) -> (res:felt){
    return (res=a+b);
}
```

The cairo contract `a.cairo` has been deployed at address `addr`. And, we want to call `add` function from a warped version of a solidity contract. All you have to do is to follow these steps:

### Step 1.

Run command with appropriate cairo file name and it's address at which it has been deployed

```sh
bin/warp gen_interface a.cairo --contract-address `${addr}`
```

This command will generate two files in the directory where your cairo file is present (in thie case `a.cairo`).

1. A cairo file which would look like as follows for `a.cairo`:

```js
%lang starknet

// imports
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin
from warplib.maths.utils import felt_to_uint256, narrow_safe
from warplib.maths.external_input_check_ints import warp_external_input_check_int256

// existing structs


// transformed structs


// tuple structs


// forwarder interface
@contract_interface
namespace Forwarder {
    func add(
        a: felt,
        b: felt,
    ) -> (res:felt){
    }
}

//cast functions for structs


// external input check functions


//funtions to interact with given cairo contract
@view
func add_771602f7 {syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    a: Uint256,
    b: Uint256,
) -> (
    res: Uint256,
) {
    alloc_locals;
    // check external input
    warp_external_input_check_int256(a);
    warp_external_input_check_int256(b);
    // cast inputs
    let (a_cast) = narrow_safe(a);
    let (b_cast) = narrow_safe(b);
    // call cairo contract function
    let (res_cast_rev) = Forwarder.add(0,a_cast,b_cast);
    // cast outputs
    let (res) = felt_to_uint256(res_cast_rev);
    return (res,);
}
```
