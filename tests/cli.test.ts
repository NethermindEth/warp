import { expect } from 'chai';
import { describe, it } from 'mocha';
import { Command } from 'commander';
import * as path from 'path';
import {
  createCallProgram,
  createCompileProgram,
  createDeclareProgram,
  createDeployAccountProgram,
  createInvokeProgram,
  createDeployProgram,
  createStatusProgram,
  createTranspileProgram,
} from '../src/programFactory';
import sinon, { SinonStub } from 'sinon';
import * as clientInternals from '../src/execSync-internals';

// type Input = string[] | number[] | Input[] | (string | number | Input)[];

// type encodeTest = [string, Input, string[]];

// const tests: encodeTest[] = [
//   ['decimals()', [], []],
//   ['totalSupply()', [], []],
//   ['balanceOf(address)', ['0x123123123'], ['0x123123123']],
//   ['balanceOf(address)', ['1234'], ['1234']],
//   [
//     'mint(address[4],uint256)',
//     [['0x1', '0x2', '0x3', '0x4'], '4'],
//     ['0x1', '0x2', '0x3', '0x4', '0x4', '0x0'],
//   ],
//   [
//     'mint(address[],uint256)',
//     [['0x1', '0x2', '0x3', '0x4'], '4'],
//     ['0x4', '0x1', '0x2', '0x3', '0x4', '0x4', '0x0'],
//   ],
//   [
//     'mint(address[][2])',
//     [
//       [
//         ['0x1', '0x2', '0x3'],
//         ['0x3', '0x4'],
//       ],
//     ],
//     ['0x3', '0x1', '0x2', '0x3', '0x2', '0x3', '0x4'],
//   ],
//   ['mint(bool,bool,bool,bool)', ['true', 'false', '1', '0'], ['0x1', '0x0', '0x1', '0x0']],
//   ['mint(bytes8)', ['0xffffffffffffffff'], ['0xffffffffffffffff']],
//   ['byte_me(bytes)', [['0xff', '0xff', '0xff', '0xff']], ['0x4', '0xff', '0xff', '0xff', '0xff']],
//   ['string(string)', ['hello'], ['0x5', '0x68', '0x65', '0x6c', '0x6c', '0x6f']],
//   [
//     'uint256arr(uint256[], uint256[2])',
//     [
//       ['4', '5', '6'],
//       ['99', '100'],
//     ],
//     ['0x3', '0x4', '0x0', '0x5', '0x0', '0x6', '0x0', '0x63', '0x0', '0x64', '0x0'],
//   ],
// ];

// describe('Solidity abi parsing and decode tests', function () {
//   tests.map(([signature, input, output]) =>
//     it(`parses ${signature}`, () => {
//       const result = parse(signature)(input);
//       expect(result).to.deep.equal(output.map(BigInt));
//     }),
//   );
// });

const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;
const cairoPath = `${path.resolve(__dirname, '..')}`;

// function transpileTestFile(): void {
//   const program = new Command();

//   createTranspileProgram(program);

//   program.parse([
//     'node',
//     './tests/cli.testTest.ts',
//     'transpile',
//     'tests/testFiles/Test.sol',
//     '--output-dir',
//     '.',
//   ]);
// }

