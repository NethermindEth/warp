import { PrintOptions } from '..';
import { isValidSolFile } from '../io';
import { compileSolFile } from '../solCompile';
import { DefaultASTPrinter } from './astPrinter';

export function analyseSol(file: string, options: PrintOptions) {
  if (!isValidSolFile(file)) {
    console.log(`${file} is not a valid solidity file`);
  }

  DefaultASTPrinter.applyOptions(options);

  compileSolFile(file, true).roots.forEach((root) => {
    console.log(`---${root.absolutePath}---`);
    console.log(DefaultASTPrinter.print(root));
  });
}
