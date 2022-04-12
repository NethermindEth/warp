import assert = require('assert');
import {
  DataLocation,
  Expression,
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  Identifier,
  MemberAccess,
  StructDefinition,
  UserDefinedTypeName,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createIdentifier } from '../../utils/nodeTemplates';
import { isExternallyVisible } from '../../utils/utils';
import { collectUnboundVariables } from './../loopFunctionaliser/utils';

export class StructModifier extends ASTMapper {
  /*
  Pass Explanation:
  Memory structs passed to external functions need to be registered and allocated to the WARP memory system. 
  This is done by turning the memory struct in into a calldata struct and inserting a VariableDeclarationStatment that
  creates a struct in memory in the function body. This will then be picked up in the References pass and the Struct will 
  persist in the WARP memory system.

  before pass:
  struct structDef {
    uint8 member1;
    uint8 member2;
  }

  function test(structDef memory structA) pure external returns (uint8) {
    return structA.member1;
  }

  after pass:
  struct structDef {
    uint8 member1;
    uint8 member2;
  }

  function test(structDef calldata structA) pure external returns (uint8) {
    structDef memory structA_mem = structDef(structA.member1, structA.member 2)
    return structA_mem.member1;
  }
  
  This only needs to be done for external functions since internal functions will use the references of the WARP memory system.
  */

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    const body = node.vBody;
    if (isExternallyVisible(node) && body !== undefined) {
      [...collectUnboundVariables(body).entries()]
        .filter(
          ([decl]) =>
            node.vParameters.vParameters.includes(decl) &&
            decl.storageLocation === DataLocation.Memory &&
            decl.vType instanceof UserDefinedTypeName &&
            decl.vType.vReferencedDeclaration instanceof StructDefinition,
        )
        .forEach(([varDecl, ids]) => {
          const memoryStruct = cloneASTNode(varDecl, ast);
          memoryStruct.name = memoryStruct.name + '_mem';
          varDecl.storageLocation = DataLocation.CallData;
          const varDeclStatement = this.createVariableDeclarationStatement(
            varDecl,
            memoryStruct,
            ast,
          );
          body.insertAtBeginning(varDeclStatement);
          ids.forEach((identifier) =>
            ast.replaceNode(
              identifier,
              createIdentifier(memoryStruct, ast, memoryStruct.storageLocation),
            ),
          );
        });
      ast.setContextRecursive(node);
    }
    this.commonVisit(node, ast);
  }

  private createVariableDeclarationStatement(
    calldataStruct: VariableDeclaration,
    memoryStruct: VariableDeclaration,
    ast: AST,
  ): VariableDeclarationStatement {
    const structDeclarationStatement = new VariableDeclarationStatement(
      ast.reserveId(),
      '',
      [memoryStruct.id],
      [memoryStruct],
      this.createStructConstructor(calldataStruct, memoryStruct, ast),
    );
    return structDeclarationStatement;
  }

  private createStructConstructor(
    calldataStruct: VariableDeclaration,
    memoryStruct: VariableDeclaration,
    ast: AST,
  ): FunctionCall {
    const structConstructorTypeString = this.generateStructTypeString(memoryStruct);
    assert(
      calldataStruct.vType instanceof UserDefinedTypeName &&
        calldataStruct.vType.vReferencedDeclaration instanceof StructDefinition,
    );

    const structConstructor = new FunctionCall(
      ast.reserveId(),
      '',
      structConstructorTypeString,
      FunctionCallKind.StructConstructorCall,
      this.generateStructIdentifier(calldataStruct, ast),
      this.generateMemberAccess(calldataStruct, ast),
    );
    return structConstructor;
  }

  private generateStructTypeString(varDecl: VariableDeclaration): string {
    const dataLocation = varDecl.storageLocation;
    assert(varDecl.vType instanceof UserDefinedTypeName);
    const structName = varDecl.typeString;

    return `${structName} ${dataLocation}`;
  }

  generateStructIdentifier(varDecl: VariableDeclaration, ast: AST): Expression {
    assert(
      varDecl.vType instanceof UserDefinedTypeName &&
        varDecl.vType.vReferencedDeclaration instanceof StructDefinition,
    );
    const funcIdentifier = new Identifier(
      ast.reserveId(),
      '',
      `type(${varDecl.typeString} storage pointer)`,
      varDecl.vType.vReferencedDeclaration.name,
      varDecl.vType.vReferencedDeclaration.id,
    );
    return funcIdentifier;
  }

  private generateMemberAccess(varDecl: VariableDeclaration, ast: AST): Array<MemberAccess> {
    assert(
      varDecl.vType instanceof UserDefinedTypeName &&
        varDecl.vType.vReferencedDeclaration instanceof StructDefinition,
    );
    const memberAccessArray = varDecl.vType.vReferencedDeclaration.vMembers.map((member) => {
      const newIdentifier = createIdentifier(varDecl, ast, varDecl.storageLocation);
      return new MemberAccess(
        ast.reserveId(),
        '',
        member.typeString,
        newIdentifier,
        member.name,
        member.id,
      );
    });
    return memberAccessArray;
  }
}
