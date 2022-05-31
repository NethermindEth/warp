import { error } from './formatting';

export function logError(message: string): void {
  console.error(error(message));
}

export class CLIError extends Error {
  constructor(message: string) {
    super(error(message));
  }
}

export class TranspilationAbandonedError extends Error {
  constructor(message: string) {
    super(error(message));
  }
}

// For features that will not be supported unless Cairo changes to make implementing them feasible
export class WillNotSupportError extends TranspilationAbandonedError {}
export class NotSupportedYetError extends TranspilationAbandonedError {}
export class TranspileFailedError extends TranspilationAbandonedError {}
