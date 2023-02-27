import { execSync } from 'child_process';
import { existsSync, readFileSync, writeFileSync } from 'fs-extra';

/*

This is a script to run semantic tests from specific solc release. 

To execute this script, run:
` $ VERSION=*SOLC_VERSION* FITLER=*filter* yarn test:semantic --compare `

- compare flag will tell the differences between tests list present in 
  semanticWhitelist.ts and tests written in specified version of solc
- filter can be specified to run a specfic group of tests or an individual 
  test

It generates a file `tests/behaviour/expectations/semanticTestsGenerated.ts`
which contains the list of tests and call the routine `behaviour.test.ts`
test execution step for every group of semantic tests.
*/

let version = '0.8.14'; // default version if no solc version is given
const filter = process.env.FILTER;

if (filter) {
  console.log(`Using filter for Semantics tests: ${filter}`);
}

if (process.env.VERSION) {
  version = process.env.VERSION;
} else {
  console.warn('No solc version provided for semantic tests, using default: ' + version);
}

if (!existsSync('./tests/behaviour/solidity')) {
  if (!existsSync('./tests/behaviour/setup.sh')) {
    new Error('setup.sh not found');
  }
  execSync(`VERSION=${version}./tests/behaviour/setup.sh`);
}

const whitelistPath = './tests/behaviour/expectations/semanticWhitelist.ts';
const whitelistData = readFileSync(whitelistPath, 'utf-8');

const testsSupportStatus: Map<string, string> = new Map(); // key: test-name , value : string

whitelistData.split('\n').forEach((line) => {
  const trimmed = line.trim();

  if (trimmed.startsWith(`// 'tests/behaviour/solidity/test/libsolidity/semanticTests/`)) {
    /**
     *  Tests with comments in semanticWhitelist.ts is considered as unsupported
     *  So, a unsupported test entry in the list contains more than one '//'s.
     *  An example entry of unsupported test is:
     *      // 'tests/behaviour/solidity/test/libsolidity/semanticTests/state_variables_init_order_3.sol', // TEST NOT SUPPORTED AT THIS STAGE or WILL NOT SUPPORT
     *  An entry structure of a test in semantic test list is:
     *  | // | '(single starting quote) | --test-name-- | '(single ending quote) | ,(optional comma separator) | // | --comment-part-- |
     **/

    const testPath = trimmed.slice(`// '`.length).trim();
    const testPathLets = testPath.split('//'); // first item is the test-name

    if (testPathLets.length > 1) {
      testsSupportStatus.set(
        testPathLets[0].replace("'", '').replace(',', '').trim(), // remove possible trailing punctuation marks
        testPathLets.slice(1).join('//').trim(), // comment part of the test
      );
    } else {
      testsSupportStatus.set(testPathLets[0].replace("'", '').replace(',', '').trim(), 'SUPPORTED');
    }
  }
});

if (process.argv.includes('--compare')) {
  // Comparisons of tests between white_list and current version

  const testFiles = execSync(
    // Get all solidity files under tests/behaviour/solidity/test/libsolidity/semanticTests (recursively)
    'find ./tests/behaviour/solidity/test/libsolidity/semanticTests -type f -name "*.sol"',
  )
    .toString()
    .trim()
    .split('\n')
    .sort()
    .filter((file) => {
      if (filter) {
        return file.includes(filter);
      }
      return true;
    })
    .map((file) => file.slice(2)); // remove leading `./`

  console.log(
    `-------Tests which are present in solc version:${version} but not in whitelist------`,
  );
  testFiles.forEach((file) => {
    if (!testsSupportStatus.has(file)) {
      console.log(file);
    }
  });

  console.log(
    `-------Tests which are present in whitelist but not in solc version:${version}------`,
  );
  testsSupportStatus.forEach((_value, key) => {
    if (!testFiles.includes(key)) {
      console.log(key);
    }
  });
}

// Test Execution Loop

const testDirs = execSync(
  // Get list of all directories present in tests/behaviour/solidity/test/libsolidity/semanticTests
  'find ./tests/behaviour/solidity/test/libsolidity/semanticTests -mindepth 1 -type d',
)
  .toString()
  .trim()
  .split('\n')
  .sort()
  .map((file) => file.slice(2)); // remove leading `./`

const filterDirs: string[] = [
  ...testDirs,
  'tests/behaviour/solidity/test/libsolidity/semanticTests', // An extra entry for miscllaneous tests
];

const currentTestsFileBody = readFileSync(
  './tests/behaviour/expectations/semanticTestsGenerated.ts',
  'utf-8',
); // Read current state of semanticTestsGenerated.ts

filterDirs.forEach((dir) => {
  const testFiles = execSync(`find ./${dir} -mindepth 1 -maxdepth 1 -name '*.sol'`)
    .toString()
    .trim()
    .split('\n')
    .sort()
    .map((file) => file.slice(2))
    .filter((file) => {
      // ASK: what if there is new test added in the release
      // ASK: i.e test present in this release but not in semanticWhitelist
      if (filter) {
        return file.includes(filter) && testsSupportStatus.get(file) === 'SUPPORTED';
      }
      return testsSupportStatus.get(file) === 'SUPPORTED';
    });
  if (testFiles.length > 0) {
    console.log(
      `-----------------------------------Running tests from ${dir
        .split('/')
        .pop()}-----------------------------------`,
    );
    const testsFileBody = [
      '// AUTO-GENERATED by semanticTestRunner.ts',
      '// By default, tests should be an empty list',
      'const tests:string[] = [',
      ...testFiles.map((file) => {
        return `    "${file}",`;
      }),
      '];',
      'export default tests;',
    ];
    writeFileSync(
      './tests/behaviour/expectations/semanticTestsGenerated.ts',
      testsFileBody.join('\n'),
    );
    try {
      execSync(
        `FILTER=${dir} npx mocha tests/behaviour/behaviour.test.ts --extension ts --require ts-node/register --exit`,
        { stdio: 'inherit' },
      );
    } catch (e) {
      console.log(e);
    }
  }
});

writeFileSync('./tests/behaviour/expectations/semanticTestsGenerated.ts', currentTestsFileBody); // restore the content of the file
