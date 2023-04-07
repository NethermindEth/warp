import { CairoUint } from '../../export';
import {
  U8_TO_FELT,
  U16_TO_FELT,
  U24_TO_FELT,
  U32_TO_FELT,
  U40_TO_FELT,
  U48_TO_FELT,
  U56_TO_FELT,
  U64_TO_FELT,
  U72_TO_FELT,
  U80_TO_FELT,
  U88_TO_FELT,
  U96_TO_FELT,
  U104_TO_FELT,
  U112_TO_FELT,
  U120_TO_FELT,
  U128_TO_FELT,
  U136_TO_FELT,
  U144_TO_FELT,
  U152_TO_FELT,
  U160_TO_FELT,
  U168_TO_FELT,
  U176_TO_FELT,
  U184_TO_FELT,
  U192_TO_FELT,
  U200_TO_FELT,
  U208_TO_FELT,
  U216_TO_FELT,
  U224_TO_FELT,
  U232_TO_FELT,
  U240_TO_FELT,
  U248_TO_FELT,
  U8_FROM_FELT,
  U16_FROM_FELT,
  U24_FROM_FELT,
  U32_FROM_FELT,
  U40_FROM_FELT,
  U48_FROM_FELT,
  U56_FROM_FELT,
  U64_FROM_FELT,
  U72_FROM_FELT,
  U80_FROM_FELT,
  U88_FROM_FELT,
  U96_FROM_FELT,
  U104_FROM_FELT,
  U112_FROM_FELT,
  U120_FROM_FELT,
  U128_FROM_FELT,
  U136_FROM_FELT,
  U144_FROM_FELT,
  U152_FROM_FELT,
  U160_FROM_FELT,
  U168_FROM_FELT,
  U176_FROM_FELT,
  U184_FROM_FELT,
  U192_FROM_FELT,
  U200_FROM_FELT,
  U208_FROM_FELT,
  U216_FROM_FELT,
  U224_FROM_FELT,
  U232_FROM_FELT,
  U240_FROM_FELT,
  U248_FROM_FELT,
} from '../../utils/importPaths';

export const toFeltfromuXImport = (uNtype: CairoUint) => {
  switch (uNtype.toString()) {
    case 'u8':
      return U8_TO_FELT;
    case 'u16':
      return U16_TO_FELT;
    case 'u24':
      return U24_TO_FELT;
    case 'u32':
      return U32_TO_FELT;
    case 'u40':
      return U40_TO_FELT;
    case 'u48':
      return U48_TO_FELT;
    case 'u56':
      return U56_TO_FELT;
    case 'u64':
      return U64_TO_FELT;
    case 'u72':
      return U72_TO_FELT;
    case 'u80':
      return U80_TO_FELT;
    case 'u88':
      return U88_TO_FELT;
    case 'u96':
      return U96_TO_FELT;
    case 'u104':
      return U104_TO_FELT;
    case 'u112':
      return U112_TO_FELT;
    case 'u120':
      return U120_TO_FELT;
    case 'u128':
      return U128_TO_FELT;
    case 'u136':
      return U136_TO_FELT;
    case 'u144':
      return U144_TO_FELT;
    case 'u152':
      return U152_TO_FELT;
    case 'u160':
      return U160_TO_FELT;
    case 'u168':
      return U168_TO_FELT;
    case 'u176':
      return U176_TO_FELT;
    case 'u184':
      return U184_TO_FELT;
    case 'u192':
      return U192_TO_FELT;
    case 'u200':
      return U200_TO_FELT;
    case 'u208':
      return U208_TO_FELT;
    case 'u216':
      return U216_TO_FELT;
    case 'u224':
      return U224_TO_FELT;
    case 'u232':
      return U232_TO_FELT;
    case 'u240':
      return U240_TO_FELT;
    case 'u248':
      return U248_TO_FELT;
    default:
      throw new Error('Invalid CairoUint type');
  }
};

export const getFeltfromuXImport = (uNtype: CairoUint) => {
  switch (uNtype.toString()) {
    case 'u8':
      return U8_FROM_FELT;
    case 'u16':
      return U16_FROM_FELT;
    case 'u24':
      return U24_FROM_FELT;
    case 'u32':
      return U32_FROM_FELT;
    case 'u40':
      return U40_FROM_FELT;
    case 'u48':
      return U48_FROM_FELT;
    case 'u56':
      return U56_FROM_FELT;
    case 'u64':
      return U64_FROM_FELT;
    case 'u72':
      return U72_FROM_FELT;
    case 'u80':
      return U80_FROM_FELT;
    case 'u88':
      return U88_FROM_FELT;
    case 'u96':
      return U96_FROM_FELT;
    case 'u104':
      return U104_FROM_FELT;
    case 'u112':
      return U112_FROM_FELT;
    case 'u120':
      return U120_FROM_FELT;
    case 'u128':
      return U128_FROM_FELT;
    case 'u136':
      return U136_FROM_FELT;
    case 'u144':
      return U144_FROM_FELT;
    case 'u152':
      return U152_FROM_FELT;
    case 'u160':
      return U160_FROM_FELT;
    case 'u168':
      return U168_FROM_FELT;
    case 'u176':
      return U176_FROM_FELT;
    case 'u184':
      return U184_FROM_FELT;
    case 'u192':
      return U192_FROM_FELT;
    case 'u200':
      return U200_FROM_FELT;
    case 'u208':
      return U208_FROM_FELT;
    case 'u216':
      return U216_FROM_FELT;
    case 'u224':
      return U224_FROM_FELT;
    case 'u232':
      return U232_FROM_FELT;
    case 'u240':
      return U240_FROM_FELT;
    case 'u248':
      return U248_FROM_FELT;
    default:
      throw new Error('Invalid CairoUint type');
  }
};
