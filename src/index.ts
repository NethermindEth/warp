import { Command } from 'commander';
import {
  createAnalyseProgram,
  createCallProgram,
  createCompileProgram,
  createDeclareProgram,
  createDeployAccountProgram,
  createDeployProgram,
  createInstallProgram,
  createInvokeProgram,
  createStatusProgram,
  createTestProgram,
  createTransformProgram,
  createTranspileProgram,
  createVersionProgram,
} from './programFactory';

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

export type IDeclareOptions = IOptionalNetwork;

export const program = new Command();

createTranspileProgram(program);

createTransformProgram(program);

createTestProgram(program);

createAnalyseProgram(program);

const placeholderValue = { val: '' };

createCompileProgram(program, placeholderValue);

createStatusProgram(program, placeholderValue);

createDeployProgram(program, placeholderValue);

createDeployAccountProgram(program, placeholderValue);

createInvokeProgram(program, placeholderValue);

createCallProgram(program, placeholderValue);

createDeclareProgram(program, placeholderValue);

createInstallProgram(program);

createVersionProgram(program);

program.parse(process.argv);
