use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;

const MAX_FELT: felt252 = 3618502788666131213697322783095070105623107215331596699973092056135872020480;

// ==================== Basic Functions ====================
#[test]
fn test_alloc(){
    let mut warp_memory = WarpMemoryTrait::initialize();
    assert(warp_memory.free_space_pointer == 0, 'Pointer should be 0');

    warp_memory.unsafe_alloc(5);
    assert(warp_memory.free_space_pointer == 5, 'Pointer should be 5');

    warp_memory.alloc(10);
    assert(warp_memory.free_space_pointer == 15, 'Pointer should be 15');
}

#[test]
#[should_panic]
fn test_alloc_overflow_should_panic(){
    let mut warp_memory = WarpMemoryTrait::initialize();

    warp_memory.alloc(10);

    // this should crash due to pointer overflow
    warp_memory.alloc(MAX_FELT);

}

#[test]
fn test_unsafe_access() {
    let mut warp_memory = WarpMemoryTrait::initialize();
    warp_memory.unsafe_write(3, 5); 
    
    let read_from_unallocated = warp_memory.unsafe_read(3);
    assert(read_from_unallocated == 5, 'Invalid read value');
    assert(warp_memory.free_space_pointer == 0, 'Free space pointer should be 0');
}

#[test] 
#[should_panic]
fn test_unallocated_write_should_panic() {
    let mut warp_memory = WarpMemoryTrait::initialize();
    warp_memory.write(3, 5); 
}

#[test] 
#[should_panic]
fn test_unallocated_read_should_panic() {
    let mut warp_memory = WarpMemoryTrait::initialize();
    warp_memory.read(3); 
}

#[test]
fn test_access(){
    let mut warp_memory = WarpMemoryTrait::initialize();

    let ptr1 = warp_memory.unsafe_alloc(2);
    assert(ptr1 == 0, 'Allocated mem ptr should be 0');
    assert(warp_memory.free_space_pointer == 2, 'Free space pointer should be 2');

    warp_memory.write(ptr1, 2); 
    warp_memory.write(ptr1 + 1, 3); 
    assert(warp_memory.read(ptr1) == 2, 'Invalid read value on pos 0');
    assert(warp_memory.read(ptr1 + 1) == 3, 'Invalid read value on pos 1');

    let ptr2 = warp_memory.unsafe_alloc(3);
    assert(ptr2 == 2, 'Allocated mem ptr should be 2');
    assert(warp_memory.free_space_pointer == 5, 'Free space pointer should be 5');

    warp_memory.write(ptr2, 4); 
    warp_memory.write(ptr2 + 1, 5); 
    warp_memory.write(ptr2 + 2, 6); 
    assert(warp_memory.read(ptr2) == 4, 'Invalid read value on pos 2');
    assert(warp_memory.read(ptr2 + 1) == 5, 'Invalid read value on pos 3');
    assert(warp_memory.read(ptr2 + 2) == 6, 'Invalid read value on pos 4');
}

// ==================== Complex Functions ====================
use warplib::warp_memory::WarpMemoryArraysTrait;

#[test]
fn test_get_or_create_id(){
    let mut warp_memory = WarpMemoryTrait::initialize();

    let ptr1 = warp_memory.unsafe_alloc(2);
    warp_memory.write(ptr1, 3);

    let read_id1 = warp_memory.get_or_create_id(ptr1, 10);
    assert(read_id1 == 3, 'Invalid read id value');

    let read_id2 = warp_memory.get_or_create_id(ptr1 + 1, 10);
    assert(read_id2 == 2, 'Invalid read id value');
    assert(warp_memory.free_space_pointer == 12, 'Invalid pointer value');
}

#[test]
fn test_new_dynamic_array(){
    let mut warp_memory = WarpMemoryTrait::initialize();

    let dyn_array = warp_memory.new_dynamic_array(MAX_FELT-1, 1);
    assert(warp_memory.free_space_pointer == MAX_FELT, 'Invalid pointer value');
    assert(warp_memory.read(dyn_array) == MAX_FELT - 1, 'Invalid length value');
}

#[test]
#[should_panic]
fn test_new_dynamic_array_overflow_should_panic(){
    let mut warp_memory = WarpMemoryTrait::initialize();

    let dyn_array = warp_memory.new_dynamic_array(MAX_FELT, 1);
}

#[test]
#[should_panic]
fn test_complex_element_dynamic_array_overflow__should_panic(){
    let mut warp_memory = WarpMemoryTrait::initialize();

    let dyn_array = warp_memory.new_dynamic_array(MAX_FELT - 1, 2);
}

