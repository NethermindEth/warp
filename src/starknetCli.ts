import assert from 'assert';
import * as path from 'path';
import { ExecSyncOptions } from 'child_process';
import { execSync } from './execSync-internals';
import {
  IDeployProps,
  ICallOrInvokeProps,
  INetwork,
  IDeployAccountProps,
  IOptionalDebugInfo,
  IDeclareOptions,
} from './programFactory';
import { encodeInputs } from './passes';
import { CLIError, logCLIError } from './utils/errors';
import { getDependencyGraph, hashFilename, reducePath } from './utils/postCairoWrite';

const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;
const STARKNET_DECLARE = 'starknet declare';
const STARKNET_STATUS = 'starknet tx_status';
const STARKNET_COMPILE = 'starknet-compile';
const STARKNET_DEPLOY = 'starknet deploy';
const STARKNET_DEPLOY_ACC = 'starknet deploy_account';
const STARKNET_INVOKE = 'starknet invoke';
const STARKNET_CALL = 'starknet call';

interface CompileResult {
  success: boolean;
  cmd?: string;
  resultPath?: string;
  abiPath?: string;
}

// Functions to that are command agnostic
function callStarkNetCMD(cliCMD: string, starkNetCMD: string, isStdio = true): string | Buffer {
  const options: ExecSyncOptions = isStdio ? { stdio: 'inherit' } : { encoding: 'utf8' };

  try {
    const result = execSync(cliCMD, options);

    return result;
  } catch (e) {
    logCLIError(`StarkNet ${starkNetCMD} failed with error ${e}`);
  }
}

function buildStarkNetCMD(
  command: string,
  arg: string,
  keyValueOptions: Map<string, string>,
  flagOptions: string[],
): string {
  const cmdArray: string[] = [];
  cmdArray.push(warpVenvPrefix);
  cmdArray.push(command);

  if (arg !== '') {
    cmdArray.push(arg);
  }

  cmdArray.push(
    [...keyValueOptions.entries()].map(([key, value]) => `--${key} ${value}`).join(' '),
  );

  cmdArray.push(flagOptions.join(' '));

  const output = cmdArray.join(' ').trim();
  return output;
}

// Functions that process CLI inputs
export function buildStatusCMD(tx_hash: string, option: INetwork): string {
  assert(option.network !== undefined);
  const kVOptions: Map<string, string> = new Map([
    ['hash', tx_hash],
    ['network', option.network],
  ]);

  const flagOptions: string[] = [];
  const statusCMD: string = buildStarkNetCMD(STARKNET_STATUS, '', kVOptions, flagOptions);

  return statusCMD;
}

export function buildCompileCMD(
  filePath: string,
  outputPath: string,
  abiPath: string,
  cairoPath = '',
  isDebug?: IOptionalDebugInfo,
) {
  const keyValueOptions: Map<string, string> = new Map([
    ['output', outputPath],
    ['abi', abiPath],
  ]);

  if (cairoPath !== '') {
    keyValueOptions.set('cairo_path', cairoPath);
  }
  const debug: string = isDebug?.debug_info ? '--debug_info_with_source' : '--no_debug_info';
  const flagOptions: string[] = [debug];

  const compileCMD: string = buildStarkNetCMD(
    STARKNET_COMPILE,
    filePath,
    keyValueOptions,
    flagOptions,
  );
  return compileCMD;
}

export function buildDeployCMD(
  filePath: string,
  option: IDeployProps,
  inputs: string,
  classHash: string | undefined,
): string {
  assert(option.network !== undefined, 'Network needs to be passed to deploy command');
  const keyValueOptions: Map<string, string> = new Map();
  const flagOptions: string[] = [];
  const arg = '';

  if (option.no_wallet) {
    keyValueOptions.set('contract', filePath);
    flagOptions.push('--no_wallet');
  } else {
    assert(option.wallet !== undefined, 'Wallet undefined');
    assert(classHash !== undefined, `Class hash undefined for file ${filePath}.`);
    keyValueOptions.set('class_hash', classHash);
    keyValueOptions.set('wallet', option.wallet);
    if (option.account !== undefined) {
      keyValueOptions.set('account', option.account);
    }
  }

  keyValueOptions.set('network', option.network);
  if (inputs !== '') {
    keyValueOptions.set('inputs', inputs);
  }
  const deployCMD: string = buildStarkNetCMD(STARKNET_DEPLOY, arg, keyValueOptions, flagOptions);
  return deployCMD;
}

