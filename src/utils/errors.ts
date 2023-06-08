import { existsSync, readFileSync } from 'fs';
import { ASTNode, parseSourceLocation, SourceUnit } from 'solc-typed-ast';
import execa from 'execa';
import { error } from './formatting';
import { getSourceFromLocations } from './utils';

export function logError(message: string): void {
  console.error(error(message));
}

export class CLIError extends Error {
  constructor(message: string) {
    super(error(message));
  }
}

export class InsaneASTError extends Error {}

export class TranspilationAbandonedError extends Error {
  constructor(message: string, node?: ASTNode, highlight = true) {
    message = highlight ? `${error(message)}${`\n\n${getSourceCode(node)}\n`}` : message;
    super(message);
  }
}

function getSourceCode(node: ASTNode | undefined): string {
  if (node === undefined) return '';
  const sourceUnit = node.getClosestParentByType(SourceUnit);
  if (sourceUnit === undefined) return '';
  const filePath = sourceUnit.absolutePath;
  if (existsSync(filePath)) {
    const content = readFileSync(filePath, { encoding: 'utf-8' });
    return [
      `File ${filePath}:\n`,
      ...getSourceFromLocations(content, [parseSourceLocation(node.src)], error, 3)
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

export function getErrorMessage(
  unsupportedPerSource: Map<string, [string, ASTNode][]>,
  initialMessage: string,
): string {
  const errorData = Array.from(unsupportedPerSource.entries());

  const sourceErrors = errorData.map(([filePath, errors]) => {
    const content = readFileSync(filePath, { encoding: 'utf8' });

    return {
      path: filePath,
      errors: errors.map(([message, node]) => ({
        message,
        code: getSourceFromLocations(content, [parseSourceLocation(node.src)], error, 4),
      })),
    };
  });

  let errorId = 0;

  return [
    error(initialMessage),
    sourceErrors.flatMap((source) => [
      `File: ${source.path}:`,
      ...source.errors.map((err) => `${error(`${++errorId}. ${err.message}`)}:\n\n${err.code}`),
    ]),
  ].join('\n');
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function instanceOfExecaError(object: any): object is execa.ExecaError {
  return 'stderr' in object;
}