#[test]
fn test_index_dyn(){
    let mut warp_memory = WarpMemoryTrait::initialize();
    let dyn_array = warp_memory.new_dynamic_array(5, 2);
    assert(warp_memory.free_space_pointer == 11, 'Invalid pointer value');

    warp_memory.unsafe_write(1, 2);
    warp_memory.unsafe_write(3, 3);
    warp_memory.unsafe_write(9, 5);
    warp_memory.unsafe_write(5, 7);

    let value_loc = warp_memory.index_dyn(dyn_array, 0, 2);
    assert(value_loc == 1, 'Invalid index location (1)');

    let value_loc = warp_memory.index_dyn(dyn_array, 1, 2);
    assert(value_loc == 3, 'Invalid index location (3)');

    let value_loc = warp_memory.index_dyn(dyn_array, 4, 2);
    assert(value_loc == 9, 'Invalid index location (9)');

    let value_loc = warp_memory.index_dyn(dyn_array, 1, 4);
    assert(value_loc == 5, 'Invalid index location (5)');
}

#[test]
#[should_panic]
fn test_index_dyn_out_of_range_should_panic(){
    let mut warp_memory = WarpMemoryTrait::initialize();
    let dyn_array = warp_memory.new_dynamic_array(5, 2);

    warp_memory.index_dyn(dyn_array, 5, 2);
}

#[test]
fn test_index_static(){
    let mut warp_memory = WarpMemoryTrait::initialize();
    let length = 10;
    let static_array = warp_memory.unsafe_alloc(length);

    let value_loc = warp_memory.index_static(static_array, 0, 2, length);
    assert(value_loc == 0, 'Invalid index location');

    let value_loc = warp_memory.index_static(static_array, 1, 2, length);
    assert(value_loc == 2, 'Invalid index location');

    let value_loc = warp_memory.index_static(static_array, 4, 2, length);
    assert(value_loc == 8, 'Invalid index location');

    let value_loc = warp_memory.index_static(static_array, 1, 4, length);
    assert(value_loc == 4, 'Invalid index location');
}

#[test]
#[should_panic]
fn test_index_static_out_of_range_should_panic(){
    let mut warp_memory = WarpMemoryTrait::initialize();
    let elem_size = 2;
    let length = 5;
    let static_array = warp_memory.unsafe_alloc(length * elem_size);

    warp_memory.index_static(static_array, 5, elem_size, length);
}

#[test]
fn test_dyn_length() {
    let mut warp_memory = WarpMemoryTrait::initialize();
    let dyn_array = warp_memory.new_dynamic_array(5, 3);

    assert(warp_memory.length_dyn(dyn_array) == 5, 'Expected array with length 5');
}

// ==================== Accessor Functions ====================
use array::ArrayTrait;
use integer::u32_to_felt252;
use option::OptionTrait;
use warplib::warp_memory::WarpMemoryMultiCellAccessorTrait;
use warplib::warp_memory::WarpMemoryAccessorTrait;

#[test]
#[available_gas(1000000)]
fn test_access_multiple() {
    let mut values = ArrayTrait::new();
    values.append(2);
    values.append(3);
    values.append(5);

    let mut warp_memory = WarpMemoryTrait::initialize();
    let pointer = warp_memory.unsafe_alloc(3);
    
    warp_memory.write_multiple(pointer, ref values);

    let mut read_values = warp_memory.read_multiple(pointer, u32_to_felt252(values.len()));
    loop {
        match gas::withdraw_gas() {
           Option::Some(_) => {},
           Option::None(_) => {
                panic_with_felt252('Out of gas');
           }
        }

        if  values.len() == 0 {
            break();
        }
        let val = values.pop_front().unwrap();
        let read_val = read_values.pop_front().unwrap();
        assert(val == read_val, 'Values do not match');
    };
}

#[test]
#[available_gas(1000000)]
#[should_panic]
fn test_write_multiple_overflow_should_panic() {

    let mut values = ArrayTrait::new();
    values.append(2);
    values.append(3);
    values.append(5);

    let mut warp_memory = WarpMemoryTrait::initialize();
    warp_memory.unsafe_alloc(MAX_FELT);
    
    warp_memory.write_multiple(MAX_FELT - 2, ref values);
}

#[test]
#[available_gas(1000000)]
#[should_panic]
fn test_write_multiple_unallocated_should_panic() {

    let mut values = ArrayTrait::new();
    values.append(2);
    values.append(3);
    values.append(5);

    let mut warp_memory = WarpMemoryTrait::initialize();
    let pointer = warp_memory.unsafe_alloc(2);
    
    warp_memory.write_multiple(pointer, ref values);
}

