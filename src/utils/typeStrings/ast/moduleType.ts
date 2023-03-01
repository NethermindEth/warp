import { Range, TypeNode } from 'solc-typed-ast';

export class ModuleType extends TypeNode {
  readonly path: string;

  constructor(path: string, src?: Range) {
    super(src);

    this.path = path;
  }

  pp(): string {
    return `module "${this.path}"`;
  }
}
