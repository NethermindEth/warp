import { generateFile, PATH_TO_WARPLIB, WarplibFunctionInfo } from './utils';
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
import { glob } from 'glob';
import { parseMultipleRawCairoFunctions } from '../utils/cairoParsing';
import { fixed_bytes_types } from './implementations/types/bytes';

const mathWarplibFunctions: WarplibFunctionInfo[] = [
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
];
const conversionWarplibFunctions: WarplibFunctionInfo[] = [int_conversions()];
const inputCheckWarplibFunctions: WarplibFunctionInfo[] = [
  external_input_check_ints(),
  // external_input_check_address - handwritten
];
const warplibTypes: WarplibFunctionInfo[] = [fixed_bytes_types()];

generateWarplibFor('maths', mathWarplibFunctions);
generateWarplibFor('conversions', conversionWarplibFunctions);
generateWarplibFor('external_input_check', inputCheckWarplibFunctions);
generateWarplibFor('types', warplibTypes);

function generateWarplibFor(folderName: string, functions: WarplibFunctionInfo[]) {
  functions.forEach((warpFunc: WarplibFunctionInfo) => generateFile(warpFunc, folderName));
  const content: string = folderContent(folderName);
  writeExportedFunctions(`${folderName}.cairo`, content);
}

function folderContent(folderName: string): string {
  return (
    glob
      .sync(path.join(PATH_TO_WARPLIB, folderName, '*.cairo'))
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
      .join('\n\n')
  );
}

function writeExportedFunctions(fileToWrite: string, folderContent: string) {
  fs.writeFileSync(
    path.join(PATH_TO_WARPLIB, fileToWrite),
    endent`
      // AUTO-GENERATED
      ${folderContent}
    `,
  );
}
