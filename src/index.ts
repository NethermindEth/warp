import { Command } from 'commander';
import {
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
} from './programFactory';

export const program = new Command();

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
createAnalyseProgram(program);
createTestProgram(program);
createTransformProgram(program);
createTranspileProgram(program);
// for (const prog of programs) {
//   prog(program, placeholderValue);
// }

program.parse(process.argv);
