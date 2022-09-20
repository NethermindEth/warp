import { expect } from 'chai';
import { describe, it } from 'mocha';
import { parse } from '../src/utils/functionSignatureParser';
import { Command } from 'commander';
import { CliOptions } from '../src/programFactory';
import * as path from 'path';
import { createCairoFileName, isValidSolFile, outputResult } from '../src/io';
import { handleTranspilationError, transpile } from '../src/transpiler';
import { compileSolFile } from '../src/solCompile';
import { postProcessCairoFile } from '../src/utils/postCairoWrite';
import {
  createCallProgram,
  createCompileProgram,
  createDeclareProgram,
  createDeployAccountProgram,
  createDeployProgram,
  createInvokeProgram,
  createStatusProgram,
} from '../src/programFactory';

type Input = string[] | number[] | Input[] | (string | number | Input)[];

type encodeTest = [string, Input, string[]];

const tests: encodeTest[] = [
  ['decimals()', [], []],
  ['totalSupply()', [], []],
  ['balanceOf(address)', ['0x123123123'], ['0x123123123']],
  ['balanceOf(address)', ['1234'], ['1234']],
  [
    'mint(address[4],uint256)',
    [['0x1', '0x2', '0x3', '0x4'], '4'],
    ['0x1', '0x2', '0x3', '0x4', '0x4', '0x0'],
  ],
  [
    'mint(address[],uint256)',
    [['0x1', '0x2', '0x3', '0x4'], '4'],
    ['0x4', '0x1', '0x2', '0x3', '0x4', '0x4', '0x0'],
  ],
  [
    'mint(address[][2])',
    [
      [
        ['0x1', '0x2', '0x3'],
        ['0x3', '0x4'],
      ],
    ],
    ['0x3', '0x1', '0x2', '0x3', '0x2', '0x3', '0x4'],
  ],
  ['mint(bool,bool,bool,bool)', ['true', 'false', '1', '0'], ['0x1', '0x0', '0x1', '0x0']],
  ['mint(bytes8)', ['0xffffffffffffffff'], ['0xffffffffffffffff']],
  ['byte_me(bytes)', [['0xff', '0xff', '0xff', '0xff']], ['0x4', '0xff', '0xff', '0xff', '0xff']],
  ['string(string)', ['hello'], ['0x5', '0x68', '0x65', '0x6c', '0x6c', '0x6f']],
  [
    'uint256arr(uint256[], uint256[2])',
    [
      ['4', '5', '6'],
      ['99', '100'],
    ],
    ['0x3', '0x4', '0x0', '0x5', '0x0', '0x6', '0x0', '0x63', '0x0', '0x64', '0x0'],
  ],
];

describe('Solidity abi parsing and decode tests', function () {
  tests.map(([signature, input, output]) =>
    it(`parses ${signature}`, () => {
      const result = parse(signature)(input);
      expect(result).to.deep.equal(output.map(BigInt));
    }),
  );
});

const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;
const cairoPath = `${path.resolve(__dirname, '..')}`;

const options = {
  network: '--network',
  noWallet: '--no_wallet',
  hash: '--hash',
  debug: '--debug_info',
  wallet: '--wallet',
  account: '--account',
  address: '--address',
  useCairoAbi: '--use_cairo_abi',
  function: '--function',
  inputs: '--inputs',
  contract: '--contract',
  output: '--output',
  abi: '--abi',
  classHash: '--class_hash',
  cairoPath: '--cairo_path',
};

const command = {
  starknet: 'starknet',
  starknetStatus: 'tx_status',
  warpStatus: 'status',
  starknetCompile: 'starknet-compile',
  compile: 'compile',
  deployAccount: 'deploy_account',
  call: 'call',
  invoke: 'invoke',
  deploy: 'deploy',
  declare: 'declare',
};

const mockData = {
  network: 'alpha-goerli',
  hash: '0x01a',
  cairoFile: 'tests/testFiles/Test__WC__WARP.cairo',
  cairoFileCompiled: 'tests/testFiles/Test__WC__WARP_compiled.json',
  cairoFileAbi: 'tests/testFiles/Test__WC__WARP_abi.json',
  ozWallet: 'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
  account: 'Test_Account',
};