#[test]
#[available_gas(1000000)]
#[should_panic]
fn test_read_multiple_overflow_should_panic() {
    let mut warp_memory = WarpMemoryTrait::initialize();
    warp_memory.unsafe_alloc(MAX_FELT);
    warp_memory.read_multiple(MAX_FELT - 2, 3);
}

#[test]
#[available_gas(1000000)]
#[should_panic]
fn test_read_multiple_unallocated_should_panic() {
    let mut warp_memory = WarpMemoryTrait::initialize();
    let pointer = warp_memory.unsafe_alloc(2);
    warp_memory.read_multiple(pointer, 3);
}

#[test]
#[available_gas(1000000)]
fn test_store_retrieve() {
    let mut warp_memory = WarpMemoryTrait::initialize();
    let pointer = warp_memory.unsafe_alloc(6);
    
    // Store u256
    let val1 = u256{low: 2, high: 0};
    warp_memory.store(pointer, val1);
    let val2 = u256{low: 4, high: 0};
    warp_memory.store(pointer + 2, val2);

    // Store u128
    let val3 = 105_u128;
    warp_memory.store(pointer + 4, val3);

    // Store u8
    let val4 = 15_u8;
    warp_memory.store(pointer + 5, val4);

    let readVal1: u256 = warp_memory.retrieve(pointer,  2);
    assert(readVal1 == val1, 'Incorrect value 1');

    let readVal2: u256 = warp_memory.retrieve(pointer + 2, 2);
    assert(readVal2 == val2, 'Incorrect value 2');

    let readVal3: u128 = warp_memory.retrieve(pointer + 4, 1);
    assert(readVal3 == val3, 'Incorrect value 3');

    let readVal4: u8 = warp_memory.retrieve(pointer + 5, 1);
    assert(readVal4 == val4, 'Incorrect value 4');
}



// ==================== FixedBytes Functions ====================

use integer::u256_from_felt252;
use warplib::types::fixed_bytes::bytes32;
use warplib::types::fixed_bytes::bytes13;
use warplib::types::fixed_bytes::FixedBytesTrait;
use warplib::warp_memory::WarpMemoryBytesTrait;
use warplib::conversions::integer_conversions::u256_from_felts;

#[test]
#[available_gas(1000000)]
fn test_bytes32_converter_simple() {
    let mut values = ArrayTrait::new();
    values.append(219);

    let mut warp_memory = WarpMemoryTrait::initialize();
    let array_pointer = warp_memory.new_dynamic_array(1, 1); // this points now to the start that holds the array len: 1
    warp_memory.write_multiple(array_pointer+1, ref values);
    
    assert(warp_memory.read(array_pointer) == 1, 'Saved a wrong length');
    assert(warp_memory.read(array_pointer+1) == 219, 'Wrong first value');

    let fixed_byte32: bytes32 = warp_memory.bytes_to_fixed_bytes32(array_pointer);
    let expected_value = u256 { low: 0_u128, high: 0xdb000000000000000000000000000000_u128 };
    assert(fixed_byte32.value == expected_value, 'Unexpected bytes32 read');
}

#[test]
#[available_gas(10000000)]
fn test_bytes32_converter_len16() {
    let mut values = ArrayTrait::new();
    values.append(131);
    values.append(89);
    values.append(219);
    values.append(164);
    values.append(153);
    values.append(22);
    values.append(76);
    values.append(190);
    values.append(47);
    values.append(201);
    values.append(200);
    values.append(109);
    values.append(199);
    values.append(88);
    values.append(32);
    values.append(68);

    let mut warp_memory = WarpMemoryTrait::initialize();
    let array_pointer = warp_memory.new_dynamic_array(16, 1); // this points now to the start that holds the array len: 16
    warp_memory.write_multiple(array_pointer+1, ref values);
    
    assert(warp_memory.read(array_pointer) == 16, 'Saved a wrong length');
    assert(warp_memory.read(array_pointer+1) == 131, 'Wrong first value');

    let fixed_byte32: bytes32 = warp_memory.bytes_to_fixed_bytes32(array_pointer);
    let expected_value = u256 { low: 0_u128, high: 0x8359dba499164cbe2fc9c86dc7582044_u128 };
    assert(fixed_byte32.value == expected_value, 'Unexpected bytes32 read');
}

