import assert from 'assert';
import * as path from 'path';
import { execSync, ExecSyncOptions } from 'child_process';
import {
  IDeployProps,
  ICallOrInvokeProps,
  IOptionalNetwork,
  IDeployAccountProps,
  IOptionalDebugInfo,
  IDeclareOptions,
} from './index';
import { encodeInputs } from './passes';
import { CLIError, logError } from './utils/errors';
import { getDependencyGraph, hashFilename, reducePath } from './utils/postCairoWrite';

const warpVenvPrefix = `PATH=${path.resolve(__dirname, '..', 'warp_venv', 'bin')}:$PATH`;
const CAIRO_CMD_DECLARE = ' declare';
const CAIRO_CMD_STATUS = ' tx_status';
const CAIRO_CMD_STARKNET_COMPILE = '-compile';
const CAIRO_CMD_STARKNET_DEPLOY = ' deploy';
const CAIRO_CMD_STARKNET_DEPLOY_ACC = ' deploy_account';
const CAIRO_CMD_STARKNET_INVOKE = ' invoke';
const CAIRO_CMD_STARKNET_CALL = ' call';

interface CompileResult {
  success: boolean;
  output?: string;
  resultPath?: string;
  abiPath?: string;
  classHash?: string;
}

function callCairoCommand(cmd: string, command: string, isStdio = true) {
  const options: ExecSyncOptions = isStdio ? { stdio: 'inherit' } : { encoding: 'utf8' };
  try {
    const result = execSync(cmd, options);

    return result;
  } catch (e) {
    logError(`StarkNet ${command} failed`);
  }
}

function buildCairoCommand(
  options: string[] | Map<string, string | undefined>,
  command: string,
  multiOptions?: any,
) {
  let output = `${warpVenvPrefix} starknet${command} `;
  multiOptions = multiOptions?.join(' ');

  output = output.concat(
    `${[...options.entries()].map(([key, value]) => `--${key} ${value} `).join(' ')}`,
  );

  if (multiOptions !== undefined) output = output.concat(multiOptions);

  return output;
}

function starkNetCompile(
  filePath: string,
  debug_info: IOptionalDebugInfo | undefined,
  parameters: Map<string, string | undefined>,
) {
  const debug: string = debug_info ? '--debug_info_with_source' : '--no_debug_info';

  const multiOptions: string[] = [debug, filePath];

  const cmd: string = buildCairoCommand(parameters, CAIRO_CMD_STARKNET_COMPILE, multiOptions);
  callCairoCommand(cmd, CAIRO_CMD_STARKNET_COMPILE);

  return cmd;
}

export function compileCairo(
  filePath: string,
  cairoPath: string = path.resolve(__dirname, '..'),
  debug_info?: IOptionalDebugInfo,
): CompileResult {
  if (cairoPath == undefined) {
    logError(`Error: Exception: Cairo Path was not set properly.`);
    return { success: false, resultPath: undefined, abiPath: undefined, classHash: undefined };
  }
  assert(filePath?.endsWith('.cairo'), `Attempted to compile non-cairo file ${filePath} as cairo`);
  const cairoPathRoot: string = filePath?.slice(0, -'.cairo'.length);
  const resultPath = `${cairoPathRoot}_compiled.json`;
  const abiPath = `${cairoPathRoot}_abi.json`;

  const parameters: Map<string, string> = new Map([
    ['output', resultPath],
    ['abi', abiPath],
  ]);

  if (cairoPath !== '') {
    parameters.set('cairo_path', cairoPath);
  }

  try {
    console.log(`Running starknet compile with cairoPath ${cairoPath}`);
    const output: string = starkNetCompile(filePath, debug_info, parameters);
    return { success: true, resultPath, abiPath, classHash: undefined, output };
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
  network: string,
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
      );
      const fileLocationHash = hashFilename(reducePath(filesToDeclare, 'warp_output'));
      filesCompiled.set(fileLocationHash, result);
    }
  }

  const { success, resultPath, abiPath } = compileCairo(root, path.resolve(__dirname, '..'));
  if (!success) {
    throw new CLIError(`Compilation of cairo file ${root} failed`);
  }

  return { success, resultPath, abiPath };
}

export function runStarknetCompile(filePath: string, debug_info: IOptionalDebugInfo) {
  const { success, resultPath } = compileCairo(filePath, path.resolve(__dirname, '..'), debug_info);
  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  }
  console.log(`starknet-compile output written to ${resultPath}`);
}

export function checkStatus(tx_hash: string, option: IOptionalNetwork): string {
  const options: Map<string, string | undefined> = new Map([
    ['hash', tx_hash],
    ['network', option?.network],
  ]);

  const cmd: string = buildCairoCommand(options, CAIRO_CMD_STATUS);

  return cmd;
}

