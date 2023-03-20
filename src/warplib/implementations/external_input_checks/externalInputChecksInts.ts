import { forAllWidths, mask, WarplibFunctionInfo } from '../../utils';

const INDENT = ' '.repeat(4);

// TODO: Check if cairo 1.0 validates outputs itself. Is it needed anymore?
export function external_input_check_ints(): WarplibFunctionInfo {
  return {
    fileName: 'external_input_check_ints',
    imports: [],
    functions: forAllWidths((int_width) => {
      // These functions will not be needed when we transition to map solidity uintN to cairo uN
      if (int_width === 256) {
        return 'fn warp_external_input_check_int256(x : u256){}\n';
      } else {
        return [
          `fn warp_external_input_check_int${int_width}(x : felt){`,
          `${INDENT}let max: felt = ${mask(int_width)};`,
          `${INDENT}assert(x <= max, 'Error: value out-of-bounds.');`,
          `}\n`,
        ].join('\n');
      }
    }),
  };
}
