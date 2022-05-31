import { expect } from 'chai';
import { describe, it } from 'mocha';
import { parse } from '../src/utils/functionSignatureParser';

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

describe('Warplib files should compile', function () {
  tests.map(([signature, input, output]) =>
    it(`parses ${signature}`, () => {
      const result = parse(signature)(input);
      expect(result).to.deep.equal(output.map(BigInt));
    }),
  );
});
