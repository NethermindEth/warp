import { Command } from 'commander';
import { createProgram } from './programFactory';

const program = new Command();

createProgram(program);

program.parse(process.argv);
