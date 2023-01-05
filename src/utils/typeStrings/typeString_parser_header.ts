/* eslint-disable */
// Need the ts-nocheck to suppress the noUnusedLocals errors in the generated parser
// @ts-nocheck
import { lt } from 'semver';
import {
  ASTNode,
  ASTNodeConstructor,
  ContractDefinition,
  DataLocation,
  EnumDefinition,
  Expression,
  FunctionDefinition,
  FunctionStateMutability,
  FunctionVisibility,
  resolveAny,
  StructDefinition,
  UserDefinedValueTypeDefinition,
  VariableDeclaration,
  AddressType,
  ArrayType,
  BoolType,
  BuiltinType,
  BytesType,
  FixedBytesType,
  FunctionType,
  IntLiteralType,
  IntType,
  MappingType,
  PointerType,
  RationalLiteralType,
  StringLiteralType,
  StringType,
  TupleType,
  TypeNameType,
  TypeNode,
  UserDefinedType,
  assert,
  pp,
  InferType,
} from 'solc-typed-ast';
import { InaccessibleDynamicType } from './ast/inaccessible_dynamic_type';
import { ModuleType } from './ast/module_type';

function getFunctionAttributes(
  decorators: string[],
): [FunctionVisibility, FunctionStateMutability] {
  let visiblity: FunctionVisibility | undefined;
  let mutability: FunctionStateMutability | undefined;

  const visiblities = new Set<string>([
    FunctionVisibility.Internal,
    FunctionVisibility.External,
    FunctionVisibility.Public,
    FunctionVisibility.Private,
  ]);

  const mutabilities = new Set<string>([
    FunctionStateMutability.Pure,
    FunctionStateMutability.View,
    FunctionStateMutability.NonPayable,
    FunctionStateMutability.Payable,
  ]);

  for (const decorator of decorators) {
    if (visiblities.has(decorator)) {
      if (visiblity !== undefined) {
        throw new Error(
          `Multiple visiblity decorators specified: ${decorator} conflicts with ${visiblity}`,
        );
      }

      visiblity = decorator as FunctionVisibility;
    } else if (mutabilities.has(decorator)) {
      if (mutability !== undefined) {
        throw new Error(
          `Multiple mutability decorators specified: ${decorator} conflicts with ${mutability}`,
        );
      }

      mutability = decorator as FunctionStateMutability;
    }
  }

  // Assume default visiblity is internal
  if (visiblity === undefined) {
    visiblity = FunctionVisibility.Internal;
  }

  // Assume default mutability is non-payable
  if (mutability === undefined) {
    mutability = FunctionStateMutability.NonPayable;
  }

  return [visiblity, mutability];
}

/**
 * Return the `TypeNode` corresponding to `node`, where `node` is an AST node
 * with a type string (`Expression` or `VariableDeclaration`).
 *
 * The function uses a parser to process the type string,
 * while resolving and user-defined type references in the context of `node`.
 *
 * @param arg - an AST node with a type string (`Expression` or `VariableDeclaration`)
 * @param version - compiler version to be used. Useful as resolution rules changed between 0.4.x and 0.5.x.
 */
export function getNodeType(
  node: Expression | VariableDeclaration,
  inference: InferType,
): TypeNode {
  return parse(node.typeString, { ctx: node, inference }) as TypeNode;
}

/**
 * Return the `TypeNode` corresponding to `arg`, where `arg` is either a raw type string,
 * or an AST node with a type string (`Expression` or `VariableDeclaration`).
 *
 * The function uses a parser to process the type string,
 * while resolving and user-defined type references in the context of `ctx`.
 *
 * @param arg - either a type string, or a node with a type string (`Expression` or `VariableDeclaration`)
 * @param version - compiler version to be used. Useful as resolution rules changed between 0.4.x and 0.5.x.
 * @param ctx - `ASTNode` representing the context in which a type string is to be parsed
 */
export function getNodeTypeInCtx(
  arg: Expression | VariableDeclaration | string,
  inference: InferType,
  ctx: ASTNode,
): TypeNode {
  const typeString = typeof arg === 'string' ? arg : arg.typeString;

  return parse(typeString, { ctx, inference }) as TypeNode;
}

function makeUserDefinedType<T extends ASTNode>(
  name: string,
  constructor: ASTNodeConstructor<T>,
  inference: InferType,
  ctx: ASTNode,
): UserDefinedType {
  let defs = [...resolveAny(name, ctx, inference)];

  /**
   * Note that constructors below 0.5.0 may have same name as contract definition.
   */
  if (constructor === ContractDefinition) {
    defs = defs
      .filter(
        (def) =>
          def instanceof ContractDefinition ||
          (def instanceof FunctionDefinition && def.isConstructor && def.name === def.vScope.name),
      )
      .map((def) => (def instanceof FunctionDefinition ? def.vScope : def));
  } else {
    defs = defs.filter((def) => def instanceof constructor);
  }

  if (defs.length === 0) {
    throw new Error(`Couldn't find ${constructor.name} ${name}`);
  }

  if (defs.length > 1) {
    throw new Error(`Multiple matches for ${constructor.name} ${name}`);
  }

  const def = defs[0];

  assert(
    def instanceof constructor,
    'Expected {0} to resolve to {1} got {2} instead',
    name,
    constructor.name,
    def,
  );

  return new UserDefinedType(name, def);
}
