import { generateFile, mask } from '../../utils';

const INDENT = ' '.repeat(4);

const import_strings: string[] = [
  'from starkware.cairo.common.math_cmp import is_le_felt',
  'from starkware.cairo.common.uint256 import Uint256',
];

const AddressBoundChecker: Array<string> = [
  `func warp_external_input_check_address{range_check_ptr}(x : felt):`,
  `${INDENT}let (inRange : felt) = is_le_felt(x, ${mask(251)})`,
  `${INDENT}with_attr error_message("Error: value out-of-bounds. Value must be less than 2**251."):`,
  `${INDENT.repeat(2)}assert 1 = inRange`,
  `${INDENT}end`,
  `${INDENT}return ()`,
  `end\n`,
];

export function external_input_check_address(): void {
  generateFile('external_input_check_address', import_strings, [...AddressBoundChecker]);
}
