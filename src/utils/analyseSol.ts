import { isValidSolFile } from '../io';
import { compileSolFile } from '../solCompile';
import { DefaultASTPrinter } from './astPrinter';

export function analyseSol(file: string) {
  if (!isValidSolFile(file)) {
    console.log(`${file} is not a valid solidity file`);
  }

  compileSolFile(file, true).roots.forEach((root) => {
    console.log(`---${root.absolutePath}---`);
    console.log(DefaultASTPrinter.print(root));
  });
}
