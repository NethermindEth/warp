import { expect } from 'chai';
import { describe, it } from 'mocha';
import { parse } from '../src/utils/functionSignatureParser';
import { Command } from 'commander';
import {
  ICallOrInvokeProps,
  IDeclareOptions,
  IDeployAccountProps,
  IDeployProps,
  IOptionalDebugInfo,
  IOptionalNetwork,
} from '../src';
import {
  checkStatus,
  deployAccount,
  processDeclareContract,
  runStarknetCallOrInvoke,
  runStarknetCompile,
  runStarknetDeclare,
  runStarknetDeploy,
  runStarknetDeployAccount,
  runStarknetStatus,
  starknetCallOrInvoke,
  starkNetCompile,
  starkNetDeploy,
} from '../src/starknetCli';
import * as path from 'path';

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
  network: 'alha-goerli',
  hash: '0x01a',
  cairoFile: 'tests/testFiles/ERC20__WC__WARP.cairo',
  ozWallet: 'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount',
  account: 'Test_Account',
};

describe('Warp CLI test', function () {
  this.timeout(10000);

  describe('warp status', function () {
    describe('command output test', function () {
      const program = new Command();
      let output: string;

      program.exitOverride();
      program
        .configureOutput({
          writeOut: () => {
            return;
          },
          writeErr: () => {
            return;
          },
        })
        .command('status <tx_hash>')
        .option('--network <network>', 'Starknet network URL.', process.env.STARKNET_NETWORK)
        .action((tx_hash: string, options: IOptionalNetwork) => {
          output = checkStatus(tx_hash, options);
        });

      it('1. correct starknet and command output', async () => {
        program.parse(['node', './bin/warp', command.warpStatus, mockData.hash]);

        const starknet = output.includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.includes(command.starknetStatus);
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp command passed', async () => {
        program.parse(['node', './bin/warp', command.warpStatus, mockData.hash]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.warpStatus);
      });

      it('3. correct tx_hash passed with hash modifier', async () => {
        program.parse(['node', './bin/warp', command.warpStatus, mockData.hash]);

        const args = program.args;
        expect(args[1]).to.be.equal(mockData.hash);
        const hashExists = output.includes(options.hash);
        expect(hashExists).to.be.equal(true);
        const argExists = output.includes(args[1]);
        expect(argExists).to.be.equal(true);
      });

      it('4. correct network passed with network option', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.warpStatus,
          mockData.hash,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal(options.network);
        expect(args[3]).to.be.equal(mockData.network);
        const networkExists = output.includes(args[2]);
        expect(networkExists).to.be.equal(true);
        const goerliExists = output.includes(args[3]);
        expect(goerliExists).to.be.equal(true);
      });

      it('5. parse failed because of missing tx_hash', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.warpStatus]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('6. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', 'test']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('7.correct starknet and command output', async () => {
        program.parse(['node', './bin/warp', command.warpStatus, mockData.hash]);

        const splittedOutput = output.split(' ');

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

      beforeEach(function () {
        program = new Command();

        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('status <tx_hash>')
          .option('--network <network>', 'Starknet network URL.', process.env.STARKNET_NETWORK)
          .action((tx_hash: string, options: IOptionalNetwork) => {
            runStarknetStatus(tx_hash, options, true);
          });
      });

      it('8. tx_hash is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.warpStatus]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('9. network option needs to be specified', async () => {
        let err: { code: string | undefined } | undefined;
        try {
          program.parse(['node', './bin/warp', command.warpStatus, mockData.hash]);
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
          program.parse(['node', './bin/warp', command.warpStatus, mockData.hash, '--unknown']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownOption');
      });

      it('11. does not execute with no commands', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', mockData.hash]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });

  describe('warp compile', function () {
    const resultPath = `$result_compiled.json`;
    const abiPath = `$abi_abi.json`;

    describe('command output test', function () {
      let output: string;
      let program: Command;

      const debugOptions = ['--debug_info_with_source', '--no_debug_info'];

      const parameters: Map<string, string> = new Map([
        ['output', resultPath],
        ['abi', abiPath],
      ]);

      beforeEach(function () {
        program = new Command();
        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('compile <file>')
          .option('-d, --debug_info', 'Include debug information.', false)
          .action((file: string, options: IOptionalDebugInfo) => {
            output = starkNetCompile(file, parameters, options);
          });
      });

      it('1. correct starknet and command output', async () => {
        program.parse(['node', './bin/warp', command.compile, mockData.cairoFile]);

        const starknet = output.includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.includes(command.starknetCompile);
        expect(starknetCommand).to.be.equal(true);
        const fileToCompile = output.includes(mockData.cairoFile);
        expect(fileToCompile).to.be.equal(true);
      });

      it('2. correct warp command passed', async () => {
        program.parse(['node', './bin/warp', command.compile, mockData.cairoFile]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.compile);
      });

      it('3. correct file passed with filePath', async () => {
        program.parse(['node', './bin/warp', command.compile, mockData.cairoFile]);

        const args = program.args;
        expect(args[1]).to.be.equal(mockData.cairoFile);
        const file = output.includes(mockData.cairoFile);
        expect(file).to.be.equal(true);
      });

      it('4. correct debug options passed with debug options', async () => {
        program.parse(['node', './bin/warp', command.compile, mockData.cairoFile, options.debug]);

        const args = program.args;
        expect(args[2]).to.be.equal(options.debug);
        const debugExists = output.includes(debugOptions[0]);
        expect(debugExists).to.be.equal(true);
      });

      it('5. correct debug options passed with no debug options', async () => {
        program.parse(['node', './bin/warp', command.compile, mockData.cairoFile]);

        const debugExists = output.includes(debugOptions[1]);
        expect(debugExists).to.be.equal(true);
        const boolExists = output.includes('false');
        expect(boolExists).to.be.equal(false);
      });

      it('6. parse failed because of missing tx_hash', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.compile]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('7. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', 'test']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('8. correct starknet and command output', async () => {
        program.parse(['node', './bin/warp', command.compile, mockData.cairoFile, options.debug]);

        const splittedOutput = output.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknetCompile);
        expect(splittedOutput[2]).to.be.equal(options.output);
        expect(splittedOutput[3]).to.be.equal(resultPath);
        expect(splittedOutput[4]).to.be.equal(options.abi);
        expect(splittedOutput[5]).to.be.equal(abiPath);
        expect(splittedOutput[6]).to.be.equal(debugOptions[0]);
        expect(splittedOutput[7]).to.be.equal(mockData.cairoFile);
      });
    });

    describe('runStarknetCompile test', function () {
      let program: Command;

      beforeEach(function () {
        program = new Command();
        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('compile <file>')
          .option('-d, --debug_info', 'Include debug information.', false)
          .action((file: string, options: IOptionalDebugInfo) => {
            runStarknetCompile(file, options);
          });
      });

      it('9. filepath is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.compile]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('10. a debug option is optional', async () => {
        let err: undefined;
        try {
          program.parse(['node', './bin/warp', command.compile, mockData.cairoFile]);
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
            './bin/warp',
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
          program.parse(['node', './bin/warp', 'randomCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });

  describe('warp deploy_account', function () {
    describe('command output test', function () {
      let output: string;
      let program: Command;

      beforeEach(function () {
        program = new Command();
        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('deploy_account')
          .option(
            '--account <account>',
            'The name of the account. If not given, the default for the wallet will be used.',
          )
          .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
          .option(
            '--wallet <wallet>',
            'The name of the wallet, including the python module and wallet class.',
            process.env.STARKNET_WALLET,
          )
          .action((options: IDeployAccountProps) => {
            output = deployAccount(options);
          });
      });

      it('1. correct starknet and command output', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deployAccount,
          options.network,
          mockData.network,
          options.wallet,
          mockData.ozWallet,
          options.account,
          mockData.account,
        ]);

        const starknet = output.includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.includes(command.starknet);
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp command passed', async () => {
        program.parse(['node', './bin/warp', command.deployAccount]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.deployAccount);
      });

      it('3. correct network option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deployAccount,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[1]).to.be.equal(options.network);
        expect(args[2]).to.be.equal(mockData.network);
        const net = output.includes(options.network);
        expect(net).to.be.equal(true);
        const goerli = output.includes(mockData.network);
        expect(goerli).to.be.equal(true);
      });

      it('4. correct wallet option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deployAccount,
          options.wallet,
          mockData.ozWallet,
        ]);

        const args = program.args;
        expect(args[1]).to.be.equal(options.wallet);
        expect(args[2]).to.be.equal(mockData.ozWallet);
        const opt = output.includes(options.wallet);
        expect(opt).to.be.equal(true);
        const wallet = output.includes(mockData.ozWallet);
        expect(wallet).to.be.equal(true);
      });

      it('5. correct account option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deployAccount,
          options.account,
          mockData.account,
        ]);

        const args = program.args;
        expect(args[1]).to.be.equal(options.account);
        expect(args[2]).to.be.equal(mockData.account);
        const opt = output.includes(options.account);
        expect(opt).to.be.equal(true);
        const name = output.includes(mockData.account);
        expect(name).to.be.equal(true);
      });

      it('6. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', 'incorrectCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('7. correct starknet and command output', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deployAccount,
          options.network,
          mockData.network,
          options.wallet,
          mockData.ozWallet,
          options.account,
          mockData.account,
        ]);

        const splittedOutput = output.split(' ');

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

      beforeEach(function () {
        program = new Command();
        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('deploy_account')
          .option(
            '--account <account>',
            'The name of the account. If not given, the default for the wallet will be used.',
          )
          .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
          .option(
            '--wallet <wallet>',
            'The name of the wallet, including the python module and wallet class.',
            process.env.STARKNET_WALLET,
          )
          .action((options: IDeployAccountProps) => {
            runStarknetDeployAccount(options, true);
          });
      });

      it('8. wallet option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.deployAccount]);
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
            './bin/warp',
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
          program.parse(['node', './bin/warp', command.deployAccount, '--unknownOption']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownOption');
      });

      it('11. does not execute with no commands', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', 'randomCommand']);
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
      let output: string;
      let program: Command;

      beforeEach(function () {
        program = new Command();
        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('call <file>')
          .requiredOption('--address <address>', 'Address of contract to call.')
          .requiredOption('--function <function>', 'Function to call.')
          .option(
            '--inputs <inputs...>',
            'Input to function as a comma separated string, use square brackets to represent lists and structs. Numbers can be represented in decimal and hex.',
            undefined,
          )
          .option('--use_cairo_abi', 'Use the cairo abi instead of solidity for the inputs.', false)
          .option(
            '--account <account>',
            'The name of the account. If not given, the default for the wallet will be used.',
          )
          .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
          .option(
            '--wallet <wallet>',
            'The name of the wallet, including the python module and wallet class.',
            process.env.STARKNET_WALLET,
          )
          .action(async (file: string, options: ICallOrInvokeProps) => {
            output = starknetCallOrInvoke(file, ' call', options, mockCallFunc, '');
          });
      });

      it('1. correct starknet and command output', async () => {
        program.parse([
          'node',
          './bin/warp',
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

        const starknet = output.includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.includes(command.starknet);
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp and starknet command passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const starknetCommand = output.includes(command.call);
        expect(starknetCommand).to.be.equal(true);
      });

      it('3. successfully passed file', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const starknetCommand = output.includes(command.call);
        expect(starknetCommand).to.be.equal(true);
        expect(args[1]).to.be.equal(mockData.cairoFile);
        const filepath = output.includes(mockData.cairoFile);
        expect(filepath).to.be.equal(true);
      });

      it('4. correct network option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const net = output.includes(options.network);
        expect(net).to.be.equal(true);
        const goerli = output.includes(mockData.network);
        expect(goerli).to.be.equal(true);
      });

      it('5. correct address option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const opt = output.includes(options.address);
        expect(opt).to.be.equal(true);
        const wallet = output.includes(mockAddress);
        expect(wallet).to.be.equal(true);
      });

      it('6. use cairo abi option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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

        const splittedOutput = output.split(' ');
        expect(splittedOutput[5]).to.be.equal(options.abi);
        expect(splittedOutput[6].endsWith('.cairo')).to.be.equal(true);
      });

      it('7. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', 'incorrectCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('8. correct starknet and command output', async () => {
        program.parse([
          'node',
          './bin/warp',
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

        const splittedOutput = output.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.call);
        expect(splittedOutput[3]).to.be.equal(options.address);
        expect(splittedOutput[4]).to.be.equal(mockAddress);
        expect(splittedOutput[5]).to.be.equal(options.abi);
        expect(splittedOutput[6]).to.be.equal(mockData.cairoFile);
        expect(splittedOutput[7]).to.be.equal(options.function);
        expect(splittedOutput[8]).to.be.equal(mockCallFunc);
        expect(splittedOutput[9]).to.be.equal(options.network);
        expect(splittedOutput[10]).to.be.equal(mockData.network);
        expect(splittedOutput[11]).to.be.equal(options.noWallet);
      });
    });

    describe('runStarknetCallOrInvoke test', function () {
      let program: Command;

      beforeEach(function () {
        program = new Command();
        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('call <file>')
          .requiredOption('--address <address>', 'Address of contract to call.')
          .requiredOption('--function <function>', 'Function to call.')
          .option(
            '--inputs <inputs...>',
            'Input to function as a comma separated string, use square brackets to represent lists and structs. Numbers can be represented in decimal and hex.',
            undefined,
          )
          .option('--use_cairo_abi', 'Use the cairo abi instead of solidity for the inputs.', false)
          .option(
            '--account <account>',
            'The name of the account. If not given, the default for the wallet will be used.',
          )
          .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
          .option(
            '--wallet <wallet>',
            'The name of the wallet, including the python module and wallet class.',
            process.env.STARKNET_WALLET,
          )
          .action(async (file: string, options: ICallOrInvokeProps) => {
            runStarknetCallOrInvoke(file, true, options, true);
          });
      });

      it('9. file path option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.call]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingMandatoryOptionValue');
      });

      it('10. address option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.call, mockData.cairoFile]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }
        expect(err?.code).to.be.equal('commander.missingMandatoryOptionValue');
      });

      it('11. function option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse([
            'node',
            './bin/warp',
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
          program.parse([
            'node',
            './bin/warp',
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
          program.parse(['node', './bin/warp', 'randomCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });

  describe('warp invoke', function () {
    const mockInvokeFunc = 'increase_balance';
    const mockInputs = '--inputs 1234';
    const mockInputValues = '1234';
    const mockAddress = '0x1234';

    describe('command output test', function () {
      let output: string;
      let program: Command;

      beforeEach(function () {
        program = new Command();
        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('invoke <file>')
          .requiredOption('--address <address>', 'Address of contract to call.')
          .requiredOption('--function <function>', 'Function to call.')
          .option(
            '--inputs <inputs...>',
            'Input to function as a comma separated string, use square brackets to represent lists and structs. Numbers can be represented in decimal and hex.',
            undefined,
          )
          .option('--use_cairo_abi', 'Use the cairo abi instead of solidity for the inputs.', false)
          .option(
            '--account <account>',
            'The name of the account. If not given, the default for the wallet will be used.',
          )
          .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
          .option(
            '--wallet <wallet>',
            'The name of the wallet, including the python module and wallet class.',
            process.env.STARKNET_WALLET,
          )
          .action(async (file: string, options: ICallOrInvokeProps) => {
            output = starknetCallOrInvoke(file, ' invoke', options, mockInvokeFunc, mockInputs);
          });
      });

      it('1. correct starknet and command output', async () => {
        program.parse([
          'node',
          './bin/warp',
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

        const starknet = output.includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.includes(command.starknet);
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp and starknet command passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const starknetCommand = output.includes(command.invoke);
        expect(starknetCommand).to.be.equal(true);
      });

      it('3. successfully passed file', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const starknetCommand = output.includes(command.invoke);
        expect(starknetCommand).to.be.equal(true);
        expect(args[1]).to.be.equal(mockData.cairoFile);
        const filepath = output.includes(mockData.cairoFile);
        expect(filepath).to.be.equal(true);
      });

      it('4. correct network option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const net = output.includes(options.network);
        expect(net).to.be.equal(true);
        const goerli = output.includes(mockData.network);
        expect(goerli).to.be.equal(true);
      });

      it('5. correct address option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const opt = output.includes(options.address);
        expect(opt).to.be.equal(true);
        const wallet = output.includes(mockAddress);
        expect(wallet).to.be.equal(true);
      });

      it('6. correct function option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const opt = output.includes(options.function);
        expect(opt).to.be.equal(true);
        const invokeFunction = output.includes(mockInvokeFunc);
        expect(invokeFunction).to.be.equal(true);
      });

      it('7. correct input option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const opt = output.includes(options.inputs);
        expect(opt).to.be.equal(true);
        const input = output.includes(mockInputValues);
        expect(input).to.be.equal(true);
      });

      it('8. correct account option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const opt = output.includes(options.inputs);
        expect(opt).to.be.equal(true);
        const acc = output.includes(mockData.account);
        expect(acc).to.be.equal(true);
      });

      it('9. correct wallet option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const opt = output.includes(options.inputs);
        expect(opt).to.be.equal(true);
        const wall = output.includes(mockData.ozWallet);
        expect(wall).to.be.equal(true);
      });

      it('10. use cairo abi option passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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

        const splittedOutput = output.split(' ');
        expect(splittedOutput[5]).to.be.equal(options.abi);
        expect(splittedOutput[6].endsWith('.cairo')).to.be.equal(true);
      });

      it('11. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', 'incorrectCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('12. correct starknet and command output', async () => {
        program.parse([
          'node',
          './bin/warp',
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

        const splittedOutput = output.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.invoke);
        expect(splittedOutput[3]).to.be.equal(options.address);
        expect(splittedOutput[4]).to.be.equal(mockAddress);
        expect(splittedOutput[5]).to.be.equal(options.abi);
        expect(splittedOutput[6]).to.be.equal(mockData.cairoFile);
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

      beforeEach(function () {
        program = new Command();
        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('invoke <file>')
          .requiredOption('--address <address>', 'Address of contract to call.')
          .requiredOption('--function <function>', 'Function to call.')
          .option(
            '--inputs <inputs...>',
            'Input to function as a comma separated string, use square brackets to represent lists and structs. Numbers can be represented in decimal and hex.',
            undefined,
          )
          .option('--use_cairo_abi', 'Use the cairo abi instead of solidity for the inputs.', false)
          .option(
            '--account <account>',
            'The name of the account. If not given, the default for the wallet will be used.',
          )
          .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
          .option(
            '--wallet <wallet>',
            'The name of the wallet, including the python module and wallet class.',
            process.env.STARKNET_WALLET,
          )
          .action(async (file: string, options: ICallOrInvokeProps) => {
            runStarknetCallOrInvoke(file, false, options, true);
          });
      });

      it('13. file path option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.invoke]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingMandatoryOptionValue');
      });

      it('14. address option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.invoke, mockData.cairoFile]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }
        expect(err?.code).to.be.equal('commander.missingMandatoryOptionValue');
      });

      it('15. function option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse([
            'node',
            './bin/warp',
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
          program.parse([
            'node',
            './bin/warp',
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
          program.parse(['node', './bin/warp', 'randomCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });

  describe('warp deploy', function () {
    describe('command output test', function () {
      let output: string;
      let program: Command;

      const mockInputs = '--inputs 123';
      const mockClassHash = '--class_hash 0x123';

      beforeEach(function () {
        program = new Command();
        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('deploy <file>')
          .option('-d, --debug_info', 'Compile include debug information.', false)
          .option(
            '--inputs <inputs...>',
            'Arguments to be passed to constructor of the program as a comma seperated list of strings, ints and lists.',
            undefined,
          )
          .option('--use_cairo_abi', 'Use the cairo abi instead of solidity for the inputs.', false)
          .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
          .option('--no_wallet', 'Do not use a wallet for deployment.', false)
          .option('--wallet <wallet>', 'Wallet provider to use', process.env.STARKNET_WALLET)
          .option('--account <account>', 'Account to use for deployment', undefined)
          .action((file: string, options: IDeployProps) => {
            output = starkNetDeploy(file, options, mockInputs, mockClassHash);
          });
      });

      it('1. correct starknet and command output', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const starknet = output.toString().includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.toString().includes(command.starknet);
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp and starknet command passed', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.deploy);
        const starknetCommand = output.toString().includes(command.deploy);
        expect(starknetCommand).to.be.equal(true);
      });

      it('3. successfully passed file with no wallet option', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.noWallet,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.deploy);
        const starknetCommand = output.includes(command.deploy);
        expect(starknetCommand).to.be.equal(true);
        expect(args[1]).to.be.equal(mockData.cairoFile);
        const filepath = output.includes(mockData.cairoFile);
        expect(filepath).to.be.equal(true);
      });

      it('4. correct network option passed with no wallet option', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.noWallet,
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal(options.network);
        expect(args[3]).to.be.equal(mockData.network);
        const net = output.includes(options.network);
        expect(net).to.be.equal(true);
        const goerli = output.includes(mockData.network);
        expect(goerli).to.be.equal(true);
      });

      it('5. contract hash option passed when wallet option wasnt passed', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
        ]);

        const args = program.args;
        expect(args[4]).to.be.equal(options.account);
        expect(args[5]).to.be.equal(mockData.account);
        const opt = output.includes(mockClassHash);
        expect(opt).to.be.equal(true);
        const acc = output.includes(mockData.account);
        expect(acc).to.be.equal(true);
      });

      it('6. contract hash option passed when wallet option was passed', async () => {
        program.parse([
          'node',
          './bin/warp',
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
        const opt = output.includes(mockClassHash);
        expect(opt).to.be.equal(true);
        const wallet = output.includes(options.wallet);
        expect(wallet).to.be.equal(true);
        const walletModule = output.includes(mockData.ozWallet);
        expect(walletModule).to.be.equal(true);
      });

      it('7. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', 'incorrectCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('8. correct starknet and command output with no wallet', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.noWallet,
        ]);

        const splittedOutput = output.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.deploy);
        expect(splittedOutput[3]).to.be.equal(options.network);
        expect(splittedOutput[4]).to.be.equal(mockData.network);
        expect(splittedOutput[5]).to.be.equal(options.account);
        expect(splittedOutput[6]).to.be.equal('undefined');
        expect(splittedOutput[7]).to.be.equal(options.noWallet);
        expect(splittedOutput[8]).to.be.equal(options.contract);
        expect(splittedOutput[9]).to.be.equal(mockData.cairoFile);
        expect(splittedOutput[10]).to.be.equal(options.inputs);
        expect(splittedOutput[11]).to.be.equal('123');
      });

      it('9. correct starknet and command output without no wallet and account', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
        ]);

        const splittedOutput = output.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.deploy);
        expect(splittedOutput[3]).to.be.equal(options.network);
        expect(splittedOutput[4]).to.be.equal(mockData.network);
        expect(splittedOutput[5]).to.be.equal(options.account);
        expect(splittedOutput[6]).to.be.equal(mockData.account);
        expect(splittedOutput[7]).to.be.equal('--class_hash');
        expect(splittedOutput[8]).to.be.equal('0x123');
        expect(splittedOutput[9]).to.be.equal('--inputs');
        expect(splittedOutput[10]).to.be.equal('123');
      });

      it('10. correct starknet and command output with wallet module and account', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.deploy,
          mockData.cairoFile,
          options.network,
          mockData.network,
          options.account,
          mockData.account,
          options.wallet,
          mockData.ozWallet,
        ]);

        const splittedOutput = output.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.deploy);
        expect(splittedOutput[3]).to.be.equal(options.network);
        expect(splittedOutput[4]).to.be.equal(mockData.network);
        expect(splittedOutput[5]).to.be.equal(options.account);
        expect(splittedOutput[6]).to.be.equal(mockData.account);
        expect(splittedOutput[7]).to.be.equal('--class_hash');
        expect(splittedOutput[8]).to.be.equal('0x123');
        expect(splittedOutput[9]).to.be.equal(options.wallet);
        expect(splittedOutput[10]).to.be.equal(mockData.ozWallet);
        expect(splittedOutput[11]).to.be.equal(options.inputs);
        expect(splittedOutput[12]).to.be.equal('123');
      });
    });

    describe('runStarknetDeploy test', function () {
      let program: Command;

      beforeEach(function () {
        program = new Command();

        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('deploy <file>')
          .option('-d, --debug_info', 'Compile include debug information.', false)
          .option(
            '--inputs <inputs...>',
            'Arguments to be passed to constructor of the program as a comma seperated list of strings, ints and lists.',
            undefined,
          )
          .option('--use_cairo_abi', 'Use the cairo abi instead of solidity for the inputs.', false)
          .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
          .option('--no_wallet', 'Do not use a wallet for deployment.', false)
          .option('--wallet <wallet>', 'Wallet provider to use', process.env.STARKNET_WALLET)
          .option('--account <account>', 'Account to use for deployment', undefined)
          .action((file: string, options: IDeployProps) => {
            runStarknetDeploy(file, options, true);
          });
      });

      it('11. file path option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.deploy]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('12. does not accept unknown options', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.deploy, '--unknownOptions']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownOption');
      });

      it('13. does not execute with no commands', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', 'randomCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });

  describe('warp declare', function () {
    describe('command output test', function () {
      let output: string;
      let program: Command;

      beforeEach(function () {
        program = new Command();
        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('declare <cairo_contract>')
          .description('Command to declare Cairo contract on a StarkNet Network.')
          .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
          .action((cairo_contract: string, options: IDeclareOptions) => {
            output = processDeclareContract(cairo_contract, options) as string;
          });
      });

      it('1. correct starknet and command output', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.declare,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const starknet = output.includes(command.starknet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.includes(command.starknet);
        expect(starknetCommand).to.be.equal(true);
      });

      it('2. correct warp and starknet command passed', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.declare,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.declare);
        const starknetCommand = output.includes(command.declare);
        expect(starknetCommand).to.be.equal(true);
      });

      it('3. mockData.cairoFile passed successfully', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.declare,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[0]).to.be.equal(command.declare);
        const starknetCommand = output.includes(command.declare);
        expect(starknetCommand).to.be.equal(true);
        expect(args[1]).to.be.equal(mockData.cairoFile);
        const filepath = output.includes(mockData.cairoFile);
        expect(filepath).to.be.equal(true);
      });

      it('4. network option passed successfully', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.declare,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const args = program.args;
        expect(args[2]).to.be.equal(options.network);
        const net = output.includes(options.network);
        expect(net).to.be.equal(true);
        expect(args[3]).to.be.equal(mockData.network);
        const alpha = output.includes(mockData.network);
        expect(alpha).to.be.equal(true);
      });

      it('5. parse failed because of incorrect command ', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', 'incorrectCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });

      it('6. correct starknet and command output with no wallet', async () => {
        program.parse([
          'node',
          './bin/warp',
          command.declare,
          mockData.cairoFile,
          options.network,
          mockData.network,
        ]);

        const splittedOutput = output.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(command.starknet);
        expect(splittedOutput[2]).to.be.equal(command.declare);
        expect(splittedOutput[3]).to.be.equal(options.contract);
        expect(splittedOutput[4]).to.be.equal(mockData.cairoFile);
        expect(splittedOutput[5]).to.be.equal(options.network);
        expect(splittedOutput[6]).to.be.equal(mockData.network);
      });
    });

    describe('runStarknetDeclare test', function () {
      let program: Command;

      beforeEach(function () {
        program = new Command();
        program.exitOverride();
        program
          .configureOutput({
            writeOut: () => {
              return;
            },
            writeErr: () => {
              return;
            },
          })
          .command('declare <cairo_contract>')
          .description('Command to declare Cairo contract on a StarkNet Network.')
          .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
          .action(async (cairo_contract: string, options: IDeclareOptions) => {
            runStarknetDeclare(cairo_contract, options);
          });
      });

      it('7. file path option is required', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.declare]);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.missingArgument');
      });

      it('8. does not accept unknown options', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', command.declare, '--unknownOptions']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownOption');
      });

      it('9. does not execute with no commands', async () => {
        let err: { code: string | undefined } | undefined;

        try {
          program.parse(['node', './bin/warp', 'randomCommand']);
        } catch (e) {
          err = e as { code: string | undefined } | undefined;
        }

        expect(err?.code).to.be.equal('commander.unknownCommand');
      });
    });
  });
});
