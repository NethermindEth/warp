import * as os from 'os';
import * as path from 'path';

import { NotSupportedYetError } from './utils/errors';

type SupportedPlatforms = 'linux_x64' | 'darwin_x64' | 'darwin_arm64';
export type SupportedSolcVersions = '7' | '8';

export function getPlatform(): SupportedPlatforms {
  const platform = `${os.platform()}_${os.arch()}`;

  switch (platform) {
    case 'linux_x64':
    case 'darwin_x64':
    case 'darwin_arm64':
      return platform;
    default:
      throw new NotSupportedYetError(`Unsupported plaform ${platform}`);
  }
}

export function nethersolcPath(version: SupportedSolcVersions): string {
  const platform = getPlatform();
  return path.resolve(__dirname, '..', 'nethersolc', platform, version, 'solc');
}

export function fullVersionFromMajor(majorVersion: SupportedSolcVersions): string {
  switch (majorVersion) {
    case '7':
      return '0.7.6';
    case '8':
      return '0.8.14';
  }
}
