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
  TypeNode,
  UserDefinedType,
} from 'solc-typed-ast';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
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
    toHexString(valueString),
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
  console.log(
    `Attempting to create member access with type: ${node.typeString}`,
    `\n with name: ${member.name}`,
    `\n referensing id: ${member.id}`,
    `\n expression typeString: ${node.typeString}`,
    `\n expression reference to: ${enumDef.name}`,
    `\n expresion referencing id: ${enumDef.id}`,
  );
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
    console.log('---- First member access ----');
    console.log(node.vExpression.typeString);
    console.log(node.typeString);
    console.log(node.vExpression instanceof FunctionCall);
    if (
      !node.vExpression.typeString.startsWith('type(') ||
      !(node.vExpression instanceof FunctionCall)
    ) {
      return;
    }

    const argNode = node.vExpression.vArguments[0];
    console.log(
      `Arguments: ${node.vExpression.vArguments.reduce((acc, val) => {
        acc.push(val.typeString);
        return acc;
      }, [] as string[])}`,
    );
    // console.log(argNode);

    console.log('Pass filter 1');

    const replaceNode: ASTNode | null = this.getReplacement(argNode, node.memberName, ast);

    if (replaceNode !== null) {
      console.log('Replacing with:', replaceNode);
      ast.replaceNode(node, replaceNode);
    }
  }

  private getReplacement(node: Expression, memberName: string, ast: AST): ASTNode | null {
    let nodeType = getNodeType(node, ast.compilerVersion);
    nodeType = nodeType instanceof TypeNameType ? nodeType.type : nodeType;

    console.log('nodetype:', nodeType);

    if (nodeType instanceof IntType && (memberName === 'min' || memberName === 'max'))
      return createLiteral(
        memberName === 'min' ? calculateIntMin(nodeType) : calculateIntMax(nodeType),
        LiteralKind.Number,
        ast,
        node.src,
        node.raw,
      );

    console.log('filter 2', nodeType instanceof UserDefinedType);

    if (nodeType instanceof UserDefinedType) {
      console.log('User defined type');
      console.log(nodeType.pp());
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
        console.log('accessing ', memberName);
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
          return createLiteral(interfaceId, LiteralKind.HexString, ast, node.src, node.raw);
        }
      }
    }
    return null;
  }
}
