export interface Class<T> {
  // By parameter contravariance this matches any function that returns T
  new (...x: never[]): T;
}

export function notNull<T>(x: T | null): x is T {
  return x !== null;
}

export function notUndefined<T>(x: T | undefined): x is T {
  return x !== undefined;
}
