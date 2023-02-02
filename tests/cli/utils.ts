import { sh } from '../util';
import * as path from 'path';

export const WALLET = 'starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount';
export const GATEWAY_URL = 'http://127.0.0.1:5050';
export const NETWORK = 'alpha-goerli';
export const STARKNET_ACCOUNT_DIR = path.resolve(__dirname, '.');
export const WARP_BIN = path.resolve(__dirname, '..', '..', 'bin', 'warp');
export const NETWORK_OPTIONS = `--network ${NETWORK} --feeder_gateway_url ${GATEWAY_URL} --gateway_url ${GATEWAY_URL}`;

export const TIME_LIMIT = 10 * 60 * 1000;
export const TX_FEE_ETH_REGEX = /max_fee: (.*) ETH/g;
export const TX_FEE_WEI_REGEX = /max_fee:.* ETH \((.*) WEI\)/g;
export const CONTRACT_ADDRESS_REGEX = /Contract address: (.*)/g;
export const CONTRACT_CLASS_REGEX = /Contract class hash: (.*)/g;
export const TX_HASH_REGEX = /Transaction hash: (.*)/g;

export function extractFromStdout(stdout: string, regex: RegExp) {
  return [...stdout.matchAll(regex)][0][1];
}

export async function mintEthToAccount(
  address: string,
): Promise<{ stdout: string; stderr: string }> {
  const res = await sh(
    `curl localhost:5050/mint -H "Content-Type: application/json" -d "{ \\"address\\": \\"${address}\\", \\"amount\\": 1000000000000000000, \\"lite\\": false }"`,
  );
  return res;
}
