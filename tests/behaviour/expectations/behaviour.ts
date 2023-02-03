import { Dir, Expect, File } from './types';
import {
  getByte32Array,
  flatten,
  getByteXArray,
  toCairoUint256,
  toCairoInt256,
  MIN_INT256,
  MAX_INT256,
  toCairoInt8,
  MIN_INT8,
  MAX_INT8,
  cairoUint256toHex,
} from './utils';
import createKeccakHash from 'keccak';
import { warpEventCanonicalSignaturehash256 } from '../../../src/export';

export const expectations = flatten(
  new Dir('tests', [
    new Dir('behaviour', [
      new Dir('contracts', [
        new Dir('abiDecode', [
          File.Simple('abiDecodeDynamic', [
            Expect.Simple('decodeSimpleDynamic', getByte32Array(32, 5, 2, 3, 7, 9, 11), [
              '5',
              ...['2', '0'],
              ...['3', '0'],
              ...['7', '0'],
              ...['9', '0'],
              ...['11', '0'],
            ]),
            Expect.Simple(
              'decodeNestedDynamic',
              getByte32Array(32, 2, 64, 160, 2, 2, 3, 3, 7, 9, 11),
              ['2', '2', '3', '3', '7', '9', '11'],
            ),
            Expect.Simple('decodeDynamicStaticNested', getByte32Array(32, 2, 1, 2, 3, 4), [
              '1',
              '2',
              '3',
              '4',
            ]),
            Expect.Simple(
              'decodeBytes',
              getByte32Array(32, 6, BigInt('0x010102030508'.padEnd(66, '0'))),
              ['6', '1', '1', '2', '3', '5', '8'],
            ),
            Expect.Simple(
              'decodeMix',
              getByte32Array(
                ...[128, 7, 11, 256],
                ...[3, 2, 3, 5],
                ...[3, BigInt('0x0d1113'.padEnd(66, '0'))],
              ),
              ['3', '2', '3', '5', '7', '11', '3', '13', '17', '19'],
            ),
          ]),
          File.Simple('abiDecodeStatic', [
            Expect.Simple('decodeSimpleStatic', getByte32Array(3, 5, 7), [
              ...['3', '0'],
              ...['5', '0'],
              ...['7', '0'],
            ]),
            Expect.Simple('decodeNestedStatic', getByte32Array(2, 3, 5, 6, 7, 8), [
              ...['2', '0'],
              ...['3', '0'],
              ...['5', '0'],
              ...['6', '0'],
              ...['7', '0'],
              ...['8', '0'],
            ]),
            Expect.Simple(
              'decodeStaticDynamicNested',
              getByte32Array(32, 64, 160, 2, 1, 2, 3, 3, 4, 5),
              ['2', '1', '2', '3', '3', '4', '5'],
            ),
          ]),
          File.Simple('abiDecodeStruct', [
            Expect.Simple('decodeSimpleStruct', getByte32Array(1, 11, 111, 1111), [
              '1',
              '11',
              '111',
              '1111',
            ]),
            Expect.Simple(
              'decodeSimpleStructArray',
              getByte32Array(32, 2, 1, 2, 3, 4, 5, 6, 7, 8),
              ['2', '1', '2', '3', '4', '5', '6', '7', '8'],
            ),
            Expect.Simple(
              'decodeComplexStruct',
              getByte32Array(32, 160, 2, 3, 5, 7, 3, 13, 17, 19),
              ['3', '13', '17', '19', '2', '3', '5', '7'],
            ),
            Expect.Simple(
              'decodeComplex2Struct',
              getByte32Array(32, 64, 192, 3, 1, 2, 3, 2, 4, 5),
              ['3', '1', '2', '3', '2', '4', '5'],
            ),
          ]),
          File.Simple('abiDecodeValue', [
            Expect.Simple('decodeAsInt24', getByte32Array(148), ['148']),
            Expect.Simple('decodeAsUint256', getByte32Array(0), ['0', '0'], 'Zero uint256'),
            Expect.Simple('decodeAsUint256', getByte32Array(148), ['148', '0'], 'Small uint256'),
            Expect.Simple(
              'decodeAsUint256',
              getByte32Array(2n ** 128n - 1n),
              [`${2n ** 128n - 1n}`, '0'],
              'Highest number in Uint256.low',
            ),
            Expect.Simple(
              'decodeAsUint256',
              getByte32Array(BigInt(2) ** BigInt(128)),
              ['0', '1'],
              'Lowest number in Uint256.high',
            ),
            Expect.Simple(
              'decodeAsUint256',
              getByte32Array(BigInt(2) ** BigInt(256) - BigInt(1)),
              [`${2n ** 128n - 1n}`, `${2n ** 128n - 1n}`],
              'Highest number in Uint256.high and Uint256.low',
            ),
            Expect.Simple(
              'decodeAsAddress',
              getByte32Array(2n ** 180n),
              [`${2n ** 180n}`],
              'Using an address bigger than 160 bits',
            ),
            Expect.Simple('decodeAsAddressAndUint256', getByte32Array(1040, 1500), [
              '1040',
              '1500',
              '0',
            ]),
          ]),
        ]),
        new Dir('abiEncode', [
          File.Simple('abiEncodeDynamic', [
            Expect.Simple('simpleDynamic', [], getByte32Array(32, 3, 2, 3, 5)),
            Expect.Simple(
              'nestedDynamic',
              [],
              getByte32Array(32, 2, 64, 192, 3, 2, 3, 5, 2, 7, 11),
            ),
            Expect.Simple(
              'mixDynamic',
              [],
              getByte32Array(64, 384, 2, 64, 192, 3, 2, 3, 5, 2, 7, 11, 3, 2, 3, 5),
            ),
          ]),
          File.Simple('abiEncodeStatic', [
            Expect.Simple('staticSimple', [], getByte32Array(2, 3, 5)),
            Expect.Simple('staticNested', [], getByte32Array(2, 3, 4, 5)),
            Expect.Simple('staticDynamicNested', [], getByte32Array(32, 64, 160, 2, 2, 3, 1, 11)),
          ]),
          File.Simple('abiEncodeStrings', [
            Expect.Simple('emptyString', [], getByte32Array(32, 0)),
            Expect.Simple(
              'stringEncoding',
              [],
              getByte32Array(32, 4, BigInt('0x686f6c61'.padEnd(66, '0'))),
            ),
            Expect.Simple(
              'docsExample',
              [],
              getByte32Array(
                ...[64, 320],
                ...[2, 64, 160],
                ...[2, 1, 2],
                ...[1, 3],
                ...[3, 96, 160, 224],
                ...[3, BigInt('0x6f6e65'.padEnd(66, '0'))],
                ...[3, BigInt('0x74776f'.padEnd(66, '0'))],
                ...[5, BigInt('0x7468726565'.padEnd(66, '0'))],
              ),
            ),
          ]),
          File.Simple('abiEncodeStruct', [
            Expect.Simple('structSimple', [], getByte32Array(2, 3)),
            Expect.Simple('structComplex', [], getByte32Array(32, 128, 7, 11, 13, 3, 2, 3, 5)),
          ]),
          File.Simple('abiEncodeValue', [
            Expect.Simple('rational', [], getByte32Array(255, 65534)),
            Expect.Simple(
              'rationalLiterals',
              [],
              getByte32Array(1, BigInt(2) ** BigInt(256) - BigInt(2)),
            ),
          ]),
          File.Simple('abiEncodePacked', [
            Expect.Simple(
              'fixedBytes',
              ['7', '5', '3'],
              getByteXArray(
                { byteSize: 18, value: 7 },
                { byteSize: 32, value: BigInt(3) * BigInt(2) ** BigInt(128) + BigInt(5) },
              ),
            ),
            Expect.Simple(
              'addresses',
              ['1', '2'],
              getByteXArray({ byteSize: 32, value: 1 }, { byteSize: 32, value: 2 }),
            ),
            Expect.Simple('booleans', ['1', '1'], ['2', '1', '1']),
            Expect.Simple('enums', ['3', '2'], ['2', '3', '2']),
            Expect.Simple(
              'addressArray',
              ['2', '3', `${2n ** 180n}`, '2', '5', '7'],
              getByte32Array(2, 3, 2n ** 180n, 5, 7),
            ),
            Expect.Simple(
              'bArray',
              ['3', '2', '3', '5', '4', '7', '11', '13', '17'],
              ['7', '2', '3', '5', '7', '11', '13', '17'],
            ),
            Expect.Simple(
              'dynArray',
              [...['2', '3', '5'], ...['1', '7', '0']],
              getByteXArray(
                { byteSize: 4, value: 3 },
                { byteSize: 4, value: 5 },
                { byteSize: 32, value: 7 },
              ),
            ),
            Expect.Simple(
              'staticArray',
              ['2', '3', '5', '7', '11'],
              getByteXArray(
                { byteSize: 1, value: 2 },
                { byteSize: 1, value: 3 },
                { byteSize: 4, value: 5 },
                { byteSize: 4, value: 7 },
                { byteSize: 4, value: 11 },
              ),
            ),
          ]),
          File.Simple('abiEncodeWithSelector', [
            Expect.Simple(
              'encodeWithSelector',
              [],
              getByteXArray({ byteSize: 4, value: 0x01020304 }, { byteSize: 32, value: 3 }),
            ),
            Expect.Simple(
              'encodeWithSignature',
              [],
              getByteXArray({ byteSize: 4, value: 0x697e407d }, { byteSize: 32, value: 15 }),
            ),
          ]),
        ]),
        new Dir('abstractContracts', [
          File.Simple('mappingInConstructor', [
            Expect.Simple(
              'map',
              ['0', '0'],
              ['0', '0'],
              'test a value not set by the abstract constructor',
            ),
            Expect.Simple(
              'map',
              ['5', '0'],
              ['20', '0'],
              'test the value set by the abstract constructor',
            ),
          ]),
        ]),
        new Dir('anonymous_parameters', [
          new File(
            'func_override',
            'A',
            [],
            [
              Expect.Simple('f8', ['1', '2'], ['10']),
              Expect.Simple('f256', ['1', '0', '2', '0'], ['10', '0']),
            ],
          ),
          new File(
            'func_override',
            'B',
            [],
            [
              Expect.Simple('f8', ['3', '2'], ['5']),
              Expect.Simple('f256', ['5', '0', '4', '0'], ['9', '0']),
              Expect.Simple('one_argument8', ['5', '4'], ['12']),
              Expect.Simple('one_argument256', ['7', '0', '90', '725'], ['14', '0']),
            ],
          ),
        ]),
        new Dir('array_len', [
          File.Simple('memoryArray', [Expect.Simple('dynMemArrayLen', [], ['45', '0'])]),
          File.Simple('storageArray', [Expect.Simple('dynStorageArrayLen', [], ['1', '0'])]),
          File.Simple('calldataArray', [
            Expect.Simple('returnArrLength', ['3', '1', '2', '3'], ['3', '0']),
            Expect.Simple('returnArrDoubleLength', ['2', '0', '5'], ['4', '0']),
            Expect.Simple('fnCallWithArrLength', ['1', '9'], ['2', '0']),
            Expect.Simple('fnCallArrLengthNestedCalls', ['2', '1', '2'], ['16', '0']),
            Expect.Simple('assignLengthToStorageUint', ['3', '1', '2', '3'], ['3', '0']),
            Expect.Simple('assignToStorageArr', ['3', '1', '2', '3'], ['3', '0']),
            Expect.Simple('staticArrayLength', ['1', '2', '3'], ['3', '0']),
          ]),
        ]),
        new Dir('assembly', [
          File.Simple('Integers', [
            Expect.Simple(
              'subtractionFromZeroResultInNegativeValue',
              [],
              [...toCairoInt256(-1), toCairoInt8(-2)],
            ),
            Expect.Simple(
              'overflowsAreUnchecked',
              [],
              [
                ...toCairoInt256(MIN_INT256 + 1n),
                ...toCairoInt256(MAX_INT256),
                toCairoInt8(MIN_INT8),
                toCairoInt8(MAX_INT8 - 1n),
              ],
            ),
          ]),
        ]),
        new Dir('assignments', [
          File.Simple('compoundAssignment', [
            Expect.Simple('compoundAssignmentToMemory', [], ['3', '4']),
            Expect.Simple('compoundAssignmentToStorage', [], ['3', '4']),
          ]),
          File.Simple('functionSingle', [
            Expect.Simple('test', ['3'], ['3']),
            Expect.Simple('test256', ['3', '4'], ['3', '4']),
          ]),
          File.Simple('scalar', [
            Expect.Simple('test', ['3'], ['3']),
            Expect.Simple('test256', ['3', '4'], ['3', '4']),
          ]),
          File.Simple('tupleAssignments', [
            Expect.Simple('gapAndOrder', [], ['4', '0', '17', '0', '1', '0']),
          ]),
        ]),
        new Dir('bool_operators', [
          File.Simple('and', [
            Expect.Simple('test', ['1', '1'], ['1']),
            Expect.Simple('test', ['1', '0'], ['0']),
            Expect.Simple('test', ['0', '1'], ['0']),
            Expect.Simple('test', ['0', '0'], ['0']),
          ]),
          File.Simple('or', [
            Expect.Simple('test', ['1', '1'], ['1']),
            Expect.Simple('test', ['1', '0'], ['1']),
            Expect.Simple('test', ['0', '1'], ['1']),
            Expect.Simple('test', ['0', '0'], ['0']),
          ]),
        ]),
        new Dir('builtins', [File.Simple('blockMethods', [Expect.Simple('number', [], ['1'])])]),
        new Dir('bytes', [
          File.Simple('byteArrays', [
            Expect.Simple('getC', ['1'], ['9029']),
            Expect.Simple('getStorageBytesArray', [], ['13398']),
            Expect.Simple('getMemoryBytesArray', [], ['9029']),
            Expect.Simple('getMemoryBytesArrayTwo', [], ['4660', '9029']),
            Expect.Simple('getStorageBytesDynArray', [], ['4660']),
          ]),
          File.Simple('byteStructs', [
            Expect.Simple('getB3A', [], ['4660']),
            Expect.Simple('getBsC', [], ['18']),
          ]),
          File.Simple('bytesX', [
            Expect.Simple('bytes2access', ['0', '0'], ['0x11']),
            Expect.Simple('bytes12access', ['3', '0'], ['0x22']),
            Expect.Simple('bytes17access', ['14', '0'], ['0xde']),
            Expect.Simple('bytes24access', ['19', '0'], ['0x22']),
            Expect.Simple('bytes32access', ['15'], ['0x33']),
            Expect.Simple('bytes31access', ['30', '0'], ['0xff']),
            Expect.Simple('bytes32access', ['30'], ['0x44']),
            Expect.Simple('bytes32access256', ['31', '0'], ['0x11']),
          ]),
          File.Simple('conversions', [
            Expect.Simple('bytes1To2', ['150'], ['38400']),
            Expect.Simple('bytes3To3', ['1111'], ['1111']),
            Expect.Simple('bytes4To32', ['65534'], ['0', '5192138402209799099855309241319424']),
            Expect.Simple('bytes8To4', ['12378913312101057897'], ['2882190354']),
            Expect.Simple(
              'bytes32To16',
              ['15874680775494891679575061431532588017', '28760374527829798034901604089752130979'],
              ['28760374527829798034901604089752130979'],
            ),
            Expect.Simple(
              'bytes32To1',
              ['15874680775494891679575061431532588017', '28760374527829798034901604089752130979'],
              ['21'],
            ),
            Expect.Simple(
              'bytes25To7',
              ['135817028705001336493080341132658109378489430838222946241521'],
              ['6090246200111295'],
            ),
            Expect.Simple('bytes4To2Assignment', [], ['4660']),
          ]),
          File.Simple('dynamicToFixed', [
            Expect.Simple(
              'fromMemory',
              [
                '16',
                '0x61',
                '0x62',
                '0x63',
                '0x64',
                '0x65',
                '0x66',
                '0x67',
                '0x68',
                '0x61',
                '0x62',
                '0x63',
                '0x64',
                '0x65',
                '0x66',
                '0x67',
                '0x68',
              ],
              ['0x61626364656667686162636465666768'],
            ),
            Expect.Simple(
              'fromCalldata',
              [
                '16',
                '0x61',
                '0x62',
                '0x63',
                '0x64',
                '0x65',
                '0x66',
                '0x67',
                '0x68',
                '0x61',
                '0x62',
                '0x63',
                '0x64',
                '0x65',
                '0x66',
                '0x67',
                '0x68',
              ],
              ['0x61626364656667686162636465666768'],
            ),
            Expect.Simple('fromStorage', [], ['0x61626364656667686162636465666768']),
            Expect.Simple(
              'fromStorageLong',
              [],
              ['0x61626364656667686162636465666768', '0x61626364656667686162636465666768'],
            ),
          ]),
          new File(
            'fixedSizeBytesArrays',
            'WARP',
            ['340282366920938463463374607431768211455'],
            [
              Expect.Simple('getA', [], ['4660']),
              Expect.Simple('getB', [], ['0']),
              Expect.Simple('getC', [], ['0']),
              Expect.Simple('getD', [], ['340282366920938463463374607431768211455']),
              Expect.Simple('literalByte', [], ['1463898704']), // "WARP" = 0x57415250
              Expect.Simple('shiftBytesBy', ['2'], ['18640']),
              // 0x12345678
              Expect.Simple('shiftBytesByConstant', ['305419896'], ['76354974']),
              // 0x4321
              Expect.Simple('bitwiseAnd', ['17185'], ['544']),
              Expect.Simple('bitwiseOr', ['17185'], ['21301']),
              Expect.Simple('bitwiseXor', ['17185'], ['20757']),
              Expect.Simple('bitwiseNor', [], ['60875']),
              Expect.Simple('comparisonWithAB', ['0x4142'], ['1']),
              Expect.Simple('comparisonWithAB', ['0x4242'], ['0']),
              // 0xffff, 0xabcd
              Expect.Simple('nestedBitwiseOp', ['65535', '43981'], ['43465']),
              new Expect('testing constructor arguments out of bounds', [
                [
                  'constructor',
                  ['340282366920938463463374607431768211456'],
                  null,
                  '0',
                  'Error message: Error: value out-of-bounds. Value must be less than 2**128.',
                ],
              ]),
              Expect.Simple('length', [], ['4', '32']),
            ],
          ),
          new File(
            'fixedSizeByte7',
            'WARP',
            ['47'], // 0x2f
            [
              Expect.Simple('getA', [], ['47']),
              Expect.Simple('getB', [], ['170']),
              Expect.Simple('shiftByteBy', ['2'], ['188']),
              // 0x99
              Expect.Simple('shiftByteByConstant', ['153'], ['38']),
              // 0xbb
              Expect.Simple('bitwiseAnd', ['187'], ['43']),
              Expect.Simple('bitwiseOr', ['187'], ['191']),
              Expect.Simple('bitwiseXor', ['187'], ['148']),
              Expect.Simple('bitwiseNor', [], ['208']),
              // 0x2f, 0xf2
              Expect.Simple('nestedBitwiseAnd', ['47', '242'], ['34']),
              new Expect('testing constructor arguments out of bounds', [
                [
                  'constructor',
                  ['256'],
                  null,
                  '0',
                  'Error message: Error: value out-of-bounds. Value must be less than 2**8.',
                ],
              ]),
            ],
          ),
          File.Simple('index', [
            Expect.Simple('getByteAtIndex', ['0'], ['0']),
            Expect.Simple('getByteAtIndex', ['4'], ['4']),
            Expect.Simple(
              'flip',
              ['0x0102030405060708'],
              ['8', '8', '7', '6', '5', '4', '3', '2', '1'],
            ),
          ]),
          File.Simple('stringsBytesConversion', [
            Expect.Simple('getCharacter', ['4', '10', '12', '14', '16', ...['2', '0']], ['14']),
            Expect.Simple('getLength', [], ['4', '0']),
          ]),
        ]),
        new Dir('cairo_stubs', [
          File.Simple('basic', [Expect.Simple('useStub', [], ['5'])]),
          File.Simple('currentFunc', [
            Expect.Simple('simpleCase', [], ['1']),
            Expect.Simple('recursiveAdd', ['5', '3'], ['8']),
            Expect.Simple('testInternalDefinedInBase', [], ['2']),
            Expect.Simple('externalDefinedInBase', [], ['1']),
          ]),
          File.Simple('proxy', [
            new Expect('set hash and use', [
              ['setHash', ['hash@tests/behaviour/contracts/cairo_stubs/basic.WARP'], [], '0'],
              ['useStub_16588e6a', [], ['5'], '0'],
            ]),
          ]),
        ]),
        new Dir('calldata', [
          File.Simple('passingDynArrayInternally', [
            new Expect(
              'testing that calldata dynamic arrays can be passed to internal functions with the correct cairo type.',
              [['externReturnIndexAccess', ['4', '10', '20', '30', '40'], ['10', '20', '30'], '0']],
            ),
            new Expect(
              'testing that calldata dynamic arrays can be passed to internal functions with the correct cairo type, with whole dynarray returned',
              [
                [
                  'externReturnDarray',
                  ['4', '10', '20', '30', '40'],
                  ['4', '10', '20', '30', '40'],
                  '0',
                ],
              ],
            ),
            Expect.Simple('returnFirstIndex', ['2', ...['1', '2']], ['1']),
          ]),
          File.Simple('returningDynArrayExternally', [
            Expect.Simple('test', ['3', '4', '5', '6'], ['3', '4', '5', '6']),
            Expect.Simple('testIndexing', ['3', '4', '5', ' 6'], ['6']),
            Expect.Simple('testTwice', ['3', '4', '5', '6'], ['3', '4', '5', '6']),
          ]),
        ]),
        new Dir('concat', [
          File.Simple('bytes', [
            Expect.Simple('c0', [], ['0']),
            Expect.Simple('c1', ['3', '1', '2', '3'], ['3', '1', '2', '3']),
            Expect.Simple(
              'c2',
              ['3', '1', '2', '3', '4', '5', '6', '7', '8'],
              ['7', '1', '2', '3', '5', '6', '7', '8'],
            ),
            Expect.Simple(
              'c3',
              ['3', '1', '2', '3', '4', '5', '6', '7', '8', '2', '100', '200'],
              ['9', '1', '2', '3', '5', '6', '7', '8', '100', '200'],
            ),
            Expect.Simple(
              'c4',
              ['3', '1', '2', '3', '4', '5', '6', '7', '8'],
              ['7', '1', '2', '3', '5', '6', '7', '8'],
            ),
            Expect.Simple('c5', [], ['4', '1', '2', '3', '4']),
            Expect.Simple(
              'dynamicAndLiteral',
              ['2', ...['4', '5']],
              ['4', ...['4', '5', '104', '105'], '4', ...['104', '105', '4', '5']],
            ),
            Expect.Simple(
              'long',
              [],
              [
                '52',
                ...[
                  ...['97', '98', '99', '100'],
                  ...['101', '102', '103', '104'],
                  ...['105', '106', '107', '108'],
                  ...['109', '110', '111', '112'],
                  ...['113', '114', '115', '116'],
                  ...['117', '118', '119', '120'],
                  ...['121', '122', '65', '66'],
                  ...['67', '68', '69', '70'],
                  ...['71', '72', '73', '74'],
                  ...['75', '76', '77', '78'],
                  ...['79', '80', '81', '82'],
                  ...['83', '84', '85', '86'],
                  ...['87', '88', '89', '90'],
                ],
              ],
            ),
            Expect.Simple('d1', ['6553600'], ['3', '100', '0', '0']),
            Expect.Simple(
              'd2',
              ['255', '255', '0'],
              ['33', '255', ...new Array(31).fill('0'), '255'],
            ),
            Expect.Simple(
              'd3',
              ['128', '3', '1', '2', '3', '256'],
              ['20', '128', '1', '2', '3', ...new Array(14).fill('0'), '1', '0'],
            ),
            Expect.Simple(
              'staticAndLiteral',
              ['0xabcd'],
              ['4', ...['0xab', '0xcd', '104', '105'], '4', ...['104', '105', '0xab', '0xcd']],
            ),
          ]),
          File.Simple('strings', [
            Expect.Simple('s0', [], ['0']),
            Expect.Simple('s1', ['3', '1', '2', '3'], ['3', '1', '2', '3']),
            Expect.Simple(
              's2',
              ['3', '1', '2', '3', '4', '5', '6', '7', '8'],
              ['7', '1', '2', '3', '5', '6', '7', '8'],
            ),
            Expect.Simple(
              's3',
              ['3', '1', '2', '3', '4', '5', '6', '7', '8', '2', '100', '200'],
              ['9', '1', '2', '3', '5', '6', '7', '8', '100', '200'],
            ),
            Expect.Simple(
              's4',
              ['3', '1', '2', '3', '4', '5', '6', '7', '8'],
              ['7', '1', '2', '3', '5', '6', '7', '8'],
            ),
            Expect.Simple('s5', [], ['5', '97', '97', '98', '98', '99']),
            Expect.Simple('emptySingle', [], ['0']),
            Expect.Simple('emptyMultiple', [], ['0']),
          ]),
        ]),
        new Dir('conditionals', [
          File.Simple('and', [
            Expect.Simple('f', ['50', '0', '0'], ['0', '0']),
            Expect.Simple('f', ['10', '0', '1'], ['1', '0']),
            Expect.Simple('f', ['4', '0', '1'], ['5', '0']),
          ]),
          File.Simple('conditionals', [
            Expect.Simple('returnStr', ['1'], ['4', '87', '65', '82', '80']),
            Expect.Simple('updateVar', ['1'], ['20', '0', '46', '0']),
            Expect.Simple('updateVar', ['0'], ['15', '0', '50', '0']),
          ]),
          File.Simple('useValues', [
            Expect.Simple('useValues', ['1'], ['3', '4']),
            Expect.Simple('useValues', ['0'], ['1', '2']),
          ]),
          File.Simple('voidReturn', [
            Expect.Simple('x', [], ['0', '0']),
            Expect.Simple('voidReturn', [], []),
            Expect.Simple('x', [], ['5', '0']),
            Expect.Simple('voidReturn', [], []),
            Expect.Simple('x', [], ['10', '0']),
            Expect.Simple('voidReturn', [], []),
            Expect.Simple('x', [], ['0', '0']),
          ]),
          new File(
            'nested_and_or',
            'WARP',
            ['740', '0'],
            [
              Expect.Simple('move_valid', ['0', '0', '500', '0'], ['0']),
              Expect.Simple('move_valid', ['700', '0', '500', '0'], ['0']),
              Expect.Simple('move_valid', ['800', '0', '500', '0'], ['1']),
              Expect.Simple('move_valid', ['2000', '0', '500', '0'], ['0']),
              Expect.Simple('move_valid', ['1200', '0', '500', '0'], ['1']),
            ],
          ),
        ]),
        new Dir('constants', [
          File.Simple('constant_string_at_file_level', [
            Expect.Simple('f', [], ['3', '0x3', '0x1', '0x2']),
            Expect.Simple('g', [], ['3', '0x3', '0x1', '0x2']),
            Expect.Simple('h', [], ['5', '0x68', '0x65', '0x6C', '0x6C', '0x6F']),
            Expect.Simple(
              'i',
              [],
              ['0x38', '0', '0x1', '0', '129445968720857988376759499178045865984'],
            ),
          ]),
          File.Simple('simpleConstants', [
            Expect.Simple('getX', [], ['247']),
            Expect.Simple('stateVarOp', [], ['9']),
            Expect.Simple('constantOp', [], ['249']),
            Expect.Simple('pureOp', [], ['512']),
            Expect.Simple('pureOpWithValue', ['32'], ['288']),
            new Expect('changeStateVar', [
              ['changeStateVar', [], [], '0'],
              ['getX', [], ['503'], '0'],
            ]),
          ]),
          File.Simple('simpleConstantsUint256', [
            Expect.Simple('getX', [], ['0', '255211775190703847597530955573826158592']),
            Expect.Simple(
              'stateVarOp',
              [],
              ['340282366920938463463374607431768211455', '85070591730234615865843651857942052863'],
            ),
            Expect.Simple(
              'constantOp',
              [],
              [
                '340282366920938463463374607431768211455',
                '164824271477329568240072075474762727423',
              ],
            ),
            Expect.Simple(
              'pureOp',
              [],
              ['68056473384187692692674921486353642291', '68056473384187692692674921486353642291'],
            ),
            Expect.Simple(
              'pureOpWithValue',
              ['1', '0'],
              [
                '340282366920938463463374607431768211454',
                '340282366920938463463374607431768211455',
              ],
            ),
            Expect.Simple(
              'pureOpWithValueTwo',
              [
                '340282366920938463463374607431768211455',
                '340282366920938463463374607431768211455',
              ],
              [
                '340282366920938463463374607431768211454',
                '340282366920938463463374607431768211455',
              ],
            ),
            new Expect('changeStateVar', [
              ['changeStateVar', [], [], '0'],
              [
                'getX',
                [],
                [
                  '340282366920938463463374607431768211455',
                  '340282366920938458741008124562122997759',
                ],
                '0',
              ],
            ]),
          ]),
          new File(
            'simpleImmutable',
            'WARP',
            ['0', '256', '512'],
            [
              Expect.Simple('getUintValue', [], ['0', '256'], '0'),
              Expect.Simple('getIntValue', [], ['512'], '0'),
              Expect.Simple('addUintValue', ['0', '256'], ['0', '512'], '0'),
              Expect.Simple('addIntValue', ['256'], ['768'], '0'),
              new Expect('testing constructor argument out of bounds', [
                [
                  'constructor',
                  ['0', '256', '65536'],
                  null,
                  '0',
                  'Error message: Error: value out-of-bounds. Value must be less than 2**16.',
                ],
              ]),
            ],
          ),
        ]),
        new Dir('conversions', [
          File.Simple('addr2uint256', [
            Expect.Simple(
              'address2uint256',
              ['3618502788666131106986593281521497120414687020801267626233049500247285301247'],
              ['340282366920938463463374607431768211455', '10633823966279326983230456482242756607'],
            ),
          ]),
          File.Simple('signedIdentity', [
            Expect.Simple('implicit', ['210', '11', '12'], ['210', '11', '12']),
            Expect.Simple('explicit', ['200', '300', '400'], ['200', '300', '400']),
          ]),
          File.Simple('signedNarrowing', [
            Expect.Simple(
              'explicit',
              ['63005', '1000', '2000'],
              ['29', '70778732319555200400381918345807787983848'],
            ),
          ]),
          File.Simple('signedWidening', [
            Expect.Simple('implicit', ['10'], ['10', '10', '0']),
            Expect.Simple(
              'implicit',
              ['250'],
              [
                '65530',
                '340282366920938463463374607431768211450',
                '340282366920938463463374607431768211455',
              ],
            ),
            Expect.Simple('explicit', ['20'], ['20', '20', '0']),
            Expect.Simple(
              'explicit',
              ['240'],
              [
                '65520',
                '340282366920938463463374607431768211440',
                '340282366920938463463374607431768211455',
              ],
            ),
          ]),
          File.Simple('unsignedIdentity', [
            Expect.Simple('implicit', ['210', '11', '12'], ['210', '11', '12']),
            Expect.Simple('explicit', ['200', '300', '400'], ['200', '300', '400']),
          ]),
          File.Simple('unsignedNarrowing', [
            Expect.Simple(
              'explicit',
              ['63005', '1000', '2000'],
              ['29', '70778732319555200400381918345807787983848'],
            ),
          ]),
          File.Simple('unsignedWidening', [
            Expect.Simple('implicit', ['10'], ['10', '10', '0']),
            Expect.Simple('implicit', ['250'], ['250', '250', '0']),
            Expect.Simple('explicit', ['20'], ['20', '20', '0']),
            Expect.Simple('explicit', ['240'], ['240', '240', '0']),
          ]),

          File.Simple('widthsignWideningItoUchange', [
            Expect.Simple('widthsignWitou', ['60069'], ['4294961829']),
          ]),
          File.Simple('widthsignnarrowingItoUchange', [
            Expect.Simple('widthsignNitou', ['4294912623'], ['10863']),
          ]),
          File.Simple('widthsignwideningUtoIchange', [
            Expect.Simple('widthsignWutoi', ['32767'], ['32767']),
          ]),
          File.Simple('widthsignnarrowingUtoIchange', [
            Expect.Simple('widthsignNutoi', ['32768'], ['32768']),
          ]),
        ]),
        new Dir('copy_calldata_to_storage', [
          new Dir('implicitArrayConversions', [
            File.Simple('singleLayerBytes', [
              new Expect('BY0', [['testby0', ['10', '20', '30'], ['30', '20', '10'], '0']]),
              new Expect('BY1', [['testby1', ['10', '20', '30'], ['30', '20', '10'], '0']]),
              new Expect('BY2', [['testby2', ['3', '10', '20', '30'], ['30', '20', '10'], '0']]),
              new Expect('BY3', [
                [
                  'testby3',
                  ['10', '20', '30'],
                  ['128849018880', '85899345920', '42949672960'],
                  '0',
                ],
              ]),
              new Expect('BY4', [
                [
                  'testby4',
                  ['10', '20', '30'],
                  ['128849018880', '85899345920', '42949672960'],
                  '0',
                ],
              ]),
              new Expect('BY5', [
                [
                  'testby5',
                  ['3', '10', '20', '30'],
                  ['128849018880', '85899345920', '42949672960'],
                  '0',
                ],
              ]),
              new Expect('BY6', [
                [
                  'testby6',
                  ['10', '20', '30'],
                  [
                    '0',
                    '2376844875427930127806318510080',
                    '0',
                    '1584563250285286751870879006720',
                    '0',
                    '792281625142643375935439503360',
                  ],
                  '0',
                ],
              ]),
              new Expect('BY7', [
                [
                  'testby7',
                  ['10', '20', '30'],
                  [
                    '0',
                    '2376844875427930127806318510080',
                    '0',
                    '1584563250285286751870879006720',
                    '0',
                    '792281625142643375935439503360',
                  ],
                  '0',
                ],
              ]),
              new Expect('BY8', [
                [
                  'testby8',
                  ['3', '10', '20', '30'],
                  [
                    '0',
                    '2376844875427930127806318510080',
                    '0',
                    '1584563250285286751870879006720',
                    '0',
                    '792281625142643375935439503360',
                  ],
                  '0',
                ],
              ]),
            ]),
            File.Simple('singleLayer', [
              new Expect('A0', [
                ['testa0', ['10', '20', '30'], ['30', '0', '20', '0', '10', '0'], '0'],
              ]),
              new Expect('A1', [['testa1', ['10', '20', '30'], ['30', '20', '10'], '0']]),
              new Expect('A2', [
                [
                  'testa2',
                  ['10', '20', '30'],
                  ['0', '0', '0', '0', '30', '0', '20', '0', '10', '0'],
                  '0',
                ],
              ]),
              new Expect('A3', [['testa3', ['3', '10', '20', '30'], ['30', '20', '10'], '0']]),
              new Expect('A4', [
                ['testa4', ['10', '20', '30'], ['30', '0', '20', '0', '10', '0'], '0'],
              ]),
              new Expect('A5', [
                [
                  'testa5',
                  ['10', '20', '30'],
                  ['0', '0', '0', '0', '30', '0', '20', '0', '10', '0'],
                  '0',
                ],
              ]),
              new Expect('A6', [
                [
                  'testa6',
                  ['4', '10', '20', '30', '40'],
                  ['40', '0', '30', '0', '20', '0', '10', '0'],
                  '0',
                ],
              ]),
              new Expect('A7', [
                [
                  'testa7',
                  ['4', '10', '20', '30', '40'],
                  ['40', '0', '30', '0', '20', '0', '10', '0'],
                  '0',
                ],
              ]),
            ]),
            File.Simple('doubleLayer', [
              new Expect('B0', [
                [
                  'testb0',
                  ['10', '20', '30', '40', '50', '60'],
                  ['60', '50', '40', '30', '20', '10'],
                  '0',
                ],
              ]),
              new Expect('B1', [
                [
                  'testb1',
                  ['10', '20', '30', '40', '50', '60'],
                  ['60', '50', '40', '30', '20', '10'],
                  '0',
                ],
              ]),
              new Expect('B2', [
                [
                  'testb2',
                  ['10', '20', '30', '40', '50', '60'],
                  ['0', '60', '50', '40', '0', '30', '20', '10'],
                  '0',
                ],
              ]),
              new Expect('B3', [
                [
                  'testb3',
                  ['10', '20', '30', '40', '50', '255'],
                  ['0', '0', '0', '0', '0', '65535', '50', '40', '0', '30', '20', '10'],
                  '0',
                ],
              ]),
              new Expect('B4', [
                [
                  'testb4',
                  ['10', '20', '30', '40', '50', '60'],
                  ['60', '50', '40', '30', '20', '10'],
                  '0',
                ],
              ]),
              new Expect('B5', [
                [
                  'testb5',
                  ['10', '20', '30', '40', '50', '60'],
                  ['60', '0', '50', '0', '40', '0', '30', '0', '20', '0', '10', '0'],
                  '0',
                ],
              ]),
              new Expect('B6', [
                [
                  'testb6',
                  ['10', '20', '30', '40', '50', '60'],
                  ['60', '0', '50', '0', '40', '0', '30', '0', '20', '0', '10', '0'],
                  '0',
                ],
              ]),
              new Expect('B7', [
                [
                  'testb7',
                  ['10', '20', '30', '40', '50', '60'],
                  [
                    '0',
                    '0',
                    '60',
                    '0',
                    '50',
                    '0',
                    '40',
                    '0',
                    '0',
                    '0',
                    '30',
                    '0',
                    '20',
                    '0',
                    '10',
                    '0',
                  ],
                  '0',
                ],
              ]),
              new Expect('B8', [
                [
                  'testb8',
                  ['10', '20', '30', '40', '50', '60'],
                  [
                    '0',
                    '0',
                    '60',
                    '0',
                    '50',
                    '0',
                    '40',
                    '0',
                    '0',
                    '0',
                    '30',
                    '0',
                    '20',
                    '0',
                    '10',
                    '0',
                  ],
                  '0',
                ],
              ]),
              new Expect('B9', [
                [
                  'testb9',
                  ['10', '20', '30', '40', '50', '60'],
                  ['60', '0', '50', '0', '40', '0', '30', '0', '20', '0', '10', '0'],
                  '0',
                ],
              ]),
              new Expect('B10', [
                [
                  'testb10',
                  ['2', '10', '20', '30', '40', '50', '60'],
                  ['60', '50', '40', '30', '20', '10'],
                  '0',
                ],
              ]),
              new Expect('B11', [
                [
                  'testb11',
                  ['2', '10', '20', '30', '40', '50', '60'],
                  ['60', '50', '40', '30', '20', '10'],
                  '0',
                ],
              ]),
              new Expect('B12', [
                [
                  'testb12',
                  ['2', '10', '20', '30', '40', '50', '60'],
                  ['60', '50', '40', '30', '20', '10'],
                  '0',
                ],
              ]),
              new Expect('B13', [
                [
                  'testb13',
                  ['2', '10', '20', '30', '40', '50', '60'],
                  ['60', '0', '50', '0', '40', '0', '30', '0', '20', '0', '10', '0'],
                  '0',
                ],
              ]),
              new Expect('B14', [
                [
                  'testb14',
                  ['2', '10', '20', '30', '40', '50', '60'],
                  ['60', '0', '50', '0', '40', '0', '30', '0', '20', '0', '10', '0'],
                  '0',
                ],
              ]),
              new Expect('B15', [
                [
                  'testb15',
                  ['2', '10', '20', '30', '40', '50', '60'],
                  ['60', '0', '50', '0', '40', '0', '30', '0', '20', '0', '10', '0'],
                  '0',
                ],
              ]),
              new Expect('B16', [
                [
                  'testb16',
                  ['2', '10', '20', '30', '40', '50', '60'],
                  ['60', '0', '50', '0', '40', '0', '30', '0', '20', '0', '10', '0'],
                  '0',
                ],
              ]),
            ]),
            File.Simple('tripleLayer', [
              new Expect('C0', [
                [
                  'testc0',
                  ['2', '10', '20', '30', '40', '50', '60', '70', '80'],
                  ['50', '60', '70', '80', '10', '20', '30', '40'],
                  '0',
                ],
              ]),
              new Expect('C1', [
                [
                  'testc1',
                  ['2', '10', '20', '30', '40', '50', '60', '70', '80'],
                  ['2', '70', '80', '2', '50', '60', '2', '30', '40', '2', '10', '20'],
                  '0',
                ],
              ]),
              new Expect('C2', [
                [
                  'testc2',
                  ['2', '10', '20', '30', '40', '50', '60', '70', '80'],
                  [
                    '70',
                    '80',
                    '0',
                    '0',
                    '50',
                    '60',
                    '0',
                    '0',
                    '30',
                    '40',
                    '0',
                    '0',
                    '10',
                    '20',
                    '0',
                    '0',
                  ],
                  '0',
                ],
              ]),
              new Expect('C3', [
                [
                  'testc3',
                  ['2', '10', '20', '30', '40', '50', '60', '70', '80'],
                  ['2', '70', '80', '2', '50', '60', '2', '30', '40', '2', '10', '20'],
                  '0',
                ],
              ]),
              new Expect('C4', [
                [
                  'testc4',
                  ['2', '10', '20', '30', '40', '50', '60', '70', '80'],
                  [
                    '70',
                    '80',
                    '0',
                    '0',
                    '50',
                    '60',
                    '0',
                    '0',
                    '30',
                    '40',
                    '0',
                    '0',
                    '10',
                    '20',
                    '0',
                    '0',
                  ],
                  '0',
                ],
              ]),
              new Expect('C5', [
                [
                  'testc5',
                  ['10', '20', '30', '40', '50', '60', '70', '80'],
                  [
                    '70',
                    '80',
                    '0',
                    '0',
                    '50',
                    '60',
                    '0',
                    '0',
                    '30',
                    '40',
                    '0',
                    '0',
                    '10',
                    '20',
                    '0',
                    '0',
                  ],
                  '0',
                ],
              ]),
              new Expect('C6', [
                [
                  'testc6',
                  ['10', '20', '30', '40', '50', '60', '70', '80'],
                  ['2', '70', '80', '2', '50', '60', '2', '30', '40', '2', '10', '20'],
                  '0',
                ],
              ]),
              new Expect('C7', [
                [
                  'testc7',
                  ['10', '20', '30', '40', '50', '60', '70', '80'],
                  [
                    '70',
                    '80',
                    '0',
                    '0',
                    '50',
                    '60',
                    '0',
                    '0',
                    '30',
                    '40',
                    '0',
                    '0',
                    '10',
                    '20',
                    '0',
                    '0',
                  ],
                  '0',
                ],
              ]),
              new Expect('C8', [
                [
                  'testc8',
                  ['10', '20', '30', '40', '50', '60', '70', '80'],
                  ['2', '70', '80', '2', '50', '60', '2', '30', '40', '2', '10', '20'],
                  '0',
                ],
              ]),
              new Expect('C9', [
                [
                  'testc9',
                  ['10', '20', '30', '40', '50', '60', '70', '80'],
                  [
                    '70',
                    '80',
                    '0',
                    '0',
                    '50',
                    '60',
                    '0',
                    '0',
                    '30',
                    '40',
                    '0',
                    '0',
                    '10',
                    '20',
                    '0',
                    '0',
                  ],
                  '0',
                ],
              ]),
              new Expect('C10', [
                [
                  'testc10',
                  ['10', '20', '30', '40', '50', '60', '70', '80'],
                  ['70', '80', '0', '50', '60', '0', '30', '40', '0', '10', '20', '0'],
                  '0',
                ],
              ]),
            ]),
            File.Simple('push', [
              Expect.Simple('passInt8ToInt256', ['2', '1', '255'], []),
              Expect.Simple('arr', ['0', '0', '0', '0'], ['1', '0']),
              Expect.Simple(
                'arr',
                ['0', '0', '1', '0'],
                ['0xffffffffffffffffffffffffffffffff', '0xffffffffffffffffffffffffffffffff'],
              ),
            ]),
          ]),
          File.Simple('dynamic_arrays', [
            new Expect('felt dynamic arrays is copied from calldata to storage', [
              ['setX', ['4', '2', '3', '5', '7'], [], '0'],
              ['getXFull', [], ['4', '2', '3', '5', '7'], '0'],
              ['getX', [], ['10'], '0'],
            ]),
            new Expect('uint256 dynamic array is copied form calldata to storage', [
              ['setY', ['4', '2', '0', '3', '0', '5', '0', '7', '0'], [], '0'],
              ['getYFull', [], ['4', '2', '0', '3', '0', '5', '0', '7', '0'], '0'],
              ['getY', [], ['10', '0'], '0'],
            ]),
          ]),
          File.Simple('static_arrays', [
            new Expect('static array is copied from calldata to storage', [
              ['setX', ['3', '0', '5', '0', '1', '0'], [], '0'],
              ['getX', [], ['9', '0'], '0'],
            ]),
          ]),
          File.Simple('structs', [
            new Expect('struct is copied from calldata to storage', [
              ['setS', ['3', '5', '0'], [], '0'],
              ['getS', [], ['8', '0'], '0'],
            ]),
            new Expect('struct dynamic array is copied from calldata to storage', [
              ['setF', [], [], '0'],
              [
                'getF',
                [],
                ['3', ...['10', '20', '0'], ...['2', '3', '0'], ...['3', '4', '0']],
                '0',
              ],
            ]),
            Expect.Simple(
              'getD',
              [],
              ['1', '0', '1', '0', '2', '1', '2', '0'],
              'struct of structs is copyed form calldata to storage',
            ),
            new Expect('dynamic array of structs of structs is copied from calldata to storage', [
              ['setE', [], [], '0'],
              [
                'getE',
                [],
                [
                  '3',
                  ...['1', '0', '1', '0', '2', '1', '2', '0'],
                  ...['3', '0', '3', '0', '2', '3', '2', '0'],
                  ...['5', '0', '5', '0', '7', '5', '7', '0'],
                ],
                '0',
              ],
            ]),
          ]),
        ]),
        new Dir('copy_memory_to_calldata', [
          File.Simple('dynArray', [
            new Expect('returning a dynarray of felts', [
              ['returnFelt', [], ['3', '10', '20', '30'], '0'],
            ]),
            new Expect('returning a dynarray of Uint256', [
              ['returnUint256', [], ['3', '10', '0', '100', '0', '1000', '0'], '0'],
            ]),
            new Expect('returning a dynarray of structs', [
              ['returnStruct', [], ['3', '1', '0', '10', '2', '0', '20', '3', '0', '30'], '0'],
            ]),
            new Expect('return a dynarray of nested structs', [
              [
                'returnNestedStruct',
                [],
                [
                  '3',
                  '1',
                  '0',
                  '10',
                  '0',
                  '100',
                  '1000',
                  '0',
                  '2',
                  '0',
                  '20',
                  '0',
                  '200',
                  '2000',
                  '0',
                  '3',
                  '0',
                  '30',
                  '0',
                  '300',
                  '3000',
                  '0',
                ],
                '0',
              ],
            ]),
            new Expect('returning a 2 dynarrays of felts', [
              [
                'returnMultipleFeltDynArray',
                [],
                ['3', '1', '2', '3', '4', '5', '6', '7', '8'],
                '0',
              ],
            ]),
            new Expect('returning a dynarray as a member access.', [
              ['returnDynArrayAsMemberAccess', [], ['2', '10', '0', '100', '0'], '0'],
            ]),
            new Expect('returning a dynarray as a index access.', [
              ['returnDynArrayAsIndexAccess', [], ['2', '10', '0', '100', '0'], '0'],
            ]),
            new Expect('returning a dynarray from a dynarray access.', [
              ['returnDynArrayFromDynArray', [], ['3', '10', '0', '100', '0', '1000', '0'], '0'],
            ]),
            new Expect('returning a dynarray function call in return statement.', [
              ['returnDynArrayFromFunctionCall', [], ['3', '100', '200', '252'], '0'],
            ]),
          ]),
        ]),
        new Dir('copy_memory_to_storage', [
          File.Simple('array_conversions', [
            Expect.Simple(
              'scalingDynamicCopy',
              ['4', '1', '2', '3', '4'],
              ['4', '1', '0', '2', '0', '3', '0', '4', '0'],
            ),
            Expect.Simple(
              'scalingStaticToDynamicCopy',
              ['4', '5', '6'],
              ['4', '4', '0', '5', '0', '6', '0', '0', '0'],
            ),
            Expect.Simple(
              'scalingStaticCopy',
              ['4', '5', '6', '7', '8'],
              ['4', '0', '5', '0', '6', '0', '7', '0', '8', '0'],
            ),
            Expect.Simple(
              'scalingStaticCopyShorterToLarger',
              ['4', '5', '6'],
              ['4', '0', '5', '0', '6', '0', '0', '0', '0', '0'],
            ),
            Expect.Simple('scalingIntDynamic', [], ['3', '65535', '5', '10']),
            Expect.Simple('scalingIntStatic', [], ['4294967294', '4', '9', '0', '0']),
            Expect.Simple('wideningBytes', [], ['2', '65280', '65280']),
            Expect.Simple(
              'nestedStaticToDynamic',
              [],
              [
                ...['3', '1', '0', '2', '0', '3', '0'],
                ...['3', '4', '0', '5', '0', '6', '0'],
                ...['3', '7', '0', '8', '0', '9', '0'],
              ],
            ),
            Expect.Simple(
              'nestedDynamicToDynamic',
              [],
              [...['2', '1', '0', '2', '0'], ...['2', '3', '0', '4', '0']],
            ),
            Expect.Simple(
              'nestedSmallerStaticToDynamic',
              [],
              [...['2', '1', '0', '2', '0'], ...['2', '3', '0', '4', '0'], '0'],
            ),
            Expect.Simple(
              'nestedDynamicStaticToDynamic',
              [],
              [
                ...['3', '1', '0', '2', '0', '3', '0'],
                ...['3', '4', '0', '5', '0', '6', '0'],
                ...['3', '7', '0', '8', '0', '9', '0'],
              ],
            ),
            Expect.Simple(
              'nestedStaticDynamicToDynamic',
              [],
              [
                ...['1', '1', '0'],
                ...['2', '0', '0', '2', '0'],
                ...['3', '0', '0', '0', '0', '3', '0'],
              ],
            ),
            Expect.Simple(
              'nestedStaticToStatic',
              [],
              [
                ...['1', '0', '2', '0', '0', '0'],
                ...['3', '0', '4', '0', '0', '0'],
                ...['5', '0', '6', '0', '0', '0'],
              ],
            ),
            Expect.Simple(
              'nestedSmallerStaticToStatic',
              [],
              [
                ...['1', '0', '2', '0', '0', '0'],
                ...['3', '0', '4', '0', '0', '0'],
                ...['0', '0', '0', '0', '0', '0'],
              ],
            ),
            Expect.Simple(
              'nestedNestedStatic',
              [],
              [...['1', '0', '0', '0'], ...['0', '0', '0', '0'], ...['0', '0', '0', '0']],
            ),
            Expect.Simple(
              'nestedDynamicStaticToDynamicStatic',
              [],
              [
                '3',
                ...['1', '0', '2', '0', '0', '0'],
                ...['3', '0', '4', '0', '0', '0'],
                ...['5', '0', '6', '0', '0', '0'],
              ],
            ),
            Expect.Simple(
              'nestedStaticDynamicToStaticDynamic',
              [],
              [
                ...['1', ...['1', '0']],
                ...['2', ...['0', '0', '2', '0']],
                ...['3', ...['0', '0', '0', '0', '3', '0']],
              ],
            ),
          ]),
          File.Simple('dynamic_arrays', [
            new Expect('arrays are initialised correctly', [
              ['getLengths', [], ['5', '0', '10', '0'], '0'],
              ['arr8', ['4', '0'], ['0'], '0'],
              ['arr8', ['5', '0'], null, '0'],
              ['arr256', ['9', '0'], ['0', '0'], '0'],
              ['arr256', ['10', '0'], null, '0'],
            ]),
            new Expect('arrays are assigned values correctly', [
              ['fillWithValues', [], [], '0'],
              ['arr8', ['0', '0'], ['1'], '0'],
              ['arr8', ['4', '0'], ['5'], '0'],
              ['arr256', ['0', '0'], ['1', '2'], '0'],
              ['arr256', ['9', '0'], ['10', '11'], '0'],
            ]),
            new Expect('uint8 array overwritten correctly', [
              ['assign8', ['3', '0'], [], '0'],
              ['getLengths', [], ['3', '0', '10', '0'], '0'],
              ['arr8', ['0', '0'], ['0'], '0'],
              ['arr8', ['1', '0'], ['0'], '0'],
              ['arr8', ['2', '0'], ['0'], '0'],
              ['arr8', ['3', '0'], null, '0'],
              ['arr256', ['9', '0'], ['10', '11'], '0'],
              ['arr256', ['10', '0'], null, '0'],
            ]),
            new Expect('uint256 array overwritten correctly', [
              ['assign256', ['12', '0'], [], '0'],
              ['getLengths', [], ['3', '0', '12', '0'], '0'],
              ['arr8', ['2', '0'], ['0'], '0'],
              ['arr8', ['3', '0'], null, '0'],
              ['arr256', ['9', '0'], ['0', '0'], '0'],
              ['arr256', ['11', '0'], ['0', '0'], '0'],
              ['arr256', ['12', '0'], null, '0'],
            ]),
            new Expect('lengths set properly with tuple assignment', [
              ['tupleAssign', ['12', '0', '5', '0'], [], '0'],
              ['getLengths', [], ['12', '0', '5', '0'], '0'],
            ]),
          ]),
          File.Simple('dynamic_arrays_2d', [
            new Expect('two dimensional dynamic arrays to storage', [
              ['setArr8', [], ['1', '1', '2', '0', '2', '3', '0', '0', '3'], '0'],
              ['arr8', ['0', '0', '0', '0'], ['1'], '0'],
              ['getArr8', ['0', '0'], ['1', '1'], '0'],
              ['getArr8', ['1', '0'], ['2', '0', '2'], '0'],
              ['getArr8', ['2', '0'], ['3', '0', '0', '3'], '0'],
            ]),
          ]),
          File.Simple('struct', [
            new Expect('memory to storage for structs', [
              ['getStructs', [], ['0', '0', '0', '0', '0', '0'], '0'],
              ['copySimpleStruct', ['1', '2'], [], '0'],
              ['getStructs', [], ['0', '0', '0', '0', '1', '2'], '0'],
              ['copyNestedStruct', ['3', '4', '5', '6'], [], '0'],
              ['getStructs', [], ['3', '4', '5', '6', '1', '2'], '0'],
              ['copyInnerStruct', ['7', '8'], [], '0'],
              ['getStructs', [], ['3', '4', '7', '8', '1', '2'], '0'],
            ]),
          ]),
        ]),
        new Dir('copy_storage_to_calldata', [
          File.Simple('dynamic_arrays', [
            new Expect('felt dynamic array from storage to calldata', [
              ['pushToX', ['1'], [], '0'],
              ['pushToX', ['2'], [], '0'],
              ['pushToX', ['3'], [], '0'],
              ['getX', [], ['3', '1', '2', '3'], '0'],
            ]),
            new Expect('uint256 dynamic array from storage to calldata', [
              ['pushToY', ['1', '0'], [], '0'],
              ['pushToY', ['2', '0'], [], '0'],
              ['pushToY', ['3', '0'], [], '0'],
              ['getY', [], ['3', '1', '0', '2', '0', '3', '0'], '0'],
            ]),
          ]),
          File.Simple('static_arrays', [
            new Expect('static array copy from storage to calldata', [
              ['setX', ['1', '0', '2', '0', '3', '0'], [], '0'],
              ['getX', [], ['1', '0', '2', '0', '3', '0'], '0'],
            ]),
          ]),
          File.Simple('structs', [
            new Expect('structs copy from storage to calldata', [
              ['setS', ['5', '7', '0'], [], '0'],
              ['getS', [], ['5', '7', '0'], '0'],
            ]),
          ]),
        ]),
        new Dir('copy_storage_to_memory', [
          File.Simple('dynamic_arrays', [
            Expect.Simple('copySimpleArrayLength', [], ['3', '0']),
            Expect.Simple('copySimpleArrayValues', [], ['5', '0', '4']),
            Expect.Simple('copySimpleArrayToIdentifier', [], ['3', '5', '0', '4']),
            Expect.Simple(
              'testNestedArray',
              [...['3', '1', '2', '3'], ...['2', '1', '0'], ...['3', '4', '5', '6']],
              [...['3', '1', '2', '3'], ...['2', '1', '0'], ...['3', '4', '5', '6']],
            ),
          ]),
          File.Simple('static_arrays', [
            Expect.Simple('getX', [], ['1', '2', '3', '4', '5']),
            Expect.Simple(
              'getY',
              [],
              ['5', '0', '0', '0', '0', '10', '0', '0', '0', '0', '15', '0', '0', '0', '17'],
            ),
            Expect.Simple('getW', [], ['1', '0', '2', '0', '3', '0']),
            Expect.Simple('getZ', [], ['1', '0', '2', '0', '3', '0', '4', '0', '5', '0', '6', '0']),
            Expect.Simple('scalarInTuple', [], ['1', '0', '10', '0', '3', '0']),
            Expect.Simple(
              'getNested',
              [...['3', '1', '2', '3'], ...['2', '1', '0'], ...['3', '4', '5', '6']],
              [...['3', '1', '2', '3'], ...['2', '1', '0'], ...['3', '4', '5', '6']],
            ),
            Expect.Simple(
              'getNestedLarge',
              [
                ...['3', '1', '2', '3'],
                ...['2', '1', '0'],
                ...['3', '4', '5', '6'],
                ...['1', '5'],
                ...['2', '11', '13'],
                ...['2', '17', '19'],
              ],
              [
                ...['3', '1', '2', '3'],
                ...['2', '1', '0'],
                ...['3', '4', '5', '6'],
                ...['1', '5'],
                ...['2', '11', '13'],
                ...['2', '17', '19'],
              ],
            ),
          ]),
          File.Simple('structs', [
            Expect.Simple('setS', ['2', '3', '5', '7'], []),
            Expect.Simple('getS', [], ['2', '3', '5', '7']),
            Expect.Simple('setP', ['3', '3', '5', '7'], []),
            Expect.Simple('getP', [], ['3', '3', '5', '7']),
          ]),
        ]),
        new Dir('copy_storage_to_storage', [
          File.Simple('array_conversions', [
            new Expect('copy static to dynamic', [
              ['setStatic', ['4', '5', '7', '6'], ['4', '5', '7', '6'], '0'],
              ['copyStaticToDynamic', [], ['2', '4', '5', '7', '6', '4', '5', '7', '6'], '0'],
            ]),
            new Expect('copy nested static to nested dynamic', [
              [
                'setStaticDeep',
                [...['4', '5', '7', '6'], ...['1', '2', '3', '9']],
                [...['4', '5', '7', '6'], ...['1', '2', '3', '9']],
                '0',
              ],
              [
                'copyStaticToDynamicDeep',
                [],
                [
                  '2',
                  ...['4', '5', '7', '6'],
                  '2',
                  ...['1', '2', '3', '9'],
                  ...[...['4', '5', '7', '6'], ...['1', '2', '3', '9']],
                ],
                '0',
              ],
              [
                'copyStaticToDynamicPush',
                [],
                [...['2', '4', '5', '7', '6'], ...['2', '1', '2', '3', '9'], '0'],
                '0',
              ],
            ]),
            new Expect('copy nested static to nested static of different size', [
              [
                'setStaticDeep',
                [...['4', '5', '7', '6'], ...['1', '2', '3', '9']],
                [...['4', '5', '7', '6'], ...['1', '2', '3', '9']],
                '0',
              ],
              [
                'copyStaticDifferentSize',
                [],
                [
                  ...['4', '5', '7', '6', '0', '0'],
                  ...['1', '2', '3', '9', '0', '0'],
                  ...['0', '0', '0', '0', '0', '0'],
                ],
                '0',
              ],
              [
                'copyStaticDifferentSizeComplex',
                [],
                [
                  ...['4', '5', '7', '6', '0', '0'],
                  ...['1', '2', '3', '9', '0', '0'],
                  ...['0', '0', '0', '0', '0', '0'],
                ],
                '0',
              ],
            ]),
            new Expect('copy nested static to T[][X]', [
              [
                'setStaticDeep',
                [...['4', '5', '7', '6'], ...['1', '2', '3', '9']],
                [...['4', '5', '7', '6'], ...['1', '2', '3', '9']],
                '0',
              ],
              [
                'copyStaticStaticToStaticDynamic',
                [],
                [
                  '2',
                  ...['4', '5', '7', '6'],
                  '2',
                  ...['1', '2', '3', '9'],
                  ...[...['4', '5', '7', '6'], ...['1', '2', '3', '9']],
                ],
                '0',
              ],
            ]),
            new Expect('copy nested static to T[X][]', [
              [
                'setStaticDeep',
                [...['4', '5', '7', '6'], ...['1', '2', '3', '9']],
                [...['4', '5', '7', '6'], ...['1', '2', '3', '9']],
                '0',
              ],
              [
                'copyStaticStaticToDynamicStatic',
                [],
                [
                  ...['4', '5', '7', '6'],
                  ...['1', '2', '3', '9'],
                  ...[...['4', '5', '7', '6'], ...['1', '2', '3', '9']],
                ],
                '0',
              ],
            ]),
            Expect.Simple('scalingUint', ['3', '2', '3', '5'], ['3', '2', '0', '3', '0', '5', '0']),
            Expect.Simple('scalingInt', ['1', '255'], ['1', '4294967295']),
            Expect.Simple(
              'identity',
              [],
              [...['3', '2', '3', '5'], ...['3', '2', '0', '3', '0', '5', '0']],
            ),
          ]),
          File.Simple('dynamic_arrays', [
            new Expect('copy values', [
              ['setArr1', ['5', '7', '6', ' 8', '3', '2', '1', ' 9'], [], '0'],
              ['copy', [], [], '0'],
              ['getArr1', [], ['5', '7', '6', ' 8', '3', '2', '1', ' 9'], '0'],
              ['getArr2', [], ['5', '7', '6', ' 8', '3', '2', '1', ' 9'], '0'],
            ]),
          ]),
          File.Simple('scalars', [
            new Expect('copy values', [
              ['getValues', [], ['0', '0', '0'], '0'],
              ['set8', ['5'], [], '0'],
              ['copy8To256', [], [], '0'],
              ['getValues', [], ['5', '5', '0'], '0'],
              ['set256', ['4', '3'], [], '0'],
              ['copy256To8', [], [], '0'],
              ['getValues', [], ['4', '4', '3'], '0'],
            ]),
          ]),
          File.Simple('static_arrays', [
            new Expect('copy values', [
              ['setArr1', ['5', '7', '6', ' 8'], [], '0'],
              ['copy', [], [], '0'],
              ['getArr1', [], ['5', '7', '6', ' 8'], '0'],
              ['getArr2', [], ['5', '7', '6', ' 8'], '0'],
            ]),
          ]),
          File.Simple('structs', [
            new Expect('copy full struct', [
              ['getStruct1', [], ['0', '0', '0', '0', '0'], '0'],
              ['getStruct2', [], ['0', '0', '0', '0', '0'], '0'],
              ['setStruct1', ['1', '3', '1', '4', '2'], [], '0'],
              ['getStruct1', [], ['1', '3', '1', '4', '2'], '0'],
              ['getStruct2', [], ['0', '0', '0', '0', '0'], '0'],
              ['copyFull', [], [], '0'],
              ['getStruct1', [], ['1', '3', '1', '4', '2'], '0'],
              ['getStruct2', [], ['1', '3', '1', '4', '2'], '0'],
            ]),
            new Expect('copy inner struct', [
              ['getStruct1', [], ['1', '3', '1', '4', '2'], '0'],
              ['getStruct2', [], ['1', '3', '1', '4', '2'], '0'],
              ['setStruct1', ['0', '8', '7', '6', '5'], [], '0'],
              ['getStruct1', [], ['0', '8', '7', '6', '5'], '0'],
              ['getStruct2', [], ['1', '3', '1', '4', '2'], '0'],
              ['copyInner', [], [], '0'],
              ['getStruct1', [], ['0', '8', '7', '6', '5'], '0'],
              ['getStruct2', [], ['1', '8', '7', '4', '2'], '0'],
            ]),
          ]),
        ]),
        new Dir('cross_contract_calls', [
          File.Simple(
            'this_methods_call',
            [Expect.Simple('execute_add', ['2', '0', '35', '0'], ['637', '0'])],
            'A',
          ),
          File.Simple('simple', [Expect.Simple('f', [], ['69', '0'])], 'A'),
          File.Simple(
            'simple',
            [
              Expect.Simple(
                'f',
                ['address@tests/behaviour/contracts/cross_contract_calls/simple.A'],
                ['69', '0'],
              ),
            ],
            'WARP',
          ),
          File.Simple('public_vars', [Expect.Simple('f', [], ['696', '0'])], 'A'),
          File.Simple(
            'public_vars',
            [
              Expect.Simple(
                'setA',
                ['address@tests/behaviour/contracts/cross_contract_calls/public_vars.A'],
                [],
              ),
            ],
            'B',
          ),
          File.Simple(
            'public_vars',
            [
              Expect.Simple(
                'setB',
                [
                  'address@tests/behaviour/contracts/cross_contract_calls/public_vars.A',
                  'address@tests/behaviour/contracts/cross_contract_calls/public_vars.B',
                ],
                [],
              ),
              Expect.Simple('foo', [], ['696', '0']),
              Expect.Simple(
                'f',
                ['address@tests/behaviour/contracts/cross_contract_calls/simple.A'],
                ['69', '0'],
              ),
            ],
            'C',
          ),
          File.Simple(
            'other_contract_same_type',
            [Expect.Simple('counter', [], ['0', '0'])],
            'WARPDuplicate',
          ),
          File.Simple('other_contract_same_type', [
            Expect.Simple('counter', [], ['0', '0']),
            Expect.Simple(
              'getAndIncrementOtherCounter',
              [
                'address@tests/behaviour/contracts/cross_contract_calls/other_contract_same_type.WARPDuplicate',
              ],
              ['0', '0'],
            ),
            Expect.Simple(
              'getCounters',
              [
                'address@tests/behaviour/contracts/cross_contract_calls/other_contract_same_type.WARPDuplicate',
              ],
              [...['0', '0'], ...['1', '0']],
            ),
          ]),
          File.Simple('dynArrays', [], 'ArrayProvider'),
          File.Simple('dynArrays', [
            Expect.Simple(
              'receiveArr',
              ['address@tests/behaviour/contracts/cross_contract_calls/dynArrays.ArrayProvider'],
              ['3', '0'],
            ),
            Expect.Simple(
              'receiveMultiple',
              [
                '2',
                '7',
                '8',
                '9',
                '3',
                'address@tests/behaviour/contracts/cross_contract_calls/dynArrays.ArrayProvider',
              ],
              ['2', '0', '5', '0', '4', '0', '2', '0', '5', '0', '4', '0'],
            ),
          ]),
          File.Simple('external_base_this_call', [
            Expect.Simple('externalCallSelfAsBase', [], ['23', '0']),
          ]),
          File.Simple('otherReferenceTypes', [
            Expect.Simple('setProduct', ['1', '2', '3', '5', '7', '11', '13'], []),
            Expect.Simple('getS', [], ['1', '2', '3', '5']),
            Expect.Simple('getT', [], ['7', '11', '13']),
          ]),
        ]),
        // covers nested mappings
        new Dir('Dai', [
          new File(
            'dai',
            'Dai',
            [],
            [
              new Expect('mint', [
                ['mint', ['1', '10000', '0'], ['1'], '1'],
                ['getBalance', ['1'], ['10000', '0'], '1'],
              ]),
              new Expect('transfer', [
                ['transfer', ['2', '4000', '0'], ['1'], '1'],
                ['getBalance', ['2'], ['4000', '0'], '1'],
                ['getBalance', ['1'], ['6000', '0'], '1'],
              ]),
              new Expect('approve', [
                ['approve', ['3', '300', '0'], ['1'], '2'],
                ['getAllowance', ['2', '3'], ['300', '0'], '2'],
              ]),
              new Expect('transferFrom', [
                ['transferFrom', ['2', '1', '200', '0'], ['1'], '3'],
                ['getBalance', ['2'], ['3800', '0'], '1'],
                ['getBalance', ['1'], ['6200', '0'], '1'],
              ]),
              new Expect('allowance after transferFrom', [
                ['getAllowance', ['2', '3'], ['100', '0'], '2'],
              ]),
              new Expect('increase allowance', [
                ['increaseAllowance', ['3', '100', '0'], ['1'], '2'],
                ['getAllowance', ['2', '3'], ['200', '0'], '2'],
              ]),
              new Expect('decrease allowance', [
                ['decreaseAllowance', ['3', '131', '0'], ['1'], '2'],
                ['getAllowance', ['2', '3'], ['69', '0'], '2'],
              ]),
            ],
          ),
        ]),
        new Dir('delete', [
          File.Simple('address', [Expect.Simple('f', [], ['23', '0'])]),

          File.Simple('array_static', [
            new Expect('delete', [
              ['set', ['2', '0', '3', '4'], ['3', '4'], '0'],
              ['clearAt', ['2', '0'], [], '0'],
              ['get', ['2', '0'], ['0', '0'], '0'],
              ['set', ['0', '0', '1', '2'], ['1', '2'], '0'],
              ['clear', [], [], '0'],
              ['getLength', [], ['4', '0'], '0'],
              ['get', ['0', '0'], ['0', '0'], '0'],
              ['get', ['2', '0'], ['0', '0'], '0'],
            ]),
          ]),

          File.Simple('array_dynamic', [
            new Expect('delete', [
              ['initialize', [], [], '0'],
              ['clearAt', ['2', '0'], [], '0'],
              ['get', ['2', '0'], ['0'], '0'],
              ['get', ['0', '0'], ['8'], '0'],
              ['getLength', [], ['3', '0'], '0'],
              ['clear', [], [], '0'],
              ['getLength', [], ['0', '0'], '0'],
            ]),
          ]),

          File.Simple('boolean', [
            Expect.Simple('boolean', ['1'], ['0'], 'delete true = false'),
            Expect.Simple('boolean', ['0'], ['0'], 'delete false = false'),
            new Expect('delete state boolean', [
              ['flag', [], ['1'], '0'],
              ['deleteFlag', [], [], '0'],
              ['flag', [], ['0'], '0'],
            ]),
          ]),

          File.Simple('enum', [
            new Expect('delete', [
              ['set', ['3'], [], '0'],
              ['reset', [], [], '0'],
              ['get', [], ['0'], '0'],
            ]),
          ]),

          File.Simple('int', [
            new Expect('delete', [
              ['totalSupply', [], ['100000000000000', '0'], '0'],
              ['reset', [], [], '0'],
              ['totalSupply', [], ['0', '0'], '0'],
              ['addValue', ['25', '0'], ['25', '0'], '0'],
            ]),
          ]),

          File.Simple('struct', [
            new Expect('deleteWholeStruct', [
              ['setRadius', ['1', '2'], [], '0'],
              ['setPoint', ['3', '4', '5', '6'], [], '0'],
              ['getRadius', [], ['1', '2'], '0'],
              ['getPoint', [], ['3', '4', '5', '6'], '0'],
              ['deleteCircle', [], [], '0'],
              ['getRadius', [], ['0', '0'], '0'],
              ['getPoint', [], ['0', '0', '0', '0'], '0'],
            ]),
            new Expect('deleteInnerStruct', [
              ['setPoint', ['3', '4', '5', '6'], [], '0'],
              ['getPoint', [], ['3', '4', '5', '6'], '0'],
              ['deletePoint', [], [], '0'],
              ['getPoint', [], ['0', '0', '0', '0'], '0'],
            ]),
            new Expect('deleteScalarMember', [
              ['setRadius', ['1', '2'], [], '0'],
              ['getRadius', [], ['1', '2'], '0'],
              ['deleteRadius', [], [], '0'],
              ['getRadius', [], ['0', '0'], '0'],
            ]),
          ]),
        ]),
        new Dir('ElementaryTypeNames', [
          File.Simple('example', [Expect.Simple('ArrayFunc', [], ['69', '0'])]),
        ]),
        new Dir('ecrecover', [
          File.Simple('failing_ecrecover_invalid_input', [
            Expect.Simple('f', [], ['0']),
            Expect.Simple('g', [], ['0']),
            Expect.Simple('h', [], ['0']),
            Expect.Simple('i', [], ['0']),
            Expect.Simple('j', [], ['0']),
          ]),
          File.Simple('ecrecover_abiV2', [
            Expect.Simple(
              'a',
              [
                '234745004841049624363786949598178524444',
                '32925812571728971113564727197502457669',
                '28',
                '96147544071759159599371930037513463647',
                '153782390194236923625092705480893473134',
                '337845726153857016191633394724627039561',
                '317318150077682688293495167967147192469',
              ],
              ['0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b'],
            ),
          ]),
          File.Simple('ecrecover', [
            Expect.Simple(
              'a',
              [
                '234745004841049624363786949598178524444',
                '32925812571728971113564727197502457669',
                '28',
                '96147544071759159599371930037513463647',
                '153782390194236923625092705480893473134',
                '337845726153857016191633394724627039561',
                '317318150077682688293495167967147192469',
              ],
              ['0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b'],
            ),
          ]),
        ]),
        new Dir('enums', [
          File.Simple('boundCheck', [
            Expect.Simple('checkInt256', ['3', '0'], null),
            Expect.Simple('checkInt256', ['2', '0'], []),
            Expect.Simple('checkInt8', ['3'], null),
            Expect.Simple('checkInt8', ['2'], []),
          ]),
          File.Simple('singleEnum', [
            Expect.Simple('get', [], ['0']),
            new Expect('set', [
              ['set', ['254'], [], '0'],
              ['get', [], ['254'], '0'],
            ]),
            new Expect('callSetInternally', [
              ['callSetInternally', ['128'], [], '0'],
              ['get', [], ['128'], '0'],
            ]),
            new Expect('cancel', [
              ['cancel', [], [], '0'],
              ['get', [], ['255'], '0'],
            ]),
            new Expect('setWithContractName', [
              ['setWithContractName', [], [], '0'],
              ['get', [], ['1'], '0'],
            ]),
          ]),
          File.Simple('singleEnum7', [
            Expect.Simple('get', [], ['0']),
            new Expect('set', [
              ['set', ['257'], [], '0'],
              ['get', [], ['257'], '0'],
            ]),
            new Expect('callSetInternally', [
              ['callSetInternally', ['128'], [], '0'],
              ['get', [], ['128'], '0'],
            ]),
            new Expect('cancel', [
              ['cancel', [], [], '0'],
              ['get', [], ['259'], '0'],
            ]),
            new Expect('setWithContractName', [
              ['setWithContractName', [], [], '0'],
              ['get', [], ['1'], '0'],
            ]),
          ]),
          File.Simple('doubleEnum', [
            Expect.Simple('a', [], ['2']),
            Expect.Simple('getTopEnum', [], ['0']),
            new Expect('setB', [
              ['setB', [], [], '0'],
              ['a', [], ['1'], '0'],
              ['getTopEnum', [], ['4'], '0'],
            ]),
            new Expect('setBAgain', [
              ['setB', [], [], '0'],
              ['a', [], ['0'], '0'],
              ['getTopEnum', [], ['1'], '0'],
            ]),
          ]),
        ]),
        new Dir('enumtoint', [
          File.Simple('enumtointconversion', [Expect.Simple('test', [], ['1', '0'])]),
        ]),
        new Dir('ERC20', [
          File.Simple('ERC20', [
            new Expect('mint', [
              ['mint', ['1', '5', '0'], ['1'], '0'],
              ['balanceOf', ['1'], ['5', '0'], '0'],
            ]),
            new Expect('transferFrom', [
              ['mint', ['2', '600', '0'], ['1'], '0'],
              ['transferFrom', ['2', '3', '400', '0'], ['1'], '0'],
              ['balanceOf', ['2'], ['200', '0'], '0'],
              ['balanceOf', ['3'], ['400', '0'], '0'],
            ]),
            Expect.Simple('totalSupply', [], ['100000000000000', '0']),
            Expect.Simple('decimals', [], ['18']),
            new Expect('transfer', [
              ['mint', ['4', '600', '0'], ['1'], '0'],
              ['transfer', ['5', '400', '0'], ['1'], '4'],
              ['balanceOf', ['4'], ['200', '0'], '0'],
              ['balanceOf', ['5'], ['400', '0'], '0'],
            ]),
          ]),
        ]),
        new Dir('error_handling', [
          File.Simple('revert', [
            new Expect('conditionalRevert', [['couldFail', ['2'], ['4', '0'], '0']]),
            new Expect('conditionalRevert should fail', [
              ['couldFail', ['1'], null, '0', 'I am failing'],
            ]),
            new Expect('revertBothBranches', [
              ['definitelyFailsWithMsg', [], null, '0', 'I am failing'],
            ]),
          ]),
          File.Simple('assert', [
            new Expect('assert should pass', [['willPass', [], [], '0']]),
            new Expect('assert should fail', [['shouldFail', ['1'], null, '0']]),
          ]),
          File.Simple('require', [
            new Expect('require should pass', [['willPass', [], [], '0']]),
            new Expect('require should fail', [['shouldFail', [], null, '0', 'why is x not 2???']]),
          ]),
        ]),
        new Dir('events', [
          File.Simple('simple', [
            new Expect('add', [
              [
                'add',
                ['34', '0', '35', '0'],
                [],
                '0',
                undefined,
                [
                  {
                    data: ['69'],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('uintEvent', ['uint256']),
                      ),
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
            new Expect('array', [
              [
                'array',
                [],
                [],
                '0',
                undefined,
                [
                  {
                    data: ['32', '3', '2', '3', '5'],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('arrayEvent', ['uint256[]']),
                      ),
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
            new Expect('nestedArray', [
              [
                'nestedArray',
                [],
                [],
                '0',
                undefined,
                [
                  {
                    data: ['32', '2', '64', '192', '3', '2', '3', '5', '2', '7', '11'],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('nestedArrayEvent', ['uint256[][]']),
                      ),
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
            new Expect('structComplex', [
              [
                'structComplex',
                [],
                [],
                '0',
                undefined,
                [
                  {
                    data: ['32', '128', '7', '11', '13', '3', '2', '3', '5'],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('structEvent', [
                          ['uint8[]', 'uint256[3]'],
                        ]),
                      ),
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
          ]),
          File.Simple('indexed', [
            new Expect('add', [
              [
                'add',
                ['34', '0', '35', '0'],
                [],
                '0',
                undefined,
                [
                  {
                    data: [],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('uintEvent', ['uint256']),
                      ),
                      '69',
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
            new Expect('array', [
              [
                'array',
                [],
                [],
                '0',
                undefined,
                [
                  {
                    data: [],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('arrayEvent', ['uint256[]']),
                      ),
                      // 2,
                      // 3,
                      // 5,
                      `${BigInt(
                        `0x${createKeccakHash('keccak256')
                          .update(
                            (
                              (BigInt(2) << BigInt(32 * 8 * 2)) |
                              (BigInt(3) << BigInt(32 * 8 * 1)) |
                              BigInt(5)
                            )
                              .toString(16)
                              .padStart(32 * 3 * 2, '0'),
                            'hex',
                          )
                          .digest('hex')}`,
                      )}`,
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
            new Expect('arrayString', [
              [
                'arrayString',
                [],
                [],
                '0',
                undefined,
                [
                  {
                    data: [],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('arrayStringEvent', ['string[]']),
                      ),
                      `${BigInt(
                        `0x${createKeccakHash('keccak256')
                          .update(
                            (
                              (BigInt(0x61) << BigInt(32 * 8 * 3 - 8)) |
                              (BigInt(0x62) << BigInt(32 * 8 * 2 - 8)) |
                              (BigInt(0x63) << BigInt(32 * 8 * 1 - 8))
                            )
                              .toString(16)
                              .padEnd(32 * (8 / 4) * 3, '0'),
                            'hex',
                          )
                          .digest('hex')}`,
                      )}`,
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
            new Expect('nestedArray', [
              [
                'nestedArray',
                [],
                [],
                '0',
                undefined,
                [
                  {
                    data: [],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('nestedArrayEvent', ['uint256[][]']),
                      ),
                      // 2,
                      // 3,
                      // 5,
                      // 7,
                      // 11,
                      `${BigInt(
                        `0x${createKeccakHash('keccak256')
                          .update(
                            (
                              (BigInt(2) << BigInt(32 * 8 * 4)) |
                              (BigInt(3) << BigInt(32 * 8 * 3)) |
                              (BigInt(5) << BigInt(32 * 8 * 2)) |
                              (BigInt(7) << BigInt(32 * 8 * 1)) |
                              BigInt(11)
                            )
                              .toString(16)
                              .padStart(32 * 5 * 2, '0'),
                            'hex',
                          )
                          .digest('hex')}`,
                      )}`,
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
            new Expect('structComplex', [
              [
                'structComplex',
                [],
                [],
                '0',
                undefined,
                [
                  {
                    data: [],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('structEvent', [
                          ['uint8[]', 'uint256[3]'],
                        ]),
                      ),
                      // '2',
                      // '3',
                      // '5',
                      // '7',
                      // '11',
                      // '13',
                      `${BigInt(
                        `0x${createKeccakHash('keccak256')
                          .update(
                            (
                              (BigInt(2) << BigInt(32 * 8 * 5)) |
                              (BigInt(3) << BigInt(32 * 8 * 4)) |
                              (BigInt(5) << BigInt(32 * 8 * 3)) |
                              (BigInt(7) << BigInt(32 * 8 * 2)) |
                              (BigInt(11) << BigInt(32 * 8 * 1)) |
                              BigInt(13)
                            )
                              .toString(16)
                              .padStart(32 * 6 * 2, '0'),
                            'hex',
                          )
                          .digest('hex')}`,
                      )}`,
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
          ]),
          File.Simple('misc', [
            new Expect('allString', [
              [
                'allString',
                ['2', '65', '66', '2', '66', '67'],
                [],
                '0',
                undefined,
                [
                  {
                    data: [
                      '32',
                      '2',
                      `${(BigInt(0x41) << BigInt(248)) | (BigInt(0x42) << BigInt(240))}`,
                      '32',
                      '2',
                      `${(BigInt(0x42) << BigInt(248)) | (BigInt(0x43) << BigInt(240))}`,
                    ],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('allStringEvent', ['string', 'string']),
                      ),
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
            new Expect('allStringMisc', [
              [
                'allStringMisc',
                ['2', '65', '66', '2', '66', '67'],
                [],
                '0',
                undefined,
                [
                  {
                    data: [
                      '32',
                      '2',
                      `${(BigInt(0x42) << BigInt(248)) | (BigInt(0x43) << BigInt(240))}`,
                    ],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('allStringMiscEvent', [
                          'string',
                          'string',
                        ]),
                      ),
                      `${BigInt(
                        `0x${createKeccakHash('keccak256')
                          .update(((BigInt(0x41) << BigInt(8)) | BigInt(0x42)).toString(16), 'hex')
                          .digest('hex')}`,
                      )}`,
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
            new Expect('allUint', [
              [
                'allUint',
                ['1', '0', '2', '0'],
                [],
                '0',
                undefined,
                [
                  {
                    data: ['1'],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('allUintMiscEvent', [
                          'uint256',
                          'uint256',
                        ]),
                      ),
                      '2',
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
            new Expect('allIndexed', [
              [
                'allIndexed',
                ['1', '0', '2', '0'],
                [],
                '0',
                undefined,
                [
                  {
                    data: [],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('allIndexedEvent', [
                          'uint256',
                          'uint256',
                        ]),
                      ),
                      '1',
                      '2',
                    ],
                    order: 0,
                  },
                ],
              ],
            ]),
            new Expect('allEventsAtOnce', [
              [
                'allEventsAtOnce',
                [],
                [],
                '0',
                undefined,
                [
                  {
                    data: [
                      '32',
                      '1',
                      `${BigInt(0x61) << BigInt(248)}`,
                      '32',
                      '1',
                      `${BigInt(0x62) << BigInt(248)}`,
                    ],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('allStringEvent', ['string', 'string']),
                      ),
                    ],
                    order: 0,
                  },
                  {
                    data: ['32', '1', `${BigInt(0x62) << BigInt(248)}`],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('allStringMiscEvent', [
                          'string',
                          'string',
                        ]),
                      ),
                      `${BigInt(
                        `0x${createKeccakHash('keccak256')
                          .update(BigInt(0x61).toString(16), 'hex')
                          .digest('hex')}`,
                      )}`,
                    ],
                    order: 1,
                  },
                  {
                    data: ['1'],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('allUintMiscEvent', [
                          'uint256',
                          'uint256',
                        ]),
                      ),
                      '2',
                    ],
                    order: 2,
                  },
                  {
                    data: [],
                    keys: [
                      cairoUint256toHex(
                        warpEventCanonicalSignaturehash256('allIndexedEvent', [
                          'uint256',
                          'uint256',
                        ]),
                      ),
                      '1',
                      '2',
                    ],
                    order: 3,
                  },
                  {
                    data: ['1'],
                    keys: ['2'],
                    order: 4,
                  },
                ],
              ],
            ]),
          ]),
        ]),
        new Dir('expressions', [
          File.Simple('assign_split', [
            Expect.Simple('plusEqual', [], ['60', '0']),
            Expect.Simple('starEqual', [], ['20', '0']),
            Expect.Simple('equal', [], ['4', '0']),
            Expect.Simple('plusEqualTotal', ['10', '0'], ['75', '0']),
            Expect.Simple('starEqualTotal', ['5', '0'], ['30', '0']),
            Expect.Simple('equalTotal', ['10', '0'], ['16', '0']),
          ]),
          File.Simple('assignments_as_rvalues', [
            Expect.Simple('addingLocalAssignments', ['5', '11'], ['16']),
            Expect.Simple('addingStorageAssignments', ['5', '11'], ['16', '0']),
            Expect.Simple('assigningLocalStoragePointers', [], ['42', '0', '0', '21']),
          ]),
          File.Simple('ineffectual', [Expect.Simple('test', ['1'], ['1'])]),
          File.Simple('literals', [
            Expect.Simple('unsignedNarrow', [], ['255', '251', '0', '0']),
            Expect.Simple('signedNarrow', [], ['127', '120', '0', '156', '128']),
            Expect.Simple(
              'unsignedWide',
              [],
              [
                '340282366920938463463374607431768211455',
                '340282366920938463463374607431768211455',
                '10',
                '4722366482869645213696',
                '251',
                '0',
                '0',
                '0',
                '0',
                '0',
              ],
            ),
            Expect.Simple(
              'signedWide',
              [],
              [
                '340282366920938463463374607431768211455',
                '170141183460469231731687303715884105727',
                '10',
                '4722366482869645213696',
                '120',
                '0',
                '0',
                '0',
                '340282366920938463463374607431768211356',
                '340282366920938463463374607431768211455',
                '5',
                '340282366920938463463370103832140840960',
                '0',
                '170141183460469231731687303715884105728',
              ],
            ),
          ]),
          File.Simple('rationalLiterals', [
            Expect.Simple('equalValue', [], ['255']),
            Expect.Simple('greaterThan', [], ['1']),
            Expect.Simple('add', [], ['8']),
            Expect.Simple('subtract', [], ['3']),
            Expect.Simple('multiply', [], ['25']),
            Expect.Simple('divideBy', [], ['2']),
            Expect.Simple('exp', [], ['64']),
            Expect.Simple('mod', [], ['2']),
            Expect.Simple('shiftLeft', [], ['4']),
            Expect.Simple('shiftRight', [], ['1']),
            Expect.Simple('bitwiseNegate', [], ['253']),
            Expect.Simple('toInteger', [], ['3']),
            Expect.Simple('bitwiseAnd', [], ['2']),
            Expect.Simple('bitwiseOr', [], ['22']),
            Expect.Simple('bitwiseXor', [], ['20']),
          ]),
          File.Simple('short_circuit', [
            Expect.Simple('and_sc', [], ['56', '0']),
            Expect.Simple('and_no_sc', [], ['1', '0']),
            Expect.Simple('or_sc', [], ['56', '0']),
            Expect.Simple('or_no_sc', [], ['15', '0']),
          ]),
          File.Simple('tupleEdgeCases', [Expect.Simple('f', ['0', '0'], ['0', '0'])]),
          File.Simple('tupleOfInlineArrays', [Expect.Simple('g', [], ['21'])]),
        ]),
        new Dir('externalStructs', [
          File.Simple('externalStructs', [
            Expect.Simple('test1', [], ['5', '0']),
            Expect.Simple('test2', ['4', '0'], ['4', '0']),
            Expect.Simple('test3', ['3', '0', '8', '0'], ['3', '0', '8', '0']),
          ]),
        ]),
        new Dir('external_function_inputs', [
          File.Simple('dynamic_array_return_index', [
            new Expect(
              'testing that dynamic memory array as calldata are tranformed and returned correctly',
              [
                [
                  'dArrayCallDataExternal',
                  [
                    '3',
                    '1',
                    '11',
                    '111',
                    '4',
                    '2',
                    '20',
                    '200',
                    '2000',
                    '3',
                    '3',
                    '30',
                    '33',
                    '330',
                    '333',
                    '3330',
                  ],
                  ['644', '3330'],
                  '0',
                ],
              ],
            ),
            new Expect(
              'testing that dynamic memory array is written to memory and index is returned in external function',
              [
                [
                  'dArrayExternal',
                  ['8', '10', '11', '12', '13', '14', '15', '16', '17', '2', '5', '7'],
                  ['20'],
                  '0',
                ],
              ],
            ),
            new Expect(
              'testing that dynamic memory array is written to memory and index is returned in public function.',
              [['dArrayPublic', ['4', '1', '2', '3', '4'], ['1'], '0']],
            ),
            new Expect(
              'testing that multiple inputs containing dynamic arrays that are handeled correctly to external functions',
              [
                [
                  'dArrayMultipleInputsExternal',
                  ['2', '10', '11', '12', '2', '20', '21'],
                  ['31'],
                  '0',
                ],
              ],
            ),
            new Expect(
              'testing that multipe inputs containing dynamic arrays that are handeled correctly when passed to public functions',
              [
                [
                  'dArrayMultipleInputsPublic',
                  ['2', '10', '11', '12', '2', '20', '21'],
                  ['31'],
                  '0',
                ],
              ],
            ),
            new Expect('testing uint256 inputs are loaded into and read from memory correctly.', [
              ['dArray256External', ['3', '0', '1', '1', '2', '2', '3'], ['1', '2'], '0'],
            ]),
            new Expect(
              'testing uint256 inputs are loaded into and read from memory correctly, when there are multiple inputs.',
              [
                [
                  'dArray256MultipleInputs',
                  [
                    '3',
                    '10',
                    '11',
                    '100',
                    '111',
                    '1000',
                    '1111',
                    '3',
                    '2',
                    '20',
                    '200',
                    '3',
                    '30',
                    '33',
                    '300',
                    '333',
                    '3000',
                    '3333',
                  ],
                  ['4020', '4444'],
                  '0',
                ],
              ],
            ),
          ]),
          File.Simple('dynarray_array_conversion', [
            new Expect(
              'testing that dynamic arrays of (nested) static arrays have their length encoded correctly when returned from memory',
              [
                [
                  'inAndOutLength',
                  [
                    '2',
                    ...[...['1', '2', '3', '4'], ...['5', '6', '7', '8']],
                    ...[...['9', '10', '11', '12'], ...['13', '14', '15', '16']],
                  ],
                  ['2', '0', '2', '0'],
                  '0',
                ],
              ],
            ),
            new Expect(
              'testing that dynamic arrays of (nested) static arrays can be passed in and out of functions and memory',
              [
                [
                  'inAndOut',
                  [
                    '2',
                    ...[...['1', '2', '3', '4'], ...['5', '6', '7', '8']],
                    ...[...['9', '10', '11', '12'], ...['13', '14', '15', '16']],
                  ],
                  [
                    '2',
                    ...[...['1', '2', '3', '4'], ...['5', '6', '7', '8']],
                    ...[...['9', '10', '11', '12'], ...['13', '14', '15', '16']],
                  ],
                  '0',
                ],
              ],
            ),
          ]),
          File.Simple('struct_return_member', [
            new Expect('testing that memory struct is written to memory and member is returned', [
              ['testReturnMember', ['1', '2'], ['1'], '0'],
            ]),
            new Expect(
              'testing that multiple memory structs are written to memory and members returned',
              [['testMultipleStructsMembers', ['1', '2', '0', '8', '10'], ['11'], '0']],
            ),
            new Expect(
              'testing that multiple memory structs are written to memory and members returned and passed correctly between external and internal functions',
              [
                [
                  'testMultipleStructsPublicFunctionMember',
                  ['1', '2', '0', '8', '10'],
                  ['11'],
                  '0',
                ],
              ],
            ),
          ]),
          File.Simple('struct_return_struct', [
            new Expect(
              'testing that memory struct is written to memory and full struct is returned from external function',
              [['testReturnStruct', ['1', '2'], ['1', '2'], '0']],
            ),
            new Expect(
              'testing that memory struct is written to memory and full struct is returned from pubic function',
              [['testReturnStructPublic', ['1', '2'], ['1', '2'], '0']],
            ),
          ]),
          File.Simple('static_array_return_index', [
            new Expect(
              'testing a static array of ints can be passed into an external function and written to memory and index returned.',
              [['testIntExternal', ['1', '2', '3'], ['3'], '0']],
            ),
            new Expect(
              'testing a static array of ints can be passed into a public function and written to memory and index returned.',
              [['testIntPublic', ['1', '2', '3'], ['3'], '0']],
            ),
            new Expect(
              'testing a static array of structs can be passed into an external function and written to memory and index returned.',
              [
                [
                  'testStructExternal',
                  ['1', '2', '0 ', '3', '4', '0', '5', '6', '0'],
                  ['5', '6', '0'],
                  '0',
                ],
              ],
            ),
            new Expect(
              'testing a static array of structs can be passed into a public function and written to memory and index returned.',
              [['testStructPublic', ['1', '2', '0 ', '3', '4', '0', '5', '6', '0'], ['5'], '0']],
            ),
            new Expect(
              'testing when multiple inputs all of them are written into memory and read correctly.',
              [
                [
                  'testMultiplePublic',
                  ['1', '2', '0 ', '3', '4', '0', '5', '6', '0', '111', '10', '11', '12'],
                  ['13'],
                  '0',
                ],
              ],
            ),
          ]),
        ]),
        new Dir('external_input_checks', [
          File.Simple('address', [
            new Expect('testing an address in bounds does not throw', [
              [
                'addressTest',
                ['3618502788666131106986593281521497120414687020801267626233049500247285301247'],
                ['3618502788666131106986593281521497120414687020801267626233049500247285301247'],
                '0',
              ],
            ]),
            new Expect('testing an address in bounds does', [
              [
                'addressTest',
                ['3618502788666131106986593281521497120414687020801267626233049500247285301248'],
                null,
                '0',
              ],
            ]),
          ]),
          File.Simple('dynArray', [
            new Expect('testing a dynArray of int values, no values out of bounds', [
              ['elemInt', ['4', '10', '20', '30', '40'], ['10'], '0'],
            ]),
            new Expect('testing a dynArray of int values, with values out of bounds', [
              [
                'elemInt',
                ['4', '10', '20', '30', '400'],
                null,
                '0',
                'Error: value out-of-bounds. Value must be less than 2**8',
              ],
            ]),
            new Expect('testing a dynArray of struct values, with values out of bounds', [
              [
                'elemStruct',
                ['2', '20', '21', '50', '30', '40', '400'],
                null,
                '0',
                'Error: value out-of-bounds. Value must be less than 2**8',
              ],
            ]),
            new Expect('testing a dynArray of struct values, with no values out of bounds', [
              [
                'elemStruct',
                ['3', '10', '20', '30', '11', '12', '13', '20', '21', '40'],
                ['10', '20', '30'],
                '0',
                'Error: value out-of-bounds. Value must be less than 2**8',
              ],
            ]),
          ]),
          File.Simple('int', [
            new Expect('testing solidity pure external signed int8 lower bound', [
              ['testInt8', ['0'], ['0'], '0'],
            ]),
            new Expect('testing solidity pure external signed int8 upper bound', [
              ['testInt8', ['255'], ['255'], '0'],
            ]),
            new Expect('testing solidity pure external signed int8 overflow', [
              [
                'testInt8',
                ['256'],
                null,
                '0',
                'Error: value out-of-bounds. Value must be less than 2**8',
              ],
            ]),
            new Expect('testing solidity pure exernal unsigned int32 overflow', [
              [
                'testUint32',
                ['4294967296'],
                null,
                '0',
                'Error: value out-of-bounds. Value must be less than 2**32',
              ],
            ]),
            new Expect('testing solidity unsigned view external int32 in upper bound', [
              ['testUint32', ['4294967295'], ['4294967295'], '0'],
            ]),
            new Expect('testing solidity signed int248 upper bound', [
              [
                'testInt248',
                ['452312848583266388373324160190187140051835877600158453279131187530910662655'],
                ['452312848583266388373324160190187140051835877600158453279131187530910662655'],
                '0',
              ],
            ]),
            new Expect('testing soldity unsigned int248 overflow', [
              [
                'testInt248',
                ['452312848583266388373324160190187140051835877600158453279131187530910662656'],
                null,
                '0',
              ],
            ]),
            new Expect('testing solidity unsigned int256 in bounds', [
              [
                'testInt256',
                ['0', '340282366920938463463374607431768211455'],
                ['0', '340282366920938463463374607431768211455'],
                '0',
              ],
            ]),
            new Expect('testing soldity unsigned int256 in bounds', [
              [
                'testInt256',
                ['340282366920938463463374607431768211455', '0'],
                ['340282366920938463463374607431768211455', '0'],
                '0',
              ],
            ]),
            new Expect('testing solidity unsigned int256 lower out of bounds', [
              [
                'testInt256',
                ['0', '340282366920938463463374607431768211456'],
                null,
                '0',
                'Error: value out-of-bounds. Values passed to high and low members of Uint256 must be less than 2**128.',
              ],
            ]),
            new Expect('testing solidity unsigned int256 high out of bounds', [
              [
                'testInt256',
                ['340282366920938463463374607431768211456', '0'],
                null,
                '0',
                'Error: value out-of-bounds. Values passed to high and low members of Uint256 must be less than 2**128.',
              ],
            ]),
            new Expect('testing solidity unsigned int256 lower and high out of bounds', [
              [
                'testInt256',
                [
                  '340282366920938463463374607431768211456',
                  '340282366920938463463374607431768211456',
                ],
                null,
                '0',
                'Error: value out-of-bounds. Values passed to high and low members of Uint256 must be less than 2**128.',
              ],
            ]),
            new Expect('testing that more than 1 assert is placed when there are two inputs', [
              [
                'testInt256Int8',
                ['18', '256'],
                null,
                '0',
                'Error: value out-of-bounds. Value must be less than 2**8.',
              ],
            ]),
            new Expect('testing that more than 1 assert is placed when there are two inputs', [
              [
                'testInt256Int8',
                ['65536', '255'],
                null,
                '0',
                'Error: value out-of-bounds. Value must be less than 2**16.',
              ],
            ]),
          ]),
          File.Simple('enum', [
            new Expect('testing that enum in range does not throw error', [
              ['externalFunction', ['0'], ['0'], '0'],
            ]),
            new Expect('testing that enum in range does not throw error', [
              ['externalFunction', ['2'], ['2'], '0'],
            ]),
            new Expect('testing public function with enum out of range throws error', [
              [
                'externalFunction',
                ['3'],
                null,
                '0',
                'Error: value out-of-bounds. Values passed to must be in enum range (0, 2].',
              ],
            ]),
            new Expect(
              'testing external function with more than 1 input has multiple asserts are placed pt. 1',
              [
                [
                  'externalFunction2Inputs',
                  ['2', '4'],
                  null,
                  '0',
                  'Error: value out-of-bounds. Values passed to must be in enum range (0, 3].',
                ],
              ],
            ),
            new Expect(
              'testing external function with more than 1 input has multiple asserts are placed pt. 2',
              [
                [
                  'externalFunction2Inputs',
                  ['3', '3'],
                  null,
                  '0',
                  'Error: value out-of-bounds. Values passed to must be in enum range (0, 2].',
                ],
              ],
            ),
          ]),
          File.Simple('staticArray', [
            new Expect('testing an array of ints with no values out of bounds', [
              ['elemInt', ['10', '20', '30', '40', '50'], ['10'], '0'],
            ]),
            new Expect('testing an array of ints with no values out of bounds', [
              [
                'elemInt',
                ['10', '20', '30', '40', '300'],
                null,
                '0',
                'Error: value out-of-bounds. Value must be less than 2**8',
              ],
            ]),
            new Expect('testing an array of structs with no values out of bounds', [
              [
                'elemStruct',
                ['10', '0', '11', '20', '0', '22', '30', '0', '33'],
                ['10', '0', '11'],
                '0',
              ],
            ]),
            new Expect('testing an array of structs with values out of bounds', [
              [
                'elemStruct',
                ['10', '0', '11', '20', '0', '22', '30', '0', '330'],
                null,
                '0',
                'Error: value out-of-bounds. Value must be less than 2**8',
              ],
            ]),
            new Expect('testing an array of static arrays with no values out of bounds', [
              [
                'elemStruct',
                ['10', '11', '12', '20', '21', '22', '30', '31', '33'],
                ['10', '11', '12'],
                '0',
              ],
            ]),
            new Expect('testing an array of structs with values out of bounds', [
              [
                'elemStruct',
                ['10', '11', '12', '20', '21', '300', '30', '31', '33'],
                null,
                '0',
                'Error: value out-of-bounds. Value must be less than 2**8',
              ],
            ]),
          ]),
          File.Simple('struct', [
            new Expect('testing a struct of with int values, no values out of bounds', [
              ['memberInts', ['10', '20', '30'], ['30'], '0'],
            ]),
            new Expect('testing a struct of with int values, values out of bounds', [
              [
                'memberInts',
                ['10', '20', '300'],
                null,
                '0',
                'Error: value out-of-bounds. Value must be less than 2**8',
              ],
            ]),
            new Expect('testing a struct of with int values, no values out of bounds', [
              ['memberStructs', ['10', '10', '20', '30'], ['10'], '0'],
            ]),
            new Expect('testing a struct of with int values, values out of bounds', [
              [
                'memberStructs',
                ['10', '10', '20', '300'],
                null,
                '0',
                'Error: value out-of-bounds. Value must be less than 2**8',
              ],
            ]),
            new Expect('testing a struct of with int values, no values out of bounds', [
              ['memberStaticArray', ['10', '10', '20', '30'], ['10'], '0'],
            ]),
            new Expect('testing a struct of with int values, values out of bounds', [
              [
                'memberStaticArray',
                ['10', '10', '20', '300'],
                null,
                '0',
                'Error: value out-of-bounds. Value must be less than 2**8',
              ],
            ]),
          ]),
          File.Simple('bool', [
            new Expect('testing that false input does not throw error', [
              ['externalFunction', ['0'], ['0'], '0'],
            ]),
            new Expect('testing that true input does not throw error', [
              ['externalFunction', ['1'], ['1'], '0'],
            ]),
            new Expect('testing that external function with out of bounds input throws error', [
              [
                'externalFunction',
                ['2'],
                null,
                '0',
                'Error: value out-of-bounds. Boolean values passed to must be in range (0, 1].',
              ],
            ]),
            new Expect('testing external function and more than 1 input asserts are placed pt. 1', [
              [
                'externalFunction2Inputs',
                ['2', '0'],
                null,
                '0',
                'Error: value out-of-bounds. Boolean values passed to must be in range (0, 1].',
              ],
            ]),
            new Expect('testing external function and more than 1 input asserts are placed pt. 2', [
              [
                'externalFunction2Inputs',
                ['0', '2'],
                null,
                '0',
                'Error: value out-of-bounds. Boolean values passed to must be in range (0, 1].',
              ],
            ]),
          ]),
        ]),
        new Dir('fallback', [
          new File(
            'fallback_overriden',
            'A',
            ['100', '0'],
            [
              new Expect('modified', [
                ['unexistent', [], null, '0', 'x can not exceed the amount of 100'],
                ['sub', ['2', '0'], [], '0'],
                ['x', [], ['98', '0'], '0'],
                ['unexistent', [], [], '0'],
                ['x', [], ['99', '0'], '0'],
              ]),
            ],
          ),
          new File(
            'fallback_overriden',
            'B',
            ['100', '0'],
            [
              new Expect('overriden', [
                ['unexistent', [], [], '0'],
                ['x', [], ['110', '0'], '0'],
              ]),
            ],
          ),
          new File(
            'fallback_overriden',
            'C',
            ['100', '0'],
            [
              new Expect('inherited', [
                ['unexistent', [], null, '0', 'x can not exceed the amount of 100'],
              ]),
            ],
          ),
          File.Simple('fallback_return', [
            Expect.Simple('unexistent', [], []),
            Expect.Simple('x', [], ['1', '0']),
            Expect.Simple('unexistent', [], []),
            Expect.Simple('x', [], ['2', '0']),
            Expect.Simple('unexistent', [], []),
            Expect.Simple('x', [], ['2', '0']),
            Expect.Simple('unexistent', [], []),
            Expect.Simple('x', [], ['2', '0']),
          ]),
          new File(
            'inherited',
            'B',
            [],
            [
              Expect.Simple('getData', [], ['0', '0']),
              Expect.Simple('unexistent', ['42'], []),
              Expect.Simple('getData', [], ['1', '0']),
            ],
          ),
          File.Simple('simple', [
            Expect.Simple('x', [], ['0', '0']),
            Expect.Simple('unexistent', [], []),
            Expect.Simple('x', [], ['1', '0']),
            Expect.Simple('unexistent', ['3', '4', '5'], []),
            Expect.Simple('x', [], ['2', '0']),
            Expect.Simple('unexistent', ['10', '4', '5', '20'], []),
            Expect.Simple('x', [], ['3', '0']),
          ]),
        ]),
        new Dir('if', [
          File.Simple('complexTypeInCondition', [
            Expect.Simple('arr1DInIfExpression', ['5'], ['6']),
            Expect.Simple('map1DInIfExpression', ['5'], ['6']),
            Expect.Simple('arr2DInIfExpression', ['5'], ['6']),
            Expect.Simple('map2DInIfExpression', ['5'], ['6']),
            Expect.Simple('nestedExpressions', ['5'], ['5']),
          ]),
          File.Simple('localVariables', [
            Expect.Simple('ifNoElse', ['1'], ['1'], 'true branch'),
            Expect.Simple('ifNoElse', ['0'], ['2'], 'false branch'),
            Expect.Simple('ifWithElse', ['1'], ['1'], 'true branch'),
            Expect.Simple('ifWithElse', ['0'], ['3'], 'false branch'),
          ]),
          File.Simple('returns', [
            Expect.Simple('ifNoElse', ['1'], ['1'], 'true branch'),
            Expect.Simple('ifNoElse', ['0'], ['2'], 'false branch'),
            Expect.Simple('ifWithElse', ['1'], ['1'], 'true branch'),
            Expect.Simple('ifWithElse', ['0'], ['2'], 'false branch'),
            Expect.Simple('unreachableCode', ['1'], ['1'], 'true branch'),
            Expect.Simple('unreachableCode', ['0'], ['2'], 'false branch'),
          ]),
          File.Simple('nesting', [
            Expect.Simple('nestedIfs', ['1', '1'], ['3', '1'], 'true/true'),
            Expect.Simple('nestedIfs', ['1', '0'], ['2', '1'], 'true/false'),
            Expect.Simple('nestedIfs', ['0', '1'], ['1', '0'], 'false/true'),
            Expect.Simple('nestedIfs', ['0', '0'], ['0', '0'], 'false/false'),
            Expect.Simple('uncheckedBlock', ['1'], ['255'], 'true branch'),
            Expect.Simple('uncheckedBlock', ['0'], ['254'], 'true branch'),
            Expect.Simple('loops', ['1'], ['1'], 'true branch'),
            Expect.Simple('loops', ['0'], ['0'], 'false branch'),
          ]),
          File.Simple('noBlocks', [
            Expect.Simple('test', ['0', '0'], ['0b00']),
            Expect.Simple('test', ['0', '1'], ['0b01']),
            Expect.Simple('test', ['1', '0'], ['0b10']),
            Expect.Simple('test', ['1', '1'], ['0b11']),
          ]),
        ]),
        new Dir('imports', [
          File.Simple('importto', [Expect.Simple('checkImports', ['3', '2'], ['1'])]),
        ]),
        new Dir('inheritance', [
          new Dir('constructors', [
            new File(
              'abstractContract',
              'C',
              ['250', '0'],
              [Expect.Simple('f', ['412', '0'], ['662', '0'])],
            ),
            new File(
              'constructors',
              'C',
              [],
              [
                Expect.Simple('a', [], ['9', '0']),
                Expect.Simple('b', [], ['14', '0']),
                Expect.Simple('c', [], ['13', '0']),
                Expect.Simple('d', [], ['4', '0']),
              ],
            ),
            new File(
              'modifiedConstructor',
              'A',
              ['500', '0'],
              [Expect.Simple('a', [], ['500', '0'])],
            ),
            new File(
              'modifiedConstructor',
              'B',
              ['500', '0'],
              [Expect.Simple('a', [], ['0', '0'])],
            ),
            new File(
              'order_of_eval',
              'X',
              [],
              [Expect.Simple('g', [], ['4', '4', '0', '2', '0', '1', '0', '3', '0'])],
            ),
          ]),
          new Dir('functions', [
            new File('base', 'Base', [], [Expect.Simple('g', ['3'], ['3'])]),
            new File('mid', 'Mid', [], [Expect.Simple('g', ['10'], ['20'])]),
            new File('derived', 'Derived', [], [Expect.Simple('f', ['5'], ['15'])]),
            new File(
              'functionOverriding',
              'C',
              [],
              [Expect.Simple('f', [], ['30', '0']), Expect.Simple('g', [], ['30', '0'])],
            ),
          ]),
          new Dir('modifiers', [
            new File(
              'callBaseModifier',
              'B',
              [],
              [
                Expect.Simple('f', ['5', '0'], ['2', '0'], 'call base modifier and success'),
                new Expect('failedModifier', [
                  ['f', ['15', '0'], null, '0', 'Failed call to base modifier'],
                ]),
                Expect.Simple('g', ['20', '0'], ['2', '0'], 'call modifier overrider'),
              ],
            ),
            new File(
              'inheritedModifiedFunction',
              'B',
              [],
              [Expect.Simple('f', ['20', '0'], ['20', '0'])],
            ),
            new File(
              'modifierInheritance',
              'D',
              [],
              [
                new Expect('modifier', [
                  ['withdraw', ['5000', '0'], ['95000', '0'], '0'],
                  ['lock', [], [], '0'],
                  ['withdraw', ['280', '0'], null, '0', 'Can not call this function when locked'],
                  ['clear', [], [], '0'],
                  ['withdraw', ['280', '0'], ['0', '0'], '0'],
                ]),
              ],
            ),
            new File(
              'modifierOverriding',
              'C',
              [],
              [
                new Expect('modifier', [
                  [
                    'withdraw',
                    ['10000', '0'],
                    null,
                    '0',
                    'Value to withdraw must be smaller than the current balance',
                  ],
                  [
                    'withdraw',
                    ['100', '0'],
                    null,
                    '0',
                    'Value to withdraw must be bigger than the limit',
                  ],
                  ['withdraw', ['5500', '0'], null, '0', 'Balance must be bigger than 1000'],
                  ['withdraw', ['5000', '0'], ['1000', '0'], '0'],
                  [
                    'withdraw',
                    ['100', '0'],
                    null,
                    '0',
                    'Value to withdraw must be bigger than the limit',
                  ],
                ]),
              ],
            ),
          ]),
          new Dir('structs', [
            File.Simple('derived', [
              Expect.Simple('identity', ['1', '5'], ['1', '5']),
              Expect.Simple('swap', ['1', '5'], ['5', '1']),
              Expect.Simple('set', ['1', '5'], ['1']),
            ]),
          ]),
          new Dir('super_calls', [
            new File('order', 'Final', [], [Expect.Simple('f', [], ['2', '0'])]),
            new File('super_in_constructor', 'D', [], [Expect.Simple('f', [], ['15', '0'])]),
            new File(
              'super_in_modifier',
              'Final',
              [],
              [Expect.Simple('f', ['75', '0'], ['50', '0'])],
            ),
          ]),
          new Dir('variables', [
            new File('derived', 'Derived', [], [Expect.Simple('f', [], ['36', '0', '24', '0'])]),
          ]),
        ]),
        new Dir('largeSizeArray', [
          File.Simple('large_size_array', [
            Expect.Simple('getLength', [], [...toCairoUint256(10000000000000000000)]),
            Expect.Simple(
              'setValue',
              [...toCairoUint256(10000000), ...toCairoUint256(456)],
              [...toCairoUint256(456)],
            ),
          ]),
        ]),
        new Dir('libraries', [
          File.Simple('constantInitialization', [Expect.Simple('f', [], ['20001'])]),
          File.Simple('using_for', [
            Expect.Simple('libFunction', ['1'], ['0'], 'uint256/true branch'),
          ]),
          File.Simple('importLibs', [Expect.Simple('addSub', ['5', '4'], ['9', '1'])]),
          File.Simple('LibInLib', [Expect.Simple('mulDiv', ['5', '2'], ['10', '2', '1'])]),
          new File('libraries_in_inheritance', 'C', [], [Expect.Simple('g', [], ['1', '0'])]),
          File.Simple('library_call_in_homestead', [
            new Expect('f', [['f', [], [], '234']]),
            new Expect('sender', [['sender', [], ['234'], '465']]),
          ]),
          File.Simple('libStructs', [
            Expect.Simple(
              'f',
              [],
              ['7', '0', '8', '0'],
              'test using struct defined in library in other contract',
            ),
          ]),
          new Dir('freeFunctionsLib', [
            File.Simple('direct_and_indirect', [Expect.Simple('freeFuncLib', ['2'], ['4'])]),
            File.Simple('sameName', [Expect.Simple('freeFuncLib', ['1'], ['0'])]),
          ]),
        ]),
        new Dir('loops', [
          File.Simple('loops', [
            Expect.Simple('forLoop', ['3'], ['8']),
            Expect.Simple('whileLoop', ['10'], ['10']),
            Expect.Simple('breaks', ['5'], ['5']),
            Expect.Simple('continues', ['4'], ['24']),
            Expect.Simple('doWhile', ['0', '4'], ['5']),
            Expect.Simple('doWhile', ['7', '6'], ['8']),
            Expect.Simple('doWhile_continue', ['1'], ['1']),
            Expect.Simple('doWhile_continue_2', [], ['42', '0']),
            Expect.Simple('doWhile_return', ['4'], ['2']),
            Expect.Simple('doWhile_break', ['0', '2'], ['2']),
          ]),
        ]),
        new Dir('mangled_identifiers', [
          File.Simple('free_function', [
            Expect.Simple('f', [], ['20']),
            Expect.Simple('s', [], ['10']),
          ]),
        ]),
        new Dir('mapping', [
          File.Simple('stringKeyMapping', [
            Expect.Simple('cdString', ['1', '97'], ['5']),
            Expect.Simple('memStringLiteral', [], ['10']),
            Expect.Simple('memStringVariable', [], ['15']),
            Expect.Simple('storageString', [], ['20']),
            Expect.Simple('emptySlot', [], ['0']),
            Expect.Simple('nestedMapCalls', [], ['25']),
            Expect.Simple('sameStringKey', [], ['1']),
            Expect.Simple('stringValueChange', [], ['1']),
          ]),
          File.Simple('bytesKeyMapping', [
            Expect.Simple('cdBytes', ['1', '97'], ['5']),
            Expect.Simple('memBytesLiteral', [], ['10']),
            Expect.Simple('memBytesVariable', [], ['15']),
            Expect.Simple('storageBytes', [], ['20']),
            Expect.Simple('emptySlot', [], ['0']),
            Expect.Simple('nestedMapCalls', [], ['25']),
            Expect.Simple('sameBytesKey', [], ['1']),
            Expect.Simple('bytesValueChange', [], ['1']),
          ]),
        ]),
        new Dir('maths', [
          File.Simple('addition', [
            Expect.Simple('addition8safe', ['3', '20'], ['23']),
            Expect.Simple('addition8safe', ['200', '180'], null, 'overflow'),
            Expect.Simple('addition8unsafe', ['3', '20'], ['23']),
            Expect.Simple('addition8unsafe', ['200', '180'], ['124'], 'overflow'),
            Expect.Simple('addition120safe', ['6', '8'], ['14']),
            Expect.Simple(
              'addition120safe',
              ['900000000000000000000000000000000000', '800000000000000000000000000000000000'],
              null,
              'overflow',
            ),
            Expect.Simple('addition120unsafe', ['6', '8'], ['14']),
            Expect.Simple(
              'addition120unsafe',
              ['900000000000000000000000000000000000', '800000000000000000000000000000000000'],
              ['370772004215084127096192939719655424'],
              'overflow',
            ),
            Expect.Simple('addition256safe', ['20', '1', '5', '2'], ['25', '3']),
            Expect.Simple('addition256unsafe', ['20', '1', '5', '2'], ['25', '3']),
            Expect.Simple('addition8signedsafe', ['3', '20'], ['23'], 'pos + pos'),
            Expect.Simple('addition8signedsafe', ['100', '90'], null, 'pos + pos overflow'),
            Expect.Simple('addition8signedsafe', ['255', '254'], ['253'], 'neg + neg'),
            Expect.Simple('addition8signedsafe', ['128', '128'], null, 'neg + neg overflow'),
            Expect.Simple('addition8signedunsafe', ['3', '20'], ['23']),
            Expect.Simple('addition8signedunsafe', ['100', '90'], ['190'], 'overflow'),
            Expect.Simple('addition120signedsafe', ['6', '8'], ['14'], 'pos + pos'),
            Expect.Simple(
              'addition120signedsafe',
              ['400000000000000000000000000000000000', '450000000000000000000000000000000000'],
              null,
              'pos + pos overflow',
            ),
            Expect.Simple(
              'addition120signedsafe',
              [`${2n ** 120n / 2n}`, `${2n ** 120n - 1n}`],
              null,
              'neg + neg overflow',
            ),
            Expect.Simple('addition120signedunsafe', ['6', '8'], ['14']),
            Expect.Simple(
              'addition120signedunsafe',
              ['400000000000000000000000000000000000', '450000000000000000000000000000000000'],
              ['850000000000000000000000000000000000'],
              'overflow',
            ),
            Expect.Simple('addition256signedsafe', ['20', '1', '5', '2'], ['25', '3']),
            Expect.Simple(
              'addition256signedsafe',
              [
                '340282366920938463463374607431768211455',
                '340282366920938463463374607431768211455',
                '1',
                '0',
              ],
              ['0', '0'],
            ),
            Expect.Simple(
              'addition256signedsafe',
              [...toCairoUint256(2n ** 255n), ...toCairoUint256(2n ** 255n)],
              null,
              'neg + neg overflow',
            ),
            Expect.Simple(
              'addition256signedsafe',
              [...toCairoUint256(2n ** 255n - 1n), ...toCairoUint256(2n ** 255n - 1n)],
              null,
              'pos + pos overflow',
            ),
            Expect.Simple('addition256signedunsafe', ['20', '1', '5', '2'], ['25', '3']),
          ]),
          File.Simple('bitwise_and', [
            Expect.Simple('bitwise_and8safe', ['15', '45'], ['13']),
            Expect.Simple('bitwise_and8signedsafe', ['15', '45'], ['13']),
            Expect.Simple('bitwise_and8unsafe', ['15', '45'], ['13']),
            Expect.Simple('bitwise_and8signedunsafe', ['15', '45'], ['13']),
            Expect.Simple('bitwise_and256safe', ['15', '90', '45', '80'], ['13', '80']),
            Expect.Simple('bitwise_and256signedsafe', ['15', '90', '45', '80'], ['13', '80']),
            Expect.Simple('bitwise_and256unsafe', ['15', '90', '45', '80'], ['13', '80']),
            Expect.Simple('bitwise_and256signedunsafe', ['15', '90', '45', '80'], ['13', '80']),
          ]),
          File.Simple('bitwise_or', [
            Expect.Simple('bitwise_or8safe', ['14', '57'], ['63']),
            Expect.Simple('bitwise_or8signedsafe', ['14', '57'], ['63']),
            Expect.Simple('bitwise_or8unsafe', ['14', '57'], ['63']),
            Expect.Simple('bitwise_or8signedunsafe', ['14', '57'], ['63']),
            Expect.Simple('bitwise_or256safe', ['14', '13', '57', '100'], ['63', '109']),
            Expect.Simple('bitwise_or256signedsafe', ['14', '13', '57', '100'], ['63', '109']),
            Expect.Simple('bitwise_or256unsafe', ['14', '13', '57', '100'], ['63', '109']),
            Expect.Simple('bitwise_or256signedunsafe', ['14', '13', '57', '100'], ['63', '109']),
          ]),
          File.Simple('decrement', [
            Expect.Simple('preDecrementStatement', ['10'], ['9']),
            Expect.Simple('postDecrementStatement', ['10'], ['9']),
            Expect.Simple('preDecrementExpression', ['10'], ['9', '9']),
            Expect.Simple('postDecrementExpression', ['10'], ['10', '9']),
          ]),
          File.Simple('division', [
            Expect.Simple('division8safe', ['100', '5'], ['20']),
            Expect.Simple('division8signedsafe', ['100', '5'], ['20']),
            Expect.Simple('division8unsafe', ['100', '5'], ['20']),
            Expect.Simple('division8signedunsafe', ['100', '5'], ['20']),
            Expect.Simple('division256safe', ['100', '20', '5', '0'], ['20', '4']),
            Expect.Simple('division256signedsafe', ['100', '20', '5', '0'], ['20', '4']),
            Expect.Simple('division256unsafe', ['100', '20', '5', '0'], ['20', '4']),
            Expect.Simple('division256signedunsafe', ['100', '20', '5', '0'], ['20', '4']),
          ]),
          File.Simple('remainder', [
            Expect.Simple('remainder8safe', ['103', '5'], ['3']),
            //-119 % 5 = -4
            Expect.Simple('remainder8signedsafe', ['137', '5'], ['252']),
            Expect.Simple('remainder8unsafe', ['215', '9'], ['8']),
            Expect.Simple('remainder8signedunsafe', ['2', '5'], ['2']),
            Expect.Simple('remainder256safe', ['255', '23', '5', '0'], ['3', '0']),
            Expect.Simple('remainder256signedsafe', ['100', '20', '5', '0'], ['0', '0']),
            Expect.Simple('remainder256unsafe', ['100', '21', '5', '1'], ['0', '1']),
            Expect.Simple('remainder256signedunsafe', ['100', '20', '13', '0'], ['7', '0']),
          ]),
          File.Simple('eq', [
            Expect.Simple('eq8safe', ['1', '2'], ['0']),
            Expect.Simple('eq8signedsafe', ['1', '1'], ['1']),
            Expect.Simple('eq8unsafe', ['1', '1'], ['1']),
            Expect.Simple('eq8signedunsafe', ['1', '2'], ['0']),
            Expect.Simple('eq256safe', ['1', '2', '1', '2'], ['1']),
            Expect.Simple('eq256signedsafe', ['1', '2', '3', '2'], ['0']),
            Expect.Simple('eq256unsafe', ['1', '2', '1', '3'], ['0']),
            Expect.Simple('eq256signedunsafe', ['1', '2', '1', '2'], ['1']),
          ]),
          File.Simple('exp', [
            Expect.Simple('exp8safe', ['0', '0'], ['1']),
            Expect.Simple('exp8signedsafe', ['255', '10'], ['1']),
            Expect.Simple('exp8unsafe', ['100', '1'], ['100']),
            Expect.Simple('exp8signedunsafe', ['4', '3'], ['64']),
            Expect.Simple('exp256safe', ['0', '0', '1', '0'], ['0', '0']),
            Expect.Simple('exp256signedsafe', ['1000', '500', '0', '0'], ['1', '0']),
            Expect.Simple('exp256unsafe', ['2', '0', '3', '0'], ['8', '0']),
            Expect.Simple('exp256signedunsafe', ['0', '0', '0', '0'], ['1', '0']),
            Expect.Simple(
              'exp_minus_256',
              ['31', '0'],
              ['0', '0xff000000000000000000000000000000'],
            ),
            Expect.Simple('exp_minus_256', ['32', '0'], null),
          ]),
          File.Simple('ge', [
            Expect.Simple('ge8safe', ['1', '2'], ['0']),
            Expect.Simple('ge8signedsafe', ['255', '1'], ['0']),
            Expect.Simple('ge8unsafe', ['2', '1'], ['1']),
            Expect.Simple('ge8signedunsafe', ['5', '100'], ['0']),
            Expect.Simple('ge256safe', ['20', '3', '20', '3'], ['1']),
            Expect.Simple('ge256signedsafe', ['2', '3', '1', '4'], ['0']),
            Expect.Simple('ge256unsafe', ['1', '5', '3', '2'], ['1']),
            Expect.Simple('ge256signedunsafe', ['1', '1', '1', '1'], ['1']),
          ]),
          File.Simple('gt', [
            Expect.Simple('gt8safe', ['1', '2'], ['0']),
            Expect.Simple('gt8signedsafe', ['255', '1'], ['0']),
            Expect.Simple('gt8unsafe', ['2', '1'], ['1']),
            Expect.Simple('gt8signedunsafe', ['5', '100'], ['0']),
            Expect.Simple('gt256safe', ['20', '3', '20', '3'], ['0']),
            Expect.Simple('gt256signedsafe', ['2', '3', '1', '4'], ['0']),
            Expect.Simple('gt256unsafe', ['1', '5', '3', '2'], ['1']),
            Expect.Simple('gt256signedunsafe', ['1', '1', '1', '1'], ['0']),
          ]),
          File.Simple('increment', [
            Expect.Simple('preIncrementStatement', ['10'], ['11']),
            Expect.Simple('postIncrementStatement', ['10'], ['11']),
            Expect.Simple('preIncrementExpression', ['10'], ['11', '11']),
            Expect.Simple('postIncrementExpression', ['10'], ['10', '11']),
          ]),
          File.Simple('le', [
            Expect.Simple('le8safe', ['1', '2'], ['1']),
            Expect.Simple('le8signedsafe', ['255', '1'], ['1']),
            Expect.Simple('le8signedsafe', ['1', '10'], ['1']),
            Expect.Simple('le8signedsafe', ['156', '255'], ['1']),
            Expect.Simple('le8unsafe', ['2', '1'], ['0']),
            Expect.Simple('le8signedunsafe', ['5', '100'], ['1']),
            Expect.Simple('le256safe', ['20', '3', '20', '3'], ['1']),
            Expect.Simple('le256signedsafe', ['2', '3', '1', '4'], ['1']),
            Expect.Simple('le256unsafe', ['1', '5', '3', '2'], ['0']),
            Expect.Simple('le256signedunsafe', ['1', '1', '1', '1'], ['1']),
          ]),
          File.Simple('lt', [
            Expect.Simple('lt8safe', ['1', '2'], ['1']),
            Expect.Simple('lt8signedsafe', ['255', '1'], ['1']),
            Expect.Simple('lt8unsafe', ['2', '1'], ['0']),
            Expect.Simple('lt8signedunsafe', ['5', '100'], ['1']),
            Expect.Simple('lt256safe', ['20', '3', '20', '3'], ['0']),
            Expect.Simple('lt256signedsafe', ['2', '3', '1', '4'], ['1']),
            Expect.Simple('lt256unsafe', ['1', '5', '3', '2'], ['0']),
            Expect.Simple('lt256signedunsafe', ['1', '1', '1', '1'], ['0']),
          ]),
          File.Simple('multiplication', [
            Expect.Simple('multiplication8safe', ['4', '6'], ['24']),
            Expect.Simple('multiplication8safe', ['100', '40'], null, 'overflow'),
            Expect.Simple('multiplication8unsafe', ['4', '6'], ['24']),
            Expect.Simple('multiplication128safe', ['4', '6'], ['24']),
            Expect.Simple('multiplication128unsafe', ['4', '6'], ['24']),
            Expect.Simple('multiplication8unsafe', ['100', '40'], ['160'], 'overflow'),
            Expect.Simple('multiplication256safe', ['20', '1', '5', '0'], ['100', '5']),
            Expect.Simple('multiplication256unsafe', ['20', '0', '5', '1'], ['100', '20']),
            Expect.Simple('multiplication8signedsafe', ['255', '255'], ['1']),
            Expect.Simple('multiplication8signedsafe', ['100', '40'], null, 'overflow'),
            Expect.Simple('multiplication8signedunsafe', ['192', '2'], ['128']),
            Expect.Simple('multiplication8signedunsafe', ['100', '40'], ['160'], 'overflow'),
            Expect.Simple('multiplication128signedsafe', ['255', '255'], ['65025']),
            Expect.Simple('multiplication128signedunsafe', ['192', '2'], ['384']),
            Expect.Simple(
              'multiplication128signedunsafe',
              // -1 * 2 = -2
              ['340282366920938463463374607431768211455', '2'],
              ['340282366920938463463374607431768211454'],
            ),
            Expect.Simple(
              'multiplication256signedsafe',
              [
                '0',
                '0x40000000000000000000000000000000',
                '0xfffffffffffffffffffffffffffffffe',
                '0xffffffffffffffffffffffffffffffff',
              ],
              ['0', '0x80000000000000000000000000000000'],
            ),
            Expect.Simple(
              'multiplication256signedsafe',
              [
                '1',
                '0x40000000000000000000000000000000',
                '0xfffffffffffffffffffffffffffffffe',
                '0xffffffffffffffffffffffffffffffff',
              ],
              null,
            ),
            Expect.Simple('multiplication256signedsafe', ['20', '1', '5', '0'], ['100', '5']),
            Expect.Simple('multiplication256signedsafe', ['20', '1', '5', '0'], ['100', '5']),
            Expect.Simple('multiplication256signedunsafe', ['20', '0', '5', '1'], ['100', '20']),
          ]),
          File.Simple('neq', [
            Expect.Simple('neq8safe', ['1', '2'], ['1']),
            Expect.Simple('neq8signedsafe', ['1', '1'], ['0']),
            Expect.Simple('neq8unsafe', ['1', '1'], ['0']),
            Expect.Simple('neq8signedunsafe', ['1', '2'], ['1']),
            Expect.Simple('neq256safe', ['1', '2', '1', '2'], ['0']),
            Expect.Simple('neq256signedsafe', ['1', '2', '3', '2'], ['1']),
            Expect.Simple('neq256unsafe', ['1', '2', '1', '3'], ['1']),
            Expect.Simple('neq256signedunsafe', ['1', '2', '1', '2'], ['0']),
          ]),
          File.Simple('shl', [
            Expect.Simple('shl8safe', ['3', '4'], ['48']),
            Expect.Simple('shl8unsafe', ['3', '4'], ['48']),
            Expect.Simple('shl8signedsafe', ['3', '4'], ['48']),
            Expect.Simple('shl8signedunsafe', ['3', '4'], ['48']),
            Expect.Simple('shl8_256safe', ['3', '4', '0'], ['48']),
            Expect.Simple('shl8_256unsafe', ['3', '4', '0'], ['48']),
            Expect.Simple('shl8_256signedsafe', ['3', '4', '0'], ['48']),
            Expect.Simple('shl8_256signedunsafe', ['3', '4', '0'], ['48']),
            Expect.Simple('shl256safe', ['3', '5', '4'], ['48', '80']),
            Expect.Simple('shl256unsafe', ['3', '5', '4'], ['48', '80']),
            Expect.Simple('shl256signedsafe', ['3', '5', '4'], ['48', '80']),
            Expect.Simple('shl256signedunsafe', ['3', '5', '4'], ['48', '80']),
            Expect.Simple('shl256_256safe', ['3', '5', '4', '0'], ['48', '80']),
            Expect.Simple('shl256_256unsafe', ['3', '5', '4', '0'], ['48', '80']),
            Expect.Simple('shl256_256signedsafe', ['3', '5', '4', '0'], ['48', '80']),
            Expect.Simple('shl256_256signedunsafe', ['3', '5', '4', '0'], ['48', '80']),
            Expect.Simple('shl_positive_literal', [], ['1']),
            Expect.Simple('shl_negative_literal', [], ['1']),
          ]),
          File.Simple('shr', [
            Expect.Simple('shr8safe', ['100', '2'], ['25']),
            Expect.Simple('shr8unsafe', ['100', '2'], ['25']),
            Expect.Simple('shr8signedsafe', ['100', '2'], ['25']),
            Expect.Simple('shr8signedunsafe', ['100', '2'], ['25']),
            Expect.Simple('shr8_256safe', ['100', '2', '0'], ['25']),
            Expect.Simple('shr8_256unsafe', ['100', '2', '0'], ['25']),
            Expect.Simple('shr8_256signedsafe', ['100', '2', '0'], ['25']),
            Expect.Simple('shr8_256signedunsafe', ['100', '2', '0'], ['25']),
            Expect.Simple('shr256safe', ['100', '20', '2'], ['25', '5']),
            Expect.Simple('shr256unsafe', ['100', '20', '2'], ['25', '5']),
            Expect.Simple('shr256signedsafe', ['100', '20', '2'], ['25', '5']),
            Expect.Simple('shr256signedunsafe', ['100', '20', '2'], ['25', '5']),
            Expect.Simple('shr256_256safe', ['100', '20', '2', '0'], ['25', '5']),
            Expect.Simple('shr256_256unsafe', ['100', '20', '2', '0'], ['25', '5']),
            Expect.Simple('shr256_256signedsafe', ['100', '20', '2', '0'], ['25', '5']),
            Expect.Simple('shr256_256signedunsafe', ['100', '20', '2', '0'], ['25', '5']),
            Expect.Simple('shr_positive_literal', [], ['1']),
            Expect.Simple('shr_negative_literal', [], ['1']),
          ]),
          File.Simple('subtraction', [
            Expect.Simple('subtraction8safe', ['31', '2'], ['29']),
            Expect.Simple('subtraction8safe', ['20', '180'], null, 'overflow'),
            Expect.Simple('subtraction8unsafe', ['32', '20'], ['12']),
            Expect.Simple('subtraction8unsafe', ['2', '180'], ['78'], 'overflow'),
            Expect.Simple('subtraction8signedsafe', ['31', '2'], ['29']),
            Expect.Simple('subtraction8signedsafe', ['20', '180'], ['96'], 'overflow'),
            Expect.Simple('subtraction8signedunsafe', ['32', '20'], ['12']),
            Expect.Simple('subtraction8signedunsafe', ['20', '180'], ['96'], 'overflow'),
            Expect.Simple('subtraction200safe', ['60', '8'], ['52']),
            Expect.Simple(
              'subtraction200safe',
              ['800000000000000000000000000000000000', '900000000000000000000000000000000000'],
              null,
              'overflow',
            ),
            Expect.Simple('subtraction200unsafe', ['64', '8'], ['56']),
            Expect.Simple(
              'subtraction200unsafe',
              ['800000000000000000000000000000000000', '900000000000000000000000000000000000'],
              ['1606938044258990275541961992341162602522202993782792835301376'],
              'overflow',
            ),
            Expect.Simple('subtraction256safe', ['20', '4', '5', '2'], ['15', '2']),
            Expect.Simple('subtraction256safe', ['20', '1', '5', '2'], null, 'overflow'),
            Expect.Simple('subtraction256unsafe', ['20', '4', '5', '2'], ['15', '2']),
            Expect.Simple(
              'subtraction256unsafe',
              ['20', '4', '50', '2'],
              ['340282366920938463463374607431768211426', '1'],
              'overflow',
            ),
            Expect.Simple('subtraction256signedsafe', ['20', '4', '5', '2'], ['15', '2']),
            Expect.Simple(
              'subtraction256signedsafe',
              ['0', '0', '1', '0'],
              [
                '340282366920938463463374607431768211455',
                '340282366920938463463374607431768211455',
              ],
            ),
            Expect.Simple(
              'subtraction256signedsafe',
              ['20', '1', '5', '2'],
              ['15', '340282366920938463463374607431768211455'],
              'overflow',
            ),
            Expect.Simple('subtraction256signedunsafe', ['20', '4', '5', '2'], ['15', '2']),
            Expect.Simple(
              'subtraction256signedunsafe',
              ['20', '4', '50', '2'],
              ['340282366920938463463374607431768211426', '1'],
              'overflow',
            ),
          ]),
          File.Simple('xor', [
            Expect.Simple('xor8safe', ['10', '24'], ['18']),
            Expect.Simple('xor8signedsafe', ['10', '24'], ['18']),
            Expect.Simple('xor8unsafe', ['10', '24'], ['18']),
            Expect.Simple('xor8signedunsafe', ['10', '24'], ['18']),
            Expect.Simple('xor256safe', ['10', '7', '24', '19'], ['18', '20']),
            Expect.Simple('xor256signedsafe', ['10', '7', '24', '19'], ['18', '20']),
            Expect.Simple('xor256unsafe', ['10', '7', '24', '19'], ['18', '20']),
            Expect.Simple('xor256signedunsafe', ['10', '7', '24', '19'], ['18', '20']),
          ]),
        ]),
        new Dir('memory', [
          File.Simple('delete', [
            Expect.Simple('deleteFelt', [], ['0']),
            Expect.Simple('deleteUint', [], ['0', '0']),
            Expect.Simple('deleteS', [], ['0', '0'], 'Delete simple struct'),
            Expect.Simple('deleteDArray', ['3', '5', '3', '2'], ['0', '0'], 'Delete dynamic array'),
            Expect.Simple(
              'copyDeleteDArray',
              ['3', '5', '3', '2'],
              ['8', '0'],
              'Delete dynamic array but keep a reference copy',
            ),
            // Blocked by returning a struct containing a dynamic array
            // Expect.Simple('deleteC', [], ['0'], 'Delete struct with a dyanmic array as a member'),
            Expect.Simple(
              'deleteCnotArray',
              ['3', '5', '1', '2'],
              ['4'],
              'Delete struct but keep member array ',
            ),
            Expect.Simple('deleteSArray', [], ['3', '4'], 'Delete dynamic array of structs'),
            Expect.Simple('delete2dArray', [], ['13', '0'], 'Delete dynamic array of structs'),
          ]),
          File.Simple('dynamicArrays', [
            Expect.Simple('uint8new', [], ['0', '0']),
            Expect.Simple('uint8write', ['5'], ['0', '5']),
            Expect.Simple('uint256new', [], ['0', '0', '0', '0']),
            Expect.Simple('uint256write', ['5', '6'], ['0', '0', '5', '6']),
          ]),
          File.Simple('nested', [
            Expect.Simple('setAndGet', ['100'], ['100']),
            Expect.Simple(
              'memberAssign',
              ['2', '3', '4', '5', '6', '7', '8', '9', '10', '11'],
              ['2', '3', '4', '5', '6'],
            ),
            Expect.Simple(
              'identifierAssign',
              ['2', '3', '4', '5', '6', '7', '8', '9', '10', '11'],
              ['7', '8', '9', '10', '11'],
            ),
          ]),
          File.Simple('nestedIndexAccessWrite', [
            Expect.Simple(
              'passDataToInnerFunction',
              [],
              [...['0', '0', '0'], ...['0', '0', '0'], ...['0', '0', '1'], ...['0', '0', '7']],
              '0',
            ),
          ]),
          File.Simple('staticArrays', [
            Expect.Simple('uint8default', [], ['0', '0']),
            Expect.Simple('uint8write', ['5'], ['0', '5']),
            Expect.Simple('uint256default', [], ['0', '0', '0', '0']),
            Expect.Simple('uint256write', ['5', '6'], ['0', '0', '5', '6']),
          ]),
          File.Simple('structs', [
            Expect.Simple('createDefault', [], ['0', '0', '0']),
            Expect.Simple('createManual', ['1', '2', '3'], ['1', '2', '3']),
            Expect.Simple('writeMembers', ['1', '2', '3'], ['1', '2', '3']),
            Expect.Simple('references', ['1', '2', '3'], ['1', '2', '3']),
            Expect.Simple('input', ['3', '4', '5'], ['4', '5', '5']),
            Expect.Simple('output', ['3', '4', '5'], ['3', '4', '5']),
          ]),
        ]),
        new Dir('modifiers', [
          File.Simple('modifier', [
            Expect.Simple('f', ['90000', '0'], ['10000', '0']),
            Expect.Simple('f', ['110000', '0'], ['0', '0']),
          ]),
          File.Simple('modifierRecursive', [
            new Expect('modifier', [
              ['fact', ['5', '0'], ['120', '0'], '0'],
              ['called', [], ['6', '0'], '0'],
            ]),
          ]),
          File.Simple('modifierWithReturn', [
            Expect.Simple('returnFiveThroughModifiers', [], ['5']),
          ]),
          File.Simple('multipleModifiers', [
            new Expect('modifier', [
              ['openEvent', [], [], '0'],
              ['donate', ['238', '0'], ['238', '0'], '0'],
              ['donate', ['100', '0'], ['338', '0'], '0'],
              ['donate', ['50', '0'], null, '0', 'Value for donation must be bigger than 100'],
              ['balance', [], ['338', '0'], '0'],
              ['closeEvent', [], [], '0'],
              [
                'donate',
                ['500', '0'],
                null,
                '0',
                'The event must be open in order to receive donations',
              ],
              ['balance', [], ['0', '0'], '0'],
            ]),
          ]),
        ]),
        new Dir('modifiers', [
          File.Simple('modifier', [
            Expect.Simple('f', ['90000', '0'], ['10000', '0']),
            Expect.Simple('f', ['110000', '0'], ['0', '0']),
          ]),
          File.Simple('multipleModifiers', [
            new Expect('modifier', [
              ['openEvent', [], [], '0'],
              ['donate', ['238', '0'], ['238', '0'], '0'],
              ['donate', ['100', '0'], ['338', '0'], '0'],
              ['donate', ['50', '0'], null, '0', 'Value for donation must be bigger than 100'],
              ['balance', [], ['338', '0'], '0'],
              ['closeEvent', [], [], '0'],
              [
                'donate',
                ['500', '0'],
                null,
                '0',
                'The event must be open in order to receive donations',
              ],
              ['balance', [], ['0', '0'], '0'],
            ]),
          ]),
        ]),
        new Dir('new', [
          File.Simple('deep', [Expect.Simple('createContracts', [], [])]),
          File.Simple('many', [
            new Expect('Uint256 as argument', [
              ['createUint256Contract', ['0', '2'], [], '0'],
              ['getUint256X', [], ['0', '2'], '0'],
            ]),
            new Expect('Uint8 as argument', [
              ['createUint8Contract', ['3'], [], '0'],
              ['getUint8X', [], ['3'], '0'],
            ]),
            new Expect('Dynamic Array as argument', [
              ['createDynArrayContract', ['4', '0', '5', '0', '7', '0', '11', '0', '31'], [], '0'],
              ['getDynArrayX', [], ['4', '0', '5', '0', '7', '0', '11', '0', '31'], '0'],
            ]),
            new Expect('Static Array as argument', [
              ['createStaticArrayContract', ['13', '17', '19'], [], '0'],
              ['getStaticArrayX', [], ['13', '17', '19'], '0'],
            ]),
            new Expect('Struct as argument', [
              ['createStructContract', ['23', '29'], [], '0'],
              ['getStructX', [], ['23', '29'], '0'],
            ]),
          ]),
          File.Simple('salted', [
            new Expect('Create multiple salted contracts', [
              ['createAndStoreUint256Contract', ['0', '1', '0', '2'], [], '0'],
              ['createAndStoreUint256Contract', ['0', '2', '0', '5'], [], '0'],
              ['createUint256Contract', ['0', `${2n ** 128n - 1n}`, '0', '7'], [], '0'],
            ]),
            new Expect('Interact with different deployed salted contracts', [
              ['getUint256X', ['0', '1'], ['0', '2'], '0'],
              ['getUint256X', ['0', '2'], ['0', '5'], '0'],
            ]),
          ]),
          /*
          File.Simple('product', [
            new Expect('Different types', [
              [
                'createProduct',
                [
                  ...['2', '0'],
                  '3',
                  ...['3', '0', '2', '0', '3', '0', '5'],
                  ...['7', '11'],
                  ...['13', '17', '19'],
                ],
                [],
                '0',
              ],
              [
                'getProduct',
                ['0', '0'],
                [
                  ...['2', '0'],
                  '3',
                  ...['3', '0', '2', '0', '3', '0', '5'],
                  ...['7', '11'],
                  ...['13', '17', '19'],
                ],
                '0',
              ],
            ]),
          ]),
          */
        ]),
        new Dir('precompiles', [
          File.Simple('ecrecover', [Expect.Simple('test', [], ['1'])]),
          File.Simple('keccak256', [
            Expect.Simple(
              'testCalldataBytes',
              ['4', '0xff', '0xff', '0xaa', '0xdd'],
              [
                '175324288422466550073545188793205740709',
                '193807281875048316986278682415904036447',
              ],
            ),
            Expect.Simple(
              'testMemoryBytes',
              ['1', '0x63'],
              ['224080190154071229201179410017478621618', '14967895479457470500441594449402441164'],
            ),
            Expect.Simple(
              'testString',
              [],
              ['224080190154071229201179410017478621618', '14967895479457470500441594449402441164'],
            ),
          ]),
        ]),
        new Dir('named_args', [
          File.Simple('function', [
            Expect.Simple('f', [], []),
            Expect.Simple('k', [], ['365', '0']),
            Expect.Simple('v', [], ['234', '0']),
          ]),
          File.Simple('constructor', [
            // (1, 2, (45, 1), [1,2,3])
            Expect.Simple(
              'getData',
              [],
              ['1', '0', '2', '0', '45', '0', '1', '0', '1', '0', '2', '0', '3', '0'],
            ),
          ]),
        ]),
        new Dir('public_func_splitter', [
          File.Simple('value_passing', [], 'A'),
          File.Simple(
            'value_passing',
            [
              Expect.Simple('testExternalCallMemberAccess', [], ['1', '2']),
              Expect.Simple('testInternalCallMemberAccess', [], ['10', '11']),
              Expect.Simple('testInternalCallIdentifier', [], ['10', '11']),
              Expect.Simple(
                'testExternalCallCrossContract',
                ['address@tests/behaviour/contracts/public_func_splitter/value_passing.A'],
                ['1', '2'],
              ),
            ],
            'WARP',
          ),
        ]),
        new Dir('public_state_vars', [
          File.Simple('elementary', [
            Expect.Simple('a', [], ['234', '0']),
            Expect.Simple('b', [], ['23']),
            Expect.Simple('c', [], ['103929005307130220006098923584552504982110632080']),
            Expect.Simple(
              'd',
              [],
              [
                '340282366920938463463374607431768211455',
                '340282366920938463463374607431768211455',
              ],
            ),
            Expect.Simple('e', [], ['12', '0']),
            Expect.Simple('f', [], ['1']),
          ]),
          File.Simple('arrays', [
            Expect.Simple('a', ['2', '0'], ['3', '0']),
            Expect.Simple('d', ['0', '0'], ['103929005307130220006098923584552504982110632080']),
            Expect.Simple('e', ['1', '0'], ['0']),
            Expect.Simple('y', ['0', '0'], ['12', '0']),
            Expect.Simple('w', ['0', '0', '0', '0', '0', '0'], ['15', '0']),
          ]),
          File.Simple('enums', [
            Expect.Simple('a', [], ['0']),
            Expect.Simple('b', [], ['1']),
            Expect.Simple('c', [], ['0']),
            Expect.Simple('d', [], ['1']),
            Expect.Simple('f', [], ['2']),
          ]),
          File.Simple('mappings', [
            Expect.Simple('a', ['1', '0'], ['1', '0']),
            Expect.Simple('b', ['2', '0'], ['1']),
            Expect.Simple('d', ['1'], ['1', '0']),
            Expect.Simple('e', ['1', '1', '0'], ['1']),
          ]),
          File.Simple('structs', [
            Expect.Simple('a', [], ['1', '0', '2', '0']),
            Expect.Simple('c', [], ['5', '0', '6', '0']),
            Expect.Simple(
              'd',
              [],
              [
                '7',
                '0',
                '103929005307130220006098923584552504982110632080',
                '9',
                '10',
                '0',
                '11',
                '0',
              ],
            ),
            Expect.Simple('getStructIgnoringDynArray', ['7', '9', '8', '0'], ['7', '9', '8', '0']),
          ]),
          File.Simple('misc', [
            Expect.Simple('a', ['0', '0'], ['1', '0', '2', '0']),
            Expect.Simple(
              'd',
              ['0', '0'],
              [
                '7',
                '0',
                '103929005307130220006098923584552504982110632080',
                '9',
                '11',
                '0',
                '10',
                '0',
              ],
            ),
          ]),
        ]),
        new Dir('preExpressionSplitter', [
          File.Simple('assign_simple', [Expect.Simple('f', [], ['10', ''])]),
          File.Simple('assign_simple', [Expect.Simple('g', [], ['15', ''])]),
        ]),
        new Dir('returns', [
          File.Simple('initialiseStorageReturns', [
            Expect.Simple('getDefaultArrayLengths', [], ['0', '0', '0', '0']),
          ]),
          File.Simple('returnInserter', [
            Expect.Simple('default_returnInsert', ['6'], ['0']),
            Expect.Simple('condition_returnInsert', ['1'], ['2'], 'Return from conditional branch'),
            Expect.Simple(
              'condition_returnInsert',
              ['2'],
              ['0'],
              'Default return if not returned from conditional branch',
            ),
            Expect.Simple('revert_returnInserter', ['3'], null),
            Expect.Simple('conditions_no_returnInsert', ['9'], ['9']),
            Expect.Simple('returnInsert_with_require', ['3', '5'], ['8']),
            Expect.Simple('ifFunctionaliser_returnInserter', ['2'], ['2', '0']),
          ]),
          File.Simple('returnInitializer', [
            Expect.Simple('withReturn', ['3', '8'], ['3', '8']),
            Expect.Simple('insertReturn', ['7'], ['9', '7']),
          ]),
        ]),
        new Dir('static_array_index_access', [
          File.Simple('static_array_index_access', [
            Expect.Simple('t0', ['3', '2', '1', '0', '0'], ['3']),
            Expect.Simple(
              't1',
              [...['2', '0', '2'], ...['3', '0', '3'], '1', '0'],
              ['3', '0', '3'],
            ),
            Expect.Simple(
              't2',
              [...['2', '0', '2', '0', '2'], ...['3', '0', '3', '0', '3'], '0', '0'],
              ['2', '0', '2', '0', '2'],
            ),
            Expect.Simple('t3', ['2', '3', '5', '7', '11', '0', '0', '2', '0', '4', '0'], ['18']),
            Expect.Simple('t4', ['2', '3', '5', '7', '1', '0'], ['5']),
            Expect.Simple('t5', ['2', '3', '5', '7', '1', '0'], ['3']),
            Expect.Simple('t6', ['2', '3', '5', '7', '1', '0'], ['7']),
            Expect.Simple('n0', ['1', '2', '3', '2', '0'], ['3']),
            Expect.Simple('n1', [...['1', '2', '3'], ...['4', '5', '6'], '0', '0'], ['4']),
            Expect.Simple(
              'n2',
              [
                ...[...['1', '2', '3'], ...['4', '5', '6']],
                ...[...['2', '3', '4'], ...['5', '6', '7']],
                ...[...['3', '4', '5'], ...['6', '7', '8']],
                '2',
                '0',
              ],
              ['8'],
            ),
            Expect.Simple(
              'n3',
              [
                ...[...['1', '2', '3'], ...['4', '5', '6']],
                ...[...['2', '3', '4'], ...['5', '6', '7']],
                ...[...['3', '4', '5'], ...['6', '7', '8']],
                '2',
                '0',
              ],
              ['3', '4', '5'],
            ),
          ]),
        ]),
        new Dir('storage', [
          new Dir('delete', [
            File.Simple('value_dyn_array', [
              Expect.Simple('tryDeleteX', [], ['28']),
              Expect.Simple('tryDeleteY', [], ['71', '0']),
            ]),
            File.Simple('ref_dyn_array', [Expect.Simple('tryDeleteZ', [], ['0', '0', '0'])]),
            File.Simple('struct', [
              Expect.Simple(
                'deleteValueStruct',
                [],
                ['0', '0', '0', '0', '0', '0', '0'],
                'delete struct with value members',
              ),
              new Expect('delete struct with dynamic array', [
                ['setDynArrayStructVal', ['3'], [], '0'],
                ['setDynArrayStructVal', ['5'], [], '0'],
                ['setDynArrayStructVal', ['7'], [], '0'],
                ['deleteDynArrayStruct', [], [], '0'],
                ['getDynArrayStruct', ['0', '0'], null, '0'],
                ['setDynArrayStructVal', ['15'], [], '0'],
                ['getDynArrayStruct', ['0', '0'], ['15', '15'], '0'],
              ]),
              new Expect('delete struct with mapping', [
                ['setMapStructVal', ['5', '10'], [], '0'],
                ['deleteMapStruct', [], [], '0'],
                ['getMapStruct', ['5'], ['10'], '0'],
              ]),
            ]),
            File.Simple('map_2d_dyn_array', [
              new Expect('delete 2d dynamic arrays with mappings', [
                ['n1', ['3', '0', '5', '0'], [], '0'],
                ['map', ['3', '0'], ['5', '0'], '0'],
                ['p', [], [], '0'],
                ['n2', [], [], '0'],
                ['map', ['3', '0'], ['5', '0'], '0'],
                ['d', [], ['0', '0'], '0'],
                ['n2', [], [], '0'],
                ['map', ['3', '0'], ['5', '0'], '0'],
              ]),
            ]),
            File.Simple('static_array', [
              new Expect('delete small static array', [
                ['setSmall', ['0', '1'], [], '0'],
                ['setSmall', ['0', '2'], [], '0'],
                ['setSmall', ['2', '3'], [], '0'],
                ['getSmall', ['0', '1'], ['2'], '0'],
                ['deleteSmall', [], [], '0'],
                ['getSmall', ['0', '1'], null, '0'],
                ['setSmall', ['2', '15'], [], '0'],
                ['getSmall', ['2', '0'], ['15'], '0'],
              ]),
              new Expect('delete big static array', [
                ['setBig', ['0', '1'], [], '0'],
                ['setBig', ['0', '2'], [], '0'],
                ['setBig', ['2', '3'], [], '0'],
                ['getBig', ['0', '1'], ['2'], '0'],
                ['deleteBig', [], [], '0'],
                ['getBig', ['0', '1'], null, '0'],
                ['setBig', ['2', '15'], [], '0'],
                ['getBig', ['2', '0'], ['15'], '0'],
              ]),
            ]),
          ]),
          File.Simple('dynamic_arrays', [
            Expect.Simple('get', ['0', '0'], null, 'out of range get should fail'),
            Expect.Simple('set', ['0', '0', '0'], null, 'out of range set should fail'),
            Expect.Simple('length', [], ['0', '0'], 'length should start as 0'),
            Expect.Simple('pushNoArg', [], ['0']),
            Expect.Simple('length', [], ['1', '0'], 'length should increase after push'),
            Expect.Simple('get', ['0', '0'], ['0']),
            Expect.Simple('get', ['1', '0'], null, 'out of range get should fail'),
            Expect.Simple('pushNoArg', [], ['0']),
            Expect.Simple('length', [], ['2', '0'], 'length should increase after push'),
            Expect.Simple('get', ['1', '0'], ['0']),
            Expect.Simple('get', ['2', '0'], null, 'out of range get should fail'),
            new Expect('set', [
              ['set', ['0', '0', '4'], ['4'], '0'],
              ['get', ['0', '0'], ['4'], '0'],
            ]),
            Expect.Simple('pop', [], []),
            Expect.Simple('length', [], ['1', '0'], 'length should decrease after pop'),
            Expect.Simple('get', ['0', '0'], ['4']),
            Expect.Simple('pop', [], []),
            Expect.Simple('length', [], ['0', '0'], 'length should decrease after pop'),
            Expect.Simple('get', ['0', '0'], null),
            Expect.Simple('pop', [], null, 'attempting to pop an empty array should fail'),
            Expect.Simple('pushReturnDynArray', [], ['0', '0', '0']),
          ]),
          File.Simple('dynamicInStructs', [
            Expect.Simple('s', [], ['0', '0', '0']),
            Expect.Simple('set', ['5', '2', '2', '0x80', '0x81'], []),
            Expect.Simple('s', [], ['5', '2', '2', '0x80', '0x81']),
          ]),
          File.Simple('mappings', [
            Expect.Simple('nestedMappings', ['3'], ['3']),
            Expect.Simple('nestedMappings', ['4'], ['4'], 'stepCheck'),
            Expect.Simple('nonFeltKey', ['3', '4', '5'], ['5']),
            Expect.Simple('nonFeltKey', ['4', '5', '6'], ['6'], 'stepCheck'),
            Expect.Simple('structValue', ['10', '100', '1000'], ['10', '100', '1000']),
            Expect.Simple(
              'staticArrayValue',
              ['10', '11', '100', '101', '1000', '1001'],
              ['10', '11', '100', '101', '1000', '1001'],
            ),
            Expect.Simple(
              'staticArrayValueWithConversion',
              ['10', '100', '101', '200'],
              ['10', '0', '100', '101', '200', '0'],
            ),
            Expect.Simple(
              'dynamicArrayValue',
              ['10', '11', '100', '101', '1000', '1001'],
              ['10', '11', '100', '101', '1000', '1001'],
            ),
          ]),
          File.Simple('nesting', [Expect.Simple('nesting', [], ['5'])]),
          File.Simple('passingArguments', [
            Expect.Simple('passArray', [], ['4']),
            Expect.Simple('passInt', [], ['0', '0']),
            Expect.Simple('passMap', [], ['20']),
            Expect.Simple('passStruct', [], ['5']),
          ]),
          File.Simple('pushPopLoops', [
            Expect.Simple('test_indices', ['1', '0'], ['1', '0']),
            Expect.Simple('test_indices', ['5', '0'], ['5', '0']),
            Expect.Simple('test_indices', ['10', '0'], ['10', '0']),
            Expect.Simple('test_indices', ['9', '0'], ['9', '0']),
            Expect.Simple('test_indices', ['1', '0'], ['1', '0']),
          ]),
          File.Simple('pushPopLoopsAddress', [
            Expect.Simple('test_indices', ['0', '0'], ['0', '0']),
            Expect.Simple('test_indices', ['11', '0'], ['11', '0']),
            Expect.Simple('test_indices', ['11', '0'], ['11', '0']),
            Expect.Simple('test_indices', ['5', '0'], ['5', '0']),
            Expect.Simple('test_indices', ['0', '0'], ['0', '0']),
          ]),
          File.Simple('returns', [
            Expect.Simple('ints', [], ['3']),
            Expect.Simple('arrays', [], ['2', '2']),
            Expect.Simple('mappings', [], ['2', '4']),
            Expect.Simple('structs', [], ['2']),
          ]),
          File.Simple('scalars', [
            Expect.Simple('getValues', [], ['2', '4']),
            Expect.Simple('readValues', [], ['2', '4']),
            new Expect('setOnce', [
              ['setValues', ['5', '8'], [], '0'],
              ['getValues', [], ['5', '8'], '0'],
            ]),
            new Expect('setRepeated', [
              ['setValues', ['1', '1'], [], '0'],
              ['setValues', ['11', '32'], [], '0'],
              ['getValues', [], ['11', '32'], '0'],
            ]),
          ]),
          File.Simple('static_arrays', [
            Expect.Simple('length', [], ['5', '0']),
            Expect.Simple('get', ['2', '0'], ['0'], 'initial value'),
            Expect.Simple('get', ['5', '0'], null, 'out of range'),
            Expect.Simple('set', ['3', '0', '10'], ['10']),
            Expect.Simple('get', ['3', '0'], ['10'], 'set value should persist'),
          ]),
          File.Simple('structs', [
            Expect.Simple('getMember', [], ['0', '0']),
            new Expect('setMember', [
              ['setMember', ['5', '10'], [], '0'],
              ['getMember', [], ['5', '10'], '0'],
            ]),
            new Expect('struct constructor', [
              ['assign', ['10', '11'], [], '0'],
              ['getMember', [], ['10', '11'], '0'],
            ]),
          ]),
          File.Simple('swap', [
            Expect.Simple('set', ['5', '6', '7', '8'], []),
            Expect.Simple('swap', [], []),
            Expect.Simple('struct1', [], ['5', '6']),
            Expect.Simple('struct2', [], ['5', '6']),
          ]),
        ]),
        new Dir('stringLiteral', [
          File.Simple('stringLiteralMemory', [
            Expect.Simple('plainLiteral', [], []),
            Expect.Simple('returnLiteral', [], ['4', '87', '65', '82', '80']),
            Expect.Simple('varDecl', [], ['4', '87', '65', '82', '80']),
            Expect.Simple(
              'literalAssignmentToMemoryFromParams',
              ['2', '86', '65'],
              ['4', '87', '65', '82', '80'],
            ),
            Expect.Simple('tupleRet', [], ['2', '87', '65', '2', '82', '80']),
            Expect.Simple('funcCallWithArg', [], ['4', '87', '65', '82', '80']),
            Expect.Simple('nestedFuncCallWithArg', [], ['4', '87', '65', '82', '80']),
          ]),
          File.Simple('stringLiteralStorage', [
            Expect.Simple('literalAssignment', [], ['4', '87', '65', '82', '80']),
            Expect.Simple('memoryToStorageAssignment', [], ['4', '87', '65', '82', '80']),
          ]),
        ]),
        new Dir('this_keyword', [
          File.Simple('thisKeyword', [
            Expect.Simple(
              'simpleThis',
              [],
              ['address@tests/behaviour/contracts/this_keyword/thisKeyword.WARP'],
            ),
            Expect.Simple(
              'getAddress',
              [],
              ['address@tests/behaviour/contracts/this_keyword/thisKeyword.WARP'],
            ),
            Expect.Simple(
              'getAddressAssignment',
              [],
              ['address@tests/behaviour/contracts/this_keyword/thisKeyword.WARP'],
            ),
          ]),
        ]),
        new Dir('tuples', [
          File.Simple('calldata_tuple', [
            Expect.Simple('tupleSplit', ['3', '1', '2', '3', '5'], ['5']),
          ]),
        ]),
        new Dir('type_information', [
          File.Simple('informationEnum', [
            Expect.Simple('dMin', [], ['0']),
            Expect.Simple('dMax', [], ['3']),
          ]),
          File.Simple('informationContract', [
            Expect.Simple('getName', [], ['4', '87', '65', '82', '80']),
            Expect.Simple('getId', [], ['3619205059']),
          ]),
        ]),
        new Dir('type_name_type_removal', [
          File.Simple('complex', [
            Expect.Simple('assignment', [], []),
            Expect.Simple('varDeclStatement', [], []),
            Expect.Simple('tupleExpression', [], []),
          ]),
          File.Simple('simple', [
            Expect.Simple('memberAccess', [], []),
            Expect.Simple('identifier', [], []),
            Expect.Simple('simple', [], []),
            Expect.Simple('indexAccess', [], []),
          ]),
        ]),
        new Dir('underscore_integers', [
          File.Simple('underscore_integers', [
            Expect.Simple('a', [], ['10000', '0']),
            Expect.Simple('b', [], ['10000', '0']),
          ]),
        ]),
        new Dir('user_defined_value_types', [
          File.Simple('overloading', [
            Expect.Simple(
              'callOverloads',
              ['4'],
              ['4', '5'],
              'test wrapped value goes to different overload',
            ),
          ]),
          File.Simple('user_defined_value_types', [
            Expect.Simple('narrowUnsigned', ['1', '0'], ['1']),
            Expect.Simple('narrowUnsigned', ['2', '0'], ['2']),
            Expect.Simple('narrowUnsigned', ['257', '0'], ['1']),
            Expect.Simple('narrowSigned', ['1', '0'], ['1']),
            Expect.Simple('narrowSigned', ['2', '0'], ['2']),
            Expect.Simple('narrowSigned', ['255', '0'], ['255']),
            Expect.Simple('narrowSigned', ['257', '0'], ['1']),
            Expect.Simple('unsignedToSigned', ['1'], ['1']),
            Expect.Simple('unsignedToSigned', ['2'], ['2']),
            Expect.Simple('unsignedToSigned', ['255'], ['255']),
            Expect.Simple('unsignedToSigned', ['257'], null),
            Expect.Simple('widenWrap', ['250'], ['250']),
            Expect.Simple('widenNoWrap', ['1'], ['1', '0']),
            Expect.Simple('widenNoWrap', ['2'], ['2', '0']),
            Expect.Simple('widenNoWrap', ['255'], ['0xff', '0']),
            Expect.Simple('widenNoWrap', ['257'], null),
            Expect.Simple('widenWrap', ['1'], ['1']),
            Expect.Simple('widenWrap', ['2'], ['2']),
            Expect.Simple('widenWrap', ['255'], ['0xff']),
            Expect.Simple('widenWrap', ['257'], null),
            Expect.Simple('narrowWithUnwrap', ['1'], ['1']),
            Expect.Simple('narrowWithUnwrap', ['2'], ['2']),
            Expect.Simple('narrowWithUnwrap', ['255'], ['0xff']),
            Expect.Simple('narrowWithUnwrap', ['257'], ['1']),
          ]),
        ]),
        new Dir('using_for', [
          File.Simple('simple', [
            Expect.Simple('callOnIdentifier', [], ['6', '0']),
            Expect.Simple('callOnFunctionCall', [], ['60', '0']),
            Expect.Simple('namedArgChecker', [], ['62', '0']),
          ]),
          File.Simple('library', [
            Expect.Simple('callOnIdentifierAdd', [], ['6', '0']),
            Expect.Simple('callOnIdentifierMul', [], ['2', '0']),
            Expect.Simple('callLibFunction', [], ['1', '0']),
          ]),
          File.Simple('private', [
            Expect.Simple('callOnIdentifier', ['23', '0', '3', '0'], ['69', '0']),
          ]),
        ]),
        File.Simple('example', [
          Expect.Simple('test', [], []),
          Expect.Simple('returnTest', [], ['12', '0']),
        ]),
        File.Simple('removeIdentityFunctions', [
          Expect.Simple('f', ['10', '0'], ['3', '20', '0', '5', '0', '13', '0']),
        ]),
      ]),
    ]),
    new Dir('benchmark', [
      new File(
        'BaseJumpRateModelV2',
        'BaseJumpRateModelV2',
        ['10000000', '0', '11000000', '0', '10000000', '0', '10', '0', '0'],
        [
          Expect.Simple(
            'getSupplyRate',
            ['500', '0', '100', '0', '200', '0', '2', '0'],
            ['0', '0'],
          ),
          Expect.Simple(
            'utilizationRate',
            ['500', '0', '100', '0', '200', '0'],
            ['250000000000000000', '0'],
          ),
          Expect.Simple(
            'updateJumpRateModel',
            ['10000000', '0', '11000000', '0', '10000000', '0', '7', '0'],
            [],
          ),
        ],
      ),
      File.Simple('ERC20_storage', [
        Expect.Simple('deposit', ['74', '0', '500', '0'], []),
        Expect.Simple('transferFrom', ['74', '0', '68', '0', '400', '0', '74', '0'], ['1']),
        Expect.Simple('withdraw', ['80', '0', '74', '0'], []),
        Expect.Simple('get_balance', ['74', '0'], ['20', '0']),
      ]),
      new File(
        'ERC20',
        'ERC20',
        [
          '10',
          '78',
          '69',
          '84',
          '72',
          '69',
          '82',
          '67',
          '79',
          '73',
          '78',
          '4',
          '78',
          '69',
          '84',
          '72',
        ],
        [
          Expect.Simple(
            'name',
            [],
            ['10', '78', '69', '84', '72', '69', '82', '67', '79', '73', '78'],
          ),
          Expect.Simple('symbol', [], ['4', '78', '69', '84', '72']),
          Expect.Simple('decimals', [], ['18']),
          Expect.Simple('totalSupply', [], ['0', '0']),
          Expect.Simple('balanceOf', ['1234'], ['0', '0']),
          Expect.Simple('allowance', ['123', '765'], ['0', '0']),
          new Expect('transfer', [['transfer', ['123', '0', '0'], ['1'], '4']]),
          new Expect('approve', [['approve', ['1234', '0', '0'], ['1'], '4']]),
          new Expect('transferFrom', [['transferFrom', ['4', '123', '0', '0'], ['1'], '1234']]),
        ],
      ),
    ]),
  ]),
);
