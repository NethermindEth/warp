Optimized IR:
/*=====================================================*
 *                       WARNING                       *
 *  Solidity to Yul compilation is still EXPERIMENTAL  *
 *       It can result in LOSS OF FUNDS or worse       *
 *                !USE AT YOUR OWN RISK!               *
 *=====================================================*/

/// @use-src 0:"ERC20.sol"
object "ERC20_325" {
    code {
        {
            /// @src 0:58:3044  "contract ERC20 {..."
            let _1 := 128
            let _2 := 64
            mstore(_2, _1)
            let _3 := callvalue()
            if _3
            {
                revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
            }
            let _4 := datasize("ERC20_325_deployed")
            let _5 := dataoffset("ERC20_325_deployed")
            let _6 := _1
            codecopy(_1, _5, _4)
            let _7 := _1
            return(_1, _4)
        }
        function revert_error_ca66f745a3ce8ff40e2ccaf1ad45db7774001b90d25810abd9040049be7bf4bb()
        {
            let _1 := 0
            let _2 := _1
            revert(_1, _1)
        }
    }
    /// @use-src 0:"ERC20.sol"
    object "ERC20_325_deployed" {
        code {
            {
                /// @src 0:58:3044  "contract ERC20 {..."
                let _1 := 64
                let _2 := 128
                mstore(_1, _2)
                let _3 := 4
                let _4 := calldatasize()
                let _5 := lt(_4, _3)
                let _6 := iszero(_5)
                if _6
                {
                    let _7 := 0
                    let _8 := calldataload(_7)
                    let _9 := 224
                    let _10 := shr(_9, _8)
                    switch _10
                    case 0x06b68323 {
                        let _11 := _4
                        let param, param_1 := abi_decode_array_address_dyn_calldata_ptr(_4)
                        let ret := fun_balanceOf(param, param_1)
                        let memPos := mload(_1)
                        let _12 := abi_encode_uint256(memPos, ret)
                        let _13 := sub(_12, memPos)
                        return(memPos, _13)
                    }
                    case 0x095ea7b3 {
                        let _14 := _4
                        let param_2, param_3 := abi_decode_addresst_uint256(_4)
                        let ret_1 := fun_approve(param_2, param_3)
                        let memPos_1 := mload(_1)
                        let _15 := abi_encode_bool(memPos_1, ret_1)
                        let _16 := sub(_15, memPos_1)
                        return(memPos_1, _16)
                    }
                    case 0x18160ddd {
                        let _17 := callvalue()
                        if _17
                        {
                            revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
                        }
                        let _18 := _4
                        abi_decode(_4)
                        /// @src 0:417:429  "_totalSupply"
                        let _19 := 0x02
                        /// @src 0:58:3044  "contract ERC20 {..."
                        let _20 := sload(/** @src 0:417:429  "_totalSupply" */ _19)
                        /// @src 0:58:3044  "contract ERC20 {..."
                        let ret_2 := extract_from_storage_value_offsett_uint256(_20)
                        let memPos_2 := mload(_1)
                        let _21 := abi_encode_uint256(memPos_2, ret_2)
                        let _22 := sub(_21, memPos_2)
                        return(memPos_2, _22)
                    }
                    case 0x23b872dd {
                        let _23 := _4
                        let param_4, param_5, param_6 := abi_decode_addresst_addresst_uint256(_4)
                        let ret_3 := fun_transferFrom(param_4, param_5, param_6)
                        let memPos_3 := mload(_1)
                        let _24 := abi_encode_bool(memPos_3, ret_3)
                        let _25 := sub(_24, memPos_3)
                        return(memPos_3, _25)
                    }
                    case 0x313ce567 {
                        let _26 := callvalue()
                        if _26
                        {
                            revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
                        }
                        let _27 := _4
                        abi_decode(_4)
                        let memPos_4 := mload(_1)
                        let _28 := abi_encode_uint8(memPos_4)
                        let _29 := sub(_28, memPos_4)
                        return(memPos_4, _29)
                    }
                    case 0x39509351 {
                        let _30 := _4
                        let param_7, param_8 := abi_decode_addresst_uint256(_4)
                        let ret_4 := fun_increaseAllowance(param_7, param_8)
                        let memPos_5 := mload(_1)
                        let _31 := abi_encode_bool(memPos_5, ret_4)
                        let _32 := sub(_31, memPos_5)
                        return(memPos_5, _32)
                    }
                    case 0x40c10f19 {
                        let _33 := _4
                        let param_9, param_10 := abi_decode_addresst_uint256(_4)
                        fun_mint(param_9, param_10)
                        let _34 := _7
                        let _35 := mload(_1)
                        return(_35, _7)
                    }
                    case 0xa457c2d7 {
                        let _36 := _4
                        let param_11, param_12 := abi_decode_addresst_uint256(_4)
                        let ret_5 := fun_decreaseAllowance(param_11, param_12)
                        let memPos_6 := mload(_1)
                        let _37 := abi_encode_bool(memPos_6, ret_5)
                        let _38 := sub(_37, memPos_6)
                        return(memPos_6, _38)
                    }
                    case 0xa9059cbb {
                        let _39 := _4
                        let param_13, param_14 := abi_decode_addresst_uint256(_4)
                        let ret_6 := fun_transfer_79(param_13, param_14)
                        let memPos_7 := mload(_1)
                        let _40 := abi_encode_bool(memPos_7, ret_6)
                        let _41 := sub(_40, memPos_7)
                        return(memPos_7, _41)
                    }
                    case 0xab77262c {
                        let _42 := _4
                        let _43 := abi_decode_uint256(_4)
                        fun_setBday(_43)
                        let _44 := _7
                        let _45 := mload(_1)
                        return(_45, _7)
                    }
                    case 0xdd62ed3e {
                        let _46 := callvalue()
                        if _46
                        {
                            revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
                        }
                        let _47 := _4
                        let param_15, param_16 := abi_decode_addresst_address(_4)
                        /// @src 0:945:963  "_allowances[owner]"
                        let _48 := mapping_index_access_mapping_address_uint256_of_address_660(/** @src 0:58:3044  "contract ERC20 {..." */ param_15)
                        /// @src 0:945:972  "_allowances[owner][spender]"
                        let _49 := mapping_index_access_mapping_address_uint256_of_address(/** @src 0:945:963  "_allowances[owner]" */ _48, /** @src 0:58:3044  "contract ERC20 {..." */ param_16)
                        let ret_7 := /** @src 0:945:972  "_allowances[owner][spender]" */ read_from_storage_split_offset_uint256(_49)
                        /// @src 0:58:3044  "contract ERC20 {..."
                        let memPos_8 := mload(_1)
                        let _50 := abi_encode_uint256(memPos_8, ret_7)
                        let _51 := sub(_50, memPos_8)
                        return(memPos_8, _51)
                    }
                }
                revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
            }
            function revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
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
                    revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
                }
                length := calldataload(offset)
                let _5 := 0xffffffffffffffff
                let _6 := gt(length, _5)
                if _6
                {
                    revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
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
                    revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
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
                    revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
                }
                let _5 := 4
                let offset := calldataload(_5)
                let _6 := 0xffffffffffffffff
                let _7 := gt(offset, _6)
                if _7
                {
                    revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
                }
                let _8 := _5
                let _9 := add(_5, offset)
                let value0_1, value1_1 := abi_decode_array_address_dyn_calldata(_9, dataEnd)
                value0 := value0_1
                value1 := value1_1
            }
            function abi_encode_uint256_to_uint256(value, pos)
            { mstore(pos, value) }
            function abi_encode_uint256(headStart, value0) -> tail
            {
                let _1 := 32
                tail := add(headStart, _1)
                abi_encode_uint256_to_uint256(value0, headStart)
            }
            function validator_revert_address(value)
            {
                let _1 := sub(shl(160, 1), 1)
                let _2 := and(value, _1)
                let _3 := eq(value, _2)
                let _4 := iszero(_3)
                if _4
                {
                    let _5 := 0
                    let _6 := _5
                    revert(_5, _5)
                }
            }
            function abi_decode_address_1523() -> value
            {
                let _1 := 4
                value := calldataload(_1)
                validator_revert_address(value)
            }
            function abi_decode_address() -> value
            {
                let _1 := 36
                value := calldataload(_1)
                validator_revert_address(value)
            }
            function abi_decode_addresst_uint256(dataEnd) -> value0, value1
            {
                let _1 := 64
                let _2 := not(3)
                let _3 := add(dataEnd, _2)
                let _4 := slt(_3, _1)
                if _4
                {
                    revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
                }
                value0 := abi_decode_address_1523()
                let _5 := 36
                value1 := calldataload(_5)
            }
            function abi_encode_bool_to_bool(value, pos)
            {
                let _1 := iszero(value)
                let _2 := iszero(_1)
                mstore(pos, _2)
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
                    revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
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
                    revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
                }
                value0 := abi_decode_address_1523()
                value1 := abi_decode_address()
                let _5 := 68
                value2 := calldataload(_5)
            }
            function abi_encode_uint8_to_uint8(pos)
            {
                /// @src 0:332:334  "18"
                let _1 := 0x12
                /// @src 0:58:3044  "contract ERC20 {..."
                mstore(pos, /** @src 0:332:334  "18" */ _1)
            }
            /// @src 0:58:3044  "contract ERC20 {..."
            function abi_encode_uint8(headStart) -> tail
            {
                let _1 := 32
                tail := add(headStart, _1)
                abi_encode_uint8_to_uint8(headStart)
            }
            function abi_decode_uint256(dataEnd) -> value0
            {
                let _1 := 32
                let _2 := not(3)
                let _3 := add(dataEnd, _2)
                let _4 := slt(_3, _1)
                if _4
                {
                    revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
                }
                let _5 := 4
                value0 := calldataload(_5)
            }
            function abi_decode_addresst_address(dataEnd) -> value0, value1
            {
                let _1 := 64
                let _2 := not(3)
                let _3 := add(dataEnd, _2)
                let _4 := slt(_3, _1)
                if _4
                {
                    revert_error_dbdddcbe895c83990c08b3492a0e83918d802a52331272ac6fdb6a7c4aea3b1b()
                }
                value0 := abi_decode_address_1523()
                value1 := abi_decode_address()
            }
            function extract_from_storage_value_offsett_uint256(slot_value) -> value
            { value := slot_value }
            function read_from_storage_split_offset_uint256(slot) -> value
            {
                let _1 := sload(slot)
                value := extract_from_storage_value_offsett_uint256(_1)
            }
            function update_byte_slice_shift_1985(value) -> result
            {
                result := /** @src 0:622:628  "180595" */ 0x02c173
            }
            /// @src 0:58:3044  "contract ERC20 {..."
            function update_byte_slice_shift(value, toInsert) -> result
            { result := toInsert }
            function update_storage_value_offsett_uint256_to_uint256_1532()
            {
                /// @src 0:498:512  "bday = newBday"
                let _1 := 0x03
                /// @src 0:58:3044  "contract ERC20 {..."
                let _2 := sload(/** @src 0:498:512  "bday = newBday" */ _1)
                /// @src 0:58:3044  "contract ERC20 {..."
                let _3 := update_byte_slice_shift_1985(_2)
                /// @src 0:498:512  "bday = newBday"
                let _4 := _1
                /// @src 0:58:3044  "contract ERC20 {..."
                sstore(/** @src 0:498:512  "bday = newBday" */ _1, /** @src 0:58:3044  "contract ERC20 {..." */ _3)
            }
            function update_storage_value_offsett_uint256_to_uint256_661(value)
            {
                /// @src 0:498:512  "bday = newBday"
                let _1 := 0x03
                /// @src 0:58:3044  "contract ERC20 {..."
                let _2 := sload(/** @src 0:498:512  "bday = newBday" */ _1)
                /// @src 0:58:3044  "contract ERC20 {..."
                let _3 := update_byte_slice_shift(_2, value)
                /// @src 0:498:512  "bday = newBday"
                let _4 := _1
                /// @src 0:58:3044  "contract ERC20 {..."
                sstore(/** @src 0:498:512  "bday = newBday" */ _1, /** @src 0:58:3044  "contract ERC20 {..." */ _3)
            }
            function update_storage_value_offsett_uint256_to_uint256(slot, value)
            {
                let _1 := sload(slot)
                let _2 := update_byte_slice_shift(_1, value)
                sstore(slot, _2)
            }
            /// @ast-id 41 @src 0:442:519  "function setBday(uint newBday) public payable {..."
            function fun_setBday_662()
            {
                /// @src 0:498:512  "bday = newBday"
                update_storage_value_offsett_uint256_to_uint256_1532()
            }
            /// @ast-id 41 @src 0:442:519  "function setBday(uint newBday) public payable {..."
            function fun_setBday(var_newBday)
            {
                /// @src 0:498:512  "bday = newBday"
                update_storage_value_offsett_uint256_to_uint256_661(var_newBday)
            }
            /// @src 0:58:3044  "contract ERC20 {..."
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
            function calldata_array_index_access_address_dyn_calldata(base_ref, length) -> addr
            {
                let _1 := iszero(length)
                if _1 { panic_error_0x32() }
                addr := base_ref
            }
            function read_from_calldatat_address(ptr) -> returnValue
            {
                let value := calldataload(ptr)
                validator_revert_address(value)
                returnValue := value
            }
            function mapping_index_access_mapping_address_uint256_of_address_660(key) -> dataSlot
            {
                let _1 := sub(shl(160, 1), 1)
                let _2 := and(key, _1)
                let _3 := 0
                mstore(_3, _2)
                /// @src 0:945:956  "_allowances"
                let _4 := 0x01
                /// @src 0:58:3044  "contract ERC20 {..."
                let _5 := 0x20
                mstore(_5, /** @src 0:945:956  "_allowances" */ _4)
                /// @src 0:58:3044  "contract ERC20 {..."
                let _6 := 0x40
                let _7 := _3
                dataSlot := keccak256(_3, _6)
            }
            function mapping_index_access_mapping_address_uint256_of_address_664(key) -> dataSlot
            {
                let _1 := sub(shl(160, 1), 1)
                let _2 := and(key, _1)
                /// @src 0:646:655  "_balances"
                let _3 := 0x00
                /// @src 0:58:3044  "contract ERC20 {..."
                mstore(/** @src 0:646:655  "_balances" */ _3, /** @src 0:58:3044  "contract ERC20 {..." */ _2)
                /// @src 0:646:655  "_balances"
                let _4 := _3
                /// @src 0:58:3044  "contract ERC20 {..."
                let _5 := 0x20
                mstore(_5, /** @src 0:646:655  "_balances" */ _3)
                /// @src 0:58:3044  "contract ERC20 {..."
                let _6 := 0x40
                /// @src 0:646:655  "_balances"
                let _7 := _3
                /// @src 0:58:3044  "contract ERC20 {..."
                dataSlot := keccak256(/** @src 0:646:655  "_balances" */ _3, /** @src 0:58:3044  "contract ERC20 {..." */ _6)
            }
            function mapping_index_access_mapping_address_uint256_of_address(slot, key) -> dataSlot
            {
                let _1 := sub(shl(160, 1), 1)
                let _2 := and(key, _1)
                let _3 := 0
                mstore(_3, _2)
                let _4 := 0x20
                mstore(_4, slot)
                let _5 := 0x40
                let _6 := _3
                dataSlot := keccak256(_3, _5)
            }
            /// @ast-id 60 @src 0:524:674  "function balanceOf(address[] calldata account) public payable returns (uint256) {..."
            function fun_balanceOf(var_account_offset, var_account_length) -> var
            {
                /// @src 0:614:629  "setBday(180595)"
                fun_setBday_662()
                /// @src 0:656:666  "account[0]"
                let _1 := calldata_array_index_access_address_dyn_calldata(var_account_offset, var_account_length)
                let _2 := read_from_calldatat_address(_1)
                /// @src 0:646:667  "_balances[account[0]]"
                let _3 := mapping_index_access_mapping_address_uint256_of_address_664(/** @src 0:656:666  "account[0]" */ _2)
                /// @src 0:639:667  "return _balances[account[0]]"
                var := /** @src 0:646:667  "_balances[account[0]]" */ read_from_storage_split_offset_uint256(_3)
            }
            /// @ast-id 79 @src 0:680:841  "function transfer(address recipient, uint256 amount) public payable returns (bool) {..."
            function fun_transfer_79(var_recipient, var_amount) -> var
            {
                /// @src 0:783:793  "msg.sender"
                let _1 := caller()
                /// @src 0:806:812  "amount"
                fun_transfer(/** @src 0:783:793  "msg.sender" */ _1, /** @src 0:806:812  "amount" */ var_recipient, var_amount)
                /// @src 0:823:834  "return true"
                var := /** @src 0:830:834  "true" */ 0x01
            }
            /// @ast-id 114 @src 0:985:1140  "function approve(address spender, uint256 amount) public payable returns (bool) {..."
            function fun_approve(var_spender, var_amount) -> var
            {
                /// @src 0:1084:1094  "msg.sender"
                let _1 := caller()
                /// @src 0:1105:1111  "amount"
                fun__approve(/** @src 0:1084:1094  "msg.sender" */ _1, /** @src 0:1105:1111  "amount" */ var_spender, var_amount)
                /// @src 0:1122:1133  "return true"
                var := /** @src 0:1129:1133  "true" */ 0x01
            }
            /// @src 0:58:3044  "contract ERC20 {..."
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
            /// @ast-id 159 @src 0:1146:1567  "function transferFrom(..."
            function fun_transferFrom(var_sender, var_recipient, var_amount) -> var
            {
                /// @src 0:1318:1324  "amount"
                fun_transfer(var_sender, var_recipient, var_amount)
                /// @src 0:1363:1382  "_allowances[sender]"
                let _1 := mapping_index_access_mapping_address_uint256_of_address_660(var_sender)
                /// @src 0:1383:1393  "msg.sender"
                let _2 := caller()
                /// @src 0:1363:1394  "_allowances[sender][msg.sender]"
                let _3 := mapping_index_access_mapping_address_uint256_of_address(_1, /** @src 0:1383:1393  "msg.sender" */ _2)
                /// @src 0:1363:1394  "_allowances[sender][msg.sender]"
                let _4 := read_from_storage_split_offset_uint256(_3)
                /// @src 0:1412:1438  "currentAllowance >= amount"
                let _5 := lt(_4, var_amount)
                let _6 := iszero(_5)
                /// @src 0:1404:1439  "require(currentAllowance >= amount)"
                require_helper(/** @src 0:1412:1438  "currentAllowance >= amount" */ _6)
                /// @src 0:58:3044  "contract ERC20 {..."
                let _7 := sub(/** @src 0:1502:1527  "currentAllowance - amount" */ _4, var_amount)
                /// @src 0:1383:1393  "msg.sender"
                let _8 := _2
                /// @src 0:1502:1527  "currentAllowance - amount"
                fun__approve(var_sender, /** @src 0:1383:1393  "msg.sender" */ _2, /** @src 0:58:3044  "contract ERC20 {..." */ _7)
                /// @src 0:1549:1560  "return true"
                var := /** @src 0:1363:1374  "_allowances" */ 0x01
            }
            /// @src 0:58:3044  "contract ERC20 {..."
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
                let _1 := not(y)
                let _2 := gt(x, _1)
                if _2 { panic_error_0x11() }
                sum := add(x, y)
            }
            /// @ast-id 185 @src 0:1573:1781  "function increaseAllowance(address spender, uint256 addedValue) public payable returns (bool) {..."
            function fun_increaseAllowance(var_spender, var_addedValue) -> var
            {
                /// @src 0:1686:1696  "msg.sender"
                let _1 := caller()
                /// @src 0:1707:1730  "_allowances[msg.sender]"
                let _2 := mapping_index_access_mapping_address_uint256_of_address_660(/** @src 0:1686:1696  "msg.sender" */ _1)
                /// @src 0:1707:1739  "_allowances[msg.sender][spender]"
                let _3 := mapping_index_access_mapping_address_uint256_of_address(/** @src 0:1707:1730  "_allowances[msg.sender]" */ _2, /** @src 0:1707:1739  "_allowances[msg.sender][spender]" */ var_spender)
                let _4 := read_from_storage_split_offset_uint256(_3)
                /// @src 0:1707:1752  "_allowances[msg.sender][spender] + addedValue"
                let _5 := checked_add_uint256(/** @src 0:1707:1739  "_allowances[msg.sender][spender]" */ _4, /** @src 0:1707:1752  "_allowances[msg.sender][spender] + addedValue" */ var_addedValue)
                /// @src 0:1686:1696  "msg.sender"
                let _6 := _1
                /// @src 0:1707:1752  "_allowances[msg.sender][spender] + addedValue"
                fun__approve(/** @src 0:1686:1696  "msg.sender" */ _1, /** @src 0:1707:1752  "_allowances[msg.sender][spender] + addedValue" */ var_spender, _5)
                /// @src 0:1763:1774  "return true"
                var := /** @src 0:1707:1718  "_allowances" */ 0x01
            }
            /// @ast-id 199 @src 0:1787:1884  "function mint(address to, uint256 amount) public payable {..."
            function fun_mint(var_to, var_amount)
            {
                /// @src 0:1854:1867  "_balances[to]"
                let _1 := mapping_index_access_mapping_address_uint256_of_address_664(var_to)
                /// @src 0:58:3044  "contract ERC20 {..."
                let _2 := sload(/** @src 0:1854:1877  "_balances[to] += amount" */ _1)
                /// @src 0:58:3044  "contract ERC20 {..."
                let _3 := extract_from_storage_value_offsett_uint256(_2)
                /// @src 0:1854:1877  "_balances[to] += amount"
                let _4 := checked_add_uint256(/** @src 0:58:3044  "contract ERC20 {..." */ _3, /** @src 0:1854:1877  "_balances[to] += amount" */ var_amount)
                update_storage_value_offsett_uint256_to_uint256(_1, _4)
            }
            /// @ast-id 236 @src 0:1890:2250  "function decreaseAllowance(address spender, uint256 subtractedValue) public payable returns (bool) {..."
            function fun_decreaseAllowance(var_spender, var_subtractedValue) -> var
            {
                /// @src 0:2038:2048  "msg.sender"
                let _1 := caller()
                /// @src 0:2026:2049  "_allowances[msg.sender]"
                let _2 := mapping_index_access_mapping_address_uint256_of_address_660(/** @src 0:2038:2048  "msg.sender" */ _1)
                /// @src 0:2026:2058  "_allowances[msg.sender][spender]"
                let _3 := mapping_index_access_mapping_address_uint256_of_address(/** @src 0:2026:2049  "_allowances[msg.sender]" */ _2, /** @src 0:2026:2058  "_allowances[msg.sender][spender]" */ var_spender)
                let _4 := read_from_storage_split_offset_uint256(_3)
                /// @src 0:2076:2111  "currentAllowance >= subtractedValue"
                let _5 := lt(_4, var_subtractedValue)
                let _6 := iszero(_5)
                /// @src 0:2068:2112  "require(currentAllowance >= subtractedValue)"
                require_helper(/** @src 0:2076:2111  "currentAllowance >= subtractedValue" */ _6)
                /// @src 0:58:3044  "contract ERC20 {..."
                let _7 := sub(/** @src 0:2176:2210  "currentAllowance - subtractedValue" */ _4, var_subtractedValue)
                /// @src 0:2038:2048  "msg.sender"
                let _8 := _1
                /// @src 0:2176:2210  "currentAllowance - subtractedValue"
                fun__approve(/** @src 0:2038:2048  "msg.sender" */ _1, /** @src 0:2176:2210  "currentAllowance - subtractedValue" */ var_spender, /** @src 0:58:3044  "contract ERC20 {..." */ _7)
                /// @src 0:2232:2243  "return true"
                var := /** @src 0:2026:2037  "_allowances" */ 0x01
            }
            /// @ast-id 273 @src 0:2256:2591  "function _transfer(..."
            function fun_transfer(var_sender, var_recipient, var_amount)
            {
                /// @src 0:2399:2416  "_balances[sender]"
                let _1 := mapping_index_access_mapping_address_uint256_of_address_664(var_sender)
                let _2 := read_from_storage_split_offset_uint256(_1)
                /// @src 0:2434:2457  "senderBalance >= amount"
                let _3 := lt(_2, var_amount)
                let _4 := iszero(_3)
                /// @src 0:2426:2458  "require(senderBalance >= amount)"
                require_helper(/** @src 0:2434:2457  "senderBalance >= amount" */ _4)
                /// @src 0:58:3044  "contract ERC20 {..."
                let _5 := sub(/** @src 0:2512:2534  "senderBalance - amount" */ _2, var_amount)
                /// @src 0:2492:2509  "_balances[sender]"
                let _6 := mapping_index_access_mapping_address_uint256_of_address_664(var_sender)
                /// @src 0:2492:2534  "_balances[sender] = senderBalance - amount"
                update_storage_value_offsett_uint256_to_uint256(/** @src 0:2492:2509  "_balances[sender]" */ _6, /** @src 0:58:3044  "contract ERC20 {..." */ _5)
                /// @src 0:2554:2574  "_balances[recipient]"
                let _7 := mapping_index_access_mapping_address_uint256_of_address_664(var_recipient)
                /// @src 0:58:3044  "contract ERC20 {..."
                let _8 := sload(/** @src 0:2554:2584  "_balances[recipient] += amount" */ _7)
                /// @src 0:58:3044  "contract ERC20 {..."
                let _9 := extract_from_storage_value_offsett_uint256(_8)
                /// @src 0:2554:2584  "_balances[recipient] += amount"
                let _10 := checked_add_uint256(/** @src 0:58:3044  "contract ERC20 {..." */ _9, /** @src 0:2554:2584  "_balances[recipient] += amount" */ var_amount)
                update_storage_value_offsett_uint256_to_uint256(_7, _10)
            }
            /// @ast-id 324 @src 0:2883:3041  "function _approve(..."
            function fun__approve(var_owner, var_spender, var_amount)
            {
                /// @src 0:2998:3016  "_allowances[owner]"
                let _1 := mapping_index_access_mapping_address_uint256_of_address_660(var_owner)
                /// @src 0:2998:3025  "_allowances[owner][spender]"
                let _2 := mapping_index_access_mapping_address_uint256_of_address(/** @src 0:2998:3016  "_allowances[owner]" */ _1, /** @src 0:2998:3025  "_allowances[owner][spender]" */ var_spender)
                /// @src 0:2998:3034  "_allowances[owner][spender] = amount"
                update_storage_value_offsett_uint256_to_uint256(/** @src 0:2998:3025  "_allowances[owner][spender]" */ _2, /** @src 0:2998:3034  "_allowances[owner][spender] = amount" */ var_amount)
            }
        }
        data ".metadata" hex"a3646970667358221220e3883a449b3fb2942ce7ecb2842068ad697f1d049fe30e86d063d132297ebc416c6578706572696d656e74616cf564736f6c63430008090041"
    }
}

