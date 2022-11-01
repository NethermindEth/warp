import fs from 'fs';
import { ASTNode, parseSourceLocation, SourceUnit } from 'solc-typed-ast';
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
  if (fs.existsSync(filePath)) {
    const content = fs.readFileSync(filePath, { encoding: 'utf-8' });
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
  let errorNum = 0;
  const errorMsg = [...unsupportedPerSource.entries()].reduce(
    (fullMsg, [filePath, unsopported]) => {
      const content = fs.readFileSync(filePath, { encoding: 'utf8' });
      const newMessage = unsopported.reduce((newMessage, [errorMsg, node]) => {
        const errorCode = getSourceFromLocations(
          content,
          [parseSourceLocation(node.src)],
          error,
          4,
        );
        errorNum += 1;
        return newMessage + `\n${error(`${errorNum}. ` + errorMsg)}:\n\n${errorCode}\n`;
      }, `\nFile ${filePath}:\n`);

      return fullMsg + newMessage;
    },
    error(initialMessage + '\n'),
  );
  return errorMsg;
}