describe('StarkNet CLI tests', function () {
  this.timeout(200000);

  before('generate cairo contract', async () => {
    const program = new Command();

    createTranspileProgram(program);

    program.parse([
      'node',
      './tests/cli.testTest.ts',
      'transpile',
      'tests/testFiles/Test.sol',
      '--output-dir',
      '.',
      '--compile-cairo',
    ]);
  });

  describe('warp status', function () {
    let program: Command;
    const output = { val: '' };
    let execSyncStub: sinon.SinonStub;

    before(() => {
      program = new Command();
      program.exitOverride();
      execSyncStub = sinon.stub(clientInternals, 'execSync');
      createStatusProgram(program, output);
    });

    after(() => {
      execSyncStub.restore();
    });

    it('0. Args passed correctly with optional parameters missing', async () => {
      program.parse(['node', './tests/cli.testTest.ts', 'status', '0x01a']);

      const expectedCommand = [
        warpVenvPrefix,
        'starknet',
        'tx_status',
        '--hash',
        '0x01a',
        '--network',
        'alpha-goerli',
      ].join(' ');

      expect(output.val).to.be.equal(expectedCommand);
    });

    it('1. Args passed correctly with optional parameters added', async () => {
      program.parse([
        'node',
        './tests/cli.testTest.ts',
        'status',
        '0x01a',
        '--network',
        'test_network',
      ]);

      const expectedCommand = [
        warpVenvPrefix,
        'starknet',
        'tx_status',
        '--hash',
        '0x01a',
        '--network',
        'test_network',
      ].join(' ');

      expect(output.val).to.be.equal(expectedCommand);
    });

    it('2. Fails with missing tx_hash arg', async () => {
      expect(function () {
        program.parse(['node', './tests/cli.testTest.ts', 'status']);
      }).to.throw("error: missing required argument 'tx_hash'");
    });

    it('3. Fails with incorrect command', async () => {
      expect(function () {
        program.parse(['node', './tests/cli.testTest.ts', 'setus']);
      }).to.throw("error: unknown command 'setus'\n(Did you mean status?)");
    });

    it('4. Fails with unknown parameters', async () => {
      expect(function () {
        program.parse(['node', './tests/cli.testTest.ts', 'status', '0x01a', '--unknown']);
      }).to.throw("error: unknown option '--unknown'");
    });
  });

  describe('warp compile', function () {
    let program: Command;
    const output = { val: '' };
    let execSyncStub: sinon.SinonStub;

    before(() => {
      program = new Command();
      program.exitOverride();
      execSyncStub = sinon.stub(clientInternals, 'execSync');
      createCompileProgram(program, output);
    });

    after(() => {
      execSyncStub.restore();
    });

    it('0. Args passed correctly without optional parameters added', async () => {
      program.parse([
        'node',
        './tests/cli.testTest.ts',
        'compile',
        'tests/testFiles/Test__WC__WARP.cairo',
      ]);

      const expectedOutput = [
        warpVenvPrefix,
        'starknet-compile',
        'tests/testFiles/Test__WC__WARP.cairo',
        '--output',
        'tests/testFiles/Test__WC__WARP_compiled.json',
        '--abi',
        'tests/testFiles/Test__WC__WARP_abi.json',
        '--cairo_path',
        cairoPath,
        '--no_debug_info',
      ].join(' ');

      expect(output.val).to.be.equal(expectedOutput);
    });

    it('1. Args passed correctly with optional parameters added', async () => {
      program.parse([
        'node',
        './tests/cli.testTest.ts',
        'compile',
        'tests/testFiles/Test__WC__WARP.cairo',
        '--debug_info',
      ]);

      const expecectedOutput = [
        warpVenvPrefix,
        'starknet-compile',
        'tests/testFiles/Test__WC__WARP.cairo',
        '--output',
        'tests/testFiles/Test__WC__WARP_compiled.json',
        '--abi',
        'tests/testFiles/Test__WC__WARP_abi.json',
        '--cairo_path',
        cairoPath,
        '--debug_info_with_source',
      ].join(' ');

      expect(output.val).to.be.equal(expecectedOutput);
    });

    it('2. Fails with incorrect command', async () => {
      expect(function () {
        program.parse(['node', './tests/cli.testTest.ts', 'conpile']);
      }).to.throw("error: unknown command 'conpile'\n(Did you mean compile?)");
    });
  });

  describe('warp deploy_account', function () {
    let program: Command;
    const output = { val: '' };
    let execSyncStub: sinon.SinonStub;

    before(() => {
      program = new Command();
      program.exitOverride();
      execSyncStub = sinon.stub(clientInternals, 'execSync');
      createDeployAccountProgram(program, output);
    });

    after(() => {
      execSyncStub.restore();
    });

    it('0. Args passed correctly without optional parameters added', async () => {
      program.parse(['node', './tests/cli.testTest.ts', 'deploy_account']);

      const expectedOutput = [
        warpVenvPrefix,
        'starknet',
        'deploy_account',
        '--wallet',
        'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        '--network',
        'alpha-goerli',
      ].join(' ');

      expect(output.val).to.be.equal(expectedOutput);
    });

    it('1. Args passed correctly with optional parameters added', async () => {
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

      const expecectedOutput = [
        warpVenvPrefix,
        'starknet',
        'deploy_account',
        '--wallet',
        'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        '--network',
        'alpha-goerli',
        '--account',
        'Test_Account',
      ].join(' ');

      expect(output.val).to.be.equal(expecectedOutput);
    });

    it('2. Fails with incorrect command', async () => {
      expect(function () {
        program.parse(['node', './tests/cli.testTest.ts', 'deploy_accoun']);
      }).to.throw("error: unknown command 'deploy_accoun'\n(Did you mean deploy_account?)");
    });
  });

  describe('warp call/invoke', function () {
    let program: Command;
    const output = { val: '' };
    let execSyncStub: sinon.SinonStub;

    before(async () => {
      // transpileTestFile();
      execSyncStub = sinon.stub(clientInternals, 'execSync');
    });

    beforeEach(async () => {
      program = new Command();
      program.exitOverride();
      await createCallProgram(program, output);
      await createInvokeProgram(program, output);
    });

    after(() => {
      execSyncStub.restore();
    });

    it('0. Args passed correctly without optional parameters added', async () => {
      await program.parseAsync([
        'node',
        './tests/cli.testTest.ts',
        'call',
        'tests/testFiles/Test__WC__WarpNoInputs.cairo',
        '--address',
        '0x1234',
        '--function',
        'testNoInputs',
      ]);

      const expecectedOutput = [
        warpVenvPrefix,
        'starknet',
        'call',
        '--address',
        '0x1234',
        '--abi',
        'tests/testFiles/Test__WC__WarpNoInputs_abi.json',
        '--function',
        'testNoInputs_39b3913b',
        '--network',
        'alpha-goerli',
        '--wallet',
        'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
      ].join(' ');

      expect(output.val).to.be.equal(expecectedOutput);
    });

    it('1. Args passed correctly with optional parameters added', async () => {
      await program.parseAsync([
        'node',
        './tests/cli.testTest.ts',
        'call',
        'tests/testFiles/Test__WC__WarpNoInputs.cairo',
        '--address',
        '0x1234',
        '--function',
        'testNoInputs',
        '--wallet',
        'testWallet',
        '--network',
        'testNetwork',
      ]);

      const expecectedOutput = [
        warpVenvPrefix,
        'starknet',
        'call',
        '--address',
        '0x1234',
        '--abi',
        'tests/testFiles/Test__WC__WarpNoInputs_abi.json',
        '--function',
        'testNoInputs_39b3913b',
        '--network',
        'testNetwork',
        '--wallet',
        'testWallet',
      ].join(' ');

      expect(output.val).to.be.equal(expecectedOutput);
    });

    it('2. Checking inputs are transcoded without --use_cairo_abi', async () => {
      await program.parseAsync([
        'node',
        './tests/cli.testTest.ts',
        'call',
        'tests/testFiles/Test__WC__WarpInputs.cairo',
        '--address',
        '0x1234',
        '--function',
        'testInputs',
        '--wallet',
        'testWallet',
        '--network',
        'testNetwork',
        '--inputs',
        '-1',
      ]);

      const expecectedOutput = [
        warpVenvPrefix,
        'starknet',
        'call',
        '--address',
        '0x1234',
        '--abi',
        'tests/testFiles/Test__WC__WarpInputs_abi.json',
        '--function',
        'testInputs_a272a776',
        '--network',
        'testNetwork',
        '--wallet',
        'testWallet',
        '--inputs',
        '340282366920938463463374607431768211455',
        '340282366920938463463374607431768211455',
      ].join(' ');

      expect(output.val).to.be.equal(expecectedOutput);
    });

    it('3. Checking --use_cairo_abi produces correct output', async () => {
      await program.parseAsync([
        'node',
        './tests/cli.testTest.ts',
        'call',
        'tests/testFiles/Test__WC__WarpInputs.cairo',
        '--address',
        '0x1234',
        '--function',
        'testInputs_a272a776',
        '--wallet',
        'testWallet',
        '--network',
        'testNetwork',
        '--use_cairo_abi',
        '--inputs',
        '340282366920938463463374607431768211455',
        '340282366920938463463374607431768211455',
      ]);

      const expecectedOutput = [
        warpVenvPrefix,
        'starknet',
        'call',
        '--address',
        '0x1234',
        '--abi',
        'tests/testFiles/Test__WC__WarpInputs_abi.json',
        '--function',
        'testInputs_a272a776',
        '--network',
        'testNetwork',
        '--wallet',
        'testWallet',
        '--inputs',
        '340282366920938463463374607431768211455',
        '340282366920938463463374607431768211455',
      ].join(' ');

      expect(output.val).to.be.equal(expecectedOutput);
    });

    it('4. Test that invoke is swapped for call.', async () => {
      await program.parseAsync([
        'node',
        './tests/cli.testTest.ts',
        'invoke',
        'tests/testFiles/Test__WC__WarpNoInputs.cairo',
        '--address',
        '0x1234',
        '--function',
        'testNoInputs',
      ]);

      const expecectedOutput = [
        warpVenvPrefix,
        'starknet',
        'invoke',
        '--address',
        '0x1234',
        '--abi',
        'tests/testFiles/Test__WC__WarpNoInputs_abi.json',
        '--function',
        'testNoInputs_39b3913b',
        '--network',
        'alpha-goerli',
        '--wallet',
        'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
      ].join(' ');

      expect(output.val).to.be.equal(expecectedOutput);
    });
  });

  describe('warp deploy', function () {
    describe('warp deploy with --no_wallet', function () {
      let program: Command;
      const output = { val: '' };
      let execSyncStub: SinonStub;

      beforeEach(async () => {
        program = new Command();
        program.exitOverride();
        execSyncStub = sinon.stub(clientInternals, 'execSync');
        await createDeployProgram(program, output);
      });

      afterEach(() => {
        execSyncStub.restore();
      });

      it('0. Args passed correctly with optional parameters not added', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WarpNoInputs.cairo',
          '--no_wallet',
        ]);

        const expecectedOutput = [
          warpVenvPrefix,
          'starknet',
          'deploy',
          '--contract',
          'tests/testFiles/Test__WC__WarpNoInputs_compiled.json',
          '--network',
          'alpha-goerli',
          '--no_wallet',
        ].join(' ');

        expect(output.val).to.be.equal(expecectedOutput);
      });
      it('1. Args passed correctly with optional parameters added', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WarpNoInputs.cairo',
          '--no_wallet',
          '--network',
          'testNetwork',
        ]);

        const expecectedOutput = [
          warpVenvPrefix,
          'starknet',
          'deploy',
          '--contract',
          'tests/testFiles/Test__WC__WarpNoInputs_compiled.json',
          '--network',
          'testNetwork',
          '--no_wallet',
        ].join(' ');

        expect(output.val).to.be.equal(expecectedOutput);
      });
      it('2. Args passed correctly with inputs', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WarpInputs.cairo',
          '--no_wallet',
          '--network',
          'testNetwork',
          '--inputs',
          '-1',
        ]);

        const expecectedOutput = [
          warpVenvPrefix,
          'starknet',
          'deploy',
          '--contract',
          'tests/testFiles/Test__WC__WarpInputs_compiled.json',
          '--network',
          'testNetwork',
          '--inputs',
          '255',
          '--no_wallet',
        ].join(' ');

        expect(output.val).to.be.equal(expecectedOutput);
      });
      it('3. Args passed correctly with inputs and --use_cairo_abi', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WarpInputs.cairo',
          '--no_wallet',
          '--network',
          'testNetwork',
          '--inputs',
          '255',
          '--use_cairo_abi',
        ]);

        const expecectedOutput = [
          warpVenvPrefix,
          'starknet',
          'deploy',
          '--contract',
          'tests/testFiles/Test__WC__WarpInputs_compiled.json',
          '--network',
          'testNetwork',
          '--inputs',
          '255',
          '--no_wallet',
        ].join(' ');

        expect(output.val).to.be.equal(expecectedOutput);
      });
    });

    describe('warp deploy with --classhash', function () {
      let program: Command;
      const output = { val: '' };
      let execSyncStub: SinonStub;

      beforeEach(async () => {
        program = new Command();
        program.exitOverride();
        execSyncStub = sinon
          .stub(clientInternals, 'execSync')
          .returns(
            'Contract class hash: 0x000000000000000000000000000000000000000000000000000000000000001\n Transaction hash: 0x000000000000000000000000000000000000000000000000000000000000002',
          );
        await createDeployProgram(program, output);
      });

      afterEach(() => {
        execSyncStub.restore();
      });

      it('0. Args passed correctly with optional parameters not added', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WarpNoInputs.cairo',
        ]);

        const expecectedOutput = [
          warpVenvPrefix,
          'starknet',
          'deploy',
          '--class_hash',
          '0x000000000000000000000000000000000000000000000000000000000000001',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
          '--network',
          'alpha-goerli',
        ].join(' ');

        expect(output.val).to.be.equal(expecectedOutput);
      });
      it('1. Args passed correctly with optional parameters added', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WarpNoInputs.cairo',
          '--wallet',
          'testWallet',
          '--network',
          'testNetwork',
          '--account',
          'testAccount',
        ]);

        const expecectedOutput = [
          warpVenvPrefix,
          'starknet',
          'deploy',
          '--class_hash',
          '0x000000000000000000000000000000000000000000000000000000000000001',
          '--wallet',
          'testWallet',
          '--account',
          'testAccount',
          '--network',
          'testNetwork',
        ].join(' ');

        expect(output.val).to.be.equal(expecectedOutput);
      });
      it('2. Args passed correctly with inputs', async () => {
        await program.parseAsync([
          'node',
          './tests/cli.testTest.ts',
          'deploy',
          'tests/testFiles/Test__WC__WarpInputs.cairo',
          '--no_wallet',
          '--network',
          'testNetwork',
          '--inputs',
          '-1',
        ]);

        const expecectedOutput = [
          warpVenvPrefix,
          'starknet',
          'deploy',
          '--contract',
          'tests/testFiles/Test__WC__WarpInputs_compiled.json',
          '--network',
          'testNetwork',
          '--inputs',
          '255',
          '--no_wallet',
        ].join(' ');

        expect(output.val).to.be.equal(expecectedOutput);
      });
    });
  });

  describe('warp declare', function () {
    describe('command output test', function () {
      let program: Command;
      const output = { val: '' };
      let execSyncStub: SinonStub;

      beforeEach(() => {
        program = new Command();
        program.exitOverride();
        execSyncStub = sinon.stub(clientInternals, 'execSync');
        createDeclareProgram(program, output);
      });

      afterEach(() => {
        execSyncStub.restore();
      });

      it('0. Args are passed correctly when optional arguments are not defined ', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'declare',
          'tests/testFiles/Test__WC__WarpNoInputs.cairo',
          '--network',
          'alpha-goerli',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ]);

        const expecectedOutput = [
          warpVenvPrefix,
          'starknet',
          'declare',
          '--contract',
          'tests/testFiles/Test__WC__WarpNoInputs_compiled.json',
          '--network',
          'alpha-goerli',
          '--wallet',
          'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
        ].join(' ');

        expect(output.val).to.be.equal(expecectedOutput);
      });

      it('1. Args are passed correctly when optional arguments are not defined ', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'declare',
          'tests/testFiles/Test__WC__WarpNoInputs.cairo',
          '--network',
          'testNetwork',
          '--wallet',
          'testWallet',
          '--account',
          'testAccount',
        ]);

        const expectedOutput = [
          warpVenvPrefix,
          'starknet',
          'declare',
          '--contract',
          'tests/testFiles/Test__WC__WarpNoInputs_compiled.json',
          '--network',
          'testNetwork',
          '--wallet',
          'testWallet',
          '--account',
          'testAccount',
        ].join(' ');

        expect(output.val).to.be.equal(expectedOutput);
      });

      it('2. declare with no_wallet ', async () => {
        program.parse([
          'node',
          './tests/cli.testTest.ts',
          'declare',
          'tests/testFiles/Test__WC__WarpNoInputs.cairo',
          '--no_wallet',
        ]);

        const expecectedOutput = [
          warpVenvPrefix,
          'starknet',
          'declare',
          '--contract',
          'tests/testFiles/Test__WC__WarpNoInputs_compiled.json',
          '--network',
          'alpha-goerli',
          '--no_wallet',
        ].join(' ');

        expect(output.val).to.be.equal(expecectedOutput);
      });
    });
  });
});
