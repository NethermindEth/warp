import { PrintOptions } from '../cli';
import { isValidSolFile } from '../io';
import { compileSolFiles } from '../solCompile';
import { DefaultASTPrinter } from './astPrinter';

export async function analyseSol(file: string, options: PrintOptions): Promise<void> {
  if (!isValidSolFile(file)) {
    console.log(`${file} is not a valid solidity file`);
  }

  DefaultASTPrinter.applyOptions(options);

  (await compileSolFiles([file], { warnings: true })).roots.forEach((root) => {
    console.log(`---${root.absolutePath}---`);
    console.log(DefaultASTPrinter.print(root));
  });
}
