import {
  DataLocation,
  Expression,
  getNodeType,
  Identifier,
  IndexAccess,
  MemberAccess,
  PointerType,
  VariableDeclaration,
} from 'solc-typed-ast';
import { AST } from '../../ast/ast';
import { ASTMapper } from '../../ast/mapper';

/*
  Analyses all expressions in the AST to determine which datalocation (if any)
  they refer to. It's useful to do this as its own pass because there are edge cases
  not caught by a simple getNodeType (e.g. scalar storage variables)
*/

export class ActualLocationAnalyser extends ASTMapper {
  constructor(public actualLocations: Map<Expression, DataLocation>) {
    super();
  }

  visitExpression(node: Expression, ast: AST): void {
    const type = getNodeType(node, ast.compilerVersion);
    if (type instanceof PointerType) {
      this.actualLocations.set(node, type.location);
    } else {
      this.actualLocations.set(node, DataLocation.Default);
    }

    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    this.visitExpression(node, ast);
    // Storage var identifiers can be of scalar types, so would not be picked up
    // by the PointerType check
    if (
      node.vReferencedDeclaration instanceof VariableDeclaration &&
      node.vReferencedDeclaration.stateVariable
    ) {
      this.actualLocations.set(node, DataLocation.Storage);
    }
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    // Recurse first to analyse the base expression
    this.visitExpression(node, ast);

    // Checking this afterwards ensures that a memory struct inside a storage struct
    // is marked as being in storage
    const baseLocation = this.actualLocations.get(node.vExpression);

    if (baseLocation !== undefined) {
      this.actualLocations.set(node, baseLocation);
    }
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    // Works on the same principle as visitMemberAccess
    this.visitExpression(node, ast);

    const baseLocation = this.actualLocations.get(node.vBaseExpression);

    if (baseLocation !== undefined) {
      this.actualLocations.set(node, baseLocation);
    }
  }
}

// TODO determine whether it's better to use this function or the above pass
// export function getLocation(node: Expression, ast: AST): DataLocation {
//   // Storage var identifiers can be of scalar types, so would not be picked up
//   // by the PointerType check
//   if (
//     node instanceof Identifier &&
//     node.vReferencedDeclaration instanceof VariableDeclaration &&
//     node.vReferencedDeclaration.stateVariable
//   ) {
//     return DataLocation.Storage;
//   } else if (node instanceof MemberAccess) {
//     return getLocation(node.vExpression, ast);
//   } else if (node instanceof IndexAccess) {
//     return getLocation(node.vBaseExpression, ast);
//   }

//   const type = getNodeType(node, ast.compilerVersion);
//   if (type instanceof PointerType) {
//     return type.location;
//   }
//   return DataLocation.Default;
// }
