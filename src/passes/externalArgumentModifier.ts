import assert = require('assert');
import {
  DataLocation,
  Expression,
  FunctionCall,
  FunctionCallKind,
  FunctionDefinition,
  FunctionVisibility,
  Identifier,
  MemberAccess,
  replaceNode,
  StructDefinition,
  UserDefinedTypeName,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { cloneASTNode } from '../utils/cloning';
import { createIdentifier } from '../utils/nodeTemplates';
import { collectUnboundVariables } from './loopFunctionaliser/utils';

export class ExternalArgumentModifier extends ASTMapper {
  /*

  Looks for all memory struct VariableDeclarations in FunctionDefinitions. e.g FunctionExample(structDef memory structVar).
  For this memory struct to be implemented in our own memory system it needs to be registered and allocated. 
  There are passes later in the transpiler process that can take care of writing the struct into memory, we will just have 
  to create a memory struct in the function body for the later passes to work correctly.

  The processes of adding the struct to memory is as follows:
  Create a VariableDeclarationStatement that declares a memory struct with an initial value equal to the VariableDeclaration
  in the FunctionDefinition. Change the VariableDeclaration in the FunctionDefinition to have storageLocation = calldata.
  Change all identifiers in the function.vBody to refer to new memory struct instead of the now calldata struct.

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
  */
  // oldToNewStructMapping = new Map<VariableDeclaration, VariableDeclaration>();
  // identifiersNotToBeChanged = new Array<Identifier>();

  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    if (node.visibility === FunctionVisibility.External && node.vBody !== undefined) {
      const varDecIdentifierMap = collectUnboundVariables(node.vBody);
      node.vParameters.vParameters.forEach((varDecl) => {
        if (
          varDecl.storageLocation === DataLocation.Memory &&
          varDecl.vType instanceof UserDefinedTypeName &&
          varDecl.vType.vReferencedDeclaration instanceof StructDefinition
        ) {
          // memoryStructs.push(varDecl);
          const memoryStruct = cloneASTNode(varDecl, ast);
          memoryStruct.name = memoryStruct.name + '_mem';
          varDecl.storageLocation = DataLocation.CallData;
          const varDeclStatement = this.createVariableDeclarationStatement(
            varDecl,
            memoryStruct,
            ast,
          );
          node.vBody?.insertAtBeginning(varDeclStatement);
          varDecIdentifierMap
            .get(varDecl)
            ?.forEach((identifier) => replaceNode(identifier, createIdentifier(memoryStruct, ast)));
        }
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
    //const memoryStruct = cloneASTNode(calldataStruct, ast);
    //memoryStruct.name = calldataStruct.name + '_mem';
    //memoryStruct.storageLocation = DataLocation.Memory;
    //this.oldToNewStructMapping.set(calldataStruct, memoryStruct);
    // const callDataVarDecl = createIdentifier(memoryStruct, ast);
    const structDeclarationStatement = new VariableDeclarationStatement(
      ast.reserveId(),
      '',
      [memoryStruct.id],
      [memoryStruct],
      this.createStructConstructor(calldataStruct, memoryStruct, ast),
    );
    // this.identifiersNotToBeChanged.push(callDataVarDecl);
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
      const newIdentifier = createIdentifier(varDecl, ast);
      //this.identifiersNotToBeChanged.push(newIdentifier);
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

  // visitIdentifier(node: Identifier, ast: AST): void {
  //   if (
  //     node.vReferencedDeclaration instanceof VariableDeclaration &&
  //     this.oldToNewStructMapping.get(node.vReferencedDeclaration) !== undefined &&
  //     !this.identifiersNotToBeChanged.includes(node)
  //   ) {
  //     const newVarDecl = this.oldToNewStructMapping.get(node.vReferencedDeclaration);
  //     assert(newVarDecl !== undefined);
  //     ast.replaceNode(node, createIdentifier(newVarDecl, ast));
  //   }
  // }
}
