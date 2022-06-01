import { CairoType } from '../../utils/cairoTypeSystem';
import { StringIndexedFuncGen } from '../base';
import { INCLUDE_CAIRO_DUMP_FUNCTIONS } from '../../cairoWriter';

export class DynArrayGen extends StringIndexedFuncGen {
  gen(valueCairoType: CairoType): [data: string, len: string] {
    const key = valueCairoType.fullStringRepresentation;
    const existing = this.generatedFunctions.get(key);
    if (existing !== undefined) {
      return [existing.name, `${existing.name}_LENGTH`];
    }

    const mappingName = `WARP_DARRAY${this.generatedFunctions.size}_${valueCairoType.typeName}`;
    this.generatedFunctions.set(key, {
      name: mappingName,
      code: [
        `@storage_var`,
        `func ${mappingName}(name: felt, index: Uint256) -> (resLoc : felt):`,
        `end`,
        `@storage_var`,
        `func ${mappingName}_LENGTH(name: felt) -> (index: Uint256):`,
        `end`,
        ...getDumpFunctions(mappingName),
      ].join('\n'),
    });
    return [mappingName, `${mappingName}_LENGTH`];
  }
}

function getDumpFunctions(mappingName: string): string[] {
  return INCLUDE_CAIRO_DUMP_FUNCTIONS
    ? [
        `func DUMP_${mappingName}_ITER{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(name: felt, length : felt, ptr: felt*):`,
        `    alloc_locals`,
        `    if length == 0:`,
        `        return ()`,
        `    end`,
        `    let index = length - 1`,
        `    let (read) = ${mappingName}.read(name, Uint256(index, 0))`,
        `    assert ptr[index] = read`,
        `    DUMP_${mappingName}_ITER(name, index, ptr)`,
        `    return ()`,
        `end`,
        `@external`,
        `func DUMP_${mappingName}{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(name: felt, length : felt) -> (data_len : felt, data: felt*):`,
        `    alloc_locals`,
        `    let (p: felt*) = alloc()`,
        `    DUMP_${mappingName}_ITER(name, length, p)`,
        `    return (length, p)`,
        `end`,
        `func DUMP_${mappingName}_LENGTH_ITER{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(length : felt, ptr: felt*):`,
        `    alloc_locals`,
        `    if length == 0:`,
        `        return ()`,
        `    end`,
        `    let index = length - 1`,
        `    let (read) = ${mappingName}_LENGTH.read(index)`,
        `    assert ptr[2*index] = read.low`,
        `    assert ptr[2*index+1] = read.high`,
        `    DUMP_${mappingName}_LENGTH_ITER(index, ptr)`,
        `    return ()`,
        `end`,
        `@external`,
        `func DUMP_${mappingName}_LENGTH{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(length : felt) -> (data_len : felt, data: felt*):`,
        `    alloc_locals`,
        `    let (p: felt*) = alloc()`,
        `    DUMP_${mappingName}_LENGTH_ITER(length, p)`,
        `    return (length*2, p)`,
        `end`,
      ]
    : [];
}
