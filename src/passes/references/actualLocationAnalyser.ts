import {
  DataLocation,
  Expression,
  FunctionCall,
  FunctionDefinition,
  FunctionVisibility,
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
    // Storage var identifiers can be of scalar types, so would not be picked up
    // by the PointerType check
    if (
      node.vReferencedDeclaration instanceof VariableDeclaration &&
      node.vReferencedDeclaration.stateVariable
    ) {
      this.actualLocations.set(node, DataLocation.Storage);
      this.commonVisit(node, ast);
    } else {
      this.visitExpression(node, ast);
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

  visitFunctionCall(node: FunctionCall, ast: AST): void {
    if (
      node.vReferencedDeclaration instanceof FunctionDefinition &&
      node.vReferencedDeclaration.visibility === FunctionVisibility.External &&
      getNodeType(node, ast.compilerVersion) instanceof PointerType
    ) {
      this.actualLocations.set(node, DataLocation.CallData);
      this.commonVisit(node, ast);
    } else {
      this.visitExpression(node, ast);
    }
  }
}
