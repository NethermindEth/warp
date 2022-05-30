import * as path from 'path';
import { execSync } from 'child_process';
import { logError } from './errors';
import { IInstallOptions } from '../index';

export function runVenvSetup(options: IInstallOptions) {
  try {
    const warpVenv = path.resolve(__dirname, '..', '..', 'warp_venv.sh');
    execSync(`${warpVenv} ${options.python}`, { stdio: options.verbose ? 'inherit' : 'pipe' });
  } catch {
    logError('Try using --python option for warp install to specify the path to python3.7');
  }
}
