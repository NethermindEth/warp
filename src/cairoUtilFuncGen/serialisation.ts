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
    .map((elem: packExpReturnType) => {
      if (elem.dataOrDataType === Read.UN) {
        reads.push(readFelt(reads.length));
        reads.push(
          `let read${reads.length} = core::integer::u${elem.metadata.nBits}_from_felt252(read${
            reads.length - 1
          });`,
        );
      } else if (elem.dataOrDataType === Read.Address) {
        requiredImports.push({ import: OPTION_TRAIT, isTrait: true });
        requiredImports.push({ import: CONTRACT_ADDRESS });
        reads.push(readFelt(reads.length));
        reads.push(
          `let read${reads.length} =  starknet::contract_address_try_from_felt252(read${
            reads.length - 1
          }).unwrap();`,
        );
      } else if (elem.dataOrDataType === Read.Felt) {
        reads.push(readFelt(reads.length));
      } else if (elem.dataOrDataType === Read.Id) {
        reads.push(readId(reads.length));
      } else if (elem.dataOrDataType === Read.Bool) {
        requiredImports.push({ import: FELT252_INTO_BOOL });
        reads.push(readFelt(reads.length));
        reads.push(`let read${reads.length} = felt252_into_bool(read${reads.length - 1});`);
      } else {
        return elem.dataOrDataType;
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

interface packExpReturnType {
  dataOrDataType: string | Read;
  metadata: {
    nBits?: number;
  };
}

function createPackExpReturnType(dataOrDataType: string | Read): packExpReturnType {
  return { dataOrDataType, metadata: {} };
}

function producePackExpression(type: CairoType): packExpReturnType[] {
  if (type instanceof WarpLocation) return [createPackExpReturnType(Read.Id)];
  if (type instanceof CairoFelt) return [createPackExpReturnType(Read.Felt)];
  if (type instanceof CairoContractAddress) return [createPackExpReturnType(Read.Address)];
  if (type instanceof CairoBool) return [createPackExpReturnType(Read.Bool)];
  if (type instanceof CairoStaticArray) {
    return [
      createPackExpReturnType('('),
      ...Array(type.size)
        .fill([...producePackExpression(type.type), ','])
        .flat()
        .map(createPackExpReturnType),
      createPackExpReturnType(')'),
    ];
  }

  if (type instanceof CairoUint) {
    if (type.fullStringRepresentation === CairoUint256.fullStringRepresentation) {
      return [
        createPackExpReturnType(type.toString()),
        createPackExpReturnType('{'),
        ...[
          ['low', new CairoUint(128)],
          ['high', new CairoUint(128)],
        ]
          .flatMap(([memberName, memberType]) => [
            createPackExpReturnType(memberName as string),
            createPackExpReturnType(':'),
            ...producePackExpression(memberType as CairoType),
            createPackExpReturnType(','),
          ])
          .slice(0, -1),
        createPackExpReturnType('}'),
      ];
    }
    return [{ dataOrDataType: Read.UN, metadata: { nBits: type.nBits } }];
  }

  if (type instanceof CairoStruct) {
    return [
      createPackExpReturnType(type.name),
      createPackExpReturnType('{'),
      ...[...type.members.entries()]
        .flatMap(([memberName, memberType]) => [
          createPackExpReturnType(memberName),
          createPackExpReturnType(':'),
          ...producePackExpression(memberType),
          createPackExpReturnType(','),
        ])
        .slice(0, -1),
      createPackExpReturnType('}'),
    ];
  }

  throw new TranspileFailedError(
    `Attempted to produce pack expression for unexpected cairo type ${type.toString()}`,
  );
}
