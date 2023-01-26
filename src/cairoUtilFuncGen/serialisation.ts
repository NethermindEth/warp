import {
  CairoFelt,
  CairoStaticArray,
  CairoStruct,
  CairoTuple,
  CairoType,
  WarpLocation,
} from '../utils/cairoTypeSystem';
import { TranspileFailedError } from '../utils/errors';

export function serialiseReads(
  type: CairoType,
  readFelt: (offset: number) => string,
  readId: (offset: number) => string,
): [reads: string[], pack: string] {
  const packExpression = producePackExpression(type);
  const reads: string[] = [];
  const packString: string = packExpression
    .map((elem: string | Read) => {
      if (elem === Read.Felt) {
        reads.push(readFelt(reads.length));
        return `read${reads.length - 1}`;
      } else if (elem === Read.Id) {
        reads.push(readId(reads.length));
        return `read${reads.length - 1}`;
      } else {
        return elem;
      }
    })
    .join('');
  return [reads, packString];
}

enum Read {
  Felt,
  Id,
}

function producePackExpression(type: CairoType): (string | Read)[] {
  if (type instanceof WarpLocation) return [Read.Id];
  if (type instanceof CairoFelt) return [Read.Felt];
  if (type instanceof CairoTuple) {
    return ['(', ...type.members.flatMap((member) => [...producePackExpression(member), ',']), ')'];
  }
  if (type instanceof CairoStaticArray) {
    return ['(', ...Array(type.size).fill(producePackExpression(type.type)).flat(), ')'];
  }
  if (type instanceof CairoStruct) {
    return [
      type.name,
      '(',
      ...[...type.members.entries()]
        .flatMap(([memberName, memberType]) => [
          memberName,
          '=',
          ...producePackExpression(memberType),
          ',',
        ])
        .slice(0, -1),
      ')',
    ];
  }

  throw new TranspileFailedError(
    `Attempted to produce pack expression for unexpected cairo type ${type.toString()}`,
  );
}
