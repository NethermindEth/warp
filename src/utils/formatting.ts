import chalk from 'chalk';
export const cyan = chalk.cyan.bold;
export const error = chalk.red.bold;

export function underline(text: string): string {
  return `${text}\n${'-'.repeat(text.length)}`;
}

export function removeExcessNewlines(text: string, maxAllowed: number): string {
  while (text.includes(`\n`.repeat(maxAllowed + 1))) {
    text = text.replace('\n'.repeat(maxAllowed + 1), `\n`.repeat(maxAllowed));
  }
  return text;
}
