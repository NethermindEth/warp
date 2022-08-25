import fs from 'fs';
import { ASTNode, parseSourceLocation, SourceUnit } from 'solc-typed-ast';
import { error } from './formatting';
import { getSourceFromLocation } from './utils';

export function logError(message: string): void {
  console.error(error(message));
}

export function logCLIError(message: string): void {
  console.error(error(message));
  throw message;
}

export class CLIError extends Error {
  constructor(message: string) {
    super(error(message));
  }
}

export class TranspilationAbandonedError extends Error {
  constructor(message: string, node?: ASTNode) {
    super(`${error(message)}${`\n\n${getSourceCode(node)}\n`}`);
  }
}

function getSourceCode(node: ASTNode | undefined): string {
  if (node === undefined) return '';
  const sourceUnit = node.getClosestParentByType(SourceUnit);
  if (sourceUnit === undefined) return '';
  const filePath = sourceUnit.absolutePath;
  if (fs.existsSync(filePath)) {
    const content = fs.readFileSync(filePath, { encoding: 'utf-8' });
    return [
      `File ${filePath}:\n`,
      ...getSourceFromLocation(content, parseSourceLocation(node.src))
        .split('\n')
        .map((l) => `\t${l}`),
    ].join('\n');
  } else {
    return '';
  }
}

// For features that will not be supported unless Cairo changes to make implementing them feasible
export class WillNotSupportError extends TranspilationAbandonedError {}
export class NotSupportedYetError extends TranspilationAbandonedError {}
export class TranspileFailedError extends TranspilationAbandonedError {}
export class PassOrderError extends TranspilationAbandonedError {}
