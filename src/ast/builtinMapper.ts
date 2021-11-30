import {
  FunctionDefinition,
  FunctionKind,
  FunctionVisibility,
  FunctionStateMutability,
  ParameterList,
  VariableDeclaration,
  Mutability,
  StateVariableVisibility,
  DataLocation,
} from 'solc-typed-ast';
import { ASTMapper } from './mapper';

interface BuiltinArg {
  name: string;
  typeString: string;
}
interface BuiltinDef {
  name: string;
  src: string;
  args: BuiltinArg[];
  returns: BuiltinArg[];
}
// TODO: replace this with a solution such that not defining a builting
// definition errors out at compile time instead of at runtime.
export abstract class BuiltinMapper extends ASTMapper {
  abstract builtinDefs: { [key: string]: BuiltinDef };
  _registeredDefs: { [key: string]: FunctionDefinition } = {};

  genDef({ name, src, args, returns }: BuiltinDef) {
    const vDecArgs = args.map(
      (v) =>
        new VariableDeclaration(
          this.genId(),
          src,
          'VariableDeclaration',
          false,
          false,
          v.name,
          -1,
          false,
          DataLocation.Memory,
          StateVariableVisibility.Private,
          Mutability.Mutable,
          v.typeString,
        ),
    );
    const argParams = new ParameterList(this.genId(), src, 'ParameterList', vDecArgs);

    const vDecReturns = returns.map(
      (v) =>
        new VariableDeclaration(
          this.genId(),
          src,
          'VariableDeclaration',
          false,
          false,
          v.name,
          -1,
          false,
          DataLocation.Memory,
          StateVariableVisibility.Private,
          Mutability.Mutable,
          v.typeString,
        ),
    );
    const returnParams = new ParameterList(this.genId(), src, 'ParameterList', vDecReturns);
    const def = new FunctionDefinition(
      this.genId(),
      src,
      'FunctionDefinition',
      -1,
      FunctionKind.Function,
      name,
      false,
      FunctionVisibility.Internal,
      FunctionStateMutability.NonPayable,
      false,
      argParams,
      returnParams,
      [],
    );
    this.register(def);
    this._registeredDefs[name] = def;
    return def;
  }

  getDefId(name: string): number {
    if (this._registeredDefs[name]) {
      return this._registeredDefs[name].id;
    }
    if (!this.builtinDefs[name]) {
      throw new Error('Expected builtin to be registered before referencing it');
    }
    return this.genDef(this.builtinDefs[name]).id;
  }
}