export function runStarknetStatus(tx_hash: string, option: IOptionalNetwork) {
  if (option.network == undefined) {
    logError(
      `Error: Exception: feeder_gateway_url must be specified with the "status" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
    return;
  }
  if (tx_hash == undefined) {
    logError(`Error: Exception: tx_hash must be specified with the "tx_status" subcommand.`);
    return;
  }

  const cmd = checkStatus(tx_hash, option);
  callCairoCommand(cmd, CAIRO_CMD_STATUS);

  return cmd;
}

function starkNetDeploy(
  filePath: string,
  option: IDeployProps,
  inputs: string,
  classHash: string | undefined,
): string {
  const wallet: string = option?.no_wallet
    ? `--no_wallet --contract ${filePath} `
    : option?.wallet === undefined
    ? `--class_hash ${classHash}`
    : `--class_hash ${classHash} --wallet ${option.wallet}`;

  const options: Map<string, string | undefined> = new Map([
    ['network', option?.network],
    ['account', option?.account],
  ]);

  const multiOptions: string[] = [wallet, inputs];

  const cmd: string = buildCairoCommand(options, CAIRO_CMD_STARKNET_DEPLOY, multiOptions);
  callCairoCommand(cmd, CAIRO_CMD_STARKNET_DEPLOY);

  return cmd;
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
  const dependencyGraph: Map<string, string[]> = getDependencyGraph(filePath, 'warp_output');

  let compileResult: CompileResult;
  try {
    compileResult = await compileCairoDependencies(
      filePath,
      dependencyGraph,
      new Map<string, CompileResult>(),
      options.debug_info,
      options.network,
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
    let classHash;
    if (!options.no_wallet) {
      assert(compileResult.resultPath !== undefined);
      classHash = declareContract(compileResult.resultPath, options);
    }
    const classHashOption = classHash ? `--class_hash ${classHash}` : '';
    const resultPath = compileResult.resultPath as string;
    const cmd: string = starkNetDeploy(resultPath, options, inputs, classHashOption);

    return cmd;
  } catch {
    logError('starknet deploy failed');
  }
}

function deployAccount(option: IDeployAccountProps): string {
  const account: string = option?.account ? `--account ${option.account}` : '';

  const options: Map<string, string | undefined> = new Map([
    ['wallet', option?.wallet],
    ['network', option?.network],
  ]);

  const multiOptions: string[] = [account];

  const cmd: string = buildCairoCommand(options, CAIRO_CMD_STARKNET_DEPLOY_ACC, multiOptions);
  callCairoCommand(cmd, CAIRO_CMD_STARKNET_DEPLOY_ACC);

  return cmd;
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

  const cmd: string = deployAccount(options);

  return cmd;
}

function starkNetCallOrInvoke(
  filePath: string | undefined,
  callOrInvoke: string,
  option: ICallOrInvokeProps,
  functionName: string,
  inputs: string,
): string {
  const wallet: string =
    option?.wallet === undefined ? '--no_wallet ' : `--wallet ${option.wallet} `;
  const account: string = option?.account ? `--account ${option.account} ` : '';

  const options: Map<string, string | undefined> = new Map([
    ['address', option?.address],
    ['abi', filePath],
    ['function', functionName],
    ['network', option?.network],
  ]);

  const multiOptions: string[] = [wallet, account, inputs];

  const cmd: string = buildCairoCommand(options, callOrInvoke, multiOptions);
  callCairoCommand(cmd, callOrInvoke);

  return cmd;
}

export async function runStarknetCallOrInvoke(
  filePath: string,
  isCall: boolean,
  options: ICallOrInvokeProps,
) {
  const callOrInvoke: string = isCall ? CAIRO_CMD_STARKNET_CALL : CAIRO_CMD_STARKNET_INVOKE;

  if (filePath == undefined) {
    logError(`Error: Exception: filePath must be specified with the "${callOrInvoke}" subcommand.`);
    return;
  }

  if (options.network == undefined) {
    logError(
      `Error: Exception: feeder_gateway_url must be specified with the "${callOrInvoke}" subcommand.\nConsider passing --network or setting the STARKNET_NETWORK environment variable.`,
    );
    return;
  }

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

  const cmd: string = starkNetCallOrInvoke(abiPath, callOrInvoke, options, funcName, inputs);

  return cmd;
}

function declareContract(filePath: string, option?: IDeclareOptions): string | undefined {
  const network: string = option?.network ? `--network ${option.network}` : ``;

  const options: Map<string, string | undefined> = new Map([['contract', filePath]]);

  const multiOptions: string[] = [network];

  const cmd: string = buildCairoCommand(options, CAIRO_CMD_DECLARE, multiOptions);
  const result = callCairoCommand(cmd, CAIRO_CMD_DECLARE, false) as string;
  try {
    return processDeclareCLI(result, filePath);
  } catch {
    logError('StarkNet declare failed');
  }
}

export function runStarknetDeclare(filePath: string, options: IDeclareOptions) {
  const { success, resultPath } = compileCairo(filePath, path.resolve(__dirname, '..'));
  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  }

  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  } else {
    assert(resultPath !== undefined);
    declareContract(resultPath, options);
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
