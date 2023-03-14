import {
  DataLocation,
  FunctionCall,
  FunctionDefinition,
  FunctionVisibility,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';
import { cloneASTNode } from '../../utils/cloning';
import { createExpressionStatement, createIdentifier } from '../../utils/nodeTemplates';
import { isDynamicArray, safeGetNodeType } from '../../utils/nodeTypeProcessing';

export class ExternalReturnReceiver extends ASTMapper {
  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): void {
    // At this stage any external function calls are  cross contract function call because
    // all same contract public functions calls are redirected to internal ones
    const receivesExternalReturn =
      node.vInitialValue instanceof FunctionCall &&
      node.vInitialValue.vReferencedDeclaration instanceof FunctionDefinition &&
      node.vInitialValue.vReferencedDeclaration.visibility === FunctionVisibility.External;

    if (!receivesExternalReturn) {
      return this.commonVisit(node, ast);
    }

    // For each variable that receives an external call and is neither a value type nor a
    // reference type with calldata location, create a temporal variable which receives the
    // calldata output and then copy it to the current node expected location
    node.vDeclarations
      .filter(
        (decl) =>
          decl.storageLocation !== DataLocation.CallData &&
          decl.storageLocation !== DataLocation.Default,
      )
      .forEach((decl) => {
        const [statement, newId] = generateCopyStatement(decl, ast);
        ast.insertStatementAfter(node, statement);
        node.assignments = node.assignments.map((value) => (value === decl.id ? newId : value));
      });

    // If the calldata output is a calldata dynamic array, then pack it inside a struct
    node.vDeclarations
      .filter(
        (decl) =>
          decl.storageLocation === DataLocation.CallData &&
          isDynamicArray(safeGetNodeType(decl, ast.inference)),
      )
      .forEach((decl) => {
        const [statement, newId] = generatePackStatement(decl, ast);
        ast.insertStatementAfter(node, statement);
        node.assignments = node.assignments.map((value) => (value === decl.id ? newId : value));
      });

    node.vDeclarations.forEach((decl) => addOutputValidation(decl, ast));
  }
}

function addOutputValidation(decl: VariableDeclaration, ast: AST) {
  const validationFunctionCall = ast
    .getUtilFuncGen(decl)
    .boundChecks.inputCheck.gen(decl, safeGetNodeType(decl, ast.inference));
  const validationStatement = createExpressionStatement(ast, validationFunctionCall);
  ast.insertStatementAfter(decl, validationStatement);
}

function generateCopyStatement(
  decl: VariableDeclaration,
  ast: AST,
): [VariableDeclarationStatement, number] {
  const callDataDecl = cloneASTNode(decl, ast);
  callDataDecl.storageLocation = DataLocation.CallData;
  callDataDecl.name = `${callDataDecl.name}_cd`;

  ast.replaceNode(decl, callDataDecl);

  return [
    new VariableDeclarationStatement(
      ast.reserveId(),
      '',
      [decl.id],
      [decl],
      createIdentifier(callDataDecl, ast),
    ),
    callDataDecl.id,
  ];
}

function generatePackStatement(
  decl: VariableDeclaration,
  ast: AST,
): [VariableDeclarationStatement, number] {
  const callDataRawDecl = cloneASTNode(decl, ast);
  callDataRawDecl.name = `${callDataRawDecl.name}_raw`;

  const packExpression = ast
    .getUtilFuncGen(decl)
    .calldata.dynArrayStructConstructor.gen(callDataRawDecl, decl);

  ast.replaceNode(decl, callDataRawDecl);

  return [
    new VariableDeclarationStatement(ast.reserveId(), '', [decl.id], [decl], packExpression),
    callDataRawDecl.id,
  ];
}
