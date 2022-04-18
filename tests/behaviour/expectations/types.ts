import assert from 'assert';
import { mangleContractFilePath } from '../../../src/passes/sourceUnitSplitter';
import { stringFlatten } from './utils';

export class AsyncTest {
  constructor(
    public name: string,
    public contract: string,
    public constructorArgs: string[],
    public expectations: Promise<Expect[]> | Expect[],
  ) {}

  get sol() {
    return `${this.name}.sol`;
  }
  get cairo() {
    return `warp_output/${mangleContractFilePath(this.name, this.contract)}.cairo`;
  }
  get compiled() {
    return `warp_output/${mangleContractFilePath(this.name, this.contract)}.json`;
  }

  static fromSync(test: File): AsyncTest {
    return new AsyncTest(test.name, test.contract, test.constructorArgs, test.expectations);
  }
}

export type Value = number | Value[] | string;

export class Dir {
  constructor(public name: string, public tests: (Dir | File)[]) {}
}

export class File {
  constructor(
    public name: string,
    public contract: string,
    public constructorArgs: string[],
    public expectations: Expect[],
  ) {}

  static Simple(name: string, expectations: Expect[], contract?: string) {
    return new File(name, contract ?? 'WARP', [], expectations);
  }
}

export class Expect {
  public steps: [
    func: string,
    inputs: string[],
    returns: string[] | null,
    caller_address: string,
    error_message?: string,
  ][];
  constructor(
    public name: string,
    steps: [
      func: string,
      inputs: Value[],
      returns: Value[] | null,
      caller_address: string,
      error_message?: string,
    ][],
  ) {
    this.steps = steps.map(([func, inputs, returns, caller_address, error_message]) => {
      if (func === 'constructor')
        assert(
          returns === null,
          `Expected return value for failing constructor tests should be null`,
        );
      return [
        func,
        stringFlatten(inputs),
        returns !== null ? stringFlatten(returns) : null,
        caller_address,
        error_message,
      ];
    });
  }
  static Simple(name: string, inputs: string[], returns: string[] | null, tag?: string): Expect {
    return new Expect(tag ? `${name}: ${tag}` : name, [[name, inputs, returns, '0']]);
  }
}
