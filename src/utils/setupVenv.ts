import * as path from 'path';
import { execSync } from 'child_process';
import { logError } from './errors';

export function runVenvSetup(python: string) {
  try {
    const warpVenv = path.resolve(__dirname, '..', '..', 'warp_venv.sh');
    execSync(`${warpVenv} ${python}`, { stdio: 'pipe' });
  } catch {
    logError('Try using --python option for warp install to specify the path to python3.7');
  }
}
