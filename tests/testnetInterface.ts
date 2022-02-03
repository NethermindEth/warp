import axios from 'axios';
import { BigNumber } from 'ethers';

export type InvokeResponse =
  | {
      status: number;
      steps: number;
      threw: false;
      return_data: string[];
    }
  | {
      status: number;
      steps: null;
      threw: true;
      return_data: null;
    };

// Returns address of deployed contract or throws
export async function deploy(jsonPath: string, input: string[]): Promise<string> {
  const response = await axios.post('http://127.0.0.1:5000/deploy', {
    compiled_cairo: jsonPath,
    input,
  });

  return BigNumber.from(response.data.contract_address)._hex;
}

export async function invoke(
  address: string,
  functionName: string,
  input: string[],
  caller_address = '0',
): Promise<InvokeResponse> {
  const response = await axios.post('http://127.0.0.1:5000/invoke', {
    address: address,
    function: functionName,
    input,
    caller_address,
  });

  return response.data.transaction_info.threw
    ? {
        status: response.status,
        steps: null,
        threw: true,
        return_data: null,
      }
    : {
        status: response.status,
        steps: response.data.execution_info?.steps ?? null,
        threw: false,
        return_data: response.data.transaction_info.return_data,
      };
}

export async function ensureTestnetContactable(timeout: number): Promise<boolean> {
  let keepGoing = true;
  setTimeout(() => (keepGoing = false), timeout);
  const axiosInstance = axios.create({
    validateStatus: null,
  });
  while (keepGoing) {
    try {
      const response = await axiosInstance.get('http://127.0.0.1:5000/ping');
      if (response.status >= 200 && response.status < 300) break;
    } catch (e) {
      // We purposefully catch and discard any errors and try again until timeout
    }
  }
  return keepGoing;
}
