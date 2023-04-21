import {
  CairoContractAddress,
  CairoFelt,
  CairoStaticArray,
  CairoStruct,
  CairoType,
  CairoUint,
  CairoUint256,
  WarpLocation,
} from '../utils/cairoTypeSystem';
import { TranspileFailedError } from '../utils/errors';

export function serialiseReads(
  type: CairoType,
  readFelt: (offset: number) => string,
  readId: (offset: number) => string,
  readAddress: (offset: number) => string,
  uNread: (nBits: number, offset: number) => string,
): [reads: string[], pack: string] {
  const packExpression = producePackExpression(type);
  const reads: string[] = [];
  const packString: string = packExpression
    .map((elem: string | Read) => {
      switch (elem) {
        case Read.Felt:
          reads.push(readFelt(reads.length));
          return `read${reads.length - 1}`;
        case Read.Id:
          reads.push(readId(reads.length));
          return `read${reads.length - 1}`;
        case Read.Address:
          reads.push(readAddress(reads.length));
          return `read${reads.length - 1}`;
        case Read.U8:
        case Read.U16:
        case Read.U24:
        case Read.U32:
        case Read.U40:
        case Read.U48:
        case Read.U56:
        case Read.U64:
        case Read.U72:
        case Read.U80:
        case Read.U88:
        case Read.U96:
        case Read.U104:
        case Read.U112:
        case Read.U120:
        case Read.U128:
        case Read.U136:
        case Read.U144:
        case Read.U152:
        case Read.U160:
        case Read.U168:
        case Read.U176:
        case Read.U184:
        case Read.U192:
        case Read.U200:
        case Read.U208:
        case Read.U216:
        case Read.U224:
        case Read.U232:
        case Read.U240:
        case Read.U248:
          reads.push(uNread(elem, reads.length));
          return `read${reads.length - 1}`;
        default:
          return elem;
      }
    })
    .join('');
  return [reads, packString];
}

enum Read {
  Felt,
  Id,
  Address,
  U8,
  U16,
  U24,
  U32,
  U40,
  U48,
  U56,
  U64,
  U72,
  U80,
  U88,
  U96,
  U104,
  U112,
  U120,
  U128,
  U136,
  U144,
  U152,
  U160,
  U168,
  U176,
  U184,
  U192,
  U200,
  U208,
  U216,
  U224,
  U232,
  U240,
  U248,
}

function uNreadSelector(nBits: number) {
  switch (nBits) {
    case 8:
      return Read.U8;
    case 16:
      return Read.U16;
    case 24:
      return Read.U24;
    case 32:
      return Read.U32;
    case 40:
      return Read.U40;
    case 48:
      return Read.U48;
    case 56:
      return Read.U56;
    case 64:
      return Read.U64;
    case 72:
      return Read.U72;
    case 80:
      return Read.U80;
    case 88:
      return Read.U88;
    case 96:
      return Read.U96;
    case 104:
      return Read.U104;
    case 112:
      return Read.U112;
    case 120:
      return Read.U120;
    case 128:
      return Read.U128;
    case 136:
      return Read.U136;
    case 144:
      return Read.U144;
    case 152:
      return Read.U152;
    case 160:
      return Read.U160;
    case 168:
      return Read.U168;
    case 176:
      return Read.U176;
    case 184:
      return Read.U184;
    case 192:
      return Read.U192;
    case 200:
      return Read.U200;
    case 208:
      return Read.U208;
    case 216:
      return Read.U216;
    case 224:
      return Read.U224;
    case 232:
      return Read.U232;
    case 240:
      return Read.U240;
    case 248:
      return Read.U248;

    default:
      throw new Error(`Unexpected nBits: ${nBits}`);
  }
}

function producePackExpression(type: CairoType): (string | Read)[] {
  if (type instanceof WarpLocation) return [Read.Id];
  if (type instanceof CairoFelt) return [Read.Felt];
  if (type instanceof CairoContractAddress) return [Read.Address];
  if (type instanceof CairoStaticArray) {
    return [
      '(',
      ...Array(type.size)
        .fill([...producePackExpression(type.type), ','])
        .flat(),
      ')',
    ];
  }

  if (type instanceof CairoUint) {
    if (type.fullStringRepresentation === CairoUint256.fullStringRepresentation) {
      return [
        type.toString(),
        '{',
        ...[
          ['low', new CairoUint(128)],
          ['high', new CairoUint(128)],
        ]
          .flatMap(([memberName, memberType]) => [
            memberName as string,
            ':',
            ...producePackExpression(memberType as CairoType),
            ',',
          ])
          .slice(0, -1),
        '}',
      ];
    }
    // return [`core::integer::${type.toString()}_from_felt252(${Read.Felt})`];
    return [uNreadSelector(type.nBits)];
  }

  if (type instanceof CairoStruct) {
    return [
      type.name,
      '{',
      ...[...type.members.entries()]
        .flatMap(([memberName, memberType]) => [
          memberName,
          ':',
          ...producePackExpression(memberType),
          ',',
        ])
        .slice(0, -1),
      '}',
    ];
  }

  throw new TranspileFailedError(
    `Attempted to produce pack expression for unexpected cairo type ${type.toString()}`,
  );
}
