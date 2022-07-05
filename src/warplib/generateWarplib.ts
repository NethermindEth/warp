import { int_conversions } from './implementations/conversions/int';
import { add, add_unsafe, add_signed, add_signed_unsafe } from './implementations/maths/add';
import { bitwise_not, bitwise_not_signed } from './implementations/maths/bitwise_not';
import { div, div_signed, div_signed_unsafe, div_unsafe } from './implementations/maths/div';
import { exp, exp_signed, exp_signed_unsafe, exp_unsafe } from './implementations/maths/exp';
import { ge, ge_signed } from './implementations/maths/ge';
import { gt, gt_signed } from './implementations/maths/gt';
import { le, le_signed } from './implementations/maths/le';
import { lt, lt_signed } from './implementations/maths/lt';
import { mod, mod_signed } from './implementations/maths/mod';
import { mul, mul_unsafe, mul_signed, mul_signed_unsafe } from './implementations/maths/mul';
import { negate } from './implementations/maths/negate';
import { shl } from './implementations/maths/shl';
import { shr, shr_signed } from './implementations/maths/shr';
import { sub_unsafe, sub_signed, sub_signed_unsafe, sub } from './implementations/maths/sub';
import { external_input_check_ints } from './implementations/external_input_checks/external_input_checks_ints';
import { external_input_check_uints } from './implementations/external_input_checks/external_input_checks_uints';
import { ints_structs } from './implementations/types/ints';
import { uints_structs } from './implementations/types/uints';
import { bitwise_and, bitwise_and_signed } from './implementations/maths/bitwise_and';
import { bitwise_or, bitwise_or_signed } from './implementations/maths/bitwise_or';

add();
add_unsafe();
add_signed();
add_signed_unsafe();

bitwise_and();
bitwise_and_signed();

bitwise_not();
bitwise_not_signed();

bitwise_or();
bitwise_or_signed();

sub();
sub_unsafe();
sub_signed();
sub_signed_unsafe();

mul();
mul_unsafe();
mul_signed();
mul_signed_unsafe();

div(), div_unsafe(), div_signed();
div_signed_unsafe();

mod();
mod_signed();

exp();
exp_signed();
exp_unsafe();
exp_signed_unsafe();

negate();

shl();

shr();
shr_signed();

ge();
ge_signed();

gt();
gt_signed();

le();
le_signed();

lt();
lt_signed();

// ---conversions---
int_conversions();

// ---external_input_checks---
external_input_check_ints();
external_input_check_uints();

// and - handwritten
// or - handwritten
// xor - handwritten

// -- type structs ---
ints_structs();
uints_structs();
