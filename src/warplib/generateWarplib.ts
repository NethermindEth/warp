import { generateFile, WarplibFunctionInfo } from './utils';
import { int_conversions } from './implementations/conversions/int';
import { add, add_unsafe, add_signed, add_signed_unsafe } from './implementations/maths/add';
import { div_signed, div_signed_unsafe } from './implementations/maths/div';
import { exp, exp_signed, exp_signed_unsafe, exp_unsafe } from './implementations/maths/exp';
import { ge_signed } from './implementations/maths/ge';
import { gt_signed } from './implementations/maths/gt';
import { le_signed } from './implementations/maths/le';
import { lt_signed } from './implementations/maths/lt';
import { mod_signed } from './implementations/maths/mod';
import { mul, mul_unsafe, mul_signed, mul_signed_unsafe } from './implementations/maths/mul';
import { negate } from './implementations/maths/negate';
import { shl } from './implementations/maths/shl';
import { shr, shr_signed } from './implementations/maths/shr';
import { sub_unsafe, sub_signed, sub_signed_unsafe } from './implementations/maths/sub';
import { bitwise_not } from './implementations/maths/bitwiseNot';
import { external_input_check_ints } from './implementations/external_input_checks/externalInputChecksInts';
import path from 'path';
import * as fs from 'fs';
import endent from 'endent';
import { warplibImportInfo } from './gatherWarplibImports';
import { glob } from 'glob';
import { parseMultipleRawCairoFunctions } from '../utils/cairoParsing';

const warplibFunctions: WarplibFunctionInfo[] = [
  add(),
  add_unsafe(),
  add_signed(),
  add_signed_unsafe(),
  // sub - handwritten
  sub_unsafe(),
  sub_signed(),
  sub_signed_unsafe(),
  mul(),
  mul_unsafe(),
  mul_signed(),
  mul_signed_unsafe(),
  // div - handwritten
  // div_unsafe - handwritten
  div_signed(),
  div_signed_unsafe(),
  // mod - handwritten
  mod_signed(),
  exp(),
  exp_signed(),
  exp_unsafe(),
  exp_signed_unsafe(),
  negate(),
  shl(),
  shr(),
  shr_signed(),
  // ge - handwritten
  ge_signed(),
  // gt - handwritten
  gt_signed(),
  // le - handwritten
  le_signed(),
  // lt - handwritten
  lt_signed(),
  // and - handwritten
  // xor - handwritten
  // bitwise_and - handwritten
  // bitwise_or - handwritten
  bitwise_not(),
  // ---conversions---
  int_conversions(),
  // ---external_input_checks---
  external_input_check_ints(),
  // external_inputt_check_address - handwritten
];
warplibFunctions.forEach((warpFunc: WarplibFunctionInfo) => generateFile(warpFunc));

const mathsContent: string = glob
  .sync('warplib/maths/*.cairo')
  .map((pathToFile) => {
    const fileName = path.basename(pathToFile, '.cairo');
    const rawCairoCode = fs.readFileSync(pathToFile, { encoding: 'utf8' });
    const useFuncNames = parseMultipleRawCairoFunctions(rawCairoCode)
      .map(({ name }) => `use ${fileName}::${name};`)
      .join('\n');

    return `mod ${fileName}\n${useFuncNames};`;
  })
  .join('\n\n');

fs.writeFileSync(
  path.join('.', 'warplib', 'maths.cairo'),
  endent`
    // AUTO-GENERATED
    ${mathsContent}
  `,
);
