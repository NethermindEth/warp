Optimized IR:
/*=====================================================*
 *                       WARNING                       *
 *  Solidity to Yul compilation is still EXPERIMENTAL  *
 *       It can result in LOSS OF FUNDS or worse       *
 *                !USE AT YOUR OWN RISK!               *
 *=====================================================*/

/// @use-src 0:"ERC20.sol"
object "ERC20_295" {
    code {
        {
            /// @src 0:58:2759  "contract ERC20 {..."
            let _1 := 128
            let _2 := 64
            mstore(_2, _1)
            let _3 := callvalue()
            if _3
            {
                revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
            }
            let _4 := allocate_unbounded()
            let _5 := datasize("ERC20_295_deployed")
            let _6 := dataoffset("ERC20_295_deployed")
            codecopy(_4, _6, _5)
            return(_4, _5)
        }
        function allocate_unbounded() -> memPtr
        {
            let _1 := 64
            memPtr := mload(_1)
        }
        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
        {
            let _1 := 0
            let _2 := _1
            revert(_1, _1)
        }
    }
    /// @use-src 0:"ERC20.sol"
    object "ERC20_295_deployed" {
        code {
            {
                /// @src 0:58:2759  "contract ERC20 {..."
                let _1 := 128
                let _2 := 64
                mstore(_2, _1)
                let _3 := 4
                let _4 := calldatasize()
                let _5 := lt(_4, _3)
                let _6 := iszero(_5)
                if _6
                {
                    let _7 := 0
                    let _8 := calldataload(_7)
                    let _9 := shift_right_unsigned(_8)
                    switch _9
                    case 0x06b68323 {
                        let _10 := callvalue()
                        if _10
                        {
                            revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                        }
                        let _11 := _4
                        let param, param_1 := abi_decode_array_address_dyn_calldata_ptr(_4)
                        let ret := fun_balanceOf(param, param_1)
                        let memPos := allocate_unbounded()
                        let _12 := abi_encode_uint256(memPos, ret)
                        let _13 := sub(_12, memPos)
                        return(memPos, _13)
                    }
                    case 0x095ea7b3 {
                        let _14 := callvalue()
                        if _14
                        {
                            revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                        }
                        let _15 := _4
                        let param_2, param_3 := abi_decode_addresst_uint256(_4)
                        let ret_1 := fun_approve(param_2, param_3)
                        let memPos_1 := allocate_unbounded()
                        let _16 := abi_encode_bool(memPos_1, ret_1)
                        let _17 := sub(_16, memPos_1)
                        return(memPos_1, _17)
                    }
                    case 0x18160ddd {
                        let _18 := callvalue()
                        if _18
                        {
                            revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                        }
                        let _19 := _4
                        abi_decode(_4)
                        let ret_2 := fun_totalSupply()
                        let memPos_2 := allocate_unbounded()
                        let _20 := abi_encode_uint256(memPos_2, ret_2)
                        let _21 := sub(_20, memPos_2)
                        return(memPos_2, _21)
                    }
                    case 0x23b872dd {
                        let _22 := callvalue()
                        if _22
                        {
                            revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                        }
                        let _23 := _4
                        let param_4, param_5, param_6 := abi_decode_addresst_addresst_uint256(_4)
                        let ret_3 := fun_transferFrom(param_4, param_5, param_6)
                        let memPos_3 := allocate_unbounded()
                        let _24 := abi_encode_bool(memPos_3, ret_3)
                        let _25 := sub(_24, memPos_3)
                        return(memPos_3, _25)
                    }
                    case 0x313ce567 {
                        let _26 := callvalue()
                        if _26
                        {
                            revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                        }
                        let _27 := _4
                        abi_decode(_4)
                        let ret_4 := fun_decimals()
                        let memPos_4 := allocate_unbounded()
                        let _28 := abi_encode_uint8(memPos_4, ret_4)
                        let _29 := sub(_28, memPos_4)
                        return(memPos_4, _29)
                    }
                    case 0x39509351 {
                        let _30 := callvalue()
                        if _30
                        {
                            revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                        }
                        let _31 := _4
                        let param_7, param_8 := abi_decode_addresst_uint256(_4)
                        let ret_5 := fun_increaseAllowance(param_7, param_8)
                        let memPos_5 := allocate_unbounded()
                        let _32 := abi_encode_bool(memPos_5, ret_5)
                        let _33 := sub(_32, memPos_5)
                        return(memPos_5, _33)
                    }
                    case 0xa457c2d7 {
                        let _34 := callvalue()
                        if _34
                        {
                            revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                        }
                        let _35 := _4
                        let param_9, param_10 := abi_decode_addresst_uint256(_4)
                        let ret_6 := fun_decreaseAllowance(param_9, param_10)
                        let memPos_6 := allocate_unbounded()
                        let _36 := abi_encode_bool(memPos_6, ret_6)
                        let _37 := sub(_36, memPos_6)
                        return(memPos_6, _37)
                    }
                    case 0xa9059cbb {
                        let _38 := callvalue()
                        if _38
                        {
                            revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                        }
                        let _39 := _4
                        let param_11, param_12 := abi_decode_addresst_uint256(_4)
                        let ret_7 := fun_transfer_63(param_11, param_12)
                        let memPos_7 := allocate_unbounded()
                        let _40 := abi_encode_bool(memPos_7, ret_7)
                        let _41 := sub(_40, memPos_7)
                        return(memPos_7, _41)
                    }
                    case 0xdd62ed3e {
                        let _42 := callvalue()
                        if _42
                        {
                            revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                        }
                        let _43 := _4
                        let param_13, param_14 := abi_decode_addresst_address(_4)
                        let ret_8 := fun_allowance(param_13, param_14)
                        let memPos_8 := allocate_unbounded()
                        let _44 := abi_encode_uint256(memPos_8, ret_8)
                        let _45 := sub(_44, memPos_8)
                        return(memPos_8, _45)
                    }
                }
                revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
            }
            function shift_right_unsigned(value) -> newValue
            {
                let _1 := 224
                newValue := shr(_1, value)
            }
            function allocate_unbounded() -> memPtr
            {
                let _1 := 64
                memPtr := mload(_1)
            }
            function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
            {
                let _1 := 0
                let _2 := _1
                revert(_1, _1)
            }
            function abi_decode_array_address_dyn_calldata(offset, end) -> arrayPos, length
            {
                let _1 := 0x1f
                let _2 := add(offset, _1)
                let _3 := slt(_2, end)
                let _4 := iszero(_3)
                if _4
                {
                    revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                }
                length := calldataload(offset)
                let _5 := 0xffffffffffffffff
                let _6 := gt(length, _5)
                if _6
                {
                    revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                }
                let _7 := 0x20
                arrayPos := add(offset, _7)
                let _8 := _7
                let _9 := 5
                let _10 := shl(_9, length)
                let _11 := add(offset, _10)
                let _12 := add(_11, _7)
                let _13 := gt(_12, end)
                if _13
                {
                    revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                }
            }
            function abi_decode_array_address_dyn_calldata_ptr(dataEnd) -> value0, value1
            {
                let _1 := 32
                let _2 := not(3)
                let _3 := add(dataEnd, _2)
                let _4 := slt(_3, _1)
                if _4
                {
                    revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                }
                let _5 := 4
                let offset := calldataload(_5)
                let _6 := 0xffffffffffffffff
                let _7 := gt(offset, _6)
                if _7
                {
                    revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                }
                let _8 := _5
                let _9 := add(_5, offset)
                let value0_1, value1_1 := abi_decode_array_address_dyn_calldata(_9, dataEnd)
                value0 := value0_1
                value1 := value1_1
            }
            function cleanup_uint256_1552() -> cleaned
            {
                cleaned := /** @src 0:305:307  "18" */ 0x12
            }
            /// @src 0:58:2759  "contract ERC20 {..."
            function cleanup_uint256_1553() -> cleaned
            {
                cleaned := /** @src 0:504:513  "_balances" */ 0x00
            }
            /// @src 0:58:2759  "contract ERC20 {..."
            function cleanup_uint256(value) -> cleaned
            { cleaned := value }
            function abi_encode_uint256_to_uint256(value, pos)
            {
                let _1 := cleanup_uint256(value)
                mstore(pos, _1)
            }
            function abi_encode_uint256(headStart, value0) -> tail
            {
                let _1 := 32
                tail := add(headStart, _1)
                abi_encode_uint256_to_uint256(value0, headStart)
            }
            function cleanup_uint160(value) -> cleaned
            {
                let _1 := sub(shl(160, 1), 1)
                cleaned := and(value, _1)
            }
            function cleanup_address(value) -> cleaned
            {
                cleaned := cleanup_uint160(value)
            }
            function validator_revert_address(value)
            {
                let _1 := cleanup_address(value)
                let _2 := eq(value, _1)
                let _3 := iszero(_2)
                if _3
                {
                    let _4 := 0
                    let _5 := _4
                    revert(_4, _4)
                }
            }
            function abi_decode_address_2189() -> value
            {
                let _1 := 4
                value := calldataload(_1)
                validator_revert_address(value)
            }
            function abi_decode_address_2191() -> value
            {
                let _1 := 36
                value := calldataload(_1)
                validator_revert_address(value)
            }
            function abi_decode_address_328() -> value
            {
                value := abi_decode_address_2189()
            }
            function abi_decode_address_1539(end) -> value
            {
                value := abi_decode_address_328()
            }
            function abi_decode_address() -> value
            {
                value := abi_decode_address_2191()
            }
            function abi_decode_address_1548(end) -> value
            { value := abi_decode_address() }
            function validator_revert_uint256(value)
            {
                let _1 := cleanup_uint256(value)
                let _2 := eq(value, _1)
                let _3 := iszero(_2)
                if _3
                {
                    let _4 := 0
                    let _5 := _4
                    revert(_4, _4)
                }
            }
            function abi_decode_uint256_2194() -> value
            {
                let _1 := 36
                value := calldataload(_1)
                validator_revert_uint256(value)
            }
            function abi_decode_uint256_2195() -> value
            {
                let _1 := 68
                value := calldataload(_1)
                validator_revert_uint256(value)
            }
            function abi_decode_uint256() -> value
            {
                value := abi_decode_uint256_2194()
            }
            function abi_decode_uint256_1540(end) -> value
            { value := abi_decode_uint256() }
            function abi_decode_uint256_1549() -> value
            {
                value := abi_decode_uint256_2195()
            }
            function abi_decode_uint256_1549_1785(end) -> value
            {
                value := abi_decode_uint256_1549()
            }
            function abi_decode_addresst_uint256(dataEnd) -> value0, value1
            {
                let _1 := 64
                let _2 := not(3)
                let _3 := add(dataEnd, _2)
                let _4 := slt(_3, _1)
                if _4
                {
                    revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                }
                value0 := abi_decode_address_1539(dataEnd)
                value1 := abi_decode_uint256_1540(dataEnd)
            }
            function cleanup_bool(value) -> cleaned
            {
                let _1 := iszero(value)
                cleaned := iszero(_1)
            }
            function abi_encode_bool_to_bool(value, pos)
            {
                let _1 := cleanup_bool(value)
                mstore(pos, _1)
            }
            function abi_encode_bool(headStart, value0) -> tail
            {
                let _1 := 32
                tail := add(headStart, _1)
                abi_encode_bool_to_bool(value0, headStart)
            }
            function abi_decode(dataEnd)
            {
                let _1 := 0
                let _2 := not(3)
                let _3 := add(dataEnd, _2)
                let _4 := slt(_3, _1)
                if _4
                {
                    revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                }
            }
            function abi_decode_addresst_addresst_uint256(dataEnd) -> value0, value1, value2
            {
                let _1 := 96
                let _2 := not(3)
                let _3 := add(dataEnd, _2)
                let _4 := slt(_3, _1)
                if _4
                {
                    revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                }
                value0 := abi_decode_address_1539(dataEnd)
                value1 := abi_decode_address_1548(dataEnd)
                value2 := abi_decode_uint256_1549_1785(dataEnd)
            }
            function cleanup_uint8(value) -> cleaned
            {
                let _1 := 0xff
                cleaned := and(value, _1)
            }
            function abi_encode_uint8_to_uint8(value, pos)
            {
                let _1 := cleanup_uint8(value)
                mstore(pos, _1)
            }
            function abi_encode_uint8(headStart, value0) -> tail
            {
                let _1 := 32
                tail := add(headStart, _1)
                abi_encode_uint8_to_uint8(value0, headStart)
            }
            function abi_decode_addresst_address(dataEnd) -> value0, value1
            {
                let _1 := 64
                let _2 := not(3)
                let _3 := add(dataEnd, _2)
                let _4 := slt(_3, _1)
                if _4
                {
                    revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                }
                value0 := abi_decode_address_1539(dataEnd)
                value1 := abi_decode_address_1548(dataEnd)
            }
            function convert_rational_by_to_uint8() -> converted
            {
                let _1 := cleanup_uint256_1552()
                let _2 := cleanup_uint256(_1)
                converted := cleanup_uint8(_2)
            }
            /// @ast-id 21 @src 0:240:314  "function decimals() public view returns (uint8) {..."
            function fun_decimals() -> var
            {
                /// @src 0:298:307  "return 18"
                var := convert_rational_by_to_uint8()
            }
            /// @src 0:58:2759  "contract ERC20 {..."
            function extract_from_storage_value_offsett_uint256(slot_value) -> value
            {
                let _1 := cleanup_uint256(slot_value)
                value := cleanup_uint256(_1)
            }
            function read_from_storage_split_offset_uint256_691() -> value
            {
                /// @src 0:390:402  "_totalSupply"
                let _1 := 0x02
                /// @src 0:58:2759  "contract ERC20 {..."
                let _2 := sload(/** @src 0:390:402  "_totalSupply" */ _1)
                /// @src 0:58:2759  "contract ERC20 {..."
                value := extract_from_storage_value_offsett_uint256(_2)
            }
            function read_from_storage_split_offset_uint256(slot) -> value
            {
                let _1 := sload(slot)
                value := extract_from_storage_value_offsett_uint256(_1)
            }
            /// @ast-id 29 @src 0:320:409  "function totalSupply() public view returns (uint256) {..."
            function fun_totalSupply() -> var_
            {
                /// @src 0:383:402  "return _totalSupply"
                var_ := /** @src 0:390:402  "_totalSupply" */ read_from_storage_split_offset_uint256_691()
            }
            /// @src 0:58:2759  "contract ERC20 {..."
            function panic_error_0x32()
            {
                let _1 := shl(224, 0x4e487b71)
                let _2 := 0
                mstore(_2, _1)
                let _3 := 0x32
                let _4 := 4
                mstore(_4, _3)
                let _5 := 0x24
                let _6 := _2
                revert(_2, _5)
            }
            function calldata_array_index_access_address_dyn_calldata(base_ref, length, index) -> addr
            {
                let _1 := lt(index, length)
                let _2 := iszero(_1)
                if _2 { panic_error_0x32() }
                let _3 := 5
                let _4 := shl(_3, index)
                addr := add(base_ref, _4)
            }
            function convert_rational_by_to_uint256_692() -> converted
            {
                let _1 := cleanup_uint256_1553()
                let _2 := cleanup_uint256(_1)
                converted := cleanup_uint256(_2)
            }
            function convert_rational_by_to_uint256(value) -> converted
            {
                let _1 := cleanup_uint256(value)
                let _2 := cleanup_uint256(_1)
                converted := cleanup_uint256(_2)
            }
            function read_from_calldatat_address(ptr) -> returnValue
            {
                let value := calldataload(ptr)
                validator_revert_address(value)
                returnValue := value
            }
            function convert_uint160_to_uint160(value) -> converted
            {
                let _1 := cleanup_uint160(value)
                let _2 := cleanup_uint256(_1)
                converted := cleanup_uint160(_2)
            }
            function convert_uint160_to_address(value) -> converted
            {
                converted := convert_uint160_to_uint160(value)
            }
            function convert_address_to_address(value) -> converted
            {
                converted := convert_uint160_to_address(value)
            }
            function mapping_index_access_mapping_address_uint256_of_address_693(key) -> dataSlot
            {
                let _1 := convert_address_to_address(key)
                /// @src 0:504:513  "_balances"
                let _2 := 0x00
                /// @src 0:58:2759  "contract ERC20 {..."
                mstore(/** @src 0:504:513  "_balances" */ _2, /** @src 0:58:2759  "contract ERC20 {..." */ _1)
                /// @src 0:504:513  "_balances"
                let _3 := _2
                /// @src 0:58:2759  "contract ERC20 {..."
                let _4 := 0x20
                mstore(_4, /** @src 0:504:513  "_balances" */ _2)
                /// @src 0:58:2759  "contract ERC20 {..."
                let _5 := 0x40
                /// @src 0:504:513  "_balances"
                let _6 := _2
                /// @src 0:58:2759  "contract ERC20 {..."
                dataSlot := keccak256(/** @src 0:504:513  "_balances" */ _2, /** @src 0:58:2759  "contract ERC20 {..." */ _5)
            }
            function mapping_index_access_mapping_address_uint256_of_address_694(key) -> dataSlot
            {
                let _1 := convert_address_to_address(key)
                let _2 := 0
                mstore(_2, _1)
                /// @src 0:795:806  "_allowances"
                let _3 := 0x01
                /// @src 0:58:2759  "contract ERC20 {..."
                let _4 := 0x20
                mstore(_4, /** @src 0:795:806  "_allowances" */ _3)
                /// @src 0:58:2759  "contract ERC20 {..."
                let _5 := 0x40
                let _6 := _2
                dataSlot := keccak256(_2, _5)
            }
            function mapping_index_access_mapping_address_uint256_of_address(slot, key) -> dataSlot
            {
                let _1 := convert_address_to_address(key)
                let _2 := 0
                mstore(_2, _1)
                let _3 := 0x20
                mstore(_3, slot)
                let _4 := 0x40
                let _5 := _2
                dataSlot := keccak256(_2, _4)
            }
            /// @ast-id 44 @src 0:415:532  "function balanceOf(address[] calldata account) public returns (uint256) {..."
            function fun_balanceOf(IS_WARPED_CALLER, calldata_len, calldata) -> var
            {
                let _10 := callvalue()
                if _10
                {
                    revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
                }
                switch IS_WARPED_CALLER 
                case 0 {

                }
                let calldata_size := calldatasize()
                let _11 := _4
                let param, param_1 := abi_decode_array_address_dyn_calldata_ptr(calldatasize)
                /// @src 0:514:524  "account[0]"
                let _1 := convert_rational_by_to_uint256_692()
                let _2 := calldata_array_index_access_address_dyn_calldata(var_account_offset, var_account_length, _1)
                let _3 := read_from_calldatat_address(_2)
                /// @src 0:504:525  "_balances[account[0]]"
                let _4 := mapping_index_access_mapping_address_uint256_of_address_693(/** @src 0:514:524  "account[0]" */ _3)
                /// @src 0:497:525  "return _balances[account[0]]"
                var := /** @src 0:504:525  "_balances[account[0]]" */ read_from_storage_split_offset_uint256(_4)
            }
            /// @ast-id 63 @src 0:538:691  "function transfer(address recipient, uint256 amount) public returns (bool) {..."
            function fun_transfer_63(var_recipient, var_amount) -> var
            {
                /// @src 0:633:643  "msg.sender"
                let _1 := caller()
                /// @src 0:656:662  "amount"
                fun_transfer(/** @src 0:633:643  "msg.sender" */ _1, /** @src 0:656:662  "amount" */ var_recipient, var_amount)
                /// @src 0:673:684  "return true"
                var := /** @src 0:680:684  "true" */ 0x01
            }
            /// @ast-id 79 @src 0:697:829  "function allowance(address owner, address spender) public view returns (uint256) {..."
            function fun_allowance(var_owner, var_spender) -> var
            {
                /// @src 0:795:813  "_allowances[owner]"
                let _1 := mapping_index_access_mapping_address_uint256_of_address_694(var_owner)
                /// @src 0:795:822  "_allowances[owner][spender]"
                let _2 := mapping_index_access_mapping_address_uint256_of_address(/** @src 0:795:813  "_allowances[owner]" */ _1, /** @src 0:795:822  "_allowances[owner][spender]" */ var_spender)
                /// @src 0:788:822  "return _allowances[owner][spender]"
                var := /** @src 0:795:822  "_allowances[owner][spender]" */ read_from_storage_split_offset_uint256(_2)
            }
            /// @ast-id 98 @src 0:835:982  "function approve(address spender, uint256 amount) public returns (bool) {..."
            function fun_approve(var_spender, var_amount) -> var
            {
                /// @src 0:926:936  "msg.sender"
                let _1 := caller()
                /// @src 0:947:953  "amount"
                fun__approve(/** @src 0:926:936  "msg.sender" */ _1, /** @src 0:947:953  "amount" */ var_spender, var_amount)
                /// @src 0:964:975  "return true"
                var := /** @src 0:971:975  "true" */ 0x01
            }
            /// @src 0:58:2759  "contract ERC20 {..."
            function require_helper(condition)
            {
                let _1 := iszero(condition)
                if _1
                {
                    let _2 := 0
                    let _3 := _2
                    revert(_2, _2)
                }
            }
            function wrapping_sub_uint256(x, y) -> diff
            {
                let _1 := sub(x, y)
                diff := cleanup_uint256(_1)
            }
            /// @ast-id 143 @src 0:988:1401  "function transferFrom(..."
            function fun_transferFrom(var_sender, var_recipient, var_amount) -> var
            {
                /// @src 0:1152:1158  "amount"
                fun_transfer(var_sender, var_recipient, var_amount)
                /// @src 0:1197:1216  "_allowances[sender]"
                let _1 := mapping_index_access_mapping_address_uint256_of_address_694(var_sender)
                /// @src 0:1217:1227  "msg.sender"
                let _2 := caller()
                /// @src 0:1197:1228  "_allowances[sender][msg.sender]"
                let _3 := mapping_index_access_mapping_address_uint256_of_address(_1, /** @src 0:1217:1227  "msg.sender" */ _2)
                /// @src 0:1197:1228  "_allowances[sender][msg.sender]"
                let _4 := read_from_storage_split_offset_uint256(_3)
                /// @src 0:1246:1272  "currentAllowance >= amount"
                let _5 := cleanup_uint256(var_amount)
                let _6 := cleanup_uint256(_4)
                let _7 := lt(_6, _5)
                let _8 := iszero(_7)
                /// @src 0:1238:1273  "require(currentAllowance >= amount)"
                require_helper(/** @src 0:1246:1272  "currentAllowance >= amount" */ _8)
                /// @src 0:1336:1361  "currentAllowance - amount"
                let _9 := wrapping_sub_uint256(_4, var_amount)
                /// @src 0:1217:1227  "msg.sender"
                let _10 := _2
                /// @src 0:1336:1361  "currentAllowance - amount"
                fun__approve(var_sender, /** @src 0:1217:1227  "msg.sender" */ _2, /** @src 0:1336:1361  "currentAllowance - amount" */ _9)
                /// @src 0:1383:1394  "return true"
                var := /** @src 0:1197:1208  "_allowances" */ 0x01
            }
            /// @src 0:58:2759  "contract ERC20 {..."
            function panic_error_0x11()
            {
                let _1 := shl(224, 0x4e487b71)
                let _2 := 0
                mstore(_2, _1)
                let _3 := 0x11
                let _4 := 4
                mstore(_4, _3)
                let _5 := 0x24
                let _6 := _2
                revert(_2, _5)
            }
            function checked_add_uint256(x, y) -> sum
            {
                let x_1 := cleanup_uint256(x)
                let y_1 := cleanup_uint256(y)
                let _1 := not(y_1)
                let _2 := gt(x_1, _1)
                if _2 { panic_error_0x11() }
                sum := add(x_1, y_1)
            }
            /// @ast-id 169 @src 0:1407:1607  "function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {..."
            function fun_increaseAllowance(var_spender, var_addedValue) -> var
            {
                /// @src 0:1512:1522  "msg.sender"
                let _1 := caller()
                /// @src 0:1533:1556  "_allowances[msg.sender]"
                let _2 := mapping_index_access_mapping_address_uint256_of_address_694(/** @src 0:1512:1522  "msg.sender" */ _1)
                /// @src 0:1533:1565  "_allowances[msg.sender][spender]"
                let _3 := mapping_index_access_mapping_address_uint256_of_address(/** @src 0:1533:1556  "_allowances[msg.sender]" */ _2, /** @src 0:1533:1565  "_allowances[msg.sender][spender]" */ var_spender)
                let _4 := read_from_storage_split_offset_uint256(_3)
                /// @src 0:1533:1578  "_allowances[msg.sender][spender] + addedValue"
                let _5 := checked_add_uint256(/** @src 0:1533:1565  "_allowances[msg.sender][spender]" */ _4, /** @src 0:1533:1578  "_allowances[msg.sender][spender] + addedValue" */ var_addedValue)
                /// @src 0:1512:1522  "msg.sender"
                let _6 := _1
                /// @src 0:1533:1578  "_allowances[msg.sender][spender] + addedValue"
                fun__approve(/** @src 0:1512:1522  "msg.sender" */ _1, /** @src 0:1533:1578  "_allowances[msg.sender][spender] + addedValue" */ var_spender, _5)
                /// @src 0:1589:1600  "return true"
                var := /** @src 0:1533:1544  "_allowances" */ 0x01
            }
            /// @ast-id 206 @src 0:1613:1965  "function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {..."
            function fun_decreaseAllowance(var_spender, var_subtractedValue) -> var
            {
                /// @src 0:1753:1763  "msg.sender"
                let _1 := caller()
                /// @src 0:1741:1764  "_allowances[msg.sender]"
                let _2 := mapping_index_access_mapping_address_uint256_of_address_694(/** @src 0:1753:1763  "msg.sender" */ _1)
                /// @src 0:1741:1773  "_allowances[msg.sender][spender]"
                let _3 := mapping_index_access_mapping_address_uint256_of_address(/** @src 0:1741:1764  "_allowances[msg.sender]" */ _2, /** @src 0:1741:1773  "_allowances[msg.sender][spender]" */ var_spender)
                let _4 := read_from_storage_split_offset_uint256(_3)
                /// @src 0:1791:1826  "currentAllowance >= subtractedValue"
                let _5 := cleanup_uint256(var_subtractedValue)
                let _6 := cleanup_uint256(_4)
                let _7 := lt(_6, _5)
                let _8 := iszero(_7)
                /// @src 0:1783:1827  "require(currentAllowance >= subtractedValue)"
                require_helper(/** @src 0:1791:1826  "currentAllowance >= subtractedValue" */ _8)
                /// @src 0:1891:1925  "currentAllowance - subtractedValue"
                let _9 := wrapping_sub_uint256(_4, var_subtractedValue)
                /// @src 0:1753:1763  "msg.sender"
                let _10 := _1
                /// @src 0:1891:1925  "currentAllowance - subtractedValue"
                fun__approve(/** @src 0:1753:1763  "msg.sender" */ _1, /** @src 0:1891:1925  "currentAllowance - subtractedValue" */ var_spender, _9)
                /// @src 0:1947:1958  "return true"
                var := /** @src 0:1741:1752  "_allowances" */ 0x01
            }
            /// @src 0:58:2759  "contract ERC20 {..."
            function update_byte_slice_shift(value, toInsert) -> result
            {
                result := cleanup_uint256(toInsert)
            }
            function update_storage_value_offsett_uint256_to_uint256(slot, value)
            {
                let _1 := convert_rational_by_to_uint256(value)
                let _2 := cleanup_uint256(_1)
                let _3 := sload(slot)
                let _4 := update_byte_slice_shift(_3, _2)
                sstore(slot, _4)
            }
            /// @ast-id 243 @src 0:1971:2306  "function _transfer(..."
            function fun_transfer(var_sender, var_recipient, var_amount)
            {
                /// @src 0:2114:2131  "_balances[sender]"
                let _1 := mapping_index_access_mapping_address_uint256_of_address_693(var_sender)
                let _2 := read_from_storage_split_offset_uint256(_1)
                /// @src 0:2149:2172  "senderBalance >= amount"
                let _3 := cleanup_uint256(var_amount)
                let _4 := cleanup_uint256(_2)
                let _5 := lt(_4, _3)
                let _6 := iszero(_5)
                /// @src 0:2141:2173  "require(senderBalance >= amount)"
                require_helper(/** @src 0:2149:2172  "senderBalance >= amount" */ _6)
                /// @src 0:2227:2249  "senderBalance - amount"
                let _7 := wrapping_sub_uint256(_2, var_amount)
                /// @src 0:2207:2224  "_balances[sender]"
                let _8 := mapping_index_access_mapping_address_uint256_of_address_693(var_sender)
                /// @src 0:2207:2249  "_balances[sender] = senderBalance - amount"
                update_storage_value_offsett_uint256_to_uint256(/** @src 0:2207:2224  "_balances[sender]" */ _8, /** @src 0:2227:2249  "senderBalance - amount" */ _7)
                /// @src 0:2269:2289  "_balances[recipient]"
                let _9 := mapping_index_access_mapping_address_uint256_of_address_693(var_recipient)
                /// @src 0:2269:2299  "_balances[recipient] += amount"
                let _10 := read_from_storage_split_offset_uint256(_9)
                let _11 := checked_add_uint256(_10, var_amount)
                update_storage_value_offsett_uint256_to_uint256(_9, _11)
            }
            /// @ast-id 294 @src 0:2598:2756  "function _approve(..."
            function fun__approve(var_owner, var_spender, var_amount)
            {
                /// @src 0:2713:2731  "_allowances[owner]"
                let _1 := mapping_index_access_mapping_address_uint256_of_address_694(var_owner)
                /// @src 0:2713:2740  "_allowances[owner][spender]"
                let _2 := mapping_index_access_mapping_address_uint256_of_address(/** @src 0:2713:2731  "_allowances[owner]" */ _1, /** @src 0:2713:2740  "_allowances[owner][spender]" */ var_spender)
                /// @src 0:2713:2749  "_allowances[owner][spender] = amount"
                update_storage_value_offsett_uint256_to_uint256(/** @src 0:2713:2740  "_allowances[owner][spender]" */ _2, /** @src 0:2713:2749  "_allowances[owner][spender] = amount" */ var_amount)
            }
        }
        data ".metadata" hex"a36469706673582212206f7134087bda80144bf7b3d1840079dcc22032fb7b9b5650d799ca65a4a286336c6578706572696d656e74616cf564736f6c63430008090041"
    }
}

