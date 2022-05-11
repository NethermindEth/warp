import {
  CairoDynArray,
  CairoFelt,
  CairoStruct,
  CairoTuple,
  CairoType,
  WarpLocation,
} from '../utils/cairoTypeSystem';
import { TranspileFailedError } from '../utils/errors';

// Could the DyanArray Function be built here.
export function serialiseReads(
  type: CairoType,
  readFelt: (offset: number) => string,
  readId: (offset: number) => string,
  createDynLenStatement: (offset: number) => string,
  createDynPtrStatement: (offset: number) => string,
): [reads: string[], pack: string, containsDynArray: boolean] {
  let containsDynArray = false;
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
      } else if (elem === Read.DynArrayLen) {
        reads.push(readFelt(reads.length));
        reads.push(
          readFelt(reads.length) +
            createDynLenStatement(reads.length) +
            createDynPtrStatement(reads.length),
        );
        containsDynArray = true;
        return `len${reads.length - 1}`;
      } else if (elem === Read.DynArrayPtr) {
        return `ptr${reads.length - 1}`;
      } else {
        return elem;
      }
    })
    .join('');
  return [reads, packString, containsDynArray];
}

enum Read {
  Felt,
  Id,
  DynArrayLen,
  DynArrayPtr,
}

function producePackExpression(type: CairoType): (string | Read)[] {
  if (type instanceof WarpLocation) return [Read.Id];
  if (type instanceof CairoFelt) return [Read.Felt];
  if (type instanceof CairoTuple) {
    return ['(', ...type.members.flatMap((member) => [...producePackExpression(member), ',']), ')'];
  }
  if (type instanceof CairoDynArray) {
    return [type.name, '(', 'len', '=', Read.DynArrayLen, ',', 'ptr', '=', Read.DynArrayPtr, ')'];
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
