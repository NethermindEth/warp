@test "check examples/composability" {
    warp transpile ./examples/composability/c2c.sol WARP
    warp transpile ./examples/composability/ERC20.sol WARP
    warp deploy ./examples/composability/c2c.json
    warp deploy ./examples/composability/ERC20.json
    warp invoke \
         --program ./examples/composability/c2c.json \
         --address 0x000a55825088d5db74b047067145bd83f78b81fd2bf755689fdee922c25bfd7e \
         --function gimmeMoney \
         --inputs "[0x021b880238a1754a51f7e7c0df7e0d9fcbf0baa7ceba0a624258f6ffcca21b4f,
                    0x04a08ffac5d97be9bdf7f05b2d74ee5589b70ca0797b5eaa2a44aff606835559]"
    rm ./examples/composability/c2c.json
    rm ./examples/composability/ERC20.json
}

@test "check constructor_dyn.sol" {
    warp transpile ./tests/yul/constructors_dyn.sol WARP
    warp deploy ./tests/yul/constructors_dyn.json --constructor_args "[0x123, (12, 15), 17]"
    rm ./tests/yul/constructors_dyn.json
}

@test "check constructor_nonDyn.sol" {
    warp transpile ./tests/yul/constructors_nonDyn.sol WARP
    warp deploy ./tests/yul/constructors_nonDyn.json --constructor_args "[0x123, 15, 17]"
    rm ./tests/yul/constructors_nonDyn.json
}
