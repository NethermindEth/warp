import assert from 'assert';
import util from 'util';
import os from 'os';
import * as path from 'path';
import { exec, ExecOptions } from 'child_process';
import Bottleneck from 'bottleneck';
import {
  IDeployProps,
  ICallOrInvokeProps,
  IGatewayProps,
  IOptionalNetwork,
  IDeployAccountProps,
  IOptionalDebugInfo,
  IDeclareOptions,
  StarkNetNewAccountOptions,
} from './cli';
import { CLIError, logError } from './utils/errors';
import { runStarkNetClassHash } from './utils/utils';
import { encodeInputs } from './transcode/encode';
import { decodeOutputs } from './transcode/decode';
import { decodedOutputsToString } from './transcode/utils';

const _execAsync = util.promisify(exec);
async function execAsync(
  cmd: string,
  options: { encoding?: BufferEncoding } & ExecOptions & { log?: boolean } = {},
): Promise<{ stdout: string; stderr: string }> {
  if (options.encoding === undefined) options.encoding = 'utf8';

  try {
    let { stdout, stderr } = await _execAsync(cmd, options);

    // removing newline
    stdout = stdout.slice(0, -1);
    stderr = stderr.slice(0, -1);

    if (options.log) {
      if (stdout) console.log(stdout);
      if (stderr) console.error(stderr);
    }

    return { stdout, stderr };
  } catch (err) {
    let { stdout, stderr } = err as { stdout: string; stderr: string };

    // removing newline
    stdout = stdout.slice(0, -1);
    stderr = stderr.slice(0, -1);

    if (options.log) {
      if (stdout) console.log(stdout);
      if (stderr) console.error(stderr);
    }

    throw err;
  }
}

const compilationBottleneck = new Bottleneck({ maxConcurrent: os.cpus().length });
const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;

