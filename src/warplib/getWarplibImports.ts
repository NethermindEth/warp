import { parseMultipleRawCairoFunctions } from '../utils/cairoParsing';
import { int_conversions } from './implementations/conversions/int';
import { add, add_unsafe, add_signed, add_signed_unsafe } from './implementations/maths/add';
import { bitwise_not } from './implementations/maths/bitwise_not';
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
import { external_input_check_ints } from './implementations/external_input_checks/external_input_checks_ints';
import { WarplibFunctionInfo } from './utils';
import { Implicits } from '../export';

const LIBPATH = 'warplib.maths';

export const warplibFunctions: WarplibFunctionInfo[] = [
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
];

export const warplibImportInfo = warplibFunctions.reduce(
  (warplibMap, warplibFunc) => {
    console.log(warplibFunc.fileName);
    warplibFunc.functions
      .flatMap((rawFunc) => parseMultipleRawCairoFunctions(rawFunc))
      .filter((funcInfo) => funcInfo.name.startsWith('warp_'))
      .forEach((funcInfo) => {
        const fullPath = `${LIBPATH}.${warplibFunc.fileName}`;

        const fileMap = warplibMap.get(fullPath);
        if (fileMap !== undefined) {
          fileMap.set(funcInfo.name, funcInfo.implicits);
        } else {
          warplibMap.set(fullPath, new Map([[funcInfo.name, funcInfo.implicits]]));
        }
      });
    return warplibMap;
  },
  // TODO: There are other handwritten warplib functions which are not included here
  new Map<string, Map<string, Implicits[]>>([
    [
      `${LIBPATH}.sub`,
      new Map([
        ['warp_sub', ['range_check_ptr']],
        ['warp_sub256', ['range_check_ptr', 'bitwise_ptr']],
      ]),
    ],
    [
      `${LIBPATH}.div`,
      new Map([
        ['warp_div', ['range_check_ptr']],
        ['warp_div256', ['range_check_ptr']],
      ]),
    ],
    [
      `${LIBPATH}.div_unsafe`,
      new Map([
        ['warp_div_unsafe', ['range_check_ptr']],
        ['warp_div256_unsafe', ['range_check_ptr']],
      ]),
    ],
    [
      `${LIBPATH}.mod`,
      new Map([
        ['warp_mod', ['range_check_ptr']],
        ['warp_mod256', ['range_check_ptr']],
      ]),
    ],
    [
      `${LIBPATH}.ge`,
      new Map([
        ['warp_ge', ['range_check_ptr']],
        ['warp_ge256', ['range_check_ptr']],
      ]),
    ],
    [
      `${LIBPATH}.gt`,
      new Map([
        ['warp_gt', ['range_check_ptr']],
        ['warp_gt256', ['range_check_ptr']],
      ]),
    ],
    [
      `${LIBPATH}.le`,
      new Map([
        ['warp_le', ['range_check_ptr']],
        ['warp_le256', ['range_check_ptr']],
      ]),
    ],
    [
      `${LIBPATH}.lt`,
      new Map([
        ['warp_lt', ['range_check_ptr']],
        ['warp_lt256', ['range_check_ptr']],
      ]),
    ],
    [
      `${LIBPATH}.xor`,
      new Map([
        ['warp_xor', ['range_check_ptr']],
        ['warp_xor256', ['range_check_ptr', 'bitwise_ptr']],
      ]),
    ],
    [`${LIBPATH}.and_`, new Map([['warp_and_', []]])],
    [
      `${LIBPATH}.bitwise_and`,
      new Map([
        ['warp_bitwise_and', ['bitwise_ptr']],
        ['warp_bitwise_and256', ['range_check_ptr', 'bitwise_ptr']],
      ]),
    ],
    [
      `${LIBPATH}.bitwise_or`,
      new Map([
        ['warp_bitwise_or', ['bitwise_ptr']],
        ['warp_bitwise_or256', ['range_check_ptr', 'bitwise_ptr']],
      ]),
    ],
  ]),
);
