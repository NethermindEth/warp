import * as path from 'path';
import { execSync } from 'child_process';
import { logError } from './errors';
import { IInstallOptions } from '../cli';

export function runVenvSetup(options: IInstallOptions) {
  try {
    const warpVenv = path.resolve(__dirname, '..', '..', 'warp_venv.sh');
    execSync(`${warpVenv} ${options.python}`, { stdio: options.verbose ? 'inherit' : 'pipe' });
  } catch {
    logError(
      'Try using --python option for warp install and specify the path to python3.7 e.g "warp install --python /usr/bin/python3.7"',
    );
  }
}
