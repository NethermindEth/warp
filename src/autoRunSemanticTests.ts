import { exec, execSync } from 'child_process';
import { existsSync, readFileSync, writeFileSync } from 'fs-extra';

if (!existsSync('./tests/behaviour/solidity')) {
  execSync('bash ./tests/behaviour/setup.sh');
}

const filters = [
  // 'solidity/test/libsolidity/semanticTests/abiEncoderV1',
  // 'solidity/test/libsolidity/semanticTests/abiEncoderV1/cleanup',
  // 'solidity/test/libsolidity/semanticTests/abiEncoderV1/struct',
  // 'solidity/test/libsolidity/semanticTests/abiEncoderV2',
  // 'solidity/test/libsolidity/semanticTests/abiEncoderV2/cleanup',
  // 'solidity/test/libsolidity/semanticTests/abiEncoderV2/struct',
  // 'solidity/test/libsolidity/semanticTests/abiencodedecode',
  'solidity/test/libsolidity/semanticTests/accessor',
  // 'solidity/test/libsolidity/semanticTests/arithmetics',
  // 'solidity/test/libsolidity/semanticTests/array',
  // 'solidity/test/libsolidity/semanticTests/array/concat',
  // 'solidity/test/libsolidity/semanticTests/array/copying',
  // 'solidity/test/libsolidity/semanticTests/array/delete',
  // 'solidity/test/libsolidity/semanticTests/array/indexAccess',
  // 'solidity/test/libsolidity/semanticTests/array/pop',
  // 'solidity/test/libsolidity/semanticTests/array/push',
  // 'solidity/test/libsolidity/semanticTests/array/slices',
  // 'solidity/test/libsolidity/semanticTests/asmForLoop',
  // 'solidity/test/libsolidity/semanticTests/builtinFunctions',
  // 'solidity/test/libsolidity/semanticTests/calldata',
  // 'solidity/test/libsolidity/semanticTests/cleanup',
  // 'solidity/test/libsolidity/semanticTests/constantEvaluator',
  // 'solidity/test/libsolidity/semanticTests/constants',
  // 'solidity/test/libsolidity/semanticTests/constructor',
  // 'solidity/test/libsolidity/semanticTests/conversions',
  // 'solidity/test/libsolidity/semanticTests/ecrecover',
  // 'solidity/test/libsolidity/semanticTests/enums',
  // 'solidity/test/libsolidity/semanticTests/error',
  // 'solidity/test/libsolidity/semanticTests/errors',
  // 'solidity/test/libsolidity/semanticTests/events',
  // 'solidity/test/libsolidity/semanticTests/exponentiation',
  // 'solidity/test/libsolidity/semanticTests/expressions',
  // 'solidity/test/libsolidity/semanticTests/externalContracts',
  // 'solidity/test/libsolidity/semanticTests/externalContracts/_prbmath',
  // 'solidity/test/libsolidity/semanticTests/externalContracts/_stringutils',
  // 'solidity/test/libsolidity/semanticTests/externalSource',
  // 'solidity/test/libsolidity/semanticTests/externalSource/_external',
  // 'solidity/test/libsolidity/semanticTests/externalSource/_external/subdir',
  // 'solidity/test/libsolidity/semanticTests/externalSource/_non_normalized_paths',
  // 'solidity/test/libsolidity/semanticTests/externalSource/_relative_imports',
  // 'solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/D',
  // 'solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/dir',
  // 'solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/dir/B',
  // 'solidity/test/libsolidity/semanticTests/externalSource/_relative_imports/dir/G',
  // 'solidity/test/libsolidity/semanticTests/externalSource/_source_name_starting_with_dots',
  // 'solidity/test/libsolidity/semanticTests/externalSource/_source_name_starting_with_dots/dir',
  // 'solidity/test/libsolidity/semanticTests/fallback',
  // 'solidity/test/libsolidity/semanticTests/freeFunctions',
  // 'solidity/test/libsolidity/semanticTests/functionCall',
  // 'solidity/test/libsolidity/semanticTests/functionCall/inheritance',
  // 'solidity/test/libsolidity/semanticTests/functionSelector',
  // 'solidity/test/libsolidity/semanticTests/functionTypes',
  // 'solidity/test/libsolidity/semanticTests/getters',
  // 'solidity/test/libsolidity/semanticTests/immutable',
  // 'solidity/test/libsolidity/semanticTests/inheritance',
  // 'solidity/test/libsolidity/semanticTests/inlineAssembly',
  // 'solidity/test/libsolidity/semanticTests/integer',
  // 'solidity/test/libsolidity/semanticTests/interfaceID',
  // 'solidity/test/libsolidity/semanticTests/isoltestTesting',
  // 'solidity/test/libsolidity/semanticTests/isoltestTesting/storage',
  // 'solidity/test/libsolidity/semanticTests/libraries',
  // 'solidity/test/libsolidity/semanticTests/literals',
  // 'solidity/test/libsolidity/semanticTests/memoryManagement',
  // 'solidity/test/libsolidity/semanticTests/metaTypes',
  // 'solidity/test/libsolidity/semanticTests/modifiers',
  // 'solidity/test/libsolidity/semanticTests/multiSource',
  // 'solidity/test/libsolidity/semanticTests/operators',
  // 'solidity/test/libsolidity/semanticTests/operators/shifts',
  // 'solidity/test/libsolidity/semanticTests/optimizer',
  // 'solidity/test/libsolidity/semanticTests/payable',
  // 'solidity/test/libsolidity/semanticTests/receive',
  // 'solidity/test/libsolidity/semanticTests/revertStrings',
  // 'solidity/test/libsolidity/semanticTests/reverts',
  // 'solidity/test/libsolidity/semanticTests/salted_create',
  // 'solidity/test/libsolidity/semanticTests/smoke',
  // 'solidity/test/libsolidity/semanticTests/specialFunctions',
  // 'solidity/test/libsolidity/semanticTests/state',
  // 'solidity/test/libsolidity/semanticTests/statements',
  // 'solidity/test/libsolidity/semanticTests/storage',
  // 'solidity/test/libsolidity/semanticTests/strings',
  // 'solidity/test/libsolidity/semanticTests/strings/concat',
  // 'solidity/test/libsolidity/semanticTests/structs',
  // 'solidity/test/libsolidity/semanticTests/structs/calldata',
  // 'solidity/test/libsolidity/semanticTests/structs/conversion',
  // 'solidity/test/libsolidity/semanticTests/tryCatch',
  // 'solidity/test/libsolidity/semanticTests/types',
  // 'solidity/test/libsolidity/semanticTests/types/mapping',
  // 'solidity/test/libsolidity/semanticTests/underscore',
  // 'solidity/test/libsolidity/semanticTests/uninitializedFunctionPointer',
  // 'solidity/test/libsolidity/semanticTests/userDefinedValueType',
  // 'solidity/test/libsolidity/semanticTests/variables',
  // 'solidity/test/libsolidity/semanticTests/various',
  // 'solidity/test/libsolidity/semanticTests/viaYul',
  // 'solidity/test/libsolidity/semanticTests/viaYul/array_memory_allocation',
  // 'solidity/test/libsolidity/semanticTests/viaYul/cleanup',
  // 'solidity/test/libsolidity/semanticTests/viaYul/conditional',
  // 'solidity/test/libsolidity/semanticTests/viaYul/conversion',
  // 'solidity/test/libsolidity/semanticTests/viaYul/loops',
  // 'solidity/test/libsolidity/semanticTests/viaYul/storage',
  // 'solidity/test/libsolidity/semanticTests/virtualFunctions',
];

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
          !trimmed.slice(2).includes('//') &&
          line.includes(filter)
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
  const controller = new AbortController();
  const { signal } = controller;
  exec('yarn testnet', { signal });
  execSync(`FILTER=${filter} yarn test:behaviour`, { stdio: 'inherit' });
  controller.abort();
});

writeFileSync(whitelistPath, whitelistData);
