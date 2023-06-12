import * as path from 'path';
import * as fs from 'fs/promises';

export async function pathExists(path: string): Promise<boolean> {
  try {
    await fs.access(path);
    return true;
  } catch {
    return false;
  }
}

export async function outputFile(file: string, data: string) {
  const dir = path.dirname(file);

  if (!(await pathExists(dir))) {
    await fs.mkdir(dir, { recursive: true });
  }

  await fs.writeFile(file, data);
}
