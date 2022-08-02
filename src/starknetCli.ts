import assert from 'assert';
import * as path from 'path';
import { execSync } from 'child_process';
import {
  IDeployProps,
  ICallOrInvokeProps,
  IOptionalNetwork,
  IDeployAccountProps,
  IOptionalDebugInfo,
} from './index';
import { encodeInputs } from './passes';
import { CLIError, logError } from './utils/errors';
import {
  getDependencyGraph,
  hashFilename,
  reducePath,
  setDeclaredAddresses,
} from './utils/postCairoWrite';

const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;

interface CompileResult {
  success: boolean;
  resultPath?: string;
  abiPath?: string;
  classHash?: string;
}

export function compileCairo(
  filePath: string,
  cairoPath: string = path.resolve(__dirname, '..'),
  debug_info?: IOptionalDebugInfo,
): CompileResult {
  assert(filePath.endsWith('.cairo'), `Attempted to compile non-cairo file ${filePath} as cairo`);
  const cairoPathRoot = filePath.slice(0, -'.cairo'.length);
  const resultPath = `${cairoPathRoot}_compiled.json`;
  const abiPath = `${cairoPathRoot}_abi.json`;
  const parameters = new Map([
    ['output', resultPath],
    ['abi', abiPath],
  ]);
  if (cairoPath !== '') {
    parameters.set('cairo_path', cairoPath);
  }
  const debug: string = debug_info ? '--debug_info_with_source' : '--no_debug_info';
  try {
    console.log(`Running starknet compile with cairoPath ${cairoPath}`);
    execSync(
      `${warpVenvPrefix} starknet-compile ${debug} ${filePath} ${[...parameters.entries()]
        .map(([key, value]) => `--${key} ${value}`)
        .join(' ')}`,
      { stdio: 'inherit' },
    );

    return { success: true, resultPath, abiPath, classHash: undefined };
  } catch (e) {
    if (e instanceof Error) {
      logError('Compile failed');
      return { success: false, resultPath: undefined, abiPath: undefined, classHash: undefined };
    } else {
      throw e;
    }
  }
}

async function compileCairoDependencies(
  root: string,
  graph: Map<string, string[]>,
  filesCompiled: Map<string, CompileResult>,
  debug_info = false,
): Promise<CompileResult> {
  const compiled = filesCompiled.get(root);
  if (compiled !== undefined) {
    return compiled;
  }

  const dependencies = graph.get(root);
  if (dependencies !== undefined) {
    for (const filesToDeclare of dependencies) {
      const result = await compileCairoDependencies(
        filesToDeclare,
        graph,
        filesCompiled,
        debug_info,
      );
      const fileLocationHash = hashFilename(reducePath(filesToDeclare, 'warp_output'));
      filesCompiled.set(fileLocationHash, result);
    }
  }

  setDeclaredAddresses(
    root,
    new Map(
      [...filesCompiled.entries()].map(([key, value]) => {
        assert(value.classHash !== undefined);
        return [key, value.classHash];
      }),
    ),
  );
  const { success, resultPath, abiPath } = compileCairo(root, path.resolve(__dirname, '..'));
  if (!success) {
    throw new CLIError(`Compilation of cairo file ${root} failed`);
  }
  const result = execSync(`${warpVenvPrefix} starknet declare --contract ${resultPath}`, {
    encoding: 'utf8',
  });
  const splitter = new RegExp('[ ]+');
  // Extract the hash from result
  const classHash = result
    .split('\n')
    .map((line) => {
      const [contractT, classT, hashT, hash, ...others] = line.split(splitter);
      if (contractT === 'Contract' && classT === 'class' && hashT === 'hash:') {
        if (others.length !== 0) {
          throw new CLIError(
            `Error while parsing the 'declare' output of ${root}. Malformed lined.`,
          );
        }
        return hash;
      }
      return null;
    })
    .filter((val) => val !== null)[0];

  if (classHash === null || classHash === undefined)
    throw new CLIError(
      `Error while parsing the 'declare' output of ${root}. Couldn't find the class hash.`,
    );

  return { success, resultPath, abiPath, classHash };
}

export function runStarknetCompile(filePath: string, debug_info: IOptionalDebugInfo) {
  const { success, resultPath } = compileCairo(filePath, path.resolve(__dirname, '..'), debug_info);
  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  }
  console.log(`starknet-compile output written to ${resultPath}`);
}

