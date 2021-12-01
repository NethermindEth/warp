import { ASTNode } from 'solc-typed-ast';
import { ASTMapper } from './mapper';

// TODO: replace this with a solution such that not defining a builting
// definition errors out at compile time instead of at runtime.
export abstract class BuiltinMapper extends ASTMapper {
  abstract builtinDefs: { [key: string]: () => ASTNode };
  private registeredDefs: { [key: string]: ASTNode } = {};

  getDefId(name: string): number {
    if (this.registeredDefs[name]) {
      return this.registeredDefs[name].id;
    }
    if (!this.builtinDefs[name]) {
      throw new Error('Expected builtin to be registered before referencing it');
    }
    this.registeredDefs[name] = this.builtinDefs[name]();
    this.register(this.registeredDefs[name]);
    return this.registeredDefs[name].id;
  }
}
