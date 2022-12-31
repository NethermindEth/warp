import { execSync } from 'child_process';
import assert from 'assert';
import { existsSync, readFileSync, writeFileSync } from 'fs-extra';

if (!existsSync('./tests/behaviour/solidity')) {
  execSync('bash ./tests/behaviour/setup.sh');
}

const filters_batches = {
  '1': [
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/cleanup',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV1/struct',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/cleanup',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiEncoderV2/struct',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/abiencodedecode',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/accessor',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/arithmetics',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/array',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/array/concat',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/array/copying',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/array/delete',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/array/indexAccess',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/array/pop',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/array/push',

    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/array/slices',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/asmForLoop',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/builtinFunctions',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/calldata',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/cleanup',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/constantEvaluator',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/constants',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/constructor',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/conversions',

    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/ecrecover',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/enums',

    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/error',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/errors',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/events',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/exponentiation',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/expressions',
  ],

  '2': [
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/_prbmath',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalContracts/_stringutils',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_external',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_external/subdir',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_non_normalized_paths',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_relative_imports',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/D',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/dir',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/dir/B',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/dir/G',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_source_name_starting_with_dots',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/externalSource/_source_name_starting_with_dots/dir',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/fallback',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/freeFunctions',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/functionCall/inheritance',

    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionSelector',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/functionTypes',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/getters',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/immutable',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/inheritance',

    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/inlineAssembly',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/integer',

    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/interfaceID',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestTesting',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/isoltestTesting/storage',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/libraries',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/literals',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/memoryManagement',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/metaTypes',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/modifiers',

    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/multiSource',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/operators',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/operators/shifts',

    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/optimizer',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/payable',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/receive',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/revertStrings',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/reverts',

    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/salted_create',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/smoke',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/specialFunctions',
  ],

  '3': [
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/statements',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/storage',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/strings',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/strings/concat',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/structs',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/calldata',

    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/structs/conversion',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/tryCatch',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/types',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/types/mapping',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/underscore',

    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/uninitializedFunctionPointer',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/userDefinedValueType',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/variables',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/various',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/array_memory_allocation',

    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/cleanup',
    // 'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conditional',

    'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/conversion',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/loops',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/viaYul/storage',
    'tests/behaviour/solidity/test/libsolidity/semanticTests/virtualFunctions',
    'tests/behaviour/solidity/test/libsolidity/semanticTests',
  ],
};

let filters: string[] = [];

if (process.env.SM_BATCH) {
  // assert SM_BATCH is only '1', '2', or '3'
  assert(['1', '2', '3'].includes(process.env.SM_BATCH));
  filters = filters_batches[process.env.SM_BATCH as '1' | '2' | '3'];
} else {
  filters = Object.values(filters_batches).flat();
}

console.log(filters);

const whitelistPath = './tests/behaviour/expectations/semantic_whitelist.ts';
const whitelistData = readFileSync(whitelistPath, 'utf-8');

function uncommentTests(filter: string): void {
  writeFileSync(
    whitelistPath,
    whitelistData
      .split('\n')
      .map((line): string => {
        const trimmed = line.trim();
        if (
          trimmed.startsWith(`// '`) &&
          trimmed.includes(filter) &&
          !trimmed.slice(`// '${filter}/`.length).includes('/')
        ) {
          return line.replace('//', '');
        } else {
          return line;
        }
      })
      .join('\n'),
  );
}

filters.forEach((filter) => {
  uncommentTests(filter);
  console.log('------------------------------------------------------');
  try {
    execSync(
      `FILTER=${filter} npx mocha tests/behaviour/behaviour.test.ts --extension ts --require ts-node/register --exit`,
      { stdio: 'inherit' },
    );
  } catch (e) {
    console.log(e);
    throw e;
  }
});

writeFileSync(whitelistPath, whitelistData);
