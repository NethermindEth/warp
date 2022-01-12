import axios, { AxiosResponse } from 'axios';
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

export async function starknet_deploy(
  inputs: string[],
  cairo_contract: string,
  program_info: string,
): Promise<AxiosResponse<any, any>> {
  const response = await axios.post('http://localhost:5000/gateway/add_transaction', {
    tx_type: 'deploy',
    cairo_contract: cairo_contract,
    program_info: program_info,
    input: inputs,
  });
  return response;
}

export async function transpile(contractPath: string, mainContract: string) {
  await sh(
    `warp transpile --cairo-output ${contractPath} ${mainContract}`,
  );
  await sh(`warp transpile ${contractPath} ${mainContract}`);
}
