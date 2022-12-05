import assert from 'assert';
import {
  ASTNode,
  ContractDefinition,
  ContractKind,
  EnumDefinition,
  EnumValue,
  Expression,
  ExternalReferenceType,
  FunctionCall,
  Identifier,
  IntType,
  MemberAccess,
  TypeNameType,
  UserDefinedType,
} from 'solc-typed-ast';
import { ABIEncoderVersion } from 'solc-typed-ast/dist/types/abi';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printTypeNode } from '../utils/astPrinter';
import { WillNotSupportError } from '../utils/errors';
import { createNumberLiteral, createStringLiteral } from '../utils/nodeTemplates';
import { safeGetNodeType } from '../utils/nodeTypeProcessing';

function calculateIntMin(type: IntType): bigint {
  if (type.signed) {
    return 1n << BigInt(type.nBits - 1);
  } else {
    return 0n;
  }
}

function calculateIntMax(type: IntType): bigint {
  if (type.signed) {
    return (1n << BigInt(type.nBits - 1)) - 1n;
  } else {
    return (1n << BigInt(type.nBits)) - 1n;
  }
}

function createEnumMemberAccess(
  outerTypeString: string,
  innerTypeString: string,
  enumDef: EnumDefinition,
  member: EnumValue,
  ast: AST,
) {
  return new MemberAccess(
    ast.reserveId(),
    '',
    outerTypeString,
    new Identifier(ast.reserveId(), '', innerTypeString, enumDef.name, enumDef.id),
    member.name,
    member.id,
  );
}

export class TypeInformationCalculator extends ASTMapper {
  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.visitExpression(node, ast);
    const typeFuncCall = node.vExpression;
    if (
      !(
        typeFuncCall instanceof FunctionCall &&
        typeFuncCall.vFunctionCallType === ExternalReferenceType.Builtin &&
        typeFuncCall.vFunctionName === 'type'
      )
    ) {
      return;
    }
    assert(
      typeFuncCall.vArguments.length === 1,
      `Calls to type() must have one argument, got ${typeFuncCall.vArguments.length}.`,
    );
    const argNode = typeFuncCall.vArguments[0];

    const replaceNode: ASTNode = this.getReplacement(
      argNode,
      node.memberName,
      node.typeString,
      ast,
    );
    ast.replaceNode(node, replaceNode);
  }

  private getReplacement(
    node: Expression,
    memberName: string,
    typestring: string,
    ast: AST,
  ): ASTNode {
    let nodeType = safeGetNodeType(node, ast.compilerVersion);
    assert(
      nodeType instanceof TypeNameType,
      `Expected TypeNameType, found ${printTypeNode(nodeType)}`,
    );
    nodeType = nodeType.type;

    if (nodeType instanceof IntType && (memberName === 'min' || memberName === 'max')) {
      const value = memberName === 'min' ? calculateIntMin(nodeType) : calculateIntMax(nodeType);
      return createNumberLiteral(value, ast, nodeType.pp());
    }

    if (nodeType instanceof UserDefinedType) {
      const userDef = nodeType.definition;
      if (userDef instanceof EnumDefinition && (memberName === 'min' || memberName === 'max'))
        return memberName === 'min'
          ? createEnumMemberAccess(typestring, node.typeString, userDef, userDef.vMembers[0], ast)
          : createEnumMemberAccess(
              typestring,
              node.typeString,
              userDef,
              userDef.vMembers[userDef.vMembers.length - 1],
              ast,
            );

      if (userDef instanceof ContractDefinition) {
        if (memberName === 'name') return createStringLiteral(userDef.name, ast);

        if (userDef.kind === ContractKind.Interface && memberName === 'interfaceId') {
          const interfaceId = userDef.interfaceId(ABIEncoderVersion.V2);
          assert(
            interfaceId !== undefined,
            'Contracts of kind interface must have a defined interfaceId',
          );
          const value = BigInt('0x' + interfaceId);
          return createNumberLiteral(value, ast);
        }

        throw new WillNotSupportError(
          `Member access "type(${nodeType.name}).${memberName}" is not supported`,
        );
      }
    }
    throw new WillNotSupportError(
      `Member access "type(${printTypeNode(nodeType)}).${memberName} is not supported"`,
    );
  }
}
