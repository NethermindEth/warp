## Interface Call Forwarder

This is a feature for the Warp transpiler to enable interaction between non-warped cairo contracts with a warped cairo contract _(cairo file generated after transpilation of a solidity contract)_.

```text
Usage: warp gen_interface [options] <file>

Options:
  --cairo-path <cairo-path>              Cairo libraries/modules import path
  --output <output>                      Output path for the generation of files
  --contract-address <contract-address>  Address at which cairo contract has been deployed
  --class-hash <class-hash>              Class hash of the cairo contract
  --solc-version <version>               Solc version to use. (default: "0.8.14")
  -h, --help                             display help for command
```

Assume you have a cairo contract `add.cairo`.

```js
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
bin/warp gen_interface a.cairo --contract-address `${addr}` --class_hash `${cairo_contract_class_hash}`
```

This command will generate two files in the directory where your cairo file (in this case `a.cairo`) is present.

- The generated cairo file which would look like as follows with name `a_forwarder.cairo`:

```js
%lang starknet

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin
from warplib.maths.utils import felt_to_uint256, narrow_safe
from warplib.maths.external_input_check_ints import warp_external_input_check_int256

@contract_interface
namespace Forwarder {
    func add(
        a: felt,
        b: felt,
    ) -> (res:felt){
    }
}

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
    let (res_cast_rev) = Forwarder.add(**${addr}**,a_cast,b_cast);
    // cast outputs
    let (res) = felt_to_uint256(res_cast_rev);
    return (res,);
}
```

- The generated solidity file (`a.sol`) would like as follows with

```solidity
pragma solidity ^0.8.14;

/// WARP-GENERATED
/// class_hash: 0x590f5d5d27ce148a5435e25097968f38b0fe3fe991147a784b1e5c2755c472a
interface Forwarder_a {
    function add(uint256 a, uint256 b) external returns (uint256 res);
}
```

### Step 2.

Declare and deploy the generated cairo file. More info at : [starknet declare&deploy cairo contracts](https://www.cairo-lang.org/docs/hello_starknet/intro.html#declare-the-contract-on-the-starknet-testnet) .

### Step 3.

Implement your logic using function generated inside a solidity interface object in the `a.sol`.

For example: `my_impl.sol` would be as follows:

```solidity
pragma solidity ^0.8.14;

import "./a.sol";

contract WARP{
    Forwarder_a public itr;
    function useAdd(uint a, uint b) public returns (uint res){
        return itr.add(a,b);
    }
}
```

### Step 4.

Transpile your solidity file using

```sh
bin/warp transpile /path/to/solc_file
```

to get corresponding cairo code.

This is a traspiled cairo output for `my_impl.sol`:

```js
%lang starknet

from warplib.maths.external_input_check_ints import warp_external_input_check_int256
from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.cairo_builtins import HashBuiltin

func WS0_READ_felt{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    loc: felt
) -> (val: felt) {
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
}

// Contract Def WARP

namespace WARP {
    // Dynamic variables - Arrays and Maps

    // Static variables

    const __warp_usrid_00_itr = 0;
}

@external
func useAdd_99bd125f{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}(
    __warp_usrid_01_a: Uint256, __warp_usrid_02_b: Uint256
) -> (__warp_usrid_03_res: Uint256) {
    alloc_locals;

    warp_external_input_check_int256(__warp_usrid_02_b);

    warp_external_input_check_int256(__warp_usrid_01_a);

    let (__warp_se_0) = WS0_READ_felt(WARP.__warp_usrid_00_itr);

    let (__warp_pse_0) = Forwarder_a_warped_interface.library_call_add_771602f7(
        0x590f5d5d27ce148a5435e25097968f38b0fe3fe991147a784b1e5c2755c472a,
        __warp_usrid_01_a,
        __warp_usrid_02_b,
    );

    return (__warp_pse_0,);
}

@view
func itr_2dd658c7{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() -> (
    __warp_usrid_04_: felt
) {
    alloc_locals;

    let (__warp_se_1) = WS0_READ_felt(WARP.__warp_usrid_00_itr);

    return (__warp_se_1,);
}

@constructor
func constructor{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr: felt}() {
    alloc_locals;
    WARP_USED_STORAGE.write(1);

    return ();
}


// Contract Def Forwarder_a@interface

@contract_interface
namespace Forwarder_a_warped_interface {
    func add_771602f7(__warp_usrid_00_a: Uint256, __warp_usrid_01_b: Uint256) -> (
        __warp_usrid_02_res: Uint256
    ) {
    }
}

// Original solidity abi: ["constructor()","useAdd(uint256,uint256)","itr()"]
```

### Step 5.

Compile & Deploy the transpiled output cairo contract and invoke the functions. More info about invoke to cairo contract : [cairo contract function invoke](https://www.cairo-lang.org/docs/hello_starknet/intro.html#interact-with-the-contract) .

For example:

```
starknet invoke \
    --address ${CONTRACT_ADDRESS} \
    --abi my_impl.json \
    --function useAdd_99bd125f \
    --inputs 12 0 13 0
```

## Running tests

For more detailed and implemented steps, you can look at the [interfaceForwarder.test.ts](../../tests/interfaceCallForwarder/interfaceForwarder.test.ts) file.

To execute interface call forwarder test, run `$ yarn test:forwarder`