export function buildDeployAccountCMD(option: IDeployAccountProps): string {
  assert(option.wallet !== undefined, 'Wallet needs to be passed to deploy_account command.');
  assert(option.network !== undefined, 'Network needs to be passed to deploy_account command.');
  const flagOptions: string[] = [];
  const keyValueOptions: Map<string, string> = new Map([
    ['wallet', option?.wallet],
    ['network', option?.network],
  ]);
  if (option?.account !== undefined) {
    keyValueOptions.set('account', option.account);
  }

  const deployAccCMD: string = buildStarkNetCMD(
    STARKNET_DEPLOY_ACC,
    '',
    keyValueOptions,
    flagOptions,
  );

  return deployAccCMD;
}

export function buildDeclareCMD(filePath: string, option: IDeclareOptions): string {
  const keyValueOptions: Map<string, string> = new Map([['contract', filePath]]);
  const flagOptions: string[] = [];

  keyValueOptions.set('network', option.network);

  if (option.no_wallet) {
    flagOptions.push('--no_wallet');
  } else {
    assert(option.wallet !== undefined);
    keyValueOptions.set('wallet', option.wallet);
  }
  if (option.account !== undefined) {
    keyValueOptions.set('account', option.account);
  }
  const declareCMD: string = buildStarkNetCMD(STARKNET_DECLARE, '', keyValueOptions, flagOptions);

  return declareCMD;
}

export function generateCompileFileNames(filePath: string): [string, string] {
  const cairoPathRoot: string = filePath?.slice(0, -'.cairo'.length);
  const compilePath = `${cairoPathRoot}_compiled.json`;
  const abiPath = `${cairoPathRoot}_abi.json`;
  return [compilePath, abiPath];
}

export function compileCairo(
  filePath: string,
  cairoPath: string = path.resolve(__dirname, '..'),
  debug_info?: IOptionalDebugInfo,
): CompileResult {
  if (cairoPath == undefined) {
    logCLIError(`Error: Exception: Cairo Path was not set properly.`);
  }
  assert(filePath?.endsWith('.cairo'), `Attempted to compile non-cairo file ${filePath} as cairo`);

  const [compilePath, abiPath] = generateCompileFileNames(filePath);

  const compileCMD = buildCompileCMD(filePath, compilePath, abiPath, cairoPath, debug_info);

  try {
    callStarkNetCMD(compileCMD, STARKNET_COMPILE);
    return { success: true, cmd: compileCMD, resultPath: compilePath, abiPath };
  } catch (e) {
    if (e instanceof Error) {
      logCLIError('Compile failed');
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
  network: string,
  outputDir: string,
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
        network,
        outputDir,
      );
      const fileLocationHash = hashFilename(reducePath(filesToDeclare, outputDir));
      filesCompiled.set(fileLocationHash, result);
    }
  }

  const { success, resultPath, abiPath } = compileCairo(root, path.resolve(__dirname, '..'), {
    debug_info: false,
  });
  if (!success) {
    throw new CLIError(`Compilation of cairo file ${root} failed`);
  }

  return { success, resultPath, abiPath };
}

export function runStarknetCompile(filePath: string, debug_info: IOptionalDebugInfo): string {
  const { success, cmd } = compileCairo(filePath, path.resolve(__dirname, '..'), debug_info);
  if (!success || cmd === undefined) {
    logCLIError(`Compilation of contract ${filePath} failed in ${runStarknetCompile.name}`);
  }
  return cmd;
}

