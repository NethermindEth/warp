import {
  ContractDefinition,
  ContractKind,
  FunctionCall,
  FunctionDefinition,
  Identifier,
  MemberAccess,
  SourceUnit,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';

/*
  Solidity supports Library, function Definition inside UsingForDirectives:
  for.eg. a
    1.) list of file-level or library functions (using {f, g, h, L.t} for uint;)
    2.) he name of a library (using L for uint;) - all functions (both public and internal ones

  This pass will resolve the function call for given type that has been via `UsingForDirective`
  by visiting every MemberAccess Node inside the FunctionCall.

  For example, if we have:
      using {x} for uint; // x is a file-level function
      then a.x() will resolve to x(a)

  More details at: https://solidity.readthedocs.io/en/latest/usingfor.html
*/

export class UsingForResolver extends ASTMapper {
  // No need to check whether certain library/functions/library-functions
  // are attached to a type, as they would be checked by solc-typed-ast

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    this.commonVisit(node, ast);

    const memberAccessNode = node.vExpression;
    if (!(memberAccessNode instanceof MemberAccess)) return;

    const referencedFn = memberAccessNode.vReferencedDeclaration;
    if (!(referencedFn instanceof FunctionDefinition)) return;

    if (
      memberAccessNode.vExpression instanceof Identifier &&
      memberAccessNode.vExpression.vReferencedDeclaration instanceof ContractDefinition &&
      memberAccessNode.vExpression.vReferencedDeclaration.kind === ContractKind.Library
    )
      return;

    const referencedFnScope = referencedFn.vScope;

    if (referencedFnScope instanceof ContractDefinition) {
      const contract = referencedFnScope;
      if (contract.kind !== ContractKind.Library) return;

      const libraryIdentifier = new Identifier(
        ast.reserveId(),
        '',
        `type(library ${contract.name})`,
        contract.name,
        contract.id,
      );
      node.vArguments.unshift(memberAccessNode.vExpression);
      ast.registerChild(memberAccessNode.vExpression, node);
      memberAccessNode.vExpression = libraryIdentifier;
      memberAccessNode.memberName = referencedFn.name;
      ast.registerChild(libraryIdentifier, memberAccessNode);
    }

    if (referencedFnScope instanceof SourceUnit) {
      const functionIdentifier = new Identifier(
        ast.reserveId(),
        '',
        node.vExpression.typeString,
        referencedFn.name,
        referencedFn.id,
      );
      node.vArguments.unshift(memberAccessNode.vExpression);
      ast.registerChild(memberAccessNode.vExpression, node);
      node.vExpression = functionIdentifier;
      ast.registerChild(functionIdentifier, node);
    }
  }
}
