import chalk from 'chalk';
export const error = chalk.red.bold;

export function logError(message: string): void {
  console.log(error(message));
}

export class TranspilationAbandonedError extends Error {
  constructor(message: string) {
    super(error(message));
  }
}

// For features that will not be supported unless Cairo changes to make implementing them feasible
export class WillNotSupportError extends TranspilationAbandonedError {
  constructor(message: string) {
    super(error(message));
  }
}
export class NotSupportedYetError extends TranspilationAbandonedError {
  constructor(message: string) {
    super(error(message));
  }
}
export class TranspileFailedError extends TranspilationAbandonedError {
  constructor(message: string) {
    super(error(message));
  }
}
