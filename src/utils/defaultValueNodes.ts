import {
  AddressType,
  ArrayType,
  BoolType,
  ElementaryTypeName,
  ElementaryTypeNameExpression,
  EnumDefinition,
  Expression,
  FixedBytesType,
  FunctionCall,
  FunctionCallKind,
  getNodeType,
  Identifier,
  IntType,
  Literal,
  LiteralKind,
  MappingType,
  MemberAccess,
  NewExpression,
  PointerType,
  StringType,
  StructDefinition,
  TupleExpression,
  TypeNode,
  UserDefinedType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { printNode, printTypeNode } from './astPrinter';
import { NotSupportedYetError } from './errors';
import { toHexString, typeNameFromTypeNode } from './utils';

export function getDefaultValue(
  nodeType: TypeNode,
  parentNode: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  if (nodeType instanceof AddressType) return addressDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof ArrayType) return arrayDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof BoolType) return boolDefault(parentNode, ast);
  else if (nodeType instanceof FixedBytesType) return fixedBytesDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof IntType) return intDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof MappingType) return intDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof PointerType) return pointerDefault(nodeType, parentNode, ast);
  else if (nodeType instanceof StringType) return stringDefault(parentNode, ast);
  else if (nodeType instanceof UserDefinedType) return userDefDefault(nodeType, parentNode, ast);
  else
    throw new NotSupportedYetError(`Not supported operation delete on ${printTypeNode(nodeType)}`);
}

function intDefault(
  node: TypeNode,
  parentNode: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  return new Literal(
    ast.reserveId(),
    parentNode.src,
    node.pp(),
    LiteralKind.Number,
    toHexString('0'),
    '0',
    undefined,
    parentNode.raw,
  );
}

function fixedBytesDefault(
  node: TypeNode,
  parentNode: Expression | VariableDeclaration,
  ast: AST,
): Expression {
  return new Literal(
    ast.reserveId(),
    parentNode.src,
    node.pp(),
    LiteralKind.Number,
    toHexString('0'),
    '0x0',
    undefined,
    parentNode.raw,
  );
}

function boolDefault(node: Expression | VariableDeclaration, ast: AST): Expression {
  return new Literal(
    ast.reserveId(),
    node.src,
    'bool',
    LiteralKind.Bool,
    toHexString('0'),
    'false',
    undefined,
    node.raw,
  );
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
      new ElementaryTypeName(
        ast.reserveId(),
        '',
        'address',
        'address',
        nodeType.payable ? 'payable' : 'nonpayable',
      ),
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
      true,
      expList,
      parentNode.raw,
    );
  }
}

function stringDefault(node: Expression | VariableDeclaration, ast: AST): Expression {
  return new Literal(
    ast.reserveId(),
    node.src,
    'literal_string ""',
    LiteralKind.String,
    toHexString('0'),
    '',
    undefined,
    node.raw,
  );
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
  else
    throw new NotSupportedYetError(
      `Not supported operation delete on ${printNode(nodeType.definition)}`,
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
    const tNode = getNodeType(member, ast.compilerVersion);
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
  else if (nodeType.to instanceof UserDefinedType) {
    return userDefDefault(nodeType.to, parentNode, ast);
  } else {
    throw new NotSupportedYetError(`Not supported operation delete on ${printTypeNode(nodeType)}`);
  }
}

function getTupleTypeString(nodeType: ArrayType): string {
  const node = nodeType.elementT;
  if (node instanceof PointerType) {
    if (node.to instanceof ArrayType)
      return `${getTupleTypeString(node.to)} memory[${nodeType.size}]`;
    else
      throw new NotSupportedYetError(`Not supported operation delete on ${printTypeNode(node.to)}`);
  } else {
    return nodeType.pp();
  }
}
