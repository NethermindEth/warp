import { generateFile, WarplibFunctionInfo } from './utils';
import { int_conversions } from './implementations/conversions/int';
import { bitwise_not } from './implementations/maths/bitwiseNot';
import { external_input_check_ints } from './implementations/external_input_checks/externalInputChecksInts';
import path from 'path';
import * as fs from 'fs';
import endent from 'endent';
import { glob } from 'glob';
import { parseMultipleRawCairoFunctions } from '../utils/cairoParsing';

const warplibFunctions: WarplibFunctionInfo[] = [
  // sub - handwritten
  // div - handwritten
  // div_unsafe - handwritten
  // mod - handwritten
  // ge - handwritten
  // gt - handwritten
  // le - handwritten
  // lt - handwritten
  // and - handwritten
  // xor - handwritten
  // bitwise_and - handwritten
  // bitwise_or - handwritten
  bitwise_not(),
  // ---conversions---
  int_conversions(),
  // ---external_input_checks---
  external_input_check_ints(),
  // external_input_check_address - handwritten
];
warplibFunctions.forEach((warpFunc: WarplibFunctionInfo) => generateFile(warpFunc));

const mathsContent: string = glob
  .sync('warplib/maths/*.cairo')
  .map((pathToFile) => {
    const fileName = path.basename(pathToFile, '.cairo');
    const rawCairoCode = fs.readFileSync(pathToFile, { encoding: 'utf8' });
    const funcNames = parseMultipleRawCairoFunctions(rawCairoCode).map(({ name }) => name);
    return { fileName, funcNames };
  })
  // TODO: Remove this filter once all warplib modules use cairo1
  .filter(({ funcNames }) => funcNames.length > 0)
  .map(({ fileName, funcNames }) => {
    const useFuncNames = funcNames.map((name) => `use ${fileName}::${name};`).join('\n');
    return `mod ${fileName};\n${useFuncNames}`;
  })
  .join('\n\n');

fs.writeFileSync(
  path.join('.', 'warplib', 'maths.cairo'),
  endent`
    // AUTO-GENERATED
    ${mathsContent}
  `,
);
