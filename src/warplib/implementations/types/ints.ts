import { generateFile, forAllWidths } from '../../utils';

const INDENT = ' '.repeat(4);

const import_strings: string[] = ['from starkware.cairo.common.uint256 import Uint256'];

const IntStructs: Array<string> = [
  ...forAllWidths((int_width) => {
    if (int_width == 256) {
      return [`struct Int256:`, `${INDENT}member value : Uint256`, `end\n`];
    } else {
      return [`struct Int${int_width}:`, `${INDENT}member value : felt`, `end\n`];
    }
  }),
];

export function ints_structs(): void {
  generateFile('ints', import_strings, [...IntStructs], 'types');
}
