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
      inputs.forEach(BigInt);
      returns !== null && returns.forEach(BigInt);
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
        new Dir('maths', [
          new File('uint256', [
            Expect.Simple('addition', [], ['42', '0']),
            Expect.Simple('multiplication', [], ['28782', '0']),
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
      ]),
    ]),
  ]),
);

//-----------------------------------------------------------------------------

function flatten(test: Dir | File): File[] {
  if (test instanceof Dir) {
    return test.tests.flatMap((subTest) => {
      subTest.name = `${test.name}/${subTest.name}`;
      return flatten(subTest);
    });
  } else {
    return [test];
  }
}
