import { int_conversions } from './implementations/conversions/int';
import { add, add_unsafe, add_signed, add_signed_unsafe } from './implementations/maths/add';
import { bitwise_not } from './implementations/maths/bitwise_not';
import { div_signed } from './implementations/maths/div';
import { exp, exp_signed, exp_signed_unsafe, exp_unsafe } from './implementations/maths/exp';
import { ge_signed } from './implementations/maths/ge';
import { gt_signed } from './implementations/maths/gt';
import { le_signed } from './implementations/maths/le';
import { lt_signed } from './implementations/maths/lt';
import { mul, mul_unsafe, mul_signed, mul_signed_unsafe } from './implementations/maths/mul';
import { negate } from './implementations/maths/negate';
import { shl } from './implementations/maths/shl';
import { shr, shr_signed } from './implementations/maths/shr';
import { sub_unsafe, sub_signed, sub_signed_unsafe } from './implementations/maths/sub';
import { external_input_check_ints } from './implementations/external_input_checks/external_input_checks_ints';
import { external_input_check_address } from './implementations/external_input_checks/external_input_checks_address';

add();
add_unsafe();
add_signed();
add_signed_unsafe();

//sub - handwritten
sub_unsafe();
sub_signed();
sub_signed_unsafe();

mul();
mul_unsafe();
mul_signed();
mul_signed_unsafe();

//div - handwritten
div_signed();

exp();
exp_signed();
exp_unsafe();
exp_signed_unsafe();

negate();

shl();

shr();
shr_signed();

//ge - handwritten
ge_signed();

//gt - handwritten
gt_signed();

//le - handwritten
le_signed();

//lt - handwritten
lt_signed();

//xor - handwritten
//bitwise_and - handwritten
//bitwise_or - handwritten
bitwise_not();

// ---conversions---

int_conversions();

// ---external_input_checks---
external_input_check_ints();
external_input_check_address();
// and - handwritten
// or - handwritten
