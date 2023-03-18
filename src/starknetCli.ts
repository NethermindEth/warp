import assert from 'assert';
import os from 'os';
import * as path from 'path';
import Bottleneck from 'bottleneck';
import {
  IDeployProps,
  ICallOrInvokeProps,
  IGatewayProps,
  IOptionalNetwork,
  IDeployAccountProps,
  IOptionalDebugInfo,
  IDeclareOptions,
  StarknetNewAccountOptions,
} from './cli';
import { CLIError, logError } from './utils/errors';
import {
  catchExecaError,
  execFileAsync,
  execFileAsyncAndLog,
  runStarknetClassHash,
} from './utils/utils';
import { encodeInputs } from './transcode/encode';
import { decodeOutputs } from './transcode/decode';
import { decodedOutputsToString } from './transcode/utils';

// Options of StarkNet cli commands
const GATEWAY_URL = 'gateway_url';
const FEEDER_GATEWAY_URL = 'feeder_gateway_url';
const ACCOUNT = 'account';
const ACCOUNT_DIR = 'account_dir';
const MAX_FEE = 'max_fee';
const NETWORK = 'network';
const WALLET = 'wallet';

const compilationBottleneck = new Bottleneck({ maxConcurrent: Math.max(os.cpus().length - 1, 1) });

type CompileResult =
  | {
      success: true;
      resultPath: string;
      abiPath: string;
      solAbiPath: string;
      classHash?: string;
    }
  | {
      success: false;
      resultPath: undefined;
      abiPath: undefined;
      solAbiPath: undefined;
      classHash?: string;
    };

export async function enqueueCompileCairo(
  filePath: string,
  cairoPath: string = path.resolve(__dirname, '..'),
  debugInfo: IOptionalDebugInfo = { debugInfo: false },
): Promise<CompileResult> {
  return compilationBottleneck.schedule(() => compileCairo(filePath, cairoPath, debugInfo));
}

export async function compileCairo(
  filePath: string,
  cairoPath: string = path.resolve(__dirname, '..'),
  debugInfo: IOptionalDebugInfo = { debugInfo: false },
): Promise<CompileResult> {
  assert(filePath.endsWith('.cairo'), `Attempted to compile non-cairo file ${filePath} as cairo`);
  const cairoPathRoot = filePath.slice(0, -'.cairo'.length);
  const resultPath = `${cairoPathRoot}_compiled.json`;
  const abiPath = `${cairoPathRoot}_abi.json`;
  const solAbiPath = `${cairoPathRoot}_sol_abi.json`;

  const cairoPathOption = cairoPath !== '' ? ['--cairo_path', cairoPath] : [];
  const debug = debugInfo.debugInfo ? '--debug_info_with_source' : '--no_debug_info';
  try {
    console.log(`Running starknet compile with cairoPath ${cairoPath}`);
    await execFileAsync('starknet-compile', [
      '--disable_hint_validation',
      debug,
      filePath,
      '--output',
      resultPath,
      '--abi',
      abiPath,
      ...cairoPathOption,
    ]);
    return { success: true, resultPath, abiPath, solAbiPath, classHash: undefined };
  } catch (e) {
    logError(catchExecaError(e, 'starknet-compile'));
    return {
      success: false,
      resultPath: undefined,
      abiPath: undefined,
      solAbiPath: undefined,
      classHash: undefined,
    };
  }
}

export async function runStarknetCompile(filePath: string, debug_info: IOptionalDebugInfo) {
  const { success, resultPath } = await enqueueCompileCairo(
    filePath,
    path.resolve(__dirname, '..'),
    debug_info,
  );
  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  }
  console.log(`starknet-compile output written to ${resultPath}`);
}

