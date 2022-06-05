import assert from 'assert';
import chalk from 'chalk';
export const cyan = chalk.cyan.bold;
export const error = chalk.red.bold;
import * as pathLib from 'path';

export function underline(text: string): string {
  return `${text}\n${'-'.repeat(text.length)}`;
}

export function removeExcessNewlines(text: string, maxAllowed: number): string {
  while (text.includes(`\n`.repeat(maxAllowed + 1))) {
    text = text.replace('\n'.repeat(maxAllowed + 1), `\n`.repeat(maxAllowed));
  }
  return text;
}

export function formatPath(path: string): string {
  assert(path.length > 0, 'Attempted to format empty import path');
  const base = path.endsWith('.sol') ? path.slice(0, -'.sol'.length) : path;
  return base.replaceAll(pathLib.sep, '.');
}
