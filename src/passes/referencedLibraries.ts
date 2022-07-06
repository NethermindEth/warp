import assert from 'assert';
import {
  ASTNode,
  // ASTNode,
  ContractDefinition,
  ContractKind,
  DataLocation,
  ElementaryTypeName,
  Expression,
  FunctionCall,
  FunctionDefinition,
  FunctionType,
  getNodeType,
  Identifier,
  MemberAccess,
  Mutability,
  SourceUnit,
  StateVariableVisibility,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { generateExpressionTypeString } from '../utils/getTypeString';
import { createIdentifier, createVariableDeclarationStatement } from '../utils/nodeTemplates';

// Library calls in solidity are delegate calls
// i.e  So we need to create an new name space, I guess it could be a new ContractDefinition.

// Must check this holds out for using for.
// See what to do about internal library functions, should they still be inlined??
// @interface

// Make sure that multiple calls to the same library do not make it insert multipl Variable Declarations in to constructor and just repoint them.
export class ReferencedLibraries extends ASTMapper {
  libCallCount = 0;
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    // const librariesById = new Map<number, ContractDefinition>();
    if (node.vExpression instanceof MemberAccess) {
      //Collect all library nodes and their ids in the map 'contractDef'
      const funcDefContract =
        node.vReferencedDeclaration?.getClosestParentByType(ContractDefinition);
      const funcCallContract = node.getClosestParentByType(ContractDefinition);
      if (
        funcCallContract !== funcDefContract &&
        funcCallContract !== undefined &&
        funcDefContract !== undefined &&
        funcDefContract.kind === ContractKind.Library
      ) {
        node.vExpression.memberName = 'library_call_' + node.vExpression.memberName;
        assert(node.vExpression.vExpression instanceof Identifier);
        node.vExpression.vExpression.name = node.vExpression.vExpression.name + '_warped_interface';
        const parentFuncDef = node.getClosestParentByType(FunctionDefinition);
        assert(parentFuncDef !== undefined);
        const classHashVarDecl = new VariableDeclaration(
          ast.reserveId(),
          '',
          true,
          false,
          `lib_class_hash${this.libCallCount}`,
          parentFuncDef.id,
          false,
          DataLocation.Default,
          StateVariableVisibility.Default,
          Mutability.Constant,
          'address',
          undefined,
          new ElementaryTypeName(ast.reserveId(), '', 'address', 'address'),
        );
        this.addArgToContructor(funcCallContract, ast);
        const filePath = funcCallContract.getClosestParentByType(SourceUnit)?.absolutePath;
        assert(filePath !== undefined);
        ast.libraryClassHashOrder.unshift(filePath);
        parentFuncDef.vParameters.insertAtBeginning(classHashVarDecl);
        assert(
          node.vReferencedDeclaration instanceof FunctionDefinition &&
            node.vReferencedDeclaration !== undefined,
        );
        this.addClashHashArg(node.vReferencedDeclaration, ast);
        this.modifyTypeString(node.vExpression, classHashVarDecl, ast);
        const classHashArg = createIdentifier(classHashVarDecl, ast);
        node.vArguments.unshift(classHashArg);
        node.acceptChildren();
        ast.setContextRecursive(parentFuncDef);
        this.libCallCount++;
      }
    }

    this.commonVisit(node, ast);
  }

  modifyTypeString(node: Expression, classHashArg: VariableDeclaration, ast: AST): void {
    const classHashType = getNodeType(classHashArg, ast.compilerVersion);
    const functionType = getNodeType(node, ast.compilerVersion);
    assert(functionType instanceof FunctionType);
    functionType.parameters.unshift(classHashType);
    node.typeString = generateExpressionTypeString(functionType);
  }

  addClashHashArg(funcDef: FunctionDefinition, ast: AST): VariableDeclaration {
    const varDecl = createClassHashVarDecl(funcDef, ast);
    funcDef.vParameters.insertAtBeginning(varDecl);
    funcDef.acceptChildren();
    ast.setContextRecursive(funcDef);
    return varDecl;
  }

  addArgToContructor(contractDef: ContractDefinition, ast: AST): void {
    const constructor = contractDef.vConstructor;
    assert(constructor != undefined);
    const classHashBlock = createClassHashVarDecl(constructor, ast);
    constructor?.vParameters.insertAtBeginning(classHashBlock);

    const classHashStorageVar = createClassHashVarDecl(contractDef, ast);
    const clashHashBlockId: Identifier = createIdentifier(classHashBlock, ast);
    //const expressionStatement = createExpressionStatement(clashHashBlockId, ast);
    const varDeclStatement = createVariableDeclarationStatement(
      [classHashStorageVar],
      clashHashBlockId,
      ast,
    );
    const body = constructor.vBody;
    body?.insertAtBeginning(varDeclStatement);
    ast.setContextRecursive(contractDef);
  }
}

// Used to prevent sanity check from failing.
function createClassHashVarDecl(funcDef: ASTNode, ast: AST): VariableDeclaration {
  const classHashVarDecl = new VariableDeclaration(
    ast.reserveId(),
    '',
    true,
    false,
    '@class_hash',
    funcDef.id,
    true,
    DataLocation.Storage,
    StateVariableVisibility.Default,
    Mutability.Constant,
    'address', // Probably needs to be changed to pointer
    undefined,
    new ElementaryTypeName(ast.reserveId(), '', 'address', 'address'),
  );
  return classHashVarDecl;
}
