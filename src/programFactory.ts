import chalk from 'chalk';
import { Command } from 'commander';
import { createCairoFileName, isValidSolFile, outputResult } from './io';
import { compileSolFile } from './solCompile';
import {
  runStarknetCallOrInvoke,
  runStarknetCompile,
  runStarknetDeclare,
  runStarknetDeploy,
  runStarknetDeployAccount,
  runStarknetStatus,
} from './starknetCli';
import { runTests } from './testing';
import { handleTranspilationError, transform, transpile } from './transpiler';
import { analyseSol } from './utils/analyseSol';
import { postProcessCairoFile } from './utils/postCairoWrite';
import { runVenvSetup } from './utils/setupVenv';

export type CompilationOptions = {
  warnings: boolean;
};

export type TranspilationOptions = {
  checkTrees?: boolean;
  dev?: boolean;
  order?: string;
  printTrees?: boolean;
  strict?: boolean;
  warnings?: boolean;
  until?: string;
};

export type PrintOptions = {
  highlight?: string[];
  stubs?: boolean;
};

export type OutputOptions = {
  compileCairo?: boolean;
  compileErrors?: boolean;
  outputDir: string;
  result: boolean;
};

export type CliOptions = CompilationOptions & TranspilationOptions & PrintOptions & OutputOptions;

export interface IOptionalNetwork {
  network?: string;
}
export interface IOptionalDebugInfo {
  debug_info: boolean;
}

interface IDeployProps_ {
  inputs?: string[];
  use_cairo_abi: boolean;
  no_wallet: boolean;
  wallet?: string;
  outputDir: string;
}

export type IDeployProps = IDeployProps_ & IOptionalNetwork & IOptionalAccount & IOptionalDebugInfo;

interface IOptionalWallet {
  wallet?: string;
}

interface IOptionalAccount {
  account?: string;
}

export type IDeployAccountProps = IOptionalAccount & IOptionalNetwork & IOptionalWallet;

interface ICallOrInvokeProps_ {
  address: string;
  function: string;
  inputs?: string[];
  use_cairo_abi: boolean;
}

export type ICallOrInvokeProps = ICallOrInvokeProps_ &
  IOptionalNetwork &
  IOptionalWallet &
  IOptionalAccount;

export type IInstallOptions = IInstallOptions_ & IOptionalVerbose;

interface IOptionalVerbose {
  verbose: boolean;
}

interface IInstallOptions_ {
  python: string;
}

export type IDeclareOptions = IOptionalNetwork & IOptionalWallet;

const createCompileProgram = (program: Command, output = { val: '' }) => {
  program
    .command('compile <file>')
    .option('-d, --debug_info', 'Include debug information.', false)
    .action((file: string, options: IOptionalDebugInfo) => {
      output.val = runStarknetCompile(file, options) as string;
    });
};

const createStatusProgram = (program: Command, output = { val: '' }) => {
  program
    .command('status <tx_hash>')
    .option('--network <network>', 'Starknet network URL.', process.env.STARKNET_NETWORK)
    .action((tx_hash: string, options: IOptionalNetwork) => {
      output.val = runStarknetStatus(tx_hash, options) as string;
    });
};

const createDeployProgram = async (program: Command, output = { val: '' }) => {
  program
    .command('deploy <file>')
    .option('-d, --debug_info', 'Compile include debug information.', false)
    .option(
      '--inputs <inputs...>',
      'Arguments to be passed to constructor of the program as a comma seperated list of strings, ints and lists.',
      undefined,
    )
    .option('--use_cairo_abi', 'Use the cairo abi instead of solidity for the inputs.', false)
    .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
    .option('--no_wallet', 'Do not use a wallet for deployment.', false)
    .option('--wallet <wallet>', 'Wallet provider to use', process.env.STARKNET_WALLET)
    .option('--account <account>', 'Account to use for deployment', undefined)
    .option(
      '-o, --output-dir <path>',
      'Output directory when getting dependency graph',
      'warp_output',
    )
    .action(async (file: string, options: IDeployProps) => {
      output.val = (await runStarknetDeploy(file, options)) as string;
    });
};

const createDeployAccountProgram = (program: Command, output = { val: '' }) => {
  program
    .command('deploy_account')
    .option(
      '--account <account>',
      'The name of the account. If not given, the default for the wallet will be used.',
    )
    .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
    .option(
      '--wallet <wallet>',
      'The name of the wallet, including the python module and wallet class.',
      process.env.STARKNET_WALLET,
    )
    .action((options: IDeployAccountProps) => {
      output.val = runStarknetDeployAccount(options) as string;
    });
};

const createInvokeProgram = async (program: Command, output = { val: '' }) => {
  program
    .command('invoke <file>')
    .requiredOption('--address <address>', 'Address of contract to invoke.')
    .requiredOption('--function <function>', 'Function to invoke.')
    .option(
      '--inputs <inputs...>',
      'Input to function as a comma separated string, use square brackets to represent lists and structs. Numbers can be represented in decimal and hex.',
      undefined,
    )
    .option('--use_cairo_abi', 'Use the cairo abi instead of solidity for the inputs.', false)
    .option(
      '--account <account>',
      'The name of the account. If not given, the default for the wallet will be used.',
    )
    .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
    .option(
      '--wallet <wallet>',
      'The name of the wallet, including the python module and wallet class.',
      process.env.STARKNET_WALLET,
    )
    .action(async (file: string, options: ICallOrInvokeProps) => {
      output.val = (await runStarknetCallOrInvoke(file, false, options)) as string;
    });
};

