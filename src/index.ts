import { Command } from 'commander';
import { AST } from './ast/ast';
import { isValidSolFile, outputResult, outputSol } from './io';
import { compileSolFile } from './solCompile';
import { runTests } from './testing';
import { handleTranspilationError, transform, transpile } from './transpiler';
import { analyseSol } from './utils/analyseSol';

export type TranspilationOptions = {
  checkTrees?: boolean;
  order?: string;
  printTrees?: boolean;
  strict?: boolean;
};

export type OutputOptions = {
  compileCairo?: boolean;
  compileErrors?: boolean;
  output?: string;
  result: boolean;
};

const program = new Command();

program
  .command('transpile <file>')
  .option('--compile-cairo')
  .option('--no-compile-errors')
  .option('--check-trees')
  .option('--order <passOrder>')
  .option('-o, --output <path>')
  .option('--print-trees')
  .option('--no-result')
  .option('--strict')
  .action((file: string, options: TranspilationOptions & OutputOptions) => {
    if (!isValidSolFile(file)) return;
    try {
      compileSolFile(file)
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
  .option('--order <passOrder>')
  .option('-o, --output <path>')
  .option('--print-trees')
  .option('--no-result')
  .option('--strict')
  .action((file: string, options: TranspilationOptions & OutputOptions) => {
    if (!isValidSolFile(file)) return;
    try {
      compileSolFile(file)
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

program.parse(process.argv);
