import { Command } from 'commander';

import * as fs from 'fs';
import {
  CompileResult,
  compileSol,
  ASTReader,
  ContractDefinition,
  DefaultASTWriterMapping,
  ASTWriter,
  LatestCompilerVersion,
  PrettyFormatter,
} from 'solc-typed-ast';

import { applyPasses, transpile } from './transpiler';

const program = new Command();

program.command('transpile <file> <contractName>').action((file, contractName) => {
  if (fs.existsSync(file)) {
    console.log(transpile(file, contractName));
  }
});

program.command('print <file> <contractName>').action((file, contractName) => {
  let result: CompileResult;

  try {
    result = compileSol(file, 'auto', []);
    const reader = new ASTReader();
    const sourceUnits = reader.read(result.data);

    let contractSourceUnit: ContractDefinition;
    for (const s of sourceUnits) {
      contractSourceUnit = s.vContracts.filter((c) => c.name === contractName)[0];
    }
    const formatter = new PrettyFormatter(4, 0);
    const writer = new ASTWriter(DefaultASTWriterMapping, formatter, LatestCompilerVersion);
    const ast = applyPasses({ ast: contractSourceUnit, imports: null });
    console.log(writer.write(ast.ast));
  } catch (e) {
    console.log(e);
  }
});
program.parse(process.argv);
