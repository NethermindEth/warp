import axios from 'axios';
import { BigNumber } from 'ethers';

export type DeployResponse = {
  status: number;
  address: string;
};

export type InvokeResponse = {
  status: number;
  return_data: number[];
};

export async function deploy(jsonPath: string): Promise<DeployResponse> {
  const response = await axios.post('http://127.0.0.1:5000/deploy', {
    tx_type: 'deploy',
    compiled_cairo: jsonPath,
    input: [],
  });

  return {
    status: response.status,
    address: BigNumber.from(response.data.contract_address)._hex,
  };
}

// TODO add inputs
export async function invoke(address: string, functionName: string): Promise<InvokeResponse> {
  const response = await axios.post('http://127.0.0.1:5000/invoke', {
    tx_type: 'invoke',
    address: address,
    function: functionName,
    input: [],
  });

  return {
    status: response.status,
    return_data: response.data.transaction_info.return_data,
  };
}
