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
        const classHashArg = createIdentifier(classHashVarDecl, ast);
        node.vArguments.push(classHashArg);
        node.acceptChildren();
        ast.setContextRecursive(parentFuncDef);
        this.libCallCount++;
      }
    }

    // const calledDeclaration = node.vReferencedDeclaration;
    // if (calledDeclaration === undefined) {
    //   return this.visitExpression(node, ast);
    // }

    // //Checks if the Function is a referenced Library functions,
    // //if yes add it to the linearizedBaseContract list of parent ContractDefinition node
    // //free functions calling library functions are not yet supported
    // librariesById.forEach((library, _) => {
    //   if (library.vFunctions.some((libraryFunc) => libraryFunc.id === calledDeclaration.id)) {
    //     const parent = node.getClosestParentByType(ContractDefinition);
    //     if (parent === undefined) return;

    //     getLibrariesToInherit(library, librariesById).forEach((id) => {
    //       if (!parent.linearizedBaseContracts.includes(id)) {
    //         parent.linearizedBaseContracts.push(id);
    //       }
    //     });
    //   }
    // });
    this.commonVisit(node, ast);
  }
}
// function getLibrariesToInherit(
//   calledLibrary: ContractDefinition,
//   librariesById: Map<number, ASTNode>,
// ): number[] {
//   const ids: number[] = [calledLibrary.id];

//   calledLibrary
//     .getChildren()
//     .filter((child) => child instanceof FunctionCall && child.vExpression instanceof MemberAccess)
//     .forEach((functionCallInCalledLibrary) => {
//       if (functionCallInCalledLibrary instanceof FunctionCall) {
//         librariesById.forEach((library, libraryId) => {
//           assert(functionCallInCalledLibrary.vExpression instanceof MemberAccess);
//           const calledFuncId = functionCallInCalledLibrary.vExpression.referencedDeclaration;
//           if (library.getChildren().some((node) => node.id === calledFuncId)) {
//             ids.push(libraryId);
//           }
//         });
//       }
//     });

// return ids;
// }
