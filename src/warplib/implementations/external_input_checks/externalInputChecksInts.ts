import { forAllWidths, mask, WarplibFunctionInfo } from '../../utils';

const INDENT = ' '.repeat(4);

export function external_input_check_ints(): WarplibFunctionInfo {
  return {
    fileName: 'external_input_check_ints',
    imports: [],
    functions: forAllWidths((int_width) => {
      if (int_width === 256) {
        return [
          `fn warp_external_input_check_int256(x : u256) {`,
          `${INDENT}return ();`,
          `}\n`,
        ].join('\n');
      } else {
        return [
          `fn warp_external_input_check_int${int_width}(x : felt){`,
          `${INDENT}let max: felt = ${mask(int_width)};`,
          `${INDENT}assert( x <= max, 'Error: value out-of-bounds.');`,
          `}\n`,
        ].join('\n');
      }
    }),
  };
}
