import { Command } from 'commander';

import * as fs from 'fs';
import {
  CompileResult,
  compileSol,
  ASTReader,
  DefaultASTWriterMapping,
  ASTWriter,
  LatestCompilerVersion,
  PrettyFormatter,
} from 'solc-typed-ast';

import { applyPasses, transpile } from './transpiler';

const program = new Command();

program.command('transpile <file>').action((file) => {
  if (fs.existsSync(file)) {
    const transpilationResult = transpile(file);
    if (transpilationResult === null) {
      console.log('Transpilation failed');
    } else {
      console.log(transpilationResult.join('\n\n\n'));
    }
  }
});

program.command('print <file>').action((file) => {
  let result: CompileResult;

  try {
    result = compileSol(file, 'auto', []);
    const reader = new ASTReader();
    const sourceUnits = reader.read(result.data);
    const formatter = new PrettyFormatter(4, 0);
    const writer = new ASTWriter(DefaultASTWriterMapping, formatter, LatestCompilerVersion);

    console.log(
      sourceUnits
        .map((s) => writer.write(applyPasses({ ast: s, imports: null }).ast))
        .join('\n\n\n'),
    );
  } catch (e) {
    console.log(e);
  }
});
program.parse(process.argv);
