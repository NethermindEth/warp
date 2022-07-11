import * as fs from 'fs';
import * as path from 'path';
import assert from 'assert';
import { exec } from 'child_process';
import { expect } from 'chai';

export async function sh(cmd: string): Promise<{ stdout: string; stderr: string }> {
  return new Promise(function (resolve, reject) {
    exec(cmd, (err, stdout, stderr) => {
      if (err) {
        reject(err);
      } else {
        resolve({ stdout, stderr });
      }
    });
  });
}

const warpBin = path.resolve(__dirname, '..', 'bin', 'warp');
const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;

export function transpile(contractPath: string): Promise<{ stdout: string; stderr: string }> {
  return sh(`${warpBin} transpile ${contractPath}`);
}

export function starknetCompile(
  cairoPath: string,
  jsonOutputPath: string,
): Promise<{ stdout: string; stderr: string }> {
  return sh(
    `${warpVenvPrefix} starknet-compile --cairo_path warp_output ${cairoPath} --output ${jsonOutputPath}`,
  );
}

export function batchPromises<In, Out>(
  inputs: In[],
  parallelCount: number,
  func: (i: In) => Promise<Out>,
): SafePromise<Out>[] {
  const unwrappedPromises: Promise<Out>[] = [];

  for (let i = 0; i < inputs.length; ++i) {
    if (i < parallelCount) {
      unwrappedPromises.push(func(inputs[i]));
    } else {
      unwrappedPromises.push(
        unwrappedPromises[i - parallelCount].then(
          () => func(inputs[i]),
          () => func(inputs[i]),
        ),
      );
    }
  }

  return unwrappedPromises.map(wrapPromise);
}

export type SafePromise<T> = Promise<
  { success: true; result: T } | { success: false; result: unknown }
>;

export function wrapPromise<T>(promise: Promise<T>): SafePromise<T> {
  return promise.then(
    (res) => ({ success: true, result: res }),
    (reason) => ({ success: false, result: reason }),
  );
}

export function cleanupSync(path: string): void {
  if (fs.existsSync(path)) {
    fs.unlinkSync(path);
  }
}

export function validateInput(input: string): void {
  const num = BigInt(input);
  assert(
    num >= 0n,
    "Negative numbers should not be passed to tests, please convert to two's complement",
  );
}

export function processArgs(
  name: string,
  args: string[],
  deployedAddresses: Map<string, { address: string; hash: string }>,
): string[] {
  return args.flatMap((arg) => {
    if (arg.startsWith('address@')) {
      arg = arg.replace('address@', '');
      const value = deployedAddresses.get(arg);
      if (value === undefined) {
        expect.fail(`${name} failed, cannot find address ${arg}`);
      }
      return BigInt(value.address).toString();
    } else if (arg.startsWith('hash@')) {
      arg = arg.replace('hash@', '');
      const value = deployedAddresses.get(arg);
      if (value === undefined) {
        expect.fail(`${name} failed, cannot find address ${arg}`);
      }
      const low = BigInt(value.hash) % 2n ** 128n;
      const high = BigInt(value.hash) / 2n ** 128n;
      return [low.toString(), high.toString()];
    }
    return arg;
  });
}
export function hashToUint256(hash: string): [string, string] {
  const bigintHash = [...hash].reduce((acc, c) => acc * 256n + BigInt(c.charCodeAt(0)), 0n);

  const high = bigintHash / 2n ** 128n;
  const low = bigintHash % 2n ** 128n;
  return [low.toString(10), high.toString(10)];
}
