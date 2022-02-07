import { Command } from 'commander';
import { AST } from './ast/ast';
import { isValidSolFile, outputResult, outputSol } from './io';
import { compileSolFile } from './solCompile';
import { runTests } from './testing';
import { handleTranspilationError, transform, transpile } from './transpiler';
import { analyseSol } from './utils/analyseSol';
import {
  runStarknetCallOrInvoke,
  runStarknetDeploy,
  runStarknetDeployAccount,
  runStarknetStatus,
} from './starknetCli';

export type CompilationOptions = {
  warnings: boolean;
};

export type TranspilationOptions = {
  checkTrees?: boolean;
  highlight?: string;
  order?: string;
  printTrees?: boolean;
  strict?: boolean;
  until?: string;
};

export type OutputOptions = {
  compileCairo?: boolean;
  compileErrors?: boolean;
  output?: string;
  result: boolean;
};

type CliOptions = CompilationOptions & TranspilationOptions & OutputOptions;

const program = new Command();

program
  .command('transpile <file>')
  .option('--compile-cairo')
  .option('--no-compile-errors')
  .option('--check-trees')
  .option('--highlight <id>')
  .option('--order <passOrder>')
  .option('-o, --output <path>')
  .option('--print-trees')
  .option('--no-result')
  .option('--strict')
  // Stops transpilation after the specified pass
  .option('--until <pass>')
  .option('--no-warnings')
  .action((file: string, options: CliOptions) => {
    if (!isValidSolFile(file)) return;
    try {
      compileSolFile(file, options.warnings)
        .map((ast: AST) => ({
          name: ast.root.absolutePath,
          cairo: transpile(ast, options),
        }))
        .map(({ name, cairo }) => {
          outputResult(name, cairo, options);
        });
    } catch (e) {
      handleTranspilationError(e);
    }
  });

program
  .command('transform <file>')
  .option('--no-compile-errors')
  .option('--check-trees')
  .option('--highlight <id>')
  .option('--order <passOrder>')
  .option('-o, --output <path>')
  .option('--print-trees')
  .option('--no-result')
  .option('--strict')
  .option('--until <pass>')
  .option('--no-warnings')
  .action((file: string, options: CliOptions) => {
    if (!isValidSolFile(file)) return;
    try {
      compileSolFile(file, options.warnings)
        .map((ast: AST) => ({
          name: ast.root.absolutePath,
          solidity: transform(ast, options),
        }))
        .map(({ name, solidity }) => {
          outputSol(name, solidity, options);
        });
    } catch (e) {
      handleTranspilationError(e);
    }
  });

program
  .command('test')
  .option('-f --force')
  .option('-r --results')
  .option('-u --unsafe')
  .action((options) =>
    runTests(options.force ?? false, options.results ?? false, options.unsafe ?? false),
  );

program.command('analyse <file>').action((file: string) => analyseSol(file));

export interface IOptionalNetwork {
  network?: string;
}

program
  .command('status <tx_hash>')
  .option('--network <network>', 'Starknet network URL.', process.env.STARKNET_NETWORK)
  .action((tx_hash: string, options: IOptionalNetwork) => {
    runStarknetStatus(tx_hash, options);
  });

interface IDeployProps_ {
  inputs?: string[];
}
export type IDeployProps = IDeployProps_ & IOptionalNetwork;

program
  .command('deploy <file>')
  .option(
    '--inputs <inputs...>',
    'Arguments to be passed to constructor of the program.',
    undefined,
  )
  .option('--network <network>', 'Starknet network URL', process.env.STARKNET_NETWORK)
  .action((file: string, options: IDeployProps) => {
    runStarknetDeploy(file, options);
  });

interface IOptionalWallet {
  wallet?: string;
}

interface IDeployAccountProps_ {
  account?: string;
}
export type IDeployAccountProps = IDeployAccountProps_ & IOptionalNetwork & IOptionalWallet;

program
  .command('deploy_account')
  .option(
    '--account',
    'The name of the account. If not given, the "__default__" will be used.',
    '__default__',
  )
  .option('--network <network>', 'Starknet network URL.', process.env.STARKNET_NETWORK)
  .option(
    '--wallet <wallet>',
    'The name of the wallet, including the python module and wallet class.',
    process.env.STARKNET_WALLET,
  )
  .action((options: IDeployAccountProps) => {
    runStarknetDeployAccount(options);
  });

interface ICallOrInvokeProps_ {
  address: string;
  function: string;
  inputs?: string[];
}
export type ICallOrInvokeProps = ICallOrInvokeProps_ & IOptionalNetwork & IOptionalWallet;

program
  .command('invoke <file>')
  .requiredOption('--address <address>', 'Address of contract to invoke.')
  .requiredOption('--function <function>', 'Function to invoke.')
  .option('--inputs <inputs...>', 'Input to function.', undefined)
  .option('--network <network>', 'Starknet network URL.', process.env.STARKNET_NETWORK)
  .option(
    '--wallet <wallet>',
    'The name of the wallet, including the python module and wallet class.',
    process.env.STARKNET_WALLET,
  )
  .action((file: string, options: ICallOrInvokeProps) => {
    runStarknetCallOrInvoke(file, false, options);
  });

program
  .command('call <file>')
  .requiredOption('--address <address>', 'Address of contract to call.')
  .requiredOption('--function <function>', 'Function to call.')
  .option('--inputs <inputs...>', 'Input to function.', undefined)
  .option('--network <network>', 'Starknet network URL.', process.env.STARKNET_NETWORK)
  .option(
    '--wallet <wallet>',
    'The name of the wallet, including the python module and wallet class.',
    process.env.STARKNET_WALLET,
  )
  .action((file: string, options: ICallOrInvokeProps) => {
    runStarknetCallOrInvoke(file, true, options);
  });

program.parse(process.argv);