export function runStarknetStatus(tx_hash: string, option: IOptionalNetwork) {
  if (option.network == undefined) {
    logError(
      `Error: Exception: feeder_gateway_url must be specified with the "status" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
    return;
  }

  try {
    execSync(`${warpVenvPrefix} starknet tx_status --hash ${tx_hash} --network ${option.network}`, {
      stdio: 'inherit',
    });
  } catch {
    logError('starknet tx_status failed');
  }
}

export async function runStarknetDeploy(filePath: string, options: IDeployProps) {
  if (options.network == undefined) {
    logError(
      `Error: Exception: feeder_gateway_url must be specified with the "deploy" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
    return;
  }
  // Shouldn't be fixed to warp_output (which is the default)
  // such option does not exists currently when deploying, should be added
  const dependencyGraph = getDependencyGraph(filePath, 'warp_output');

  let compileResult: CompileResult;
  try {
    compileResult = await compileCairoDependencies(
      filePath,
      dependencyGraph,
      new Map<string, CompileResult>(),
      options.debug_info,
    );
  } catch (e) {
    if (e instanceof CLIError) {
      logError(e.message);
    }
    throw e;
  }

  let inputs: string;
  try {
    inputs = (
      await encodeInputs(filePath, 'constructor', options.use_cairo_abi, options.inputs)
    )[1];
  } catch (e) {
    if (e instanceof CLIError) {
      logError(e.message);
      return;
    }
    throw e;
  }

  try {
    const resultPath = compileResult.resultPath;
    const classHash = compileResult.classHash;
    execSync(
      `${warpVenvPrefix} starknet deploy --network ${options.network} ${
        options.no_wallet ? `--no_wallet --contract ${resultPath} ` : `--class_hash ${classHash}`
      } ${inputs} ${options.account !== undefined ? `--account ${options.account}` : ''}`,
      {
        stdio: 'inherit',
      },
    );
  } catch {
    logError('starknet deploy failed');
  }
}

export function runStarknetDeployAccount(options: IDeployAccountProps) {
  if (options.wallet == undefined) {
    logError(
      `Error: AssertionError: --wallet must be specified with the "deploy_account" subcommand.`,
    );
    return;
  }
  if (options.network == undefined) {
    logError(
      `Error: Exception: feeder_gateway_url must be specified with the "deploy_account" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
    return;
  }

  const account = options.account ? `--account ${options.account}` : '';

  try {
    execSync(
      `${warpVenvPrefix} starknet deploy_account --wallet ${options.wallet} --network ${options.network} ${account}`,
      {
        stdio: 'inherit',
      },
    );
  } catch {
    logError('starknet deploy failed');
  }
}

export async function runStarknetCallOrInvoke(
  filePath: string,
  isCall: boolean,
  options: ICallOrInvokeProps,
) {
  const callOrInvoke = isCall ? 'call' : 'invoke';

  if (options.network == undefined) {
    logError(
      `Error: Exception: feeder_gateway_url must be specified with the "${callOrInvoke}" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
    return;
  }

  const wallet = options.wallet === undefined ? '--no_wallet' : `--wallet ${options.wallet}`;
  const account = options.account ? `--account ${options.account}` : '';

  const { success, abiPath } = compileCairo(filePath, path.resolve(__dirname, '..'));
  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  }

  let funcName, inputs: string;
  try {
    [funcName, inputs] = await encodeInputs(
      filePath,
      options.function,
      options.use_cairo_abi,
      options.inputs,
    );
  } catch (e) {
    if (e instanceof CLIError) {
      logError(e.message);
      return;
    }
    throw e;
  }

  try {
    execSync(
      `${warpVenvPrefix} starknet ${callOrInvoke}  --address ${options.address} --abi ${abiPath} --function ${funcName} --network ${options.network} ${wallet} ${account} ${inputs}`,
      { stdio: 'inherit' },
    );
  } catch {
    logError(`starknet ${callOrInvoke} failed`);
  }
}

export function runStarknetDeclare(filePath: string) {
  const { success, resultPath } = compileCairo(filePath, path.resolve(__dirname, '..'));
  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  }

  try {
    execSync(`${warpVenvPrefix} starknet declare --contract ${resultPath}`);
  } catch (e) {
    logError('starkned declared failed');
  }
}
