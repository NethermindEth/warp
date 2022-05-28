import * as path from 'path';
import { execSync } from 'child_process';

export function callVenvScript() {
  execSync(path.resolve(__dirname, '..', '..', 'warp_venv.sh'));
}
