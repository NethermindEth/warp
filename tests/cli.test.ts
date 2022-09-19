import { expect } from 'chai';
import { describe, it } from 'mocha';
import { parse } from '../src/utils/functionSignatureParser';
import { Command } from 'commander';
import { createTranspileProgram } from '../src/programFactory';
import * as path from 'path';
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

describe('Warp CLI test', function () {
  this.timeout(200000);

  it('generate cairo contract', async () => {
    const program = new Command();

    createTranspileProgram(program);

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
          'status',
          '0x01a',
          '--network',
          'alpha-goerli',
        ]);

        const outputArray = [
          warpVenvPrefix,
          'starknet',
          'tx_status',
          '--hash',
          '0x01a',
          '--network',
          'alpha-goerli',
        ];

        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'status',
          '0x01a',
          '--network',
          'alpha-goerli',
        ]);

        const starknet = output.val.includes('starknet');
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.includes('tx_status');
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp command passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'status',
          '0x01a',
          '--network',
          'alpha-goerli',
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal('status');
      });

      it('3. correct tx_hash passed with hash modifier', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'status',
          '0x01a',
          '--network',
          'alpha-goerli',
        ]);

        const args = program.args;
        expect(args[1]).to.be.equal('0x01a');
        const hashExists = output.val.includes('--hash');
        expect(hashExists).to.be.equal(true);
        const argExists = output.val.includes(args[1]);
        expect(argExists).to.be.equal(true);
      });

      it('4. correct network passed with network option', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'status',
          '0x01a',
          '--network',
          'alpha-goerli',
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal('--network');
        expect(args[3]).to.be.equal('alpha-goerli');
        const networkExists = output.val.includes(args[2]);
        expect(networkExists).to.be.equal(true);
        const goerliExists = output.val.includes(args[3]);
        expect(goerliExists).to.be.equal(true);
      });

      it('5. parse failed because of missing tx_hash', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', 'status']);
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
          'status',
          '0x01a',
          '--network',
          'alpha-goerli',
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal('starknet');
        expect(splittedOutput[2]).to.be.equal('tx_status');
        expect(splittedOutput[3]).to.be.equal('--hash');
        expect(splittedOutput[4]).to.be.equal('0x01a');
        expect(splittedOutput[5]).to.be.equal('--network');
        expect(splittedOutput[6]).to.be.equal('alpha-goerli');
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
          program.parse(['node', './tests/cli.testTest.ts', 'status']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('9. network option needs to be specified', async () => {
        let err: { code: string | undefined } | undefined;
        try {
          program.parse(['node', './tests/cli.testTest.ts', 'status', '0x01a']);
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
          program.parse(['node', './tests/cli.testTest.ts', 'status', '0x01a', '--unknown']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownOption');
      });

      it('11. does not execute with no commands', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', '0x01a']);
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
          'compile',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--debug_info',
        ]);

        const outputArray = [
          warpVenvPrefix,
          'starknet-compile',
          '--output',
          'tests/testFiles/Test__WC__WARP_compiled.json',
          '--abi',
          'tests/testFiles/Test__WC__WARP_abi.json',
          '--cairo_path',
          cairoPath,
          debugOptions[0],
          'tests/testFiles/Test__WC__WARP.cairo',
        ];
        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'compile',
          'tests/testFiles/Test__WC__WARP.cairo',
        ]);

        const starknet = output.val.includes('starknet');
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.includes('starknet-compile');
        expect(starknetCommand).to.be.equal(true);
        const fileToCompile = output.val.includes('tests/testFiles/Test__WC__WARP.cairo');
        expect(fileToCompile).to.be.equal(true);
      });

      it('2. correct warp command passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'compile',
          'tests/testFiles/Test__WC__WARP.cairo',
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal('compile');
      });

      it('3. correct file passed with filePath', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'compile',
          'tests/testFiles/Test__WC__WARP.cairo',
        ]);

        const args = program.args;
        expect(args[1]).to.be.equal('tests/testFiles/Test__WC__WARP.cairo');
        const file = output.val.includes('tests/testFiles/Test__WC__WARP.cairo');
        expect(file).to.be.equal(true);
      });

      it('4. correct debug options passed with debug options', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'compile',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--debug_info',
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal('--debug_info');
        const debugExists = output.val.includes(debugOptions[0]);
        expect(debugExists).to.be.equal(true);
      });

      it('5. correct debug options passed with no debug options', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'compile',
          'tests/testFiles/Test__WC__WARP.cairo',
        ]);

        const debugExists = output.val.includes(debugOptions[1]);
        expect(debugExists).to.be.equal(true);
        const boolExists = output.val.includes('false');
        expect(boolExists).to.be.equal(false);
      });

      it('6. parse failed because of missing tx_hash', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', 'compile']);
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
          'compile',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--debug_info',
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal('starknet-compile');
        expect(splittedOutput[2]).to.be.equal('--output');
        expect(splittedOutput[3]).to.be.equal('tests/testFiles/Test__WC__WARP_compiled.json');
        expect(splittedOutput[4]).to.be.equal('--abi');
        expect(splittedOutput[5]).to.be.equal('tests/testFiles/Test__WC__WARP_abi.json');
        expect(splittedOutput[8]).to.be.equal(debugOptions[0]);
        expect(splittedOutput[9]).to.be.equal('tests/testFiles/Test__WC__WARP.cairo');
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
          program.parse(['node', './tests/cli.testTest.ts', 'compile']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('10. a debug option is optional', async () => {
        let err: undefined;
        try {
          program.parse([
            'node',
            './tests/cli.testTest.ts',
            'compile',
            'tests/testFiles/Test__WC__WARP.cairo',
          ]);
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
            'compile',
            'tests/testFiles/Test__WC__WARP.cairo',
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
          'deploy_account',
          '--network',
          'alpha-goerli',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
          '--account',
          'Test_Account',
        ]);

        const outputArray = [
          warpVenvPrefix,
          'starknet',
          'deploy_account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
        ];
        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'deploy_account',
          '--network',
          'alpha-goerli',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
          '--account',
          'Test_Account',
        ]);

        const starknet = output.val.includes('starknet');
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.includes('starknet');
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp command passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'deploy_account',
          '--network',
          'alpha-goerli',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
          '--account',
          'Test_Account',
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal('deploy_account');
      });

      it('3. correct network option passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'deploy_account',
          '--network',
          'alpha-goerli',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
          '--account',
          'Test_Account',
        ]);

        const args = program.args;
        expect(args[1]).to.be.equal('--network');
        expect(args[2]).to.be.equal('alpha-goerli');
        const net = output.val.includes('--network');
        expect(net).to.be.equal(true);
        const goerli = output.val.includes('alpha-goerli');
        expect(goerli).to.be.equal(true);
      });

      it('4. correct wallet option passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'deploy_account',
          '--network',
          'alpha-goerli',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
          '--account',
          'Test_Account',
        ]);

        const args = program.args;
        expect(args[3]).to.be.equal('--wallet');
        expect(args[4]).to.be.equal('starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount');
        const opt = output.val.includes('--wallet');
        expect(opt).to.be.equal(true);
        const wallet = output.val.includes(
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        );
        expect(wallet).to.be.equal(true);
      });

      it('5. correct account option passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'deploy_account',
          '--network',
          'alpha-goerli',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
          '--account',
          'Test_Account',
        ]);

        const args = program.args;
        expect(args[5]).to.be.equal('--account');
        expect(args[6]).to.be.equal('Test_Account');
        const opt = output.val.includes('--account');
        expect(opt).to.be.equal(true);
        const name = output.val.includes('Test_Account');
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
          'deploy_account',
          '--network',
          'alpha-goerli',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
          '--account',
          'Test_Account',
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal('starknet');
        expect(splittedOutput[2]).to.be.equal('deploy_account');
        expect(splittedOutput[3]).to.be.equal('--wallet');
        expect(splittedOutput[4]).to.be.equal(
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        );
        expect(splittedOutput[5]).to.be.equal('--network');
        expect(splittedOutput[6]).to.be.equal('alpha-goerli');
        expect(splittedOutput[7]).to.be.equal('--account');
        expect(splittedOutput[8]).to.be.equal('Test_Account');
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
          program.parse(['node', './tests/cli.testTest.ts', 'deploy_account']);
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
            'deploy_account',
            '--wallet',
            'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
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
          program.parse(['node', './tests/cli.testTest.ts', 'deploy_account', '--unknownOption']);
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
          'call',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'get_balance',
          '--network',
          'alpha-goerli',
        ]);

        const outputArray = [
          warpVenvPrefix,
          'starknet',
          'call',
          '--address',
          '0x1234',
          '--abi',
          'tests/testFiles/Test__WC__WARP_abi.json',
          '--function',
          'get_balance',
          '--network',
          'alpha-goerli',
          '--no_wallet',
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
          'call',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'get_balance',
          '--network',
          'alpha-goerli',
        ]);

        const starknet = output.val.includes('starknet');
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.includes('starknet');
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp and starknet command passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'call',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'get_balance',
          '--network',
          'alpha-goerli',
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal('call');
        const starknetCommand = output.val.includes('call');
        expect(starknetCommand).to.be.equal(true);
      });

      it('3. successfully passed file', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'call',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'get_balance',
          '--network',
          'alpha-goerli',
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal('call');
        const starknetCommand = output.val.includes('call');
        expect(starknetCommand).to.be.equal(true);
        expect(args[1]).to.be.equal('tests/testFiles/Test__WC__WARP.cairo');
        const filepath = output.val.includes('tests/testFiles/Test__WC__WARP_abi.json');
        expect(filepath).to.be.equal(true);
      });

      it('4. correct network option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'call',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'get_balance',
          '--network',
          'alpha-goerli',
        ]);

        const args = program.args;
        expect(args[7]).to.be.equal('--network');
        expect(args[8]).to.be.equal('alpha-goerli');
        const net = output.val.includes('--network');
        expect(net).to.be.equal(true);
        const goerli = output.val.includes('alpha-goerli');
        expect(goerli).to.be.equal(true);
      });

      it('5. correct address option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'call',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'get_balance',
          '--network',
          'alpha-goerli',
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal('--address');
        expect(args[3]).to.be.equal('0x1234');
        const opt = output.val.includes('--address');
        expect(opt).to.be.equal(true);
        const wallet = output.val.includes('0x1234');
        expect(wallet).to.be.equal(true);
      });

      it('6. use cairo abi option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'call',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'get_balance',
          '--network',
          'alpha-goerli',
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[5]).to.be.equal('--abi');
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
          'call',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'get_balance',
          '--network',
          'alpha-goerli',
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal('starknet');
        expect(splittedOutput[2]).to.be.equal('call');
        expect(splittedOutput[3]).to.be.equal('--address');
        expect(splittedOutput[4]).to.be.equal('0x1234');
        expect(splittedOutput[5]).to.be.equal('--abi');
        expect(splittedOutput[6]).to.be.equal('tests/testFiles/Test__WC__WARP_abi.json');
        expect(splittedOutput[7]).to.be.equal('--function');
        expect(splittedOutput[8]).to.be.equal('get_balance');
        expect(splittedOutput[9]).to.be.equal('--network');
        expect(splittedOutput[10]).to.be.equal('alpha-goerli');
        expect(splittedOutput[11]).to.be.equal('--no_wallet');
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
          await program.parseAsync(['node', './tests/cli.testTest.ts', 'call']);
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
            'call',
            'tests/testFiles/Test__WC__WARP.cairo',
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
            'call',
            'tests/testFiles/Test__WC__WARP.cairo',
            '--address',
            '0x1234',
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
            'call',
            'tests/testFiles/Test__WC__WARP.cairo',
            '--address',
            '0x1234',
            '--use_cairo_abi',
            '--function',
            'get_balance',
            '--network',
            'alpha-goerli',
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
          'invoke',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'increase_balance',
          '--inputs',
          '1234',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const outputArray = [
          warpVenvPrefix,
          'starknet',
          'invoke',
          '--address',
          '0x1234',
          '--abi',
          'tests/testFiles/Test__WC__WARP_abi.json',
          '--function',
          'increase_balance',
          '--network',
          'alpha-goerli',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
          '--account',
          'Test_Account',
          '--inputs',
          '1234',
        ];
        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'invoke',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'increase_balance',
          '--inputs',
          '1234',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const starknet = output.val.includes('starknet');
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.includes('starknet');
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp and starknet command passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'invoke',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'increase_balance',
          '--inputs',
          '1234',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal('invoke');
        const starknetCommand = output.val.includes('invoke');
        expect(starknetCommand).to.be.equal(true);
      });

      it('3. successfully passed file', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'invoke',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'increase_balance',
          '--inputs',
          '1234',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal('invoke');
        const starknetCommand = output.val.includes('invoke');
        expect(starknetCommand).to.be.equal(true);
        expect(args[1]).to.be.equal('tests/testFiles/Test__WC__WARP.cairo');
        const filepath = output.val.includes('tests/testFiles/Test__WC__WARP_abi.json');
        expect(filepath).to.be.equal(true);
      });

      it('4. correct network option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'invoke',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'increase_balance',
          '--inputs',
          '1234',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const args = program.args;
        expect(args[9]).to.be.equal('--network');
        expect(args[10]).to.be.equal('alpha-goerli');
        const net = output.val.includes('--network');
        expect(net).to.be.equal(true);
        const goerli = output.val.includes('alpha-goerli');
        expect(goerli).to.be.equal(true);
      });

      it('5. correct address option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'invoke',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'increase_balance',
          '--inputs',
          '1234',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal('--address');
        expect(args[3]).to.be.equal('0x1234');
        const opt = output.val.includes('--address');
        expect(opt).to.be.equal(true);
        const wallet = output.val.includes('0x1234');
        expect(wallet).to.be.equal(true);
      });

      it('6. correct function option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'invoke',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'increase_balance',
          '--inputs',
          '1234',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const args = program.args;
        expect(args[5]).to.be.equal('--function');
        expect(args[6]).to.be.equal('increase_balance');
        const opt = output.val.includes('--function');
        expect(opt).to.be.equal(true);
        const invokeFunction = output.val.includes('increase_balance');
        expect(invokeFunction).to.be.equal(true);
      });

      it('7. correct input option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'invoke',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'increase_balance',
          '--inputs',
          '1234',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const args = program.args;
        expect(args[7]).to.be.equal('--inputs');
        expect(args[8]).to.be.equal('1234');
        const opt = output.val.includes('--inputs');
        expect(opt).to.be.equal(true);
        const input = output.val.includes('1234');
        expect(input).to.be.equal(true);
      });

      it('8. correct account option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'invoke',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'increase_balance',
          '--inputs',
          '1234',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const args = program.args;
        expect(args[11]).to.be.equal('--account');
        expect(args[12]).to.be.equal('Test_Account');
        const opt = output.val.includes('--inputs');
        expect(opt).to.be.equal(true);
        const acc = output.val.includes('Test_Account');
        expect(acc).to.be.equal(true);
      });

      it('9. correct wallet option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'invoke',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'increase_balance',
          '--inputs',
          '1234',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const args = program.args;
        expect(args[13]).to.be.equal('--wallet');
        expect(args[14]).to.be.equal(
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        );
        const opt = output.val.includes('--inputs');
        expect(opt).to.be.equal(true);
        const wall = output.val.includes(
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        );
        expect(wall).to.be.equal(true);
      });

      it('10. use cairo abi option passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'invoke',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'increase_balance',
          '--inputs',
          '1234',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[5]).to.be.equal('--abi');
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
          'invoke',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--address',
          '0x1234',
          '--use_cairo_abi',
          '--function',
          'increase_balance',
          '--inputs',
          '1234',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal('starknet');
        expect(splittedOutput[2]).to.be.equal('invoke');
        expect(splittedOutput[3]).to.be.equal('--address');
        expect(splittedOutput[4]).to.be.equal('0x1234');
        expect(splittedOutput[5]).to.be.equal('--abi');
        expect(splittedOutput[6]).to.be.equal('tests/testFiles/Test__WC__WARP_abi.json');
        expect(splittedOutput[7]).to.be.equal('--function');
        expect(splittedOutput[8]).to.be.equal('increase_balance');
        expect(splittedOutput[9]).to.be.equal('--network');
        expect(splittedOutput[10]).to.be.equal('alpha-goerli');
        expect(splittedOutput[11]).to.be.equal('--wallet');
        expect(splittedOutput[12]).to.be.equal(
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        );
        expect(splittedOutput[13]).to.be.equal('--account');
        expect(splittedOutput[14]).to.be.equal('Test_Account');
        expect(splittedOutput[15]).to.be.equal('--inputs');
        expect(splittedOutput[16]).to.be.equal('1234');
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
          await program.parseAsync(['node', './tests/cli.testTest.ts', 'invoke']);
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
            'invoke',
            'tests/testFiles/Test__WC__WARP.cairo',
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
            'invoke',
            'tests/testFiles/Test__WC__WARP.cairo',
            '--address',
            '0x1234',
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
            'invoke',
            'tests/testFiles/Test__WC__WARP.cairo',
            '--address',
            '0x1234',
            '--use_cairo_abi',
            '--function',
            'increase_balance',
            '--inputs',
            '1234',
            '--network',
            'alpha-goerli',
            '--account',
            'Test_Account',
            '--wallet',
            'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
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

      beforeEach(async () => {
        program = new Command();
        program.exitOverride();
        await createDeployProgram(program, output, true);
      });

      it('0. compare output string', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
          '--no_wallet',
        ]);

        const outputArray = [
          warpVenvPrefix,
          'starknet',
          'deploy',
          '--network',
          'alpha-goerli',
          '--account',
          'undefined',
          '--no_wallet',
          '--contract',
          'tests/testFiles/Test__WC__WARP_compiled.json',
          '',
        ];
        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
        ]);

        const starknet = output.val.toString().includes('starknet');
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.toString().includes('starknet');
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp and starknet command passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal('deploy');
        const starknetCommand = output.val.toString().includes('deploy');
        expect(starknetCommand).to.be.equal(true);
      });

      it('3. successfully passed file with no wallet option', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
          '--no_wallet',
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal('deploy');
        const starknetCommand = output.val.includes('deploy');
        expect(starknetCommand).to.be.equal(true);
        expect(args[1]).to.be.equal('tests/testFiles/Test__WC__WARP.cairo');
      });

      it('4. correct network option passed with no wallet option', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
          '--no_wallet',
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal('--network');
        expect(args[3]).to.be.equal('alpha-goerli');
        const net = output.val.includes('--network');
        expect(net).to.be.equal(true);
        const goerli = output.val.includes('alpha-goerli');
        expect(goerli).to.be.equal(true);
      });

      it('5. contract hash option passed when wallet option wasnt passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
        ]);

        const args = program.args;

        expect(args[4]).to.be.equal('--account');
        const opt = output.val.includes('--class_hash');
        expect(opt).to.be.equal(true);
        const acc = output.val.includes('Test_Account');
        expect(acc).to.be.equal(true);
      });

      it('6. contract hash option passed when wallet option was passed', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const args = program.args;
        expect(args[6]).to.be.equal('--wallet');
        expect(args[7]).to.be.equal('starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount');
        const opt = output.val.includes('--class_hash');
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
          'deploy',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
          '--no_wallet',
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal('starknet');
        expect(splittedOutput[2]).to.be.equal('deploy');
        expect(splittedOutput[3]).to.be.equal('--network');
        expect(splittedOutput[4]).to.be.equal('alpha-goerli');
        expect(splittedOutput[5]).to.be.equal('--account');
        expect(splittedOutput[6]).to.be.equal('undefined');
        expect(splittedOutput[7]).to.be.equal('--no_wallet');
        expect(splittedOutput[8]).to.be.equal('--contract');
        expect(splittedOutput[9]).to.be.equal('tests/testFiles/Test__WC__WARP_compiled.json');
      });

      it('9. correct starknet and command output without no wallet and with account', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal('starknet');
        expect(splittedOutput[2]).to.be.equal('deploy');
        expect(splittedOutput[3]).to.be.equal('--network');
        expect(splittedOutput[4]).to.be.equal('alpha-goerli');
        expect(splittedOutput[5]).to.be.equal('--account');
        expect(splittedOutput[6]).to.be.equal('Test_Account');
        expect(splittedOutput[7]).to.be.equal('--class_hash');
      });

      it('10. correct starknet and command output with wallet module and account', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
          '--account',
          'Test_Account',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal('starknet');
        expect(splittedOutput[2]).to.be.equal('deploy');
        expect(splittedOutput[3]).to.be.equal('--network');
        expect(splittedOutput[4]).to.be.equal('alpha-goerli');
        expect(splittedOutput[5]).to.be.equal('--account');
        expect(splittedOutput[6]).to.be.equal('Test_Account');
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
          await program.parseAsync(['node', './tests/cli.testTest.ts', 'deploy']);
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
            'deploy',
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
          'declare',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
        ]);

        const outputArray = [
          warpVenvPrefix,
          'starknet',
          'declare',
          '--contract',
          'tests/testFiles/Test__WC__WARP_compiled.json',
          '--network',
          'alpha-goerli',
        ];
        const predictedOutput = outputArray.join(' ') as string;

        expect(output.val).to.be.equal(predictedOutput);
      });

      it('1. correct starknet and command output', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'declare',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
        ]);

        const starknet = output.val.includes('starknet');
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.val.includes('starknet');
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp and starknet command passed', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'declare',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal('declare');
        const starknetCommand = output.val.includes('declare');
        expect(starknetCommand).to.be.equal(true);
      });

      it('3. cairoFile passed successfully', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'declare',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal('declare');
        const starknetCommand = output.val.includes('declare');
        expect(starknetCommand).to.be.equal(true);
        expect(args[1]).to.be.equal('tests/testFiles/Test__WC__WARP.cairo');
        const filepath = output.val.includes('tests/testFiles/Test__WC__WARP_compiled.json');
        expect(filepath).to.be.equal(true);
      });

      it('4. network option passed successfully', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'declare',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal('--network');
        const net = output.val.includes('--network');
        expect(net).to.be.equal(true);
        expect(args[3]).to.be.equal('alpha-goerli');
        const alpha = output.val.includes('alpha-goerli');
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
          'declare',
          'tests/testFiles/Test__WC__WARP.cairo',
          '--network',
          'alpha-goerli',
        ]);

        const splittedOutput = output.val.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal('starknet');
        expect(splittedOutput[2]).to.be.equal('declare');
        expect(splittedOutput[3]).to.be.equal('--contract');
        expect(splittedOutput[4]).to.be.equal('tests/testFiles/Test__WC__WARP_compiled.json');
        expect(splittedOutput[5]).to.be.equal('--network');
        expect(splittedOutput[6]).to.be.equal('alpha-goerli');
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
          program.parse(['node', './tests/cli.testTest.ts', 'declare']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('8. does not accept unknown options', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './tests/cli.testTest.ts', 'declare', '--unknownOptions']);
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