#[test]
#[available_gas(10000000)]
fn test_bytes32_converter_len_between_16_32() {
    let mut values = ArrayTrait::new();
    values.append(131);
    values.append(89);
    values.append(219);
    values.append(164);
    values.append(153);
    values.append(22);
    values.append(76);
    values.append(190);
    values.append(47);
    values.append(201);
    values.append(200);
    values.append(109);
    values.append(199);
    values.append(88);
    values.append(32);
    values.append(68);
    values.append(181);
    values.append(216);

    let mut warp_memory = WarpMemoryTrait::initialize();
    let array_pointer = warp_memory.new_dynamic_array(18, 1); // this points now to the start that holds the array len: 16
    warp_memory.write_multiple(array_pointer+1, ref values);
    
    assert(warp_memory.read(array_pointer) == 18, 'Saved a wrong length');

    let fixed_byte32: bytes32 = warp_memory.bytes_to_fixed_bytes32(array_pointer);
    let expected_value = u256 { low: 0xb5d80000000000000000000000000000_u128, high: 0x8359dba499164cbe2fc9c86dc7582044_u128 };
    assert(fixed_byte32.value == expected_value, 'Unexpected bytes32 read');

    let byte0 = fixed_byte32.atIndex(0_u8);
    assert(byte0.value == 131_u8, 'Unexpected byte 0');

    let byte14 = fixed_byte32.atIndex(14_u8);
    assert(byte14.value == 32_u8, 'Unexpected byte 14');

    let byte15 = fixed_byte32.atIndex(15_u8);
    assert(byte15.value == 68_u8, 'Unexpected byte 15');

    let byte16 = fixed_byte32.atIndex(16_u8);
    assert(byte16.value == 181_u8, 'Unexpected byte 16');

    let byte17 = fixed_byte32.atIndex(17_u8);
    assert(byte17.value == 216_u8, 'Unexpected byte 17');
}

#[test]
#[available_gas(10000000)]
fn test_bytes32_converter_len_greater_than_32() {
    let mut values = ArrayTrait::new();
    values.append(131);
    values.append(89);
    values.append(219);
    values.append(164);
    values.append(153);
    values.append(22);
    values.append(76);
    values.append(190);
    values.append(47);
    values.append(201);
    values.append(200);
    values.append(109);
    values.append(199);
    values.append(88);
    values.append(32);
    values.append(68);
    values.append(181);
    values.append(216);
    values.append(56);
    values.append(165);
    values.append(176);
    values.append(86);
    values.append(72);
    values.append(101);
    values.append(53);
    values.append(32);
    values.append(21);
    values.append(1);
    values.append(220);
    values.append(120);
    values.append(194);
    values.append(95);
    values.append(38);
    values.append(78);
    values.append(9);
    values.append(8);

    let mut warp_memory = WarpMemoryTrait::initialize();
    let array_pointer = warp_memory.new_dynamic_array(36, 1); // this points now to the start that holds the array len: 36
    warp_memory.write_multiple(array_pointer+1, ref values);
    
    assert(warp_memory.read(array_pointer) == 36, 'Saved a wrong length');

    let fixed_byte32: bytes32 = warp_memory.bytes_to_fixed_bytes32(array_pointer);
    let expected_value = u256 { low: 0xb5d838a5b056486535201501dc78c25f_u128, high: 0x8359dba499164cbe2fc9c86dc7582044_u128 };
    assert(fixed_byte32.value == expected_value, 'Unexpected bytes32 read');

    let byte31 = fixed_byte32.atIndex(31_u8);
    assert(byte31.value == 95_u8, 'Unexpected byte 31');
}

#[test]
#[available_gas(10000000)]
fn test_bytes13_converter_len16() {
    let mut values = ArrayTrait::new();
    values.append(131);
    values.append(89);
    values.append(219);
    values.append(164);
    values.append(153);
    values.append(22);
    values.append(76);
    values.append(190);
    values.append(47);
    values.append(201);
    values.append(200);
    values.append(109);
    values.append(199);
    values.append(88);
    values.append(32);
    values.append(68);

    let mut warp_memory = WarpMemoryTrait::initialize();
    let array_pointer = warp_memory.new_dynamic_array(16, 1); // this points now to the start that holds the array len: 16
    warp_memory.write_multiple(array_pointer+1, ref values);
    

    let fixed_byte13: bytes13 = warp_memory.bytes_to_fixed_bytes13(array_pointer);
    let expected_value = 0x8359dba499164cbe2fc9c86dc7_u128;
    assert(fixed_byte13.value == expected_value, 'Unexpected bytes13 read');

    let byte0 = fixed_byte13.atIndex(0_u8);
    assert(byte0.value == 131_u8, 'Unexpected byte 0');

    let byte12 = fixed_byte13.atIndex(12_u8);
    assert(byte12.value == 199_u8, 'Unexpected byte 12');
}
