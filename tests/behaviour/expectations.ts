import { validateInput } from '../util';

class Dir {
  constructor(public name: string, public tests: (Dir | File)[]) {}
}

export class File {
  constructor(public name: string, public expectations: Expect[]) {}
  get sol() {
    return `${this.name}.sol`;
  }
  get cairo() {
    return `${this.name}.cairo`;
  }
  get compiled() {
    return `${this.name}.json`;
  }
}

class Expect {
  constructor(
    public name: string,
    public steps: [
      func: string,
      inputs: string[],
      returns: string[] | null,
      caller_address: string,
    ][],
  ) {
    steps.forEach(([_, inputs, returns]) => {
      // Validate that inputs and returns are valid numeric strings
      inputs.forEach(validateInput);
      returns !== null && returns.forEach(validateInput);
    });
  }
  static Simple(name: string, inputs: string[], returns: string[] | null, tag?: string): Expect {
    return new Expect(tag ? `${name}: ${tag}` : name, [[name, inputs, returns, '0']]);
  }
}

//-----------------------------------------------------------------------------

export const expectations = flatten(
  new Dir('tests', [
    new Dir('behaviour', [
      new Dir('contracts', [
        new File('example', [
          Expect.Simple('test', [], []),
          Expect.Simple('returnTest', [], ['12', '0']),
        ]),
        new Dir('assignments', [
          new File('functionSingle', [
            Expect.Simple('test', ['3'], ['3']),
            Expect.Simple('test256', ['3', '4'], ['3', '4']),
          ]),
          new File('scalar', [
            Expect.Simple('test', ['3'], ['3']),
            Expect.Simple('test256', ['3', '4'], ['3', '4']),
          ]),
        ]),
        // covers nested mappings
        new Dir('Dai', [
          new File('dai', [
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
          ]),
        ]),
        new Dir('enums', [
          new File('singleEnum', [
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
          ]),
          new File('doubleEnum', [
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
        new Dir('ERC20', [
          new File('ERC20', [
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
        new Dir('expressions', [new File('ineffectual', [Expect.Simple('test', ['1'], ['1'])])]),
        new Dir('loops', [
          new File('loops', [
            Expect.Simple('forLoop', ['3'], ['8']),
            Expect.Simple('whileLoop', ['10'], ['10']),
            Expect.Simple('breaks', ['5'], ['5']),
            Expect.Simple('continues', ['4'], ['24']),
          ]),
        ]),
        new Dir('maths', [
          new File('addition', [
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
            Expect.Simple('addition8signedsafe', ['3', '20'], ['23']),
            Expect.Simple('addition8signedsafe', ['100', '90'], null, 'overflow'),
            Expect.Simple('addition8signedunsafe', ['3', '20'], ['23']),
            Expect.Simple('addition8signedunsafe', ['100', '90'], ['190'], 'overflow'),
            Expect.Simple('addition120signedsafe', ['6', '8'], ['14']),
            Expect.Simple(
              'addition120signedsafe',
              ['400000000000000000000000000000000000', '450000000000000000000000000000000000'],
              null,
              'overflow',
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
            Expect.Simple('addition256signedunsafe', ['20', '1', '5', '2'], ['25', '3']),
          ]),
          new File('bitwise_and', [
            Expect.Simple('bitwise_and8safe', ['15', '45'], ['13']),
            Expect.Simple('bitwise_and8signedsafe', ['15', '45'], ['13']),
            Expect.Simple('bitwise_and8unsafe', ['15', '45'], ['13']),
            Expect.Simple('bitwise_and8signedunsafe', ['15', '45'], ['13']),
            Expect.Simple('bitwise_and256safe', ['15', '90', '45', '80'], ['13', '80']),
            Expect.Simple('bitwise_and256signedsafe', ['15', '90', '45', '80'], ['13', '80']),
            Expect.Simple('bitwise_and256unsafe', ['15', '90', '45', '80'], ['13', '80']),
            Expect.Simple('bitwise_and256signedunsafe', ['15', '90', '45', '80'], ['13', '80']),
          ]),
          new File('bitwise_or', [
            Expect.Simple('bitwise_or8safe', ['14', '57'], ['63']),
            Expect.Simple('bitwise_or8signedsafe', ['14', '57'], ['63']),
            Expect.Simple('bitwise_or8unsafe', ['14', '57'], ['63']),
            Expect.Simple('bitwise_or8signedunsafe', ['14', '57'], ['63']),
            Expect.Simple('bitwise_or256safe', ['14', '13', '57', '100'], ['63', '109']),
            Expect.Simple('bitwise_or256signedsafe', ['14', '13', '57', '100'], ['63', '109']),
            Expect.Simple('bitwise_or256unsafe', ['14', '13', '57', '100'], ['63', '109']),
            Expect.Simple('bitwise_or256signedunsafe', ['14', '13', '57', '100'], ['63', '109']),
          ]),
          new File('decrement', [
            Expect.Simple('preDecrementStatement', ['10'], ['9']),
            Expect.Simple('postDecrementStatement', ['10'], ['9']),
            Expect.Simple('preDecrementExpression', ['10'], ['9', '9']),
            Expect.Simple('postDecrementExpression', ['10'], ['10', '9']),
          ]),
          new File('division', [
            Expect.Simple('division8safe', ['100', '5'], ['20']),
            Expect.Simple('division8signedsafe', ['100', '5'], ['20']),
            Expect.Simple('division8unsafe', ['100', '5'], ['20']),
            Expect.Simple('division8signedunsafe', ['100', '5'], ['20']),
            Expect.Simple('division256safe', ['100', '20', '5', '0'], ['20', '4']),
            Expect.Simple('division256signedsafe', ['100', '20', '5', '0'], ['20', '4']),
            Expect.Simple('division256unsafe', ['100', '20', '5', '0'], ['20', '4']),
            Expect.Simple('division256signedunsafe', ['100', '20', '5', '0'], ['20', '4']),
          ]),
          new File('eq', [
            Expect.Simple('eq8safe', ['1', '2'], ['0']),
            Expect.Simple('eq8signedsafe', ['1', '1'], ['1']),
            Expect.Simple('eq8unsafe', ['1', '1'], ['1']),
            Expect.Simple('eq8signedunsafe', ['1', '2'], ['0']),
            Expect.Simple('eq256safe', ['1', '2', '1', '2'], ['1']),
            Expect.Simple('eq256signedsafe', ['1', '2', '3', '2'], ['0']),
            Expect.Simple('eq256unsafe', ['1', '2', '1', '3'], ['0']),
            Expect.Simple('eq256signedunsafe', ['1', '2', '1', '2'], ['1']),
          ]),
          new File('exp', [
            Expect.Simple('exp8safe', ['0', '0'], ['0']),
            Expect.Simple('exp8signedsafe', ['255', '10'], ['1']),
            Expect.Simple('exp8unsafe', ['100', '1'], ['100']),
            Expect.Simple('exp8signedunsafe', ['4', '3'], ['64']),
            Expect.Simple('exp256safe', ['0', '0', '1', '0'], ['0', '0']),
            Expect.Simple('exp256signedsafe', ['1000', '500', '0', '0'], ['1', '0']),
            Expect.Simple('exp256unsafe', ['2', '0', '3', '0'], ['8', '0']),
            Expect.Simple('exp256signedunsafe', ['0', '0', '0', '0'], ['0', '0']),
          ]),
          new File('ge', [
            Expect.Simple('ge8safe', ['1', '2'], ['0']),
            Expect.Simple('ge8signedsafe', ['255', '1'], ['0']),
            Expect.Simple('ge8unsafe', ['2', '1'], ['1']),
            Expect.Simple('ge8signedunsafe', ['5', '100'], ['0']),
            Expect.Simple('ge256safe', ['20', '3', '20', '3'], ['1']),
            Expect.Simple('ge256signedsafe', ['2', '3', '1', '4'], ['0']),
            Expect.Simple('ge256unsafe', ['1', '5', '3', '2'], ['1']),
            Expect.Simple('ge256signedunsafe', ['1', '1', '1', '1'], ['1']),
          ]),
          new File('gt', [
            Expect.Simple('gt8safe', ['1', '2'], ['0']),
            Expect.Simple('gt8signedsafe', ['255', '1'], ['0']),
            Expect.Simple('gt8unsafe', ['2', '1'], ['1']),
            Expect.Simple('gt8signedunsafe', ['5', '100'], ['0']),
            Expect.Simple('gt256safe', ['20', '3', '20', '3'], ['0']),
            Expect.Simple('gt256signedsafe', ['2', '3', '1', '4'], ['0']),
            Expect.Simple('gt256unsafe', ['1', '5', '3', '2'], ['1']),
            Expect.Simple('gt256signedunsafe', ['1', '1', '1', '1'], ['0']),
          ]),
          new File('increment', [
            Expect.Simple('preIncrementStatement', ['10'], ['11']),
            Expect.Simple('postIncrementStatement', ['10'], ['11']),
            Expect.Simple('preIncrementExpression', ['10'], ['11', '11']),
            Expect.Simple('postIncrementExpression', ['10'], ['10', '11']),
          ]),
          new File('le', [
            Expect.Simple('le8safe', ['1', '2'], ['1']),
            Expect.Simple('le8signedsafe', ['255', '1'], ['1']),
            Expect.Simple('le8unsafe', ['2', '1'], ['0']),
            Expect.Simple('le8signedunsafe', ['5', '100'], ['1']),
            Expect.Simple('le256safe', ['20', '3', '20', '3'], ['1']),
            Expect.Simple('le256signedsafe', ['2', '3', '1', '4'], ['1']),
            Expect.Simple('le256unsafe', ['1', '5', '3', '2'], ['0']),
            Expect.Simple('le256signedunsafe', ['1', '1', '1', '1'], ['1']),
          ]),
          new File('lt', [
            Expect.Simple('lt8safe', ['1', '2'], ['1']),
            Expect.Simple('lt8signedsafe', ['255', '1'], ['1']),
            Expect.Simple('lt8unsafe', ['2', '1'], ['0']),
            Expect.Simple('lt8signedunsafe', ['5', '100'], ['1']),
            Expect.Simple('lt256safe', ['20', '3', '20', '3'], ['0']),
            Expect.Simple('lt256signedsafe', ['2', '3', '1', '4'], ['1']),
            Expect.Simple('lt256unsafe', ['1', '5', '3', '2'], ['0']),
            Expect.Simple('lt256signedunsafe', ['1', '1', '1', '1'], ['0']),
          ]),
          new File('multiplication', [
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
            Expect.Simple('multiplication256signedsafe', ['20', '1', '5', '0'], ['100', '5']),
            Expect.Simple('multiplication256signedunsafe', ['20', '0', '5', '1'], ['100', '20']),
          ]),
          new File('neq', [
            Expect.Simple('neq8safe', ['1', '2'], ['1']),
            Expect.Simple('neq8signedsafe', ['1', '1'], ['0']),
            Expect.Simple('neq8unsafe', ['1', '1'], ['0']),
            Expect.Simple('neq8signedunsafe', ['1', '2'], ['1']),
            Expect.Simple('neq256safe', ['1', '2', '1', '2'], ['0']),
            Expect.Simple('neq256signedsafe', ['1', '2', '3', '2'], ['1']),
            Expect.Simple('neq256unsafe', ['1', '2', '1', '3'], ['1']),
            Expect.Simple('neq256signedunsafe', ['1', '2', '1', '2'], ['0']),
          ]),
          new File('shl', [
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
          ]),
          new File('shr', [
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
          ]),
          new File('subtraction', [
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
          new File('xor', [
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
          new File('dynamicArrays', [
            Expect.Simple('uint8writes', [], ['45']),
            Expect.Simple('uint256writes', [], ['45', '0']),
          ]),
        ]),
        new Dir('storage', [
          new File('scalars', [
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
        ]),
        new Dir('mangled_identifiers', [
          new File('free_function', [
            Expect.Simple('f', [], ['20']),
            Expect.Simple('s', [], ['10']),
          ]),
        ]),
        new Dir('delete', [
          // ---- "address" functionCall to cairo not implemented yet ----
          // new File('address', [
          //   Expect.Simple('f', [], ['23', '0']),
          // ]),

          // ---- ArrayType not implemented yet (fails on StorageAllocator) ----
          // new File('array_static', [
          //   new Expect('delete', [
          //     ['get', ['2', '0'], ['3', '0'], '0'],
          //     ['clearAt', ['2', '0'], [], '0'],
          //     ['get', ['2', '0'], ['0', '0'], '0'],
          //     ['get', ['0', '0'], ['1', '0'], '0'],
          //     ['clear', [], [], '0'],
          //     ['getLength', [], ['4', '0'], '0'],
          //     ['get', ['0', '0'], ['0', '0'], '0'],
          //   ]),
          // ]),

          // ---- ArrayType not implemented yet (fails on StorageAllocator) ----
          // new File('array_dynamic', [
          //   new Expect('delete', [
          //     ['initialize', [], [], '0'],
          //     ['clearAt', ['2', '0'], [], '0'],
          //     ['get', ['2', '0'], ['0', '0'], '0'],
          //     ['get', ['0', '0'], ['8', '0'], '0'],
          //     ['clear', [], [], '0'],
          //     ['getLength', [], ['0', '0'], '0'],
          //   ]),
          // ]),

          // ---- BoolType not implemented yet (fails on StorageAllocator) ----
          // new File('boolean', [
          //   Expect.Simple('boolean', [], ['0']),
          // ]),

          // ---- UserDefinedType not implemented yet (fails on StorageAllocator) ----
          // new File('enum', [
          //   new Expect('delete', [
          //     ['set', ['3'], [], '0'],
          //     ['reset', [], [], '0'],
          //     ['get', [], ['0'], '0'],
          //   ]),
          // ]),

          new File('int', [
            new Expect('delete', [
              ['totalSupply', [], ['100000000000000', '0'], '0'],
              ['reset', [], [], '0'],
              ['totalSupply', [], ['0', '0'], '0'],
              ['addValue', ['25', '0'], ['25', '0'], '0'],
            ]),
          ]),

          // ---- UserDefinedType not implemented yet (fails on StorageAllocator) ----
          // new File('struct', [
          //   new Expect('delete', [
          //     ['getRadious', [], ['5', '0'], '0'],
          //     ['reset', [], [], '0'],
          //     ['getRadious', [], ['0', '0'], '0'],
          //     ['getPoint', [], ['0', '0', '0', '0'], '0'],
          //   ]),
          // ]),
        ]),
      ]),
    ]),
  ]),
);

//-----------------------------------------------------------------------------

function flatten(test: Dir | File, filter?: string): File[] {
  if (test instanceof Dir) {
    return test.tests.flatMap((subTest) => {
      subTest.name = `${test.name}/${subTest.name}`;
      return flatten(subTest, filter);
    });
  } else {
    if (filter === undefined || test.name.includes(filter)) {
      return [test];
    } else {
      return [];
    }
  }
}
