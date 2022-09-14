import { Command } from 'commander';
import { programs } from './programFactory';

export const program = new Command();

const placeholderValue = { val: '' };

for (const prog of programs) {
  prog(program, placeholderValue);
}

program.parse(process.argv);