const createCallProgram = async (program: Command, output = { val: '' }) => {
  program
    .command('call <file>')
    .requiredOption('--address <address>', 'Address of contract to call.')
    .requiredOption('--function <function>', 'Function to call.')
    .option(
      '--inputs <inputs...>',
      'Input to function as a comma separated string, use square brackets to represent lists and structs. Numbers can be represented in decimal and hex.',
      undefined,
    )
    .option('--use_cairo_abi', 'Use the cairo abi instead of solidity for the inputs.', false)
    .option(
      '--account <account>',
      'The name of the account. If not given, the default for the wallet will be used.',
    )
    .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
    .option(
      '--wallet <wallet>',
      'The name of the wallet, including the python module and wallet class.',
      process.env.STARKNET_WALLET,
    )
    .action(async (file: string, options: ICallOrInvokeProps) => {
      output.val = (await runStarknetCallOrInvoke(file, true, options)) as string;
    });
};

const createDeclareProgram = (program: Command, output = { val: '' }) => {
  program
    .command('declare <cairo_contract>')
    .description('Command to declare Cairo contract on a StarkNet Network.')
    .option('--network <network>', 'StarkNet network URL.', process.env.STARKNET_NETWORK)
    .action((cairo_contract: string, options: IDeclareOptions) => {
      output.val = runStarknetDeclare(cairo_contract, options) as string;
    });
};

const createInstallProgram = (program: Command) => {
  program
    .command('install')
    .option('--python <python>', 'Path to python3.7 executable.', 'python3.7')
    .option('-v, --verbose')
    .action((options: IInstallOptions) => {
      runVenvSetup(options);
    });
};

const createVersionProgram = (program: Command) => {
  const blue = chalk.bold.blue;
  const green = chalk.bold.green;
  program.command('version').action(() => {
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const pjson = require('../package.json');
    console.log(blue(`Warp Version `) + green(pjson.version));
  });
};

const createAnalyseProgram = (program: Command) => {
  program
    .command('analyse <file>')
    .option('--highlight <ids...>')
    .action((file: string, options: PrintOptions) => analyseSol(file, options));
};

const createTestProgram = (program: Command) => {
  program
    .command('test')
    .option('-f --force')
    .option('-r --results')
    .option('-u --unsafe')
    .option('-e --exact')
    .action((options) =>
      runTests(
        options.force ?? false,
        options.results ?? false,
        options.unsafe ?? false,
        options.exact ?? false,
      ),
    );
};

const createTransformProgram = (program: Command) => {
  program
    .command('transform <file>')
    .option('--no-compile-errors')
    .option('--check-trees')
    .option('--highlight <ids...>')
    .option('--order <passOrder>')
    .option('-o, --output-dir <path>')
    .option('--print-trees')
    .option('--no-result')
    .option('--no-stubs')
    .option('--no-strict')
    .option('--until <pass>')
    .option('--no-warnings')
    .action((file: string, options: CliOptions) => {
      if (!isValidSolFile(file)) return;
      try {
        transform(compileSolFile(file, options.warnings), options).map(([name, solidity, _]) => {
          outputResult(name, solidity, options, '_warp.sol');
        });
      } catch (e) {
        handleTranspilationError(e);
      }
    });
};

const createTranspileProgram = (program: Command) => {
  program
    .command('transpile <files...>')
    .option('--compile-cairo')
    .option('--no-compile-errors')
    .option('--check-trees')
    .option('--highlight <ids...>')
    .option('--order <passOrder>')
    .option(
      '-o, --output-dir <path>',
      'Output directory for transpiled Cairo files.',
      'warp_output',
    )
    .option('--print-trees')
    .option('--no-result')
    .option('--no-stubs')
    .option('--no-strict')
    // Stops transpilation after the specified pass
    .option('--until <pass>')
    .option('--no-warnings')
    .option('--dev') // for development mode
    .action((files: string[], options: CliOptions) => {
      // We do the extra work here to make sure all the errors are printed out
      // for all files which are invalid.
      if (files.map((file) => isValidSolFile(file)).some((result) => !result)) return;
      const cairoSuffix = '.cairo';
      const contractToHashMap = new Map<string, string>();
      files.forEach((file) => {
        if (files.length > 1) {
          console.log(`Compiling ${file}`);
        }
        try {
          transpile(compileSolFile(file, options.warnings), options)
            .map(([name, cairo, abi]) => {
              outputResult(name, cairo, options, cairoSuffix, abi);
              return createCairoFileName(name, cairoSuffix);
            })
            .forEach((file) => {
              postProcessCairoFile(file, options.outputDir, contractToHashMap);
            });
        } catch (e) {
          handleTranspilationError(e);
        }
      });
    });
};

export {
  createCompileProgram,
  createStatusProgram,
  createDeployProgram,
  createDeployAccountProgram,
  createInvokeProgram,
  createCallProgram,
  createDeclareProgram,
  createInstallProgram,
  createVersionProgram,
  createAnalyseProgram,
  createTestProgram,
  createTransformProgram,
  createTranspileProgram,
};

export const programs = [
  createCompileProgram,
  createStatusProgram,
  createDeployProgram,
  createDeployAccountProgram,
  createInvokeProgram,
  createCallProgram,
  createDeclareProgram,
  createInstallProgram,
  createVersionProgram,
  createAnalyseProgram,
  createTestProgram,
  createTransformProgram,
  createTranspileProgram,
];
