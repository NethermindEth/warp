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
  GET_U8,
  GET_U16,
  GET_U24,
  GET_U32,
  GET_U40,
  GET_U48,
  GET_U56,
  GET_U64,
  GET_U72,
  GET_U80,
  GET_U88,
  GET_U96,
  GET_U104,
  GET_U112,
  GET_U120,
  GET_U128,
  GET_U136,
  GET_U144,
  GET_U152,
  GET_U160,
  GET_U168,
  GET_U176,
  GET_U184,
  GET_U192,
  GET_U200,
  GET_U208,
  GET_U216,
  GET_U224,
  GET_U232,
  GET_U240,
  GET_U248,
  WM_READ8,
  WM_READ16,
  WM_READ24,
  WM_READ32,
  WM_READ40,
  WM_READ48,
  WM_READ56,
  WM_READ64,
  WM_READ72,
  WM_READ80,
  WM_READ88,
  WM_READ96,
  WM_READ104,
  WM_READ112,
  WM_READ120,
  WM_READ128,
  WM_READ136,
  WM_READ144,
  WM_READ152,
  WM_READ160,
  WM_READ168,
  WM_READ176,
  WM_READ184,
  WM_READ192,
  WM_READ200,
  WM_READ208,
  WM_READ216,
  WM_READ224,
  WM_READ232,
  WM_READ240,
  WM_READ248,
  WM_READ256,
  WM_WRITE8,
  WM_WRITE16,
  WM_WRITE24,
  WM_WRITE32,
  WM_WRITE40,
  WM_WRITE48,
  WM_WRITE56,
  WM_WRITE64,
  WM_WRITE72,
  WM_WRITE80,
  WM_WRITE88,
  WM_WRITE96,
  WM_WRITE104,
  WM_WRITE112,
  WM_WRITE120,
  WM_WRITE128,
  WM_WRITE136,
  WM_WRITE144,
  WM_WRITE152,
  WM_WRITE160,
  WM_WRITE168,
  WM_WRITE176,
  WM_WRITE184,
  WM_WRITE192,
  WM_WRITE200,
  WM_WRITE208,
  WM_WRITE216,
  WM_WRITE224,
  WM_WRITE232,
  WM_WRITE240,
  WM_WRITE248,
  WM_WRITE256,
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
      return GET_U8;
    case 'u16':
      return GET_U16;
    case 'u24':
      return GET_U24;
    case 'u32':
      return GET_U32;
    case 'u40':
      return GET_U40;
    case 'u48':
      return GET_U48;
    case 'u56':
      return GET_U56;
    case 'u64':
      return GET_U64;
    case 'u72':
      return GET_U72;
    case 'u80':
      return GET_U80;
    case 'u88':
      return GET_U88;
    case 'u96':
      return GET_U96;
    case 'u104':
      return GET_U104;
    case 'u112':
      return GET_U112;
    case 'u120':
      return GET_U120;
    case 'u128':
      return GET_U128;
    case 'u136':
      return GET_U136;
    case 'u144':
      return GET_U144;
    case 'u152':
      return GET_U152;
    case 'u160':
      return GET_U160;
    case 'u168':
      return GET_U168;
    case 'u176':
      return GET_U176;
    case 'u184':
      return GET_U184;
    case 'u192':
      return GET_U192;
    case 'u200':
      return GET_U200;
    case 'u208':
      return GET_U208;
    case 'u216':
      return GET_U216;
    case 'u224':
      return GET_U224;
    case 'u232':
      return GET_U232;
    case 'u240':
      return GET_U240;
    case 'u248':
      return GET_U248;
    default:
      throw new Error('Invalid CairoUint type');
  }
};

export const wmReaduNImport = (uNtype: CairoUint) => {
  switch (uNtype.toString()) {
    case 'u8':
      return WM_READ8;
    case 'u16':
      return WM_READ16;
    case 'u24':
      return WM_READ24;
    case 'u32':
      return WM_READ32;
    case 'u40':
      return WM_READ40;
    case 'u48':
      return WM_READ48;
    case 'u56':
      return WM_READ56;
    case 'u64':
      return WM_READ64;
    case 'u72':
      return WM_READ72;
    case 'u80':
      return WM_READ80;
    case 'u88':
      return WM_READ88;
    case 'u96':
      return WM_READ96;
    case 'u104':
      return WM_READ104;
    case 'u112':
      return WM_READ112;
    case 'u120':
      return WM_READ120;
    case 'u128':
      return WM_READ128;
    case 'u136':
      return WM_READ136;
    case 'u144':
      return WM_READ144;
    case 'u152':
      return WM_READ152;
    case 'u160':
      return WM_READ160;
    case 'u168':
      return WM_READ168;
    case 'u176':
      return WM_READ176;
    case 'u184':
      return WM_READ184;
    case 'u192':
      return WM_READ192;
    case 'u200':
      return WM_READ200;
    case 'u208':
      return WM_READ208;
    case 'u216':
      return WM_READ216;
    case 'u224':
      return WM_READ224;
    case 'u232':
      return WM_READ232;
    case 'u240':
      return WM_READ240;
    case 'u248':
      return WM_READ248;
    case 'u256':
      return WM_READ256;
    default:
      throw new Error('Invalid CairoUint type');
  }
};

export const wmWriteuNImport = (uNtype: CairoUint) => {
  switch (uNtype.toString()) {
    case 'u8':
      return WM_WRITE8;
    case 'u16':
      return WM_WRITE16;
    case 'u24':
      return WM_WRITE24;
    case 'u32':
      return WM_WRITE32;
    case 'u40':
      return WM_WRITE40;
    case 'u48':
      return WM_WRITE48;
    case 'u56':
      return WM_WRITE56;
    case 'u64':
      return WM_WRITE64;
    case 'u72':
      return WM_WRITE72;
    case 'u80':
      return WM_WRITE80;
    case 'u88':
      return WM_WRITE88;
    case 'u96':
      return WM_WRITE96;
    case 'u104':
      return WM_WRITE104;
    case 'u112':
      return WM_WRITE112;
    case 'u120':
      return WM_WRITE120;
    case 'u128':
      return WM_WRITE128;
    case 'u136':
      return WM_WRITE136;
    case 'u144':
      return WM_WRITE144;
    case 'u152':
      return WM_WRITE152;
    case 'u160':
      return WM_WRITE160;
    case 'u168':
      return WM_WRITE168;
    case 'u176':
      return WM_WRITE176;
    case 'u184':
      return WM_WRITE184;
    case 'u192':
      return WM_WRITE192;
    case 'u200':
      return WM_WRITE200;
    case 'u208':
      return WM_WRITE208;
    case 'u216':
      return WM_WRITE216;
    case 'u224':
      return WM_WRITE224;
    case 'u232':
      return WM_WRITE232;
    case 'u240':
      return WM_WRITE240;
    case 'u248':
      return WM_WRITE248;
    case 'u256':
      return WM_WRITE256;
    default:
      throw new Error('Invalid CairoUint type');
  }
};
