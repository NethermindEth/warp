export function extractFromStdout(stdout: string, regex: RegExp) {
  return [...stdout.matchAll(regex)][0][1];
}
