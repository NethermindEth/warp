// import assert from 'assert';
// import { AST } from '../../ast/ast';
// import {
//   ContractDefinition,
//   ContractKind,
//   FunctionDefinition,
//   Statement,
//   ExpressionStatement,
//   VariableDeclaration,
//   FunctionCall,
// } from 'solc-typed-ast';
// import { ASTMapper } from '../../ast/mapper';
// import { createIdentifier } from '../../utils/nodeTemplates';
// import { isExternallyVisible } from '../../utils/utils';

// export class EnumBoundChecker extends ASTMapper {
//   visitContractDefinition(node: ContractDefinition, ast: AST): void {
//     if (node.kind === ContractKind.Interface) {
//       return;
//     }
//     this.commonVisit(node, ast);
//   }

//   visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
//     if (isExternallyVisible(node) && node.vBody !== undefined) {
//       node.vParameters.vParameters.forEach((parameter) => {
//         if (parameter.typeString.slice(0, 4) === 'enum' && parameter.name !== undefined) {
//           const functionCall = this.generateFunctionCall(node, parameter, ast);
//           this.insertFunctionCall(node, functionCall, ast);
//         }
//       });
//     }
//     this.commonVisit(node, ast);
//   }

//   private generateFunctionCall(
//     node: FunctionDefinition,
//     parameter: VariableDeclaration,
//     ast: AST,
//   ): FunctionCall {
//     const enumStubArgument = createIdentifier(parameter, ast);
//     const functionCall = ast
//       .getUtilFuncGen(node)
//       .externalFunctions.inputsChecks.enum.gen(parameter, enumStubArgument);

//     return functionCall;
//   }

//   private insertFunctionCall(node: FunctionDefinition, functionCall: FunctionCall, ast: AST): void {
//     const expressionStatement = new ExpressionStatement(ast.reserveId(), '', functionCall);

//     const functionBlock = node.vBody;

//     assert(functionBlock !== undefined);
//     if (functionBlock.getChildren().length === 0) {
//       functionBlock.appendChild(expressionStatement);
//     } else {
//       const firstStatement = functionBlock.getChildrenByType(Statement)[0];

//       ast.insertStatementBefore(firstStatement, expressionStatement);
//     }
//     ast.setContextRecursive(expressionStatement);
//   }
// }
