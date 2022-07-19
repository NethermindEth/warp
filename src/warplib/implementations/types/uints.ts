import { generateFile, forAllWidths } from '../../utils';

const INDENT = ' '.repeat(4);

const import_strings: string[] = ['from starkware.cairo.common.uint256 import Uint256'];

const IntStructs: Array<string> = [
  ...forAllWidths((int_width) => {
    if (int_width == 256) {
      return [];
    } else {
      return [`struct Uint${int_width}:`, `${INDENT}member value : felt`, `end\n`];
    }
  }),
];

export function uints_structs(): void {
  generateFile('uints', import_strings, [...IntStructs], 'types');
}
