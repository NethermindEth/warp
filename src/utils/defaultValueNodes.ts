import {
  AddressType,
  ArrayType,
  BoolType,
  BytesType,
  ContractDefinition,
  DataLocation,
  ElementaryTypeNameExpression,
  EnumDefinition,
  Expression,
  FixedBytesType,
  FunctionCall,
  FunctionCallKind,
  Identifier,
  IntType,
  MemberAccess,
  NewExpression,
  PointerType,
  StringType,
  StructDefinition,
  TupleExpression,
  TypeNode,
  UserDefinedType,
  UserDefinedValueTypeDefinition,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { printNode, printTypeNode } from './astPrinter';
import { NotSupportedYetError, TranspileFailedError } from './errors';
import { generateExpressionTypeString } from './getTypeString';
import {
  createAddressTypeName,
  createBoolLiteral,
  createNumberLiteral,
  createStringLiteral,
} from './nodeTemplates';
import { isStorageSpecificType, safeGetNodeType } from './nodeTypeProcessing';
import { typeNameFromTypeNode } from './utils';

export function getDefaultValue(
  nodeType: TypeNode,
  parentNode: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  if (shouldUsePlaceholderLiteral(nodeType, parentNode, ast))
    return intDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof AddressType) return addressDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof ArrayType) return arrayDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof BytesType) return bytesDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof BoolType) return boolDefault(parentNode, ast);
  else if (nodeType instanceof FixedBytesType) return fixedBytesDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof IntType) return intDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof PointerType) return pointerDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof StringType) return stringDefault(parentNode, ast);
  else if (nodeType instanceof UserDefinedType) return userDefDefault(nodeType, parentNode, ast);
  else
    throw new NotSupportedYetError(`Default value not implemented for ${printTypeNode(nodeType)}`);
}

function shouldUsePlaceholderLiteral(
  nodeType: TypeNode,
  parentNode: Expression | VariableDeclaration,
  ast: AST,
): boolean {
  if (isStorageSpecificType(nodeType, ast)) return true;

  if (
    parentNode instanceof VariableDeclaration &&
    !parentNode.stateVariable &&
    parentNode.storageLocation === DataLocation.Storage
  ) {
    return true;
  }

  return false;
}

function intDefault(
  node: TypeNode,
  parentNode: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  return createNumberLiteral(0, ast, generateExpressionTypeString(node));
}

function fixedBytesDefault(
  node: TypeNode,
  parentNode: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  return createNumberLiteral('0x0', ast, node.pp());
}

function boolDefault(node: Expression | VariableDeclaration, ast: AST): Expression {
  return createBoolLiteral(false, ast);
}

function addressDefault(
  nodeType: AddressType,
  node: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  return new FunctionCall(
    ast.reserveId(),
    node.src,
    nodeType.pp(),
    FunctionCallKind.TypeConversion,
    new ElementaryTypeNameExpression(
      ast.reserveId(),
      '',
      `type(${nodeType.pp()})`,
      createAddressTypeName(nodeType.payable, ast),
    ),
    [intDefault(nodeType, node, ast)],
    undefined,
    node.raw,
  );
}

function arrayDefault(
  nodeType: ArrayType,
  parentNode: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  const tString = nodeType.elementT.pp();
  if (nodeType.size === undefined) {
    // Dynamically-sized arrays
    return new FunctionCall(
      ast.reserveId(),
      parentNode.src,
      `${tString}[] memory`,
      FunctionCallKind.FunctionCall,
      new NewExpression(
        ast.reserveId(),
        '',
        `function (uint256) pure returns (${tString}[] memory)`,
        typeNameFromTypeNode(nodeType, ast),
      ),
      [intDefault(new IntType(256, false), parentNode, ast)],
      undefined,
      parentNode.raw,
    );
  } else {
    // Statically typed array
    const expList: Expression[] = [];
    for (let i = 0; i < nodeType.size; i++) {
      expList.push(getDefaultValue(nodeType.elementT, parentNode, ast));
    }
    return new TupleExpression(
      ast.reserveId(),
      parentNode.src,
      `${getTupleTypeString(nodeType)} memory`,
      true, // isInlineArray
      expList,
      parentNode.raw,
    );
  }
}

