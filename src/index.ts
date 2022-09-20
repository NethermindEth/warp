import { Command } from 'commander';
import { programs } from './programFactory';

export const program = new Command();

for (const prog of programs) {
  prog(program);
}

program.parse(process.argv);
