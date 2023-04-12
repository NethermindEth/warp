import {
  CairoBool,
  CairoFelt,
  CairoStaticArray,
  CairoStruct,
  CairoType,
  CairoUint256,
  WarpLocation,
} from '../utils/cairoTypeSystem';
import { TranspileFailedError } from '../utils/errors';
import { FELT252_INTO_BOOL } from '../utils/importPaths';

export function serialiseReads(
  type: CairoType,
  readFelt: (offset: number) => string,
  readId: (offset: number) => string,
): [reads: string[], pack: string, requiredImports: [string[], string][]] {
  const packExpression = producePackExpression(type);
  const reads: string[] = [];
  const requiredImports: [string[], string][] = [];
  const packString: string = packExpression
    .map((elem: string | Read) => {
      if (elem === Read.Felt) {
        reads.push(readFelt(reads.length));
      } else if (elem === Read.Id) {
        reads.push(readId(reads.length));
      } else if (elem === Read.Bool) {
        requiredImports.push(FELT252_INTO_BOOL);
        reads.push(readFelt(reads.length));
        reads.push(`let read${reads.length} = Felt252IntoBool::into(read${reads.length - 1});`);
      } else {
        return elem;
      }
      return `read${reads.length - 1}`;
    })
    .join('');
  return [reads, packString, requiredImports];
}

enum Read {
  Felt,
  Id,
  Bool,
}

function producePackExpression(type: CairoType): (string | Read)[] {
  if (type instanceof WarpLocation) return [Read.Id];
  if (type instanceof CairoFelt) return [Read.Felt];
  if (type instanceof CairoBool) return [Read.Bool];
  if (type instanceof CairoStaticArray) {
    return [
      '(',
      ...Array(type.size)
        .fill([...producePackExpression(type.type), ','])
        .flat(),
      ')',
    ];
  }
  if (type instanceof CairoStruct) {
    if (type.fullStringRepresentation === CairoUint256.fullStringRepresentation) {
      return [
        type.name,
        '{',
        ...[...type.members.entries()]
          .flatMap(([memberName, memberType]) => [
            memberName,
            ':',
            'u128_from_felt252(',
            ...producePackExpression(memberType),
            ')',
            ',',
          ])
          .slice(0, -1),
        '}',
      ];
    }
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