export async function runStarknetStatus(tx_hash: string, option: IOptionalNetwork & IGatewayProps) {
  if (option.network === undefined) {
    logError(
      `Error: Exception: feeder_gateway_url must be specified with the "status" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
    return;
  }

  const gatewayUrlOption = optionalArg(GATEWAY_URL, option);
  const feederGatewayUrlOption = optionalArg(FEEDER_GATEWAY_URL, option);

  await execFileAsyncAndLog('starknet', [
    'tx_status',
    '--hash',
    tx_hash,
    '--network',
    option.network,
    ...gatewayUrlOption,
    ...feederGatewayUrlOption,
  ]);
}

export async function runStarknetDeploy(filePath: string, options: IDeployProps) {
  if (options.network === undefined) {
    logError(
      `Error: Exception: feeder_gateway_url must be specified with the "deploy" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
    return;
  }
  // Shouldn't be fixed to warp_output (which is the default)
  // such option does not exists currently when deploying, should be added
  let compileResult;
  try {
    compileResult = await enqueueCompileCairo(filePath, path.resolve(__dirname, '..'), options);
  } catch (e) {
    if (e instanceof CLIError) {
      logError(e.message);
    }
    throw e;
  }
  if (!compileResult.success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  }

  let inputsOption: string[];
  try {
    const inputs = (
      await encodeInputs(
        compileResult.solAbiPath,
        'constructor',
        options.use_cairo_abi,
        options.inputs,
      )
    )[1];
    inputsOption = inputs ? ['--inputs', ...inputs.split(' ')] : [];
  } catch (e) {
    if (e instanceof CLIError) {
      logError(e.message);
      return;
    }
    throw e;
  }

  let classHash;
  if (!options.no_wallet) {
    classHash = await runStarknetClassHash(compileResult.resultPath);
  }

  const classHashOption = classHash ? ['--class_hash', classHash] : [];
  const gatewayUrlOption = optionalArg(GATEWAY_URL, options);
  const feederGatewayUrlOption = optionalArg(FEEDER_GATEWAY_URL, options);
  const accountOption = optionalArg(ACCOUNT, options);
  const accountDirOption = optionalArg(ACCOUNT_DIR, options);
  const maxFeeOption = optionalArg(MAX_FEE, options);
  const resultPath = compileResult.resultPath;
  await execFileAsyncAndLog('starknet', [
    'deploy',
    '--network',
    options.network,
    ...(options.no_wallet
      ? ['--no_wallet', '--contract', resultPath]
      : options.wallet !== undefined
      ? [...classHashOption, '--wallet', options.wallet]
      : classHashOption),
    ...inputsOption,
    ...accountOption,
    ...gatewayUrlOption,
    ...feederGatewayUrlOption,
    ...accountDirOption,
    ...maxFeeOption,
  ]);
}

export async function runStarknetDeployAccount(options: IDeployAccountProps) {
  if (options.wallet === undefined) {
    logError(
      `Error: AssertionError: --wallet must be specified with the "deploy_account" subcommand.`,
    );
    return;
  }
  if (options.network === undefined) {
    logError(
      `Error: Exception: network must be specified with the "deploy_account" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
    return;
  }

  const gatewayUrlOption = optionalArg(GATEWAY_URL, options);
  const feederGatewayUrlOption = optionalArg(FEEDER_GATEWAY_URL, options);
  const accountOption = optionalArg(ACCOUNT, options);
  const accountDirOption = optionalArg(ACCOUNT_DIR, options);
  const maxFeeOption = optionalArg(MAX_FEE, options);

  await execFileAsyncAndLog('starknet', [
    'deploy_account',
    '--wallet',
    options.wallet,
    '--network',
    options.network,
    ...accountOption,
    ...gatewayUrlOption,
    ...feederGatewayUrlOption,
    ...accountDirOption,
    ...maxFeeOption,
  ]);
}

export async function runStarknetCallOrInvoke(
  filePath: string,
  isCall: boolean,
  options: ICallOrInvokeProps,
) {
  const callOrInvoke = isCall ? 'call' : 'invoke';

  if (options.network === undefined) {
    logError(
      `Error: Exception: network must be specified with the "${callOrInvoke}" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
    return;
  }

  const wallet = options.wallet !== undefined ? ['--wallet', options.wallet] : ['--no_wallet'];
  const gatewayUrlOption = optionalArg(GATEWAY_URL, options);
  const feederGatewayUrlOption = optionalArg(FEEDER_GATEWAY_URL, options);
  const accountOption = optionalArg(ACCOUNT, options);
  const accountDirOption = optionalArg(ACCOUNT_DIR, options);
  const maxFeeOption = optionalArg(MAX_FEE, options);

  const { success, abiPath, solAbiPath } = await enqueueCompileCairo(
    filePath,
    path.resolve(__dirname, '..'),
  );
  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  }

  let funcName, inputs: string;
  let inputsOption: string[];
  try {
    [funcName, inputs] = await encodeInputs(
      solAbiPath,
      options.function,
      options.use_cairo_abi,
      options.inputs,
    );
    inputsOption = inputs ? ['--inputs', ...inputs.split(' ')] : [];
  } catch (e) {
    if (e instanceof CLIError) {
      logError(e.message);
      return;
    }
    throw e;
  }
  try {
    let warpOutput: string = (
      await execFileAsync('starknet', [
        callOrInvoke,
        '--address',
        options.address,
        '--abi',
        abiPath,
        '--function',
        funcName,
        '--network',
        options.network,
        ...wallet,
        ...accountOption,
        ...inputsOption,
        ...gatewayUrlOption,
        ...feederGatewayUrlOption,
        ...accountDirOption,
        ...maxFeeOption,
      ])
    ).stdout;

    if (isCall && !options.use_cairo_abi) {
      const decodedOutputs = await decodeOutputs(
        solAbiPath,
        options.function,
        warpOutput.toString().split(' '),
      );
      warpOutput = decodedOutputsToString(decodedOutputs);
    }
    console.log(warpOutput);
  } catch (e) {
    logError(catchExecaError(e, `starknet ${callOrInvoke}`));
  }
}

async function declareContract(filePath: string, options: IDeclareOptions) {
  // wallet check
  if (!options.no_wallet) {
    if (options.wallet === undefined) {
      logError(
        'A wallet must be specified (using --wallet or the STARKNET_WALLET environment variable), unless specifically using --no_wallet.',
      );
      return;
    }
  }
  // network check
  if (options.network === undefined) {
    logError(
      `Error: Exception: feeder_gateway_url must be specified with the declare command.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
    return;
  }

  const networkOption = optionalArg(NETWORK, options);
  const walletOption = options.no_wallet ? ['--no_wallet'] : optionalArg(WALLET, options);
  const accountOption = optionalArg(ACCOUNT, options);
  const gatewayUrlOption = optionalArg(GATEWAY_URL, options);
  const feederGatewayUrlOption = optionalArg(FEEDER_GATEWAY_URL, options);
  const accountDirOption = optionalArg(ACCOUNT_DIR, options);
  const maxFeeOption = optionalArg(MAX_FEE, options);

  await execFileAsyncAndLog('starknet', [
    'declare',
    '--contract',
    filePath,
    ...networkOption,
    ...walletOption,
    ...accountOption,
    ...gatewayUrlOption,
    ...feederGatewayUrlOption,
    ...accountDirOption,
    ...maxFeeOption,
  ]);
}

export async function runStarknetDeclare(filePath: string, options: IDeclareOptions) {
  const { success, resultPath } = await enqueueCompileCairo(
    filePath,
    path.resolve(__dirname, '..'),
  );
  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  } else {
    await declareContract(resultPath, options);
  }
}

export async function runStarknetNewAccount(options: StarknetNewAccountOptions) {
  const networkOption = optionalArg(NETWORK, options);
  const walletOption = optionalArg(WALLET, options);
  const accountOption = optionalArg(ACCOUNT, options);

  const gatewayUrlOption = optionalArg(GATEWAY_URL, options);
  const feederGatewayUrlOption = optionalArg(FEEDER_GATEWAY_URL, options);
  const accountDirOption = optionalArg(ACCOUNT_DIR, options);
  await execFileAsyncAndLog('starknet', [
    'new_account',
    ...networkOption,
    ...walletOption,
    ...accountOption,
    ...gatewayUrlOption,
    ...feederGatewayUrlOption,
    ...accountDirOption,
  ]);
}

export function processDeclareCLI(result: string, filePath: string): string {
  const splitter = new RegExp('[ ]+');
  // Extract the hash from result
  const classHash = result
    .split('\n')
    .map((line) => {
      const [contractT, classT, hashT, hash, ...others] = line.split(splitter);
      if (contractT === 'Contract' && classT === 'class' && hashT === 'hash:') {
        if (others.length !== 0) {
          throw new CLIError(
            `Error while parsing the 'declare' output of ${filePath}. Malformed lined.`,
          );
        }
        return hash;
      }
      return null;
    })
    .filter((val) => val !== null)[0];

  if (classHash === null || classHash === undefined)
    throw new CLIError(
      `Error while parsing the 'declare' output of ${filePath}. Couldn't find the class hash.`,
    );
  return classHash;
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
function optionalArg(name: string, options: any) {
  const value = options[name];
  return value ? [`--${name}`, `${value}`] : [];
}
