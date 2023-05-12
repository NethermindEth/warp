/* eslint-disable */

import { BigNumber } from 'ethers';
import { EventItem } from '../src/export';
import axios from 'axios';
import { execSync } from 'child_process';

import { DEVNET_URL } from './config';

export function starknetCliCall(command: string, args: string): string {
  return `starknet ${command} --gateway_url ${DEVNET_URL} --feeder_gateway_url ${DEVNET_URL} ${args}`;
}

export type InvokeResponse =
  | {
      status: number;
      steps: null;
      threw: false;
      return_data: string[];
      error_message: undefined;
      events: EventItem[];
    }
  | {
      status: number;
      steps: null;
      threw: true;
      return_data: null;
      error_message: string;
      events: EventItem[];
    };

export type DeployResponse =
  | {
      status: number;
      steps: null;
      threw: false;
      class_hash: string;
      contract_address: string;
      error_message: undefined;
    }
  | {
      status: number;
      steps: null;
      threw: true;
      class_hash: null;
      contract_address: null;
      error_message: string;
    };

export type DeclareResponse =
  | {
      status: number;
      threw: false;
      class_hash: string;
      error_message: undefined;
    }
  | {
      status: number;
      threw: true;
      class_hash: null;
      error_message: string;
    };

export async function declare(jsonPath: string): Promise<DeclareResponse> {
  let hash;
  try {
    const buffer = await execSync(starknetCliCall('declare', `--contract ${jsonPath}`));
    const result = buffer.toString();
    const regex = /Contract class hash: (.*)\n/g;
    hash = regex.exec(result);
  } catch (e: any) {
    const regexAlreadyDeclared =
      /\{"code":"StarknetErrorCode.CLASS_ALREADY_DECLARED","message":"Class with hash (.*) is already declared./g;
    hash = regexAlreadyDeclared.exec(e.stderr);
  }

  return hash === null
    ? {
        status: 500,
        threw: true,
        class_hash: null,
        error_message: 'result',
      }
    : {
        status: 200,
        threw: false,
        class_hash: hash[1],
        error_message: undefined,
      };
}

export async function deploy(jsonPath: string, input: string[]): Promise<DeployResponse> {
  const declared = await declare(jsonPath);
  if (declared.threw === true) {
    return {
      status: 500,
      steps: null,
      threw: true,
      class_hash: null,
      contract_address: null,
      error_message: declared.error_message,
    };
  }

  const buffer = await execSync(starknetCliCall('deploy', `--class_hash ${declared.class_hash}`));
  const result = buffer.toString();
  const regex = /Contract address: (.*)\n/g;
  const matches = regex.exec(result);

  return matches === null
    ? {
        status: 500,
        steps: null,
        threw: true,
        class_hash: null,
        contract_address: null,
        error_message: result,
      }
    : {
        status: 200,
        steps: null,
        threw: false,
        class_hash: declared.class_hash,
        contract_address: BigNumber.from(matches[1])._hex,
        error_message: undefined,
      };
}

export async function invoke(
  address: string,
  functionName: string,
  input: string[],
  caller_address = '0',
): Promise<InvokeResponse> {
  const buffer = await execSync(
    starknetCliCall(
      'invoke',
      `--function ${functionName} --inputs ${input.join(' ')} --address ${address}`,
    ),
  );
  const result = buffer.toString();
  const regex = /Transaction hash: (.*)\n/g;
  const matches = regex.exec(result);
  if (matches === null) {
    return {
      status: 500,
      steps: null,
      threw: true,
      return_data: null,
      error_message: result,
      events: [],
    };
  }
  const transactionAsBuffer = await execSync(
    starknetCliCall('get_transaction_trace', `--hash ${matches[1]}`),
  );
  const transaction = JSON.parse(transactionAsBuffer.toString());

  return {
    status: 200,
    steps: null,
    threw: false,
    return_data: transaction.function_invocation.result,
    error_message: undefined,
    events: transaction.function_invocation.events,
  };
}

export async function ensureTestnetContactable(timeout: number): Promise<boolean> {
  return Promise.resolve(true);
  // let keepGoing = true;
  // setTimeout(() => (keepGoing = false), timeout);
  // const axiosInstance = axios.create({
  //   validateStatus: null,
  // });
  // while (keepGoing) {
  //   try {
  //     const response = await axiosInstance.get('http://127.0.0.1:5000/ping');
  //     if (response.status >= 200 && response.status < 300) break;
  //   } catch (e) {
  //     // We purposefully catch and discard any errors and try again until timeout
  //   }
  // }
  // return keepGoing;
}
