import assert from 'assert';
import {
  ASTNode,
  ContractDefinition,
  ContractKind,
  EnumDefinition,
  EnumValue,
  Expression,
  FunctionCall,
  getNodeType,
  Identifier,
  IntType,
  Literal,
  LiteralKind,
  MemberAccess,
  TypeNameType,
  UserDefinedType,
} from 'solc-typed-ast';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printTypeNode } from '../utils/astPrinter';
import { NotSupportedYetError } from '../utils/errors';
import { generateLiteralTypeString } from '../utils/getTypeString';
import { toHexString } from '../utils/utils';

function calculateIntMin(type: IntType): string {
  if (type.signed) {
    return (-(2n ** BigInt(type.nBits - 1))).toString();
  } else {
    return '0';
  }
}

function calculateIntMax(type: IntType): string {
  if (type.signed) {
    return (2n ** BigInt(type.nBits - 1) - 1n).toString();
  } else {
    return (2n ** BigInt(type.nBits) - 1n).toString();
  }
}

function createLiteral(
  valueString: string,
  valueKind: LiteralKind,
  ast: AST,
  src: string,
  raw: string | undefined,
) {
  return new Literal(
    ast.reserveId(),
    src,
    generateLiteralTypeString(valueString, valueKind),
    valueKind,
    valueKind !== LiteralKind.HexString ? toHexString(valueString) : valueString,
    valueString,
    undefined,
    raw,
  );
}

function createEnumMemberAccess(
  node: Expression,
  enumDef: EnumDefinition,
  member: EnumValue,
  ast: AST,
) {
  return new MemberAccess(
    ast.reserveId(),
    '',
    node.typeString,
    new Identifier(ast.reserveId(), '', node.typeString, enumDef.name, enumDef.id),
    member.name,
    member.id,
  );
}

export class TypeInformationCalculator extends ASTMapper {
  visitMemberAccess(node: MemberAccess, ast: AST): void {
    if (
      !node.vExpression.typeString.startsWith('type(') ||
      !(node.vExpression instanceof FunctionCall)
    ) {
      return;
    }

    const argNode = node.vExpression.vArguments[0];

    const replaceNode: ASTNode | null = this.getReplacement(argNode, node.memberName, ast);

    if (replaceNode !== null) {
      ast.replaceNode(node, replaceNode);
    }
  }

  private getReplacement(node: Expression, memberName: string, ast: AST): ASTNode | null {
    let nodeType = getNodeType(node, ast.compilerVersion);
    assert(
      nodeType instanceof TypeNameType,
      `Expected TypeNameType, found ${printTypeNode(nodeType)}`,
    );
    nodeType = nodeType.type;

    if (nodeType instanceof IntType && (memberName === 'min' || memberName === 'max'))
      return createLiteral(
        memberName === 'min' ? calculateIntMin(nodeType) : calculateIntMax(nodeType),
        LiteralKind.Number,
        ast,
        node.src,
        node.raw,
      );

    if (nodeType instanceof UserDefinedType) {
      const userDef = nodeType.definition;
      if (userDef instanceof EnumDefinition && (memberName === 'min' || memberName === 'max'))
        return memberName === 'min'
          ? createEnumMemberAccess(node, userDef, userDef.vMembers[0], ast)
          : createEnumMemberAccess(
              node,
              userDef,
              userDef.vMembers[userDef.vMembers.length - 1],
              ast,
            );

      if (userDef instanceof ContractDefinition) {
        if (memberName === 'name')
          return createLiteral(userDef.name, LiteralKind.String, ast, node.src, node.raw);
        if (memberName === 'runtimeCode')
          throw new NotSupportedYetError('`runtimeCode` member access not supported yet');
        if (memberName === 'executionCode')
          throw new NotSupportedYetError('`executionCode` member access not supported yet');

        if (userDef.kind === ContractKind.Interface && memberName === 'interfaceId') {
          const interfaceId = userDef.interfaceId(ABIEncoderVersion.V2);
          assert(
            interfaceId !== undefined,
            'Contracts of kind interface must have a defined interfaceId',
          );
          return createLiteral(
            BigInt('0x' + interfaceId).toString(),
            LiteralKind.Number,
            ast,
            node.src,
            node.raw,
          );
        }
      }
    }
    return null;
  }
}
