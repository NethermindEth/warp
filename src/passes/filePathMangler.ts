import { ImportDirective, SourceUnit } from 'solc-typed-ast';

import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { WillNotSupportError } from '../utils/errors';

const PATH_REGEX = /^[\w-@/\\]*$/;

export function checkPath(path: string) {
  const pathWithoutExtension = path.substring(0, path.length - '.sol'.length);
  if (!PATH_REGEX.test(pathWithoutExtension)) {
    throw new WillNotSupportError(
      'File path includes unsupported characters, only _, -, /, , and alphanumeric characters are supported',
    );
  }
}

export class FilePathMangler extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitSourceUnit(node: SourceUnit, ast: AST): void {
    checkPath(node.absolutePath);
    this.commonVisit(node, ast);
  }
}
