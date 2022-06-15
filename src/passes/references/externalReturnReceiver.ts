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
import { createIdentifier } from '../../utils/nodeTemplates';

export class ExternalReturnReceiver extends ASTMapper {
  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): void {
    const receivesExternalReturn =
      node.vInitialValue instanceof FunctionCall &&
      node.vInitialValue.vReferencedDeclaration instanceof FunctionDefinition &&
      node.vInitialValue.vReferencedDeclaration.visibility === FunctionVisibility.External;

    if (!receivesExternalReturn) {
      return this.commonVisit(node, ast);
    }

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

    node.vDeclarations
      .filter((decl) => decl.storageLocation === DataLocation.CallData)
      .forEach((decl) => {
        const [statement, newId] = generatePackStatement(decl, ast);
        ast.insertStatementAfter(node, statement);
        node.assignments = node.assignments.map((value) => (value === decl.id ? newId : value));
      });
  }
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
    .externalFunctions.inputs.darrayStructConstructor.gen(callDataRawDecl, decl);

  ast.replaceNode(decl, callDataRawDecl);

  return [
    new VariableDeclarationStatement(ast.reserveId(), '', [decl.id], [decl], packExpression),
    callDataRawDecl.id,
  ];
}
