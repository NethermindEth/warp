import {
  CairoContractAddress,
  CairoBool,
  CairoFelt,
  CairoStaticArray,
  CairoStruct,
  CairoType,
  CairoUint,
  CairoUint256,
  WarpLocation,
} from '../utils/cairoTypeSystem';
import { TranspileFailedError } from '../utils/errors';
import { CONTRACT_ADDRESS, FELT252_INTO_BOOL, OPTION_TRAIT } from '../utils/importPaths';

export function serialiseReads(
  type: CairoType,
  readFelt: (offset: number) => string,
  readId: (offset: number) => string,
): [
  reads: string[],
  pack: string,
  requiredImports: { import: [string[], string]; isTrait?: boolean }[],
] {
  const packExpression = producePackExpression(type);
  const reads: string[] = [];
  const requiredImports: { import: [string[], string]; isTrait?: boolean }[] = [];
  const packString: string = packExpression
    .map((elem: string | Read | (string | Read)[]) => {
      if (elem instanceof Array) {
        reads.push(readFelt(reads.length));
        reads.push(
          `let read${reads.length} = core::integer::u${elem[1]}_from_felt252(read${
            reads.length - 1
          });`,
        );
      } else if (elem === Read.Address) {
        requiredImports.push({ import: OPTION_TRAIT, isTrait: true });
        requiredImports.push({ import: CONTRACT_ADDRESS });
        reads.push(readFelt(reads.length));
        reads.push(
          `let read${reads.length} =  starknet::contract_address_try_from_felt252(read${
            reads.length - 1
          }).unwrap();`,
        );
      } else if (elem === Read.Felt) {
        reads.push(readFelt(reads.length));
      } else if (elem === Read.Id) {
        reads.push(readId(reads.length));
      } else if (elem === Read.Bool) {
        requiredImports.push({ import: FELT252_INTO_BOOL });
        reads.push(readFelt(reads.length));
        reads.push(`let read${reads.length} = felt252_into_bool(read${reads.length - 1});`);
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
  Address,
  UN,
  Bool,
}

function producePackExpression(type: CairoType): (string | Read | (string | Read)[])[] {
  if (type instanceof WarpLocation) return [Read.Id];
  if (type instanceof CairoFelt) return [Read.Felt];
  if (type instanceof CairoContractAddress) return [Read.Address];
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
