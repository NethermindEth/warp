import * as fs from 'fs';
import assert from 'assert';
import { exec } from 'child_process';

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

export function transpile(contractPath: string) {
  return sh(`bin/warp transpile ${contractPath} --strict`);
}

export function starknetCompile(cairoPath: string, jsonOutputPath: string) {
  return sh(`starknet-compile --cairo_path warp_output ${cairoPath} --output ${jsonOutputPath}`);
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
