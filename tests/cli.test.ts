import { assert, expect } from 'chai';
import { describe, it } from 'mocha';
import { parse } from '../src/utils/functionSignatureParser';
import { Command } from 'commander';
import { IOptionalNetwork } from '../src';
import { checkStatus, runStarknetStatus } from '../src/starknetCli';
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

// describe('Solidity abi parsing and decode tests', function () {
//   tests.map(([signature, input, output]) =>
//     it(`parses ${signature}`, () => {
//       const result = parse(signature)(input);
//       expect(result).to.deep.equal(output.map(BigInt));
//     }),
//   );
// });

const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;

describe('Warp CLI test', function () {
  this.timeout(10000);
  const starkNet = 'starknet';
  const alphaGoerli = 'alpha-goerli';
  const network = '--network';

  describe('warp status', function () {
    const starkNetStatus = 'tx_status';
    const warpStatus = 'status';
    const hash = '--hash';

    describe('command output test', function () {
      let program = new Command();
      let output: string;

      program.exitOverride();
      program
        .configureOutput({
          writeOut: () => {},
          writeErr: () => {},
        })
        .command('status <tx_hash>')
        .option('--network <network>', 'Starknet network URL.', process.env.STARKNET_NETWORK)
        .action((tx_hash: string, options: IOptionalNetwork) => {
          output = checkStatus(tx_hash, options);
        });

      it('correct starknet and command output', async () => {
        program.parse(['node', './bin/warp', warpStatus, '0x01a']);

        const starknet = output.includes(starkNet);
        expect(starknet).to.be.equal(true);
        const starknetCommand = output.includes(starkNetStatus);
        expect(starknetCommand).to.be.equal(true);
      });

      it('correct warp command passed', async () => {
        program.parse(['node', './bin/warp', warpStatus, '0x01a']);

        const args = program.args;
        expect(args[0]).to.be.equal(warpStatus);
      });

      it('correct tx_hash passed with hash modifier', async () => {
        program.parse(['node', './bin/warp', warpStatus, '0x01a']);

        const args = program.args;
        expect(args[1]).to.be.equal('0x01a');
        const hashExists = output.includes(hash);
        expect(hashExists).to.be.equal(true);
        const argExists = output.includes(args[1]);
        expect(argExists).to.be.equal(true);
      });

      it('correct network passed with network option', async () => {
        program.parse(['node', './bin/warp', warpStatus, '0x01a', '--network', alphaGoerli]);

        const args = program.args;
        expect(args[2]).to.be.equal(network);
        expect(args[3]).to.be.equal(alphaGoerli);
        const networkExists = output.includes(args[2]);
        expect(networkExists).to.be.equal(true);
        const goerliExists = output.includes(args[3]);
        expect(goerliExists).to.be.equal(true);
      });

      it('parse failed because of missing tx_hash', async () => {
        let err: any;

        try {
          program.parse(['node', './bin/warp', warpStatus]);
        } catch (e) {
          err = e;
        }

        expect(err.code).to.be.equal('commander.missingArgument');
      });

      it('parse failed because of incorrect command ', async () => {
        let err: any;

        try {
          program.parse(['node', './bin/warp', 'test']);
        } catch (e) {
          err = e;
        }

        expect(err.code).to.be.equal('commander.unknownCommand');
      });

      it('correct starknet and command output', async () => {
        program.parse(['node', './bin/warp', warpStatus, '0x01a']);

        const splittedOutput = output.split(' ');

        expect(splittedOutput[0]).to.be.equal(warpVenvPrefix);
        expect(splittedOutput[1]).to.be.equal(starkNet);
        expect(splittedOutput[2]).to.be.equal(starkNetStatus);
        expect(splittedOutput[3]).to.be.equal(hash);
        expect(splittedOutput[4]).to.be.equal('0x01a');
        expect(splittedOutput[5]).to.be.equal(network);
        expect(splittedOutput[6]).to.be.equal(alphaGoerli);
      });
    });

    describe('runStarknetStatus test', function () {
      let program = new Command();
      let output: string | undefined;

      program.exitOverride();
      program
        .configureOutput({
          writeOut: () => {},
          writeErr: () => {},
        })
        .command('status <tx_hash>')
        .option('--network <network>', 'Starknet network URL.', process.env.STARKNET_NETWORK)
        .action((tx_hash: string, options: IOptionalNetwork) => {
          output = runStarknetStatus(tx_hash, options);
        });

      it('tx_hash is required', async () => {
        let err: any;

        try {
          program.parse(['node', './bin/warp', warpStatus]);
        } catch (e) {
          err = e;
        }

        expect(err.code).to.be.equal('commander.missingArgument');
      });

      it('a network needs to be specified', async () => {
        let err: any;
        try {
          program.parse(['node', './bin/warp', warpStatus, '0x01a']);
        } catch (e) {
          err = e;
        }

        expect(err).to.be.equal(
          'Error: Exception: feeder_gateway_url must be specified with the "status" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.',
        );
      });

      it('does not accept unknown options', async () => {
        let err: any;

        try {
          program.parse(['node', './bin/warp', warpStatus, '0x01a', '--unknown']);
        } catch (e) {
          err = e;
        }

        expect(err.code).to.be.equal('commander.unknownOption');
      });

      it('does not execute with no commands', async () => {
        let err: any;

        try {
          program.parse(['node', './bin/warp', '0x01a']);
        } catch (e) {
          err = e;
        }

        expect(err.code).to.be.equal('commander.unknownCommand');
      });
    });
  });
});
