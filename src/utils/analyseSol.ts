import { PrintOptions } from '..';
import { isValidSolFile } from '../io';
import { compileSolFiles } from '../solCompile';
import { DefaultASTPrinter } from './astPrinter';

export function analyseSol(file: string, options: PrintOptions) {
  if (!isValidSolFile(file)) {
    console.log(`${file} is not a valid solidity file`);
  }

  DefaultASTPrinter.applyOptions(options);

  compileSolFiles([file], { warnings: true }).roots.forEach((root) => {
    console.log(`---${root.absolutePath}---`);
    console.log(DefaultASTPrinter.print(root));
  });
}
