import * as path from 'path';
import * as fs from 'fs/promises';

export async function outputFile(file: string, data: string) {
  const dir = path.dirname(file);

  try {
    await fs.access(dir);
    return await fs.writeFile(file, data);
  } catch {
    await fs.mkdir(dir, { recursive: true });
    await fs.writeFile(file, data);
  }
}
