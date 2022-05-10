import assert from 'assert';
import {
  ArrayType,
  ContractDefinition,
  ContractKind,
  DataLocation,
  EnumDefinition,
  FunctionDefinition,
  FunctionVisibility,
  getNodeType,
  LiteralKind,
  StructDefinition,
  UserDefinedType,
  UserDefinedTypeName,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { printNode, printTypeNode } from './astPrinter';
import { NotSupportedYetError } from './errors';

export function getDeclaredTypeString(declaration: VariableDeclarationStatement): string {
  if (declaration.assignments.length === 1) {
    return declaration.vDeclarations[0].typeString;
  }

  const assignmentTypes = declaration.assignments.map((id) => {
    if (id === null) return '';

    const variable = declaration.vDeclarations.find((n) => n.id === id);
    assert(
      variable !== undefined,
      `${printNode(declaration)} attempts to assign to id ${id}, which is not in its declarations`,
    );
    return variable.typeString;
  });

  return `tuple(${assignmentTypes.join(',')})`;
}

export function getContractTypeString(node: ContractDefinition): string {
  if (node.kind === ContractKind.Interface) {
    return `type(contract ${node.name})`;
  }
  return `type(${node.kind} ${node.name})`;
}

export function getStructTypeString(node: StructDefinition): string {
  return `struct ${node.name}`;
}

export function getEnumTypeString(node: EnumDefinition): string {
  return `enum ${node.name}`;
}

export function getFunctionTypeString(node: FunctionDefinition, compilerVersion: string): string {
  const inputs = node.vParameters.vParameters
    .map((decl) => {
      const baseType = getNodeType(decl, compilerVersion);
      if (
        baseType instanceof ArrayType ||
        (baseType instanceof UserDefinedType && baseType.definition instanceof StructDefinition)
      ) {
        if (decl.storageLocation === DataLocation.Default) {
          if (
            decl.vType instanceof UserDefinedTypeName &&
            (decl.vType.vReferencedDeclaration instanceof EnumDefinition ||
              decl.vType.vReferencedDeclaration instanceof ContractDefinition)
          ) {
            return `${baseType.pp()}`;
          }
          throw new NotSupportedYetError(
            `Default location ref parameter to string not supported yet: ${printTypeNode(
              baseType,
              true,
            )} in ${node.name}`,
          );
        }
        return `${baseType.pp()} ${decl.storageLocation}`;
      }
      return baseType.pp();
    })
    .join(', ');
  const visibility =
    node.visibility === FunctionVisibility.Private || FunctionVisibility.Default
      ? ''
      : ` ${node.visibility}`;
  const outputs =
    node.vReturnParameters.vParameters.length === 0
      ? ''
      : `returns (${node.vReturnParameters.vParameters.map((decl) => decl.typeString).join(', ')})`;
  return `function (${inputs})${visibility} ${node.stateMutability} ${outputs}`;
}

export function getReturnTypeString(node: FunctionDefinition): string {
  const returns = node.vReturnParameters.vParameters;
  if (returns.length === 0) return 'tuple()';
  if (returns.length === 1)
    return `${returns[0].typeString}${
      returns[0].storageLocation === DataLocation.Default ? '' : ` ${returns[0].storageLocation}`
    }`;
  return `tuple(${returns
    .map(
      (decl) =>
        `${decl.typeString}${
          decl.storageLocation === DataLocation.Default ? '' : ` ${decl.storageLocation}`
        }`,
    )
    .join(',')})`;
}

export function generateLiteralTypeString(
  value: string,
  kind: LiteralKind = LiteralKind.Number,
): string {
  if (kind === LiteralKind.Bool) return 'bool';
  if (kind === LiteralKind.String) return `literal_string "${value}"`;

  if (kind === LiteralKind.Number) {
    if (value.length > 32) {
      value = `${value.slice(4)}...(${value.length - 8} digits omitted)...${value.slice(-4)}`;
    }
    return `int_const ${value}`;
  }

  throw new NotSupportedYetError(`Literal kind ${kind} is not supported yet`);
}