export function runStarknetStatus(tx_hash: string, option: INetwork): string {
  if (tx_hash == undefined) {
    logCLIError(`Error: Exception: tx_hash must be specified with the "tx_status" subcommand.`);
  }
  if (option.network == undefined) {
    logCLIError(
      `Error: Exception: feeder_gateway_url must be specified with the "status" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
  }

  const statusCMD: string = buildStatusCMD(tx_hash, option);
  callStarkNetCMD(statusCMD, STARKNET_STATUS, true);

  return statusCMD;
}

export async function runStarknetDeploy(filePath: string, options: IDeployProps): Promise<string> {
  if (options.network == undefined) {
    logCLIError(
      `Error: Exception: feeder_gateway_url must be specified with the "deploy" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
  }
  // Shouldn't be fixed to warp_output (which is the default)
  // such option does not exists currently when deploying, should be added
  const dependencyGraph: Map<string, string[]> = getDependencyGraph(filePath, options.outputDir);

  let compileResult: CompileResult;
  try {
    compileResult = await compileCairoDependencies(
      filePath,
      dependencyGraph,
      new Map<string, CompileResult>(),
      options.debug_info,
      options.network,
      options.outputDir,
    );
  } catch (e) {
    if (e instanceof CLIError) {
      logCLIError(e.message);
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
      logCLIError(e.message);
    }
    throw e;
  }

  try {
    let classHash;
    if (!options.no_wallet) {
      assert(compileResult.resultPath !== undefined);
      classHash = declareContract(compileResult.resultPath, false, options);
    }
    const resultPath = compileResult.resultPath;
    assert(resultPath !== undefined, `Could not compile ${filePath}.`);
    const deployCMD = buildDeployCMD(resultPath, options, inputs, classHash);
    callStarkNetCMD(deployCMD, STARKNET_DEPLOY, true);

    return deployCMD;
  } catch (e) {
    logCLIError('starknet deploy failed');
  }
}

export function runStarknetDeployAccount(options: IDeployAccountProps): string {
  if (options.wallet == undefined) {
    logCLIError(
      `Error: AssertionError: --wallet must be specified with the "deploy_account" subcommand.`,
    );
  }
  if (options.network == undefined) {
    logCLIError(
      `Error: Exception: feeder_gateway_url must be specified with the "deploy_account" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
  }

  const deployAccCMD: string = buildDeployAccountCMD(options);
  callStarkNetCMD(deployAccCMD, STARKNET_DEPLOY_ACC, true);

  return deployAccCMD;
}

export function buildCallOrInvokeCMD(
  abiPath: string,
  isCall: boolean,
  option: ICallOrInvokeProps,
  functionName: string,
  inputs: string,
): string {
  const callOrInvoke: string = isCall ? STARKNET_CALL : STARKNET_INVOKE;
  assert(option.network !== undefined, 'Network parameter not found in buildCallOrInvokeCMD.');
  const keyValueOptions: Map<string, string> = new Map([
    ['address', option.address],
    ['abi', abiPath],
    ['function', functionName],
    ['network', option.network],
  ]);
  const flagOptions: string[] = [];

  if (option.wallet === undefined) {
    flagOptions.push('--no_wallet');
  } else {
    keyValueOptions.set('wallet', option.wallet);
  }

  if (option.account !== undefined) {
    keyValueOptions.set('account', option.account);
  }

  if (inputs !== '') {
    keyValueOptions.set('inputs', inputs);
  }
  const callOrInvokeCMD: string = buildStarkNetCMD(callOrInvoke, '', keyValueOptions, flagOptions);

  return callOrInvokeCMD;
}

export async function runStarknetCallOrInvoke(
  filePath: string,
  isCall: boolean, // This can be added to an option
  options: ICallOrInvokeProps,
) {
  if (filePath == undefined) {
    logCLIError(`Error: Exception: filePath must be specified with call/invoke subcommands.`);
  }
  if (options.network == undefined) {
    logCLIError(
      `Error: Exception: feeder_gateway_url must be specified with call/invoke subcommands.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
  }

  const { success, abiPath } = compileCairo(filePath, path.resolve(__dirname, '..'), {
    debug_info: false,
  });
  if (!success) {
    logCLIError(`Compilation of contract ${filePath} failed`);
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
      logCLIError(e.message);
    }
    throw e;
  }
  assert(abiPath !== undefined, 'Path to ABI JSON not found.');
  const callOrInvokeCMD: string = buildCallOrInvokeCMD(abiPath, isCall, options, funcName, inputs);
  callStarkNetCMD(callOrInvokeCMD, '', true);

  return callOrInvokeCMD;
}

function declareContract(filePath: string, isStdio: boolean, option: IDeclareOptions): string {
  const declareCMD: string = buildDeclareCMD(filePath, option);
  const result = callStarkNetCMD(declareCMD, STARKNET_DECLARE, isStdio);

  if (isStdio === true) return declareCMD;

  try {
    return extractClassHash(result?.toString(), filePath);
  } catch {
    logCLIError('StarkNet declare failed');
  }
}

export function runStarknetDeclare(filePath: string, options: IDeclareOptions): string {
  const { success, resultPath } = compileCairo(filePath, path.resolve(__dirname, '..'), {
    debug_info: false,
  });

  if (!success) {
    logCLIError(`Compilation of contract ${filePath} failed`);
  } else {
    assert(resultPath !== undefined);
    const declareCMD = declareContract(resultPath, true, options);
    return declareCMD;
  }
}

export function extractClassHash(result: string, filePath: string): string {
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
