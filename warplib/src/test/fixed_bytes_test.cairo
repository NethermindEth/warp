use warplib::warp_memory::WarpMemory;
use warplib::warp_memory::WarpMemoryTrait;
use warplib::warp_memory::WarpMemoryImpl;
use warplib::warp_memory::WarpMemoryArraysTrait;
use array::ArrayTrait;
use warplib::warp_memory::WarpMemoryMultiCellAccessorTrait;
use warplib::warp_memory::WarpMemoryAccesssorTrait;
use warplib::types::fixed_bytes::bytes32;
use warplib::types::fixed_bytes::bytes13;
use warplib::types::fixed_bytes::FixedBytesTrait;
use warplib::warp_memory::WarpMemoryBytesTrait;
use warplib::conversions::integer_conversions::u256_from_felts;

#[test]
#[available_gas(10000000)]
fn test_bytes32_comparison() {
    let mut values1 = ArrayTrait::new();
    values1.append(131);
    values1.append(89);
    values1.append(219);
    values1.append(164);
    values1.append(153);
    values1.append(22);
    values1.append(76);
    values1.append(190);
    values1.append(47);
    values1.append(201);
    values1.append(200);
    values1.append(109);
    values1.append(199);
    values1.append(88);
    values1.append(32);
    values1.append(68);
    values1.append(131);
    values1.append(89);
    values1.append(219);
    values1.append(164);
    values1.append(153);
    values1.append(22);
    values1.append(76);
    values1.append(190);
    values1.append(47);
    values1.append(201);
    values1.append(200);
    values1.append(109);
    values1.append(199);
    values1.append(88);
    values1.append(32);
    values1.append(68);

    let mut values2 = ArrayTrait::new();
    values2.append(181);
    values2.append(216);
    values2.append(56);
    values2.append(165);
    values2.append(176);
    values2.append(86);
    values2.append(72);
    values2.append(101);
    values2.append(53);
    values2.append(32);
    values2.append(21);
    values2.append(1);
    values2.append(220);
    values2.append(120);
    values2.append(194);
    values2.append(95);
    values2.append(181);
    values2.append(216);
    values2.append(56);
    values2.append(165);
    values2.append(176);
    values2.append(86);
    values2.append(72);
    values2.append(101);
    values2.append(53);
    values2.append(32);
    values2.append(21);
    values2.append(1);
    values2.append(220);
    values2.append(120);
    values2.append(194);
    values2.append(95);
    
    let mut warp_memory = WarpMemoryTrait::initialize();

    let array1_pointer = warp_memory.new_dynamic_array(32, 1);
    warp_memory.write_multiple(array1_pointer+1, ref values1);
    let fixed_byte32_1: bytes32 = warp_memory.bytes_to_fixed_bytes32(array1_pointer);
    let expected_value_1 = u256 { low: 174595436756733596343387042077774192708_u128, high: 174595436756733596343387042077774192708_u128 };
    assert(fixed_byte32_1.value == expected_value_1, 'Unexpected bytes32 read in 1');

    let array2_pointer = warp_memory.new_dynamic_array(32, 1);
    warp_memory.write_multiple(array2_pointer+1, ref values2);
    let fixed_byte32_2: bytes32 = warp_memory.bytes_to_fixed_bytes32(array2_pointer);
    let expected_value_2 = u256 { low: 241712952300671586336890700143387001439_u128, high: 241712952300671586336890700143387001439_u128 };
    assert(fixed_byte32_2.value == expected_value_2, 'Unexpected bytes32 read in 2');

    assert(fixed_byte32_1.less_or_equal_comparison(fixed_byte32_2), 'B1 should be <= to B2');
    assert(fixed_byte32_1.less_comparison(fixed_byte32_2), 'B1 should be < to B2');
    assert(!(fixed_byte32_1.equal_comparison(fixed_byte32_2)), 'B1 should not be == to B2');
    assert(fixed_byte32_1.distinct_comparison(fixed_byte32_2), 'B1 should be != to B2');
    assert(!(fixed_byte32_1.greater_or_equal_comparison(fixed_byte32_2)), 'B1 should not be >= to B2');
    assert(!(fixed_byte32_1.greater_comparison(fixed_byte32_2)), 'B1 should not be > to B2');

    let and_r: bytes32 = fixed_byte32_1.and_bitwise(fixed_byte32_2);
    let expected_value_and = u256 { low: 171927833395647130874784230521578192964_u128, high: 171927833395647130874784230521578192964_u128 };
    assert(and_r.value == expected_value_and, 'Unexpected bytes32 bitwise and');
    let or_r: bytes32 = fixed_byte32_1.or_bitwise(fixed_byte32_2);
    let expected_value_or = u256 { low: 244380555661758051805493511699583001183_u128, high: 244380555661758051805493511699583001183_u128 };
    assert(or_r.value == expected_value_or, 'Unexpected bytes32 bitwise or');
    let xor_r: bytes32 = fixed_byte32_1.exclusive_or_bitwise(fixed_byte32_2);
    let expected_value_xor = u256 { low: 72452722266110920930709281178004808219_u128, high: 72452722266110920930709281178004808219_u128 };
    assert(xor_r.value == expected_value_xor, 'Unexpected bytes32 bitwise xor');
}