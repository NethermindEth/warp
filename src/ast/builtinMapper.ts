import {
  ASTNode,
  DataLocation,
  ElementaryTypeName,
  FunctionKind,
  FunctionStateMutability,
  FunctionVisibility,
  Mutability,
  ParameterList,
  StateVariableVisibility,
  VariableDeclaration,
} from 'solc-typed-ast';
import { TranspileFailedError } from '../utils/errors';
import { Implicits } from '../utils/implicits';
import { AST } from './ast';
import { CairoFunctionDefinition } from './cairoNodes';
import { ASTMapper } from './mapper';

// TODO: replace this with a solution such that not defining a builtin
// definition errors out at compile time instead of at runtime.

// Common base class for the passes that make up BuiltinHandler
export abstract class BuiltinMapper extends ASTMapper {
  feltTypeName = (ast: AST) =>
    new ElementaryTypeName(
      ast.reserveId(),
      '',
      'ElementaryTypeName',
      'felt',
      'felt',
      undefined,
      'BINARY_BUILTIN',
    );
  uintTypeName = (ast: AST) =>
    new ElementaryTypeName(
      ast.reserveId(),
      '',
      'ElementaryTypeName',
      'uint256',
      'uint',
      undefined,
      'BINARY_BUILTIN',
    );
  addressTypeName = (ast: AST) =>
    new ElementaryTypeName(
      ast.reserveId(),
      '',
      'ElementaryTypeName',
      'address',
      'address',
      undefined,
      'BINARY_BUILTIN',
    );
  abstract builtinDefs: { [key: string]: (ast: AST) => ASTNode };
  private registeredDefs: { [key: string]: ASTNode } = {};

  getDefId(name: string, ast: AST): number {
    if (this.registeredDefs[name]) {
      return this.registeredDefs[name].id;
    }
    if (!this.builtinDefs[name]) {
      throw new TranspileFailedError(
        `Expected builtin ${name} to be registered before referencing it`,
      );
    }
    this.registeredDefs[name] = this.builtinDefs[name](ast);
    ast.setContextRecursive(this.registeredDefs[name]);
    return this.registeredDefs[name].id;
  }

  // TODO replace this with a solution that generates CairoFunctionDefinitions for the argument solidity types
  createBuiltInDef(
    name: string,
    inputs: [string, 'felt' | 'uint256' | 'address'][],
    returns: [string, 'felt' | 'uint256' | 'address'][],
    implicits: Implicits[],
  ): (ast: AST) => CairoFunctionDefinition {
    const createParameters = (inputs: [string, 'felt' | 'uint256' | 'address'][], ast: AST) =>
      inputs.map(
        ([name, type]) =>
          new VariableDeclaration(
            ast.reserveId(),
            '',
            'VariableDeclaration',
            false,
            false,
            name,
            -1,
            false,
            DataLocation.Memory,
            StateVariableVisibility.Private,
            Mutability.Mutable,
            type,
            undefined,
            type === 'felt'
              ? this.feltTypeName(ast)
              : type === 'uint256'
              ? this.uintTypeName(ast)
              : this.addressTypeName(ast),
          ),
      );

    return (ast: AST) =>
      new CairoFunctionDefinition(
        ast.reserveId(),
        '',
        'CairoFunctionDefinition',
        -1,
        FunctionKind.Function,
        name,
        false,
        FunctionVisibility.Private,
        FunctionStateMutability.NonPayable,
        false,
        new ParameterList(-1, '', 'ParameterList', createParameters(inputs, ast)),
        new ParameterList(-1, '', 'ParameterList', createParameters(returns, ast)),
        [],
        new Set(implicits),
      );
  }
}