interface CompileResult {
  success: boolean;
  resultPath?: string;
  abiPath?: string;
  solAbiPath?: string;
  classHash?: string;
}

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
  const parameters = new Map([
    ['output', resultPath],
    ['abi', abiPath],
  ]);
  if (cairoPath !== '') {
    parameters.set('cairo_path', cairoPath);
  }
  const debug: string = debugInfo.debugInfo ? '--debug_info_with_source' : '--no_debug_info';
  try {
    console.log(`Running starknet compile with cairoPath ${cairoPath}`);
    await execAsync(
      `${warpVenvPrefix} starknet-compile --disable_hint_validation ${debug} ${filePath} ${[
        ...parameters.entries(),
      ]
        .map(([key, value]) => `--${key} ${value}`)
        .join(' ')}`,
      {
        log: true,
      },
    );

    return { success: true, resultPath, abiPath, solAbiPath, classHash: undefined };
  } catch (e) {
    if (e instanceof Error) {
      logError('Compile failed');
      return {
        success: false,
        resultPath: undefined,
        abiPath: undefined,
        solAbiPath: undefined,
        classHash: undefined,
      };
    } else {
      throw e;
    }
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

  const gatewayUrlOption = option.gateway_url ? `--gateway_url ${option.gateway_url}` : '';
  const feederGatewayUrlOption = option.feeder_gateway_url
    ? `--feeder_gateway_url ${option.feeder_gateway_url}`
    : '';

  try {
    await execAsync(
      `${warpVenvPrefix} starknet tx_status --hash ${tx_hash} --network ${option.network} ${gatewayUrlOption} ${feederGatewayUrlOption}`.trim(),
      {
        log: true,
      },
    );
  } catch {
    logError('starknet tx_status failed');
  }
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

  let inputs: string;
  try {
    inputs = (
      await encodeInputs(
        compileResult.solAbiPath ?? '',
        'constructor',
        options.use_cairo_abi,
        options.inputs,
      )
    )[1];
    inputs = inputs ? `--inputs ${inputs}` : inputs;
  } catch (e) {
    if (e instanceof CLIError) {
      logError(e.message);
      return;
    }
    throw e;
  }

  try {
    let classHash;
    if (!options.no_wallet) {
      assert(compileResult.resultPath !== undefined, 'resultPath should not be undefined');
      classHash = runStarkNetClassHash(compileResult.resultPath);
    }
    const classHashOption = classHash ? `--class_hash ${classHash}` : '';
    const gatewayUrlOption = options.gateway_url ? `--gateway_url ${options.gateway_url}` : '';
    const feederGatewayUrlOption = options.feeder_gateway_url
      ? `--feeder_gateway_url ${options.feeder_gateway_url}`
      : '';
    const accountDirOption = options.account_dir ? `--account_dir ${options.account_dir}` : '';
    const maxFeeOption = options.max_fee ? `--max_fee ${options.max_fee}` : '';
    const resultPath = compileResult.resultPath;
    await execAsync(
      `${warpVenvPrefix} starknet deploy --network ${options.network} ${
        options.no_wallet
          ? `--no_wallet --contract ${resultPath} `
          : options.wallet === undefined
          ? `${classHashOption}`
          : `${classHashOption} --wallet ${options.wallet}`
      } ${inputs} ${
        options.account !== undefined ? `--account ${options.account}` : ''
      } ${gatewayUrlOption} ${feederGatewayUrlOption} ${accountDirOption} ${maxFeeOption}`,
      {
        log: true,
      },
    );
  } catch (err) {
    logError(`starknet deploy failed ${err}`);
  }
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

  const account = options.account ? `--account ${options.account}` : '';

  try {
    await execAsync(
      `${warpVenvPrefix} starknet deploy_account --wallet ${options.wallet} --network ${
        options.network
      } ${account} ${options.gateway_url ? `--gateway_url ${options.gateway_url}` : ''} ${
        options.feeder_gateway_url ? `--feeder_gateway_url ${options.feeder_gateway_url}` : ''
      } ${options.account_dir ? `--account_dir ${options.account_dir}` : ''} ${
        options.max_fee ? `--max_fee ${options.max_fee}` : ''
      }`,
      {
        log: true,
      },
    );
  } catch (err) {
    logError(`starknet deploy failed ${err}`);
    console.log(err);
  }
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

  const wallet = options.wallet === undefined ? '--no_wallet' : `--wallet ${options.wallet}`;
  const account = options.account ? `--account ${options.account}` : '';

  const gatewayUrlOption = options.gateway_url ? `--gateway_url ${options.gateway_url}` : '';
  const feederGatewayUrlOption = options.feeder_gateway_url
    ? `--feeder_gateway_url ${options.feeder_gateway_url}`
    : '';
  const accountDirOption = options.account_dir ? `--account_dir ${options.account_dir}` : '';
  const maxFeeOption = options.max_fee ? `--max_fee ${options.max_fee}` : '';

  const { success, abiPath, solAbiPath } = await enqueueCompileCairo(
    filePath,
    path.resolve(__dirname, '..'),
  );
  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  }

  let funcName, inputs: string;
  try {
    [funcName, inputs] = await encodeInputs(
      `${solAbiPath}`,
      options.function,
      options.use_cairo_abi,
      options.inputs,
    );
    inputs = inputs ? `--inputs ${inputs}` : inputs;
  } catch (e) {
    if (e instanceof CLIError) {
      logError(e.message);
      return;
    }
    throw e;
  }
  try {
    let warpOutput: string = (
      await execAsync(
        `${warpVenvPrefix} starknet ${callOrInvoke} --address ${options.address} --abi ${abiPath} --function ${funcName} --network ${options.network} ${wallet} ${account} ${inputs} ${gatewayUrlOption} ${feederGatewayUrlOption} ${accountDirOption} ${maxFeeOption}`.trim(),
      )
    ).stdout;

    if (isCall && !options.use_cairo_abi) {
      const decodedOutputs = await decodeOutputs(
        solAbiPath ?? '',
        options.function,
        warpOutput.toString().split(' '),
      );
      warpOutput = decodedOutputsToString(decodedOutputs);
    }
    console.log(warpOutput);
  } catch {
    logError(`starknet ${callOrInvoke} failed`);
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
  const networkOption = options.network ? `--network ${options.network}` : ``;
  const walletOption = options.no_wallet
    ? '--no_wallet'
    : options.wallet !== undefined
    ? `--wallet ${options.wallet}`
    : ``;
  const accountOption = options.account ? `--account ${options.account}` : '';

  const gatewayUrlOption = options.gateway_url ? `--gateway_url ${options.gateway_url}` : '';
  const feederGatewayUrlOption = options.feeder_gateway_url
    ? `--feeder_gateway_url ${options.feeder_gateway_url}`
    : '';
  const accountDirOption = options.account_dir ? `--account_dir ${options.account_dir}` : '';
  const maxFeeOption = options.max_fee ? `--max_fee ${options.max_fee}` : '';

  try {
    await execAsync(
      `${warpVenvPrefix} starknet declare --contract ${filePath} ${networkOption} ${walletOption} ${accountOption} ${gatewayUrlOption} ${feederGatewayUrlOption} ${accountDirOption} ${maxFeeOption}`,
      {
        log: true,
      },
    );
  } catch {
    logError('Starknet declare failed');
  }
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
    assert(resultPath !== undefined);
    await declareContract(resultPath, options);
  }
}

export async function runStarknetNewAccount(options: StarkNetNewAccountOptions) {
  const networkOption = options.network ? `--network ${options.network}` : ``;
  const walletOption = options.wallet ? `--wallet ${options.wallet}` : ``;
  const accountOption = options.account ? `--account ${options.account}` : '';

  const gatewayUrlOption = options.gateway_url ? `--gateway_url ${options.gateway_url}` : '';
  const feederGatewayUrlOption = options.feeder_gateway_url
    ? `--feeder_gateway_url ${options.feeder_gateway_url}`
    : '';
  const accountDirOption = options.account_dir ? `--account_dir ${options.account_dir}` : '';
  try {
    await execAsync(
      `${warpVenvPrefix} starknet new_account ${networkOption} ${walletOption} ${accountOption} ${gatewayUrlOption} ${feederGatewayUrlOption} ${accountDirOption}`,
      {
        log: true,
      },
    );
  } catch {
    logError('Starknet new account creation failed');
  }
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