describe('Warp CLI test', function () {
  this.timeout(200000);

  it('generate cairo contract', async () => {
    const program = new Command();

    program
      .command('transpile <files...>')
      .option('--compile-cairo')
      .option('--no-compile-errors')
      .option('--check-trees')
      .option('--highlight <ids...>')
      .option('--order <passOrder>')
      .option(
        '-o, --output-dir <path>',
        'Output directory for transpiled Cairo files.',
        'warp_output',
      )
      .option('--print-trees')
      .option('--no-result')
      .option('--no-stubs')
      .option('--no-strict')
      // Stops transpilation after the specified pass
      .option('--until <pass>')
      .option('--no-warnings')
      .option('--dev') // for development mode
      .action((files: string[], options: CliOptions) => {
        // We do the extra work here to make sure all the errors are printed out
        // for all files which are invalid.
        if (files.map((file) => isValidSolFile(file)).some((result) => !result)) return;
        const cairoSuffix = '.cairo';
        const contractToHashMap = new Map<string, string>();
        files.forEach((file) => {
          if (files.length > 1) {
            console.log(`Compiling ${file}`);
          }
          try {
            transpile(compileSolFile(file, options.warnings), options)
              .map(([name, cairo, abi]) => {
                outputResult(name, cairo, options, cairoSuffix, abi);
                return createCairoFileName(name, cairoSuffix);
              })
              .forEach((file) => {
                postProcessCairoFile(file, options.outputDir, contractToHashMap);
              });
          } catch (e) {
            handleTranspilationError(e);
          }
        });
      });
    program.parse([
      'node',
      './tests/cli.testTest.ts',
      'transpile',
      'tests/testFiles/Test.sol',
      '--output-dir',
      '.',
    ]);
  });

  describe('warp status', function () {
    describe('command output test', function () {
      let program: Command;
      const output = { val: '' };

      beforeEach(() => {
        program = new Command();
        program.exitOverride();
        createStatusProgram(program, output, true);
      });

      it('0. compare output string', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.warpStatus,
          mockData.hash,
          options.network,
          mockData.network,
        ]);

        const outputArray = [
          warpVenvPrefix,
          command.starknet,
          command.starknetStatus,
          options.hash,
          mockData.hash,
          options.network,
          mockData.network,
        ];
        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.warpStatus,
          mockData.hash,
          options.network,
          mockData.network,
        ]);

        const starknet = output.val.includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.includes(command.starknetStatus);
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp command passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.warpStatus,
          mockData.hash,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.warpStatus);
      });

      it('3. correct tx_hash passed with hash modifier', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.warpStatus,
          mockData.hash,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[1]).to.be.equal(mockData.hash);
        const hashExists = output.val.includes(options.hash);
        expect(hashExists).to.be.equal(true);
        const argExists = output.val.includes(args[1]);
        expect(argExists).to.be.equal(true);
      });

      it('4. correct network passed with network option', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.warpStatus,
          mockData.hash,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal(options.network);
        expect(args[3]).to.be.equal(mockData.network);
        const networkExists = output.val.includes(args[2]);
        expect(networkExists).to.be.equal(true);
        const goerliExists = output.val.includes(args[3]);
        expect(goerliExists).to.be.equal(true);
      });

      it('5. parse failed because of missing tx_hash', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', command.warpStatus]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('6. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', 'test']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('7.correct starknet and command output', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.warpStatus,
          mockData.hash,
          options.network,
          mockData.network,
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.starknetStatus);
        expect(splittedOutput[3]).to.be.equal(options.hash);
        expect(splittedOutput[4]).to.be.equal(mockData.hash);
        expect(splittedOutput[5]).to.be.equal(options.network);
        expect(splittedOutput[6]).to.be.equal(mockData.network);
      });
    });

    describe('runStarknetStatus test', function () {
      let program: Command;
      const output = { val: '' };

      beforeEach(() => {
        program = new Command();
        program.exitOverride();
        createStatusProgram(program, output, true);
      });

      it('8. tx_hash is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', command.warpStatus]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('9. network option needs to be specified', async () => {
        let err: { code: string | undefined } | undefined;
        try {
          program.parse(['node', './tests/cli.testTest.ts', command.warpStatus, mockData.hash]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err).to.be.equal(
          'Error: Exception: feeder_gateway_url must be specified with the "status" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.',
        );
      });

      it('10. does not accept unknown options', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse([
            'node',
            './tests/cli.testTest.ts',
            command.warpStatus,
            mockData.hash,
            '--unknown',
          ]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownOption');
      });

      it('11. does not execute with no commands', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', mockData.hash]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });

  describe('warp compile', function () {
    describe('command output test', function () {
      let program: Command;
      const output = { val: '' };

      const debugOptions = ['--debug_info_with_source', '--no_debug_info'];

      beforeEach(() => {
        program = new Command();
        program.exitOverride();
        createCompileProgram(program, output, true);
      });

      it('0. compare output string', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.compile,
          mockData.cairoFile,
          options.debug,
        ]);

        const outputArray = [
          warpVenvPrefix,
          command.starknetCompile,
          options.output,
          mockData.cairoFileCompiled,
          options.abi,
          mockData.cairoFileAbi,
          options.cairoPath,
          cairoPath,
          debugOptions[0],
          mockData.cairoFile,
        ];
        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        program.parse(['node', './tests/cli.testTest.ts', command.compile, mockData.cairoFile]);

        const starknet = output.val.includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.includes(command.starknetCompile);
        expect(starknetCommand).to.be.equal(true);
        const fileToCompile = output.val.includes(mockData.cairoFile);
        expect(fileToCompile).to.be.equal(true);
      });

      it('2. correct warp command passed', async () => {
        program.parse(['node', './tests/cli.testTest.ts', command.compile, mockData.cairoFile]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.compile);
      });

      it('3. correct file passed with filePath', async () => {
        program.parse(['node', './tests/cli.testTest.ts', command.compile, mockData.cairoFile]);

        const args = program.args;
        expect(args[1]).to.be.equal(mockData.cairoFile);
        const file = output.val.includes(mockData.cairoFile);
        expect(file).to.be.equal(true);
      });

      it('4. correct debug options passed with debug options', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.compile,
          mockData.cairoFile,
          options.debug,
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal(options.debug);
        const debugExists = output.val.includes(debugOptions[0]);
        expect(debugExists).to.be.equal(true);
      });

      it('5. correct debug options passed with no debug options', async () => {
        program.parse(['node', './tests/cli.testTest.ts', command.compile, mockData.cairoFile]);

        const debugExists = output.val.includes(debugOptions[1]);
        expect(debugExists).to.be.equal(true);
        const boolExists = output.val.includes('false');
        expect(boolExists).to.be.equal(false);
      });

      it('6. parse failed because of missing tx_hash', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', command.compile]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('7. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', 'test']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('8. correct starknet and command output', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.compile,
          mockData.cairoFile,
          options.debug,
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknetCompile);
        expect(splittedOutput[2]).to.be.equal(options.output);
        expect(splittedOutput[3]).to.be.equal(mockData.cairoFileCompiled);
        expect(splittedOutput[4]).to.be.equal(options.abi);
        expect(splittedOutput[5]).to.be.equal(mockData.cairoFileAbi);
        expect(splittedOutput[8]).to.be.equal(debugOptions[0]);
        expect(splittedOutput[9]).to.be.equal(mockData.cairoFile);
      });
    });

    describe('runStarknetCompile test', function () {
      let program: Command;
      const output = { val: '' };

      beforeEach(() => {
        program = new Command();
        program.exitOverride();
        createCompileProgram(program, output, true);
      });

      it('9. filepath is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', command.compile]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('10. a debug option is optional', async () => {
        let err: undefined;
        try {
          program.parse(['node', './tests/cli.testTest.ts', command.compile, mockData.cairoFile]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined as undefined;
        }
        expect(err).to.be.equal(undefined);
      });

      it('11. does not accept unknown options', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse([
            'node',
            './tests/cli.testTest.ts',
            command.compile,
            mockData.cairoFile,
            '--unknownOption',
          ]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined as
            | { code: string | undefined }
            | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownOption');
      });

      it('12. does not execute with no commands', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', 'randomCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });

  describe('warp deploy_account', function () {
    describe('command output test', function () {
      let program: Command;
      const output = { val: '' };

      beforeEach(() => {
        program = new Command();
        program.exitOverride();
        createDeployAccountProgram(program, output, true);
      });

      it('0. compare output string', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.deployAccount,
          options.network,
          mockData.network,
          options.wallet,
          mockData.ozWallet,
          options.account,
          mockData.account,
        ]);

        const outputArray = [
          warpVenvPrefix,
          command.starknet,
          command.deployAccount,
          options.wallet,
          mockData.ozWallet,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
        ];
        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.deployAccount,
          options.network,
          mockData.network,
          options.wallet,
          mockData.ozWallet,
          options.account,
          mockData.account,
        ]);

        const starknet = output.val.includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.includes(command.starknet);
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp command passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.deployAccount,
          options.network,
          mockData.network,
          options.wallet,
          mockData.ozWallet,
          options.account,
          mockData.account,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.deployAccount);
      });

      it('3. correct network option passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.deployAccount,
          options.network,
          mockData.network,
          options.wallet,
          mockData.ozWallet,
          options.account,
          mockData.account,
        ]);

        const args = program.args;
        expect(args[1]).to.be.equal(options.network);
        expect(args[2]).to.be.equal(mockData.network);
        const net = output.val.includes(options.network);
        expect(net).to.be.equal(true);
        const goerli = output.val.includes(mockData.network);
        expect(goerli).to.be.equal(true);
      });

      it('4. correct wallet option passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.deployAccount,
          options.network,
          mockData.network,
          options.wallet,
          mockData.ozWallet,
          options.account,
          mockData.account,
        ]);

        const args = program.args;
        expect(args[3]).to.be.equal(options.wallet);
        expect(args[4]).to.be.equal(mockData.ozWallet);
        const opt = output.val.includes(options.wallet);
        expect(opt).to.be.equal(true);
        const wallet = output.val.includes(mockData.ozWallet);
        expect(wallet).to.be.equal(true);
      });

      it('5. correct account option passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.deployAccount,
          options.network,
          mockData.network,
          options.wallet,
          mockData.ozWallet,
          options.account,
          mockData.account,
        ]);

        const args = program.args;
        expect(args[5]).to.be.equal(options.account);
        expect(args[6]).to.be.equal(mockData.account);
        const opt = output.val.includes(options.account);
        expect(opt).to.be.equal(true);
        const name = output.val.includes(mockData.account);
        expect(name).to.be.equal(true);
      });

      it('6. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', 'incorrectCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('7. correct starknet and command output', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.deployAccount,
          options.network,
          mockData.network,
          options.wallet,
          mockData.ozWallet,
          options.account,
          mockData.account,
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.deployAccount);
        expect(splittedOutput[3]).to.be.equal(options.wallet);
        expect(splittedOutput[4]).to.be.equal(mockData.ozWallet);
        expect(splittedOutput[5]).to.be.equal(options.network);
        expect(splittedOutput[6]).to.be.equal(mockData.network);
        expect(splittedOutput[7]).to.be.equal(options.account);
        expect(splittedOutput[8]).to.be.equal(mockData.account);
      });
    });

    describe('runStarknetDeployAccount test', function () {
      let program: Command;
      const output = { val: '' };

      beforeEach(() => {
        program = new Command();
        program.exitOverride();
        createDeployAccountProgram(program, output, true);
      });

      it('8. wallet option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', command.deployAccount]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err).to.be.equal(
          'Error: AssertionError: --wallet must be specified with the "deploy_account" subcommand.',
        );
      });

      it('9. network option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse([
            'node',
            './tests/cli.testTest.ts',
            command.deployAccount,
            options.wallet,
            mockData.ozWallet,
          ]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }
        expect(err).to.be.equal(
          'Error: Exception: feeder_gateway_url must be specified with the "deploy_account" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.',
        );
      });

      it('10. does not accept unknown options', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse([
            'node',
            './tests/cli.testTest.ts',
            command.deployAccount,
            '--unknownOption',
          ]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownOption');
      });

      it('11. does not execute with no commands', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', 'randomCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });

  describe('warp call', function () {
    const mockCallFunc = 'get_balance';
    const mockAddress = '0x1234';

    describe('command output test', function () {
      let program: Command;
      const output = { val: '' };

      beforeEach(async () => {
        program = new Command();
        program.exitOverride();
        await createCallProgram(program, output, true);
      });

      it('0. compare output string', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.call,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockCallFunc,
          options.network,
          mockData.network,
        ]);

        const outputArray = [
          warpVenvPrefix,
          command.starknet,
          command.call,
          options.address,
          mockAddress,
          options.abi,
          mockData.cairoFileAbi,
          options.function,
          mockCallFunc,
          options.network,
          mockData.network,
          options.noWallet,
          '',
          '',
          '',
        ];
        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.call,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockCallFunc,
          options.network,
          mockData.network,
        ]);

        const starknet = output.val.includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.includes(command.starknet);
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp and starknet command passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.call,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockCallFunc,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.call);
        const starknetCommand = output.val.includes(command.call);
        expect(starknetCommand).to.be.equal(true);
      });

      it('3. successfully passed file', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.call,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockCallFunc,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.call);
        const starknetCommand = output.val.includes(command.call);
        expect(starknetCommand).to.be.equal(true);
        expect(args[1]).to.be.equal(mockData.cairoFile);
        const filepath = output.val.includes(mockData.cairoFileAbi);
        expect(filepath).to.be.equal(true);
      });

      it('4. correct network option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.call,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockCallFunc,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[7]).to.be.equal(options.network);
        expect(args[8]).to.be.equal(mockData.network);
        const net = output.val.includes(options.network);
        expect(net).to.be.equal(true);
        const goerli = output.val.includes(mockData.network);
        expect(goerli).to.be.equal(true);
      });

      it('5. correct address option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.call,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockCallFunc,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal(options.address);
        expect(args[3]).to.be.equal(mockAddress);
        const opt = output.val.includes(options.address);
        expect(opt).to.be.equal(true);
        const wallet = output.val.includes(mockAddress);
        expect(wallet).to.be.equal(true);
      });

      it('6. use cairo abi option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.call,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockCallFunc,
          options.network,
          mockData.network,
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[5]).to.be.equal(options.abi);
        expect(splittedOutput[6].endsWith('.json')).to.be.equal(true);
      });

      it('7. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync(['node', './tests/cli.testTest.ts', 'incorrectCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('8. correct starknet and command output', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.call,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockCallFunc,
          options.network,
          mockData.network,
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.call);
        expect(splittedOutput[3]).to.be.equal(options.address);
        expect(splittedOutput[4]).to.be.equal(mockAddress);
        expect(splittedOutput[5]).to.be.equal(options.abi);
        expect(splittedOutput[6]).to.be.equal(mockData.cairoFileAbi);
        expect(splittedOutput[7]).to.be.equal(options.function);
        expect(splittedOutput[8]).to.be.equal(mockCallFunc);
        expect(splittedOutput[9]).to.be.equal(options.network);
        expect(splittedOutput[10]).to.be.equal(mockData.network);
        expect(splittedOutput[11]).to.be.equal(options.noWallet);
      });
    });

    describe('runStarknetCallOrInvoke test', function () {
      let program: Command;
      const output = { val: '' };

      beforeEach(async () => {
        program = new Command();
        program.exitOverride();
        await createCallProgram(program, output, true);
      });

      it('9. file path option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync(['node', './tests/cli.testTest.ts', command.call]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingMandatoryOptionValue');
      });

      it('10. address option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync([
            'node',
            './tests/cli.testTest.ts',
            command.call,
            mockData.cairoFile,
          ]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }
        expect(err?.code).to.be.equal('commander.missingMandatoryOptionValue');
      });

      it('11. function option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync([
            'node',
            './tests/cli.testTest.ts',
            command.call,
            mockData.cairoFile,
            options.address,
            mockAddress,
          ]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }
        expect(err?.code).to.be.equal('commander.missingMandatoryOptionValue');
      });

      it('12. does not accept unknown options', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync([
            'node',
            './tests/cli.testTest.ts',
            command.call,
            mockData.cairoFile,
            options.address,
            mockAddress,
            options.useCairoAbi,
            options.function,
            mockCallFunc,
            options.network,
            mockData.network,
            '--unknownOptions',
          ]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownOption');
      });

      it('13. does not execute with no commands', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync(['node', './tests/cli.testTest.ts', 'randomCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });

  describe('warp invoke', function () {
    const mockInvokeFunc = 'increase_balance';
    const mockInputValues = '1234';
    const mockAddress = '0x1234';

    describe('command output test', function () {
      let program: Command;
      const output = { val: '' };

      beforeEach(async () => {
        program = new Command();
        program.exitOverride();
        await createInvokeProgram(program, output, true);
      });

      it('0. compare output string', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.invoke,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockInvokeFunc,
          options.inputs,
          mockInputValues,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const outputArray = [
          warpVenvPrefix,
          command.starknet,
          command.invoke,
          options.address,
          mockAddress,
          options.abi,
          mockData.cairoFileAbi,
          options.function,
          mockInvokeFunc,
          options.network,
          mockData.network,
          options.wallet,
          mockData.ozWallet,
          options.account,
          mockData.account,
          options.inputs,
          mockInputValues,
        ];
        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.invoke,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockInvokeFunc,
          options.inputs,
          mockInputValues,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const starknet = output.val.includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.includes(command.starknet);
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp and starknet command passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.invoke,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockInvokeFunc,
          options.inputs,
          mockInputValues,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.invoke);
        const starknetCommand = output.val.includes(command.invoke);
        expect(starknetCommand).to.be.equal(true);
      });

      it('3. successfully passed file', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.invoke,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockInvokeFunc,
          options.inputs,
          mockInputValues,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.invoke);
        const starknetCommand = output.val.includes(command.invoke);
        expect(starknetCommand).to.be.equal(true);
        expect(args[1]).to.be.equal(mockData.cairoFile);
        const filepath = output.val.includes(mockData.cairoFileAbi);
        expect(filepath).to.be.equal(true);
      });

      it('4. correct network option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.invoke,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockInvokeFunc,
          options.inputs,
          mockInputValues,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const args = program.args;
        expect(args[9]).to.be.equal(options.network);
        expect(args[10]).to.be.equal(mockData.network);
        const net = output.val.includes(options.network);
        expect(net).to.be.equal(true);
        const goerli = output.val.includes(mockData.network);
        expect(goerli).to.be.equal(true);
      });

      it('5. correct address option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.invoke,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockInvokeFunc,
          options.inputs,
          mockInputValues,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal(options.address);
        expect(args[3]).to.be.equal(mockAddress);
        const opt = output.val.includes(options.address);
        expect(opt).to.be.equal(true);
        const wallet = output.val.includes(mockAddress);
        expect(wallet).to.be.equal(true);
      });

      it('6. correct function option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.invoke,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockInvokeFunc,
          options.inputs,
          mockInputValues,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const args = program.args;
        expect(args[5]).to.be.equal(options.function);
        expect(args[6]).to.be.equal(mockInvokeFunc);
        const opt = output.val.includes(options.function);
        expect(opt).to.be.equal(true);
        const invokeFunction = output.val.includes(mockInvokeFunc);
        expect(invokeFunction).to.be.equal(true);
      });

      it('7. correct input option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.invoke,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockInvokeFunc,
          options.inputs,
          mockInputValues,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const args = program.args;
        expect(args[7]).to.be.equal(options.inputs);
        expect(args[8]).to.be.equal(mockInputValues);
        const opt = output.val.includes(options.inputs);
        expect(opt).to.be.equal(true);
        const input = output.val.includes(mockInputValues);
        expect(input).to.be.equal(true);
      });

      it('8. correct account option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.invoke,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockInvokeFunc,
          options.inputs,
          mockInputValues,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const args = program.args;
        expect(args[11]).to.be.equal(options.account);
        expect(args[12]).to.be.equal(mockData.account);
        const opt = output.val.includes(options.inputs);
        expect(opt).to.be.equal(true);
        const acc = output.val.includes(mockData.account);
        expect(acc).to.be.equal(true);
      });

      it('9. correct wallet option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.invoke,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockInvokeFunc,
          options.inputs,
          mockInputValues,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const args = program.args;
        expect(args[13]).to.be.equal(options.wallet);
        expect(args[14]).to.be.equal(mockData.ozWallet);
        const opt = output.val.includes(options.inputs);
        expect(opt).to.be.equal(true);
        const wall = output.val.includes(mockData.ozWallet);
        expect(wall).to.be.equal(true);
      });

      it('10. use cairo abi option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.invoke,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockInvokeFunc,
          options.inputs,
          mockInputValues,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[5]).to.be.equal(options.abi);
        expect(splittedOutput[6].endsWith('.json')).to.be.equal(true);
      });

      it('11. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync(['node', './tests/cli.testTest.ts', 'incorrectCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('12. correct starknet and command output', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.invoke,
          mockData.cairoFile,
          options.address,
          mockAddress,
          options.useCairoAbi,
          options.function,
          mockInvokeFunc,
          options.inputs,
          mockInputValues,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.invoke);
        expect(splittedOutput[3]).to.be.equal(options.address);
        expect(splittedOutput[4]).to.be.equal(mockAddress);
        expect(splittedOutput[5]).to.be.equal(options.abi);
        expect(splittedOutput[6]).to.be.equal(mockData.cairoFileAbi);
        expect(splittedOutput[7]).to.be.equal(options.function);
        expect(splittedOutput[8]).to.be.equal(mockInvokeFunc);
        expect(splittedOutput[9]).to.be.equal(options.network);
        expect(splittedOutput[10]).to.be.equal(mockData.network);
        expect(splittedOutput[11]).to.be.equal(options.wallet);
        expect(splittedOutput[12]).to.be.equal(mockData.ozWallet);
        expect(splittedOutput[13]).to.be.equal(options.account);
        expect(splittedOutput[14]).to.be.equal(mockData.account);
        expect(splittedOutput[15]).to.be.equal(options.inputs);
        expect(splittedOutput[16]).to.be.equal(mockInputValues);
      });
    });

    describe('runStarknetCallOrInvoke test', function () {
      let program: Command;
      const output = { val: '' };

      beforeEach(async () => {
        program = new Command();
        program.exitOverride();
        await createInvokeProgram(program, output, true);
      });

      it('13. file path option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync(['node', './tests/cli.testTest.ts', command.invoke]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingMandatoryOptionValue');
      });

      it('14. address option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync([
            'node',
            './tests/cli.testTest.ts',
            command.invoke,
            mockData.cairoFile,
          ]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }
        expect(err?.code).to.be.equal('commander.missingMandatoryOptionValue');
      });

      it('15. function option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync([
            'node',
            './tests/cli.testTest.ts',
            command.invoke,
            mockData.cairoFile,
            options.address,
            mockAddress,
          ]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }
        expect(err?.code).to.be.equal('commander.missingMandatoryOptionValue');
      });

      it('16. does not accept unknown options', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync([
            'node',
            './tests/cli.testTest.ts',
            command.invoke,
            mockData.cairoFile,
            options.address,
            mockAddress,
            options.useCairoAbi,
            options.function,
            mockInvokeFunc,
            options.inputs,
            mockInputValues,
            options.network,
            mockData.network,
            options.account,
            mockData.account,
            options.wallet,
            mockData.ozWallet,
            '--unknownOptions',
          ]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownOption');
      });

      it('17. does not execute with no commands', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync(['node', './tests/cli.testTest.ts', 'randomCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });

  describe('warp deploy', function () {
    describe('command output test', function () {
      let program: Command;
      const output = { val: '' };
      const mockClassHash = '--class_hash';

      beforeEach(async () => {
        program = new Command();
        program.exitOverride();
        await createDeployProgram(program, output, true);
      });

      it('0. compare output string', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.noWallet,
        ]);

        const outputArray = [
          warpVenvPrefix,
          command.starknet,
          command.deploy,
          options.network,
          mockData.network,
          options.account,
          'undefined',
          options.noWallet,
          options.contract,
          mockData.cairoFileCompiled,
          '',
        ];
        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const starknet = output.val.toString().includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.toString().includes(command.starknet);
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp and starknet command passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.deploy);
        const starknetCommand = output.val.toString().includes(command.deploy);
        expect(starknetCommand).to.be.equal(true);
      });

      it('3. successfully passed file with no wallet option', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.noWallet,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.deploy);
        const starknetCommand = output.val.includes(command.deploy);
        expect(starknetCommand).to.be.equal(true);
        expect(args[1]).to.be.equal(mockData.cairoFile);
      });

      it('4. correct network option passed with no wallet option', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.noWallet,
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal(options.network);
        expect(args[3]).to.be.equal(mockData.network);
        const net = output.val.includes(options.network);
        expect(net).to.be.equal(true);
        const goerli = output.val.includes(mockData.network);
        expect(goerli).to.be.equal(true);
      });

      it('5. contract hash option passed when wallet option wasnt passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
        ]);

        const args = program.args;

        expect(args[4]).to.be.equal(options.account);
        const opt = output.val.includes(mockClassHash);
        expect(opt).to.be.equal(true);
        const acc = output.val.includes(mockData.account);
        expect(acc).to.be.equal(true);
      });

      it('6. contract hash option passed when wallet option was passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const args = program.args;
        expect(args[6]).to.be.equal(options.wallet);
        expect(args[7]).to.be.equal(mockData.ozWallet);
        const opt = output.val.includes(mockClassHash);
        expect(opt).to.be.equal(true);
      });

      it('7. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync(['node', './tests/cli.testTest.ts', 'incorrectCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('8. correct starknet and command output with no wallet', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.noWallet,
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.deploy);
        expect(splittedOutput[3]).to.be.equal(options.network);
        expect(splittedOutput[4]).to.be.equal(mockData.network);
        expect(splittedOutput[5]).to.be.equal(options.account);
        expect(splittedOutput[6]).to.be.equal('undefined');
        expect(splittedOutput[7]).to.be.equal(options.noWallet);
        expect(splittedOutput[8]).to.be.equal(options.contract);
        expect(splittedOutput[9]).to.be.equal(mockData.cairoFileCompiled);
      });

      it('9. correct starknet and command output without no wallet and with account', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.deploy);
        expect(splittedOutput[3]).to.be.equal(options.network);
        expect(splittedOutput[4]).to.be.equal(mockData.network);
        expect(splittedOutput[5]).to.be.equal(options.account);
        expect(splittedOutput[6]).to.be.equal(mockData.account);
        expect(splittedOutput[7]).to.be.equal(options.classHash);
      });

      it('10. correct starknet and command output with wallet module and account', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.deploy);
        expect(splittedOutput[3]).to.be.equal(options.network);
        expect(splittedOutput[4]).to.be.equal(mockData.network);
        expect(splittedOutput[5]).to.be.equal(options.account);
        expect(splittedOutput[6]).to.be.equal(mockData.account);
        expect(splittedOutput[7]).to.be.equal('--class_hash');
      });
    });

    describe('runStarknetDeploy test', function () {
      let program: Command;
      const output = { val: '' };

      beforeEach(async () => {
        program = new Command();
        program.exitOverride();
        await createDeployProgram(program, output, true);
      });

      it('11. file path option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync(['node', './tests/cli.testTest.ts', command.deploy]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('12. does not accept unknown options', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync([
            'node',
            './tests/cli.testTest.ts',
            command.deploy,
            '--unknownOptions',
          ]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownOption');
      });

      it('13. does not execute with no commands', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          await program.parseAsync(['node', './tests/cli.testTest.ts', 'randomCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });

  describe('warp declare', function () {
    describe('command output test', function () {
      let program: Command;
      const output = { val: '' };

      beforeEach(() => {
        program = new Command();
        program.exitOverride();
        createDeclareProgram(program, output, true);
      });

      it('0. compare output string', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.declare,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const outputArray = [
          warpVenvPrefix,
          command.starknet,
          command.declare,
          options.contract,
          mockData.cairoFileCompiled,
          '--sender 0x1234',
          '--max_fee 1',
          options.network,
          mockData.network,
          options.noWallet,
        ];
        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.declare,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const starknet = output.val.includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.includes(command.starknet);
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp and starknet command passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.declare,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.declare);
        const starknetCommand = output.val.includes(command.declare);
        expect(starknetCommand).to.be.equal(true);
      });

      it('3. mockData.cairoFile passed successfully', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.declare,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.declare);
        const starknetCommand = output.val.includes(command.declare);
        expect(starknetCommand).to.be.equal(true);
        expect(args[1]).to.be.equal(mockData.cairoFile);
        const filepath = output.val.includes(mockData.cairoFileCompiled);
        expect(filepath).to.be.equal(true);
      });

      it('4. network option passed successfully', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.declare,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal(options.network);
        const net = output.val.includes(options.network);
        expect(net).to.be.equal(true);
        expect(args[3]).to.be.equal(mockData.network);
        const alpha = output.val.includes(mockData.network);
        expect(alpha).to.be.equal(true);
      });

      it('5. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', 'incorrectCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('6. correct starknet and command output with no wallet', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          command.declare,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.declare);
        expect(splittedOutput[3]).to.be.equal(options.contract);
        expect(splittedOutput[4]).to.be.equal(mockData.cairoFileCompiled);
        expect(splittedOutput[5]).to.be.equal('--sender');
        expect(splittedOutput[6]).to.be.equal('0x1234');
        expect(splittedOutput[7]).to.be.equal('--max_fee');
        expect(splittedOutput[8]).to.be.equal('1');
        expect(splittedOutput[9]).to.be.equal(options.network);
        expect(splittedOutput[10]).to.be.equal(mockData.network);
        expect(splittedOutput[11]).to.be.equal('--no_wallet');
      });
    });

    describe('runStarknetDeclare test', function () {
      let program: Command;
      const output = { val: '' };

      beforeEach(() => {
        program = new Command();
        program.exitOverride();
        createDeclareProgram(program, output, true);
      });

      it('7. file path option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', command.declare]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('8. does not accept unknown options', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', command.declare, '--unknownOptions']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownOption');
      });

      it('9. does not execute with no commands', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', 'randomCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });
});
