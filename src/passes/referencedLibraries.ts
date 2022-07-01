import assert from 'assert';
import {
  // ASTNode,
  ContractDefinition,
  ContractKind,
  DataLocation,
  ElementaryTypeName,
  FunctionCall,
  FunctionDefinition,
  Identifier,
  MemberAccess,
  Mutability,
  StateVariableVisibility,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { createIdentifier } from '../utils/nodeTemplates';

// Library calls in solidity are delegate calls
// i.e  So we need to create an new name space, I guess it could be a new ContractDefinition.

// Must check this holds out for using for.
// See what to do about internal library functions, should they still be inlined??
// @interface
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
          'int8',
          undefined,
          new ElementaryTypeName(ast.reserveId(), '', 'int8', 'int8'),
        );
        parentFuncDef.vParameters.appendChild(classHashVarDecl);
        assert(
          node.vReferencedDeclaration instanceof FunctionDefinition &&
            node.vReferencedDeclaration !== undefined,
        );
        this.addClashHashArg(node.vReferencedDeclaration, ast);
        const classHashArg = createIdentifier(classHashVarDecl, ast);
        node.vArguments.unshift(classHashArg);
        node.acceptChildren();
        ast.setContextRecursive(parentFuncDef);
        this.libCallCount++;
      }
    }

    this.commonVisit(node, ast);
  }

  addClashHashArg(funcDef: FunctionDefinition, ast: AST): void {
    const varDecl = createClassHashVarDecl(funcDef, ast);
    // console.log(varDecl);
    funcDef.vParameters.insertAtBeginning(varDecl);
    funcDef.acceptChildren();
    ast.setContextRecursive(funcDef);
  }
}

function createClassHashVarDecl(funcDef: FunctionDefinition, ast: AST): VariableDeclaration {
  const classHashVarDecl = new VariableDeclaration(
    ast.reserveId(),
    '',
    true,
    false,
    '@class_hash',
    funcDef.id,
    false,
    DataLocation.Default,
    StateVariableVisibility.Default,
    Mutability.Constant,
    'int8',
    undefined,
    new ElementaryTypeName(ast.reserveId(), '', 'int8', 'int8'),
  );
  return classHashVarDecl;
}
