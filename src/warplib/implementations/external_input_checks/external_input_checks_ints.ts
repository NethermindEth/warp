import { generateFile, forAllWidths, mask } from '../../utils';

const INDENT = ' '.repeat(4);

const import_strings: string[] = [];

const BitBoundChecker: Array<string> = [
  ...forAllWidths((int_width) => {
    if (int_width === 256) {
      return [`fn warp_external_input_check_int256(x : u256) {`, `${INDENT}return ();`, `}\n`];
    } else {
      return [
        `fn warp_external_input_check_int${int_width}(x : felt){`,
        `${INDENT}let max: felt = ${mask(int_width)};`,
        `${INDENT}assert( x <= max, 'Error: value out-of-bounds.');`,
        `}\n`,
      ];
    }
  }),
];

export function external_input_check_ints(): void {
  generateFile('external_input_check_ints', import_strings, [...BitBoundChecker]);
}
