import assert = require('assert');
import axios, { AxiosResponse } from 'axios';
import { exec } from 'child_process';
import * as fs from 'fs';

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

export async function starknet_invoke(
  address: string,
  functionName: string,
  inputs: string[],
  cairo_contract: string,
  program_info: string,
): Promise<AxiosResponse<any, any>> {
  const response = await axios.post('http://localhost:5000/gateway/add_transaction', {
    tx_type: 'invoke',
    address: address,
    function: functionName,
    cairo_contract: cairo_contract,
    program_info: program_info,
    input: inputs,
  });
  return response;
}

export function initialiseArtifactsDirectory() {
  if (fs.existsSync('tests/artifacts')) {
    fs.rmdirSync('tests/artifacts', { recursive: true });
  }
  fs.mkdirSync('tests/artifacts');
}

export function transpile(contractPath: string, cairoOutputPath: string) {
  return sh(`bin/warp transpile ${contractPath} --output ${cairoOutputPath}`);
}

export function starknetCompile(cairoPath: string, jsonOutputPath: string) {
  return sh(`starknet-compile ${cairoPath} --output ${jsonOutputPath}`);
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