function bytesDefault(
  nodeType: BytesType,
  parentNode: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  return new FunctionCall(
    ast.reserveId(),
    parentNode.src,
    `bytes memory`,
    FunctionCallKind.FunctionCall,
    new NewExpression(
      ast.reserveId(),
      '',
      `function (uint256) pure returns (bytes memory)`,
      typeNameFromTypeNode(nodeType, ast),
    ),
    [intDefault(new IntType(256, false), parentNode, ast)],
    undefined,
    parentNode.raw,
  );
}

function stringDefault(node: Expression | VariableDeclaration, ast: AST): Expression {
  return createStringLiteral('', ast);
}

function userDefDefault(
  nodeType: UserDefinedType,
  parentNode: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  if (nodeType.definition instanceof StructDefinition)
    return structDefault(nodeType.definition, parentNode, ast);
  if (nodeType.definition instanceof EnumDefinition)
    return enumDefault(nodeType, nodeType.definition, parentNode, ast);
  if (nodeType.definition instanceof ContractDefinition)
    return new FunctionCall(
      ast.reserveId(),
      '',
      nodeType.pp(),
      FunctionCallKind.TypeConversion,
      new Identifier(
        ast.reserveId(),
        '',
        `type(${nodeType.pp()})`,
        nodeType.definition.name,
        nodeType.definition.id,
      ),
      [addressDefault(new AddressType(false), parentNode, ast)],
    );
  if (nodeType.definition instanceof UserDefinedValueTypeDefinition)
    return getDefaultValue(
      safeGetNodeType(nodeType.definition.underlyingType, ast.compilerVersion),
      parentNode,
      ast,
    );
  throw new TranspileFailedError(
    `Couldn't get a default value for user defined: ${printNode(nodeType.definition)}`,
  );
}

function enumDefault(
  node: TypeNode,
  definition: EnumDefinition,
  parentNode: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  const defaultValue = definition.vMembers[0]; //Enums require at least one member
  return new MemberAccess(
    ast.reserveId(),
    parentNode.src,
    node.pp(),
    new Identifier(ast.reserveId(), '', `type(${node.pp()})`, definition.name, definition.id),
    defaultValue.name,
    defaultValue.id,
    parentNode.raw,
  );
}

function structDefault(
  structNode: StructDefinition,
  node: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  const argsList: Expression[] = [];
  for (const member of structNode.vMembers) {
    const tNode = safeGetNodeType(member, ast.compilerVersion);
    argsList.push(getDefaultValue(tNode, node, ast));
  }
  return new FunctionCall(
    ast.reserveId(),
    node.src,
    `struct ${structNode.canonicalName} memory`,
    FunctionCallKind.StructConstructorCall,
    new Identifier(
      ast.reserveId(),
      '',
      `type(struct ${structNode.canonicalName} storage pointer)`,
      structNode.name,
      structNode.id,
    ),
    argsList,
    undefined,
    node.raw,
  );
}

function pointerDefault(
  nodeType: PointerType,
  parentNode: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  if (nodeType.to instanceof ArrayType) return arrayDefault(nodeType.to, parentNode, ast);
  else if (nodeType.to instanceof UserDefinedType)
    return userDefDefault(nodeType.to, parentNode, ast);
  else if (nodeType.to instanceof StringType) return stringDefault(parentNode, ast);
  else {
    throw new TranspileFailedError(
      `Couldn't get a default value for pointer: ${printTypeNode(nodeType)}`,
    );
  }
}

function getTupleTypeString(nodeType: ArrayType): string {
  const node = nodeType.elementT;
  if (node instanceof PointerType) {
    if (node.to instanceof ArrayType)
      return `${getTupleTypeString(node.to)} memory[${nodeType.size}]`;
    else
      throw new TranspileFailedError(
        `Couldn't get tuple type string, is not ArrayType: ${printTypeNode(node.to)}`,
      );
  } else {
    return nodeType.pp();
  }
}
