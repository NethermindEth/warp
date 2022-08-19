import { compileCairo } from './starknetCli';
import * as path from 'path';
import { logError } from './utils/errors';

export function generateSolInterface(filePath: string) {
  const { success, resultPath, abiPath } = compileCairo(filePath, path.resolve(__dirname, '..'), {
    debug_info: false,
  });
  if (!success) {
    logError(`Compilation of contract ${filePath} failed`);
    return;
  }
  const cairoPathRoot = filePath.slice(0, -'.cairo'.length);
  console.log(cairoPathRoot, resultPath, abiPath);
}
