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
  uNread: (offset: number, nBits: number) => string,
): [reads: string[], pack: string] {
  const packExpression = producePackExpression(type);
  const reads: string[] = [];
  const packString: string = packExpression
    .map((elem: string | Read | (string | Read)[]) => {
      if (elem instanceof Array) {
        reads.push(uNread(reads.length, Number(elem[1] as string)));
      }
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
  UN,
}

function producePackExpression(type: CairoType): (string | Read | (string | Read)[])[] {
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
    return [[Read.UN, type.nBits]];
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
