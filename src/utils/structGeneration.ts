// import {
//   ContractDefinition,
//   DataLocation,
//   FunctionCall,
//   FunctionCallKind,
//   FunctionDefinition,
//   FunctionVisibility,
//   Identifier,
//   StructDefinition,
//   VariableDeclaration,
// } from 'solc-typed-ast';
// import { AST } from '../ast/ast';
// import { CairoStructDefinitionStub } from '../ast/cairoNodes';
// import { cloneASTNode } from './cloning';
// import { createIdentifier } from './nodeTemplates';

// export function createCallToStructConstuctor(
//   name: string,
//   structDef: StructDefinition,
//   varDecl: VariableDeclaration,
//   ast: AST,
//   node: FunctionDefinition,
// ): FunctionCall {
//   const contract = node.getClosestParentByType(ContractDefinition);
//   return new FunctionCall(
//     ast.reserveId(),
//     '',
//     // This struct is then written into calldata (This is technically not correct)
//     `struct ${contract?.name}.${name} calldata`,
//     FunctionCallKind.StructConstructorCall,
//     new Identifier(
//       ast.reserveId(),
//       '',
//       `type(struct ${contract?.name}.${name} storage pointer)`,
//       structDef.name,
//       structDef.id,
//     ),
//     // This is Calldata since that the end of the pass that calls this function all dynamic arrays.
//     // should be in calldata.
//     [createIdentifier(varDecl, ast, DataLocation.CallData)],
//   );
// }

// export function createCairoStructConstructorStub(
//   name: string,
//   dArrayVarDecl: VariableDeclaration,
//   ast: AST,
// ): CairoStructDefinitionStub {
//   const sourceUnit = ast.getContainingRoot(dArrayVarDecl);

//   // Even though this is impossible it should still work.
//   const member = cloneASTNode(dArrayVarDecl, ast);
//   member.storageLocation = DataLocation.CallData;
//   const structDef = new CairoStructDefinitionStub(
//     ast.reserveId(),
//     '',
//     name,
//     sourceUnit.id,
//     FunctionVisibility.Internal,
//     [member],
//     true,
//   );

//   ast.setContextRecursive(structDef);
//   sourceUnit.insertAtBeginning(structDef);

//   return structDef;
// }
