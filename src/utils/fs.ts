import * as path from 'path';
import * as fs from 'fs';

export function outputFileSync(file: string, data: string) {
  const dir = path.dirname(file);
  if (fs.existsSync(dir)) {
    return fs.writeFileSync(file, data);
  }
  fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(file, data);
}
