import assert from 'assert';

import {
  ASTNode,
  ArrayTypeName,
  Assignment,
  BinaryOperation,
  Block,
  Break,
  Conditional,
  Continue,
  ContractDefinition,
  DoWhileStatement,
  ElementaryTypeName,
  ElementaryTypeNameExpression,
  EmitStatement,
  EnumDefinition,
  EnumValue,
  ErrorDefinition,
  EventDefinition,
  ExpressionStatement,
  ForStatement,
  FunctionCall,
  FunctionCallOptions,
  FunctionDefinition,
  FunctionTypeName,
  Identifier,
  IdentifierPath,
  IfStatement,
  ImportDirective,
  IndexAccess,
  IndexRangeAccess,
  InheritanceSpecifier,
  InlineAssembly,
  Literal,
  Mapping,
  MemberAccess,
  ModifierDefinition,
  ModifierInvocation,
  NewExpression,
  OverrideSpecifier,
  ParameterList,
  PlaceholderStatement,
  PragmaDirective,
  Return,
  RevertStatement,
  SourceUnit,
  StructDefinition,
  StructuredDocumentation,
  Throw,
  TryCatchClause,
  TryStatement,
  TupleExpression,
  UnaryOperation,
  UncheckedBlock,
  UserDefinedTypeName,
  UserDefinedValueTypeDefinition,
  UsingForDirective,
  VariableDeclaration,
  VariableDeclarationStatement,
  WhileStatement,
  TypeName,
  Expression,
  Statement,
  StatementWithChildren,
  ASTNodeWithChildren,
} from 'solc-typed-ast';
import { CairoAssert, CairoContract, CairoFunctionDefinition } from './cairoNodes';

import { AST } from './ast';

/*
 Visits every node in a tree in depth first order, calling visitT for each T extends ASTNode
 CommonVisit is abstract to allow the returned value from visiting the child nodes to affect
 the result for the parent
 By default each visitT method calls the visit method for the immediate supertype of T until
 commonVisit is called, this allows methods such as visitExpression to catch all expressions
*/

export abstract class ASTVisitor<T> {
  static getPassName(): string {
    return this.name;
  }
  dispatchVisit(node: ASTNode, ast: AST): T {
    let res: T | null = null;
    // console.log(this);
    // console.log((ast.roots[0].lastChild?.firstChild?.lastChild?.firstChild as VariableDeclarationStatement).vInitialValue);
    // ASTNodeWithChildren
    if (node instanceof CairoContract) res = this.visitCairoContract(node, ast);
    else if (node instanceof ContractDefinition) res = this.visitContractDefinition(node, ast);
    else if (node instanceof EnumDefinition) res = this.visitEnumDefinition(node, ast);
    else if (node instanceof OverrideSpecifier) res = this.visitOverrideSpecifier(node, ast);
    else if (node instanceof ParameterList) res = this.visitParameterList(node, ast);
    else if (node instanceof SourceUnit) res = this.visitSourceUnit(node, ast);
    //  StatementWithChildren
    else if (node instanceof Block) res = this.visitBlock(node, ast);
    else if (node instanceof UncheckedBlock) res = this.visitUncheckedBlock(node, ast);
    else if (node instanceof StructDefinition) res = this.visitStructDefinition(node, ast);
    else if (node instanceof EnumValue) res = this.visitEnumValue(node, ast);
    else if (node instanceof ErrorDefinition) res = this.visitErrorDefinition(node, ast);
    else if (node instanceof EventDefinition) res = this.visitEventDefinition(node, ast);
    // Expression
    else if (node instanceof Assignment) res = this.visitAssignment(node, ast);
    else if (node instanceof BinaryOperation) res = this.visitBinaryOperation(node, ast);
    else if (node instanceof CairoAssert) res = this.visitCairoAssert(node, ast);
    else if (node instanceof Conditional) res = this.visitConditional(node, ast);
    else if (node instanceof ElementaryTypeNameExpression)
      res = this.visitElementaryTypeNameExpression(node, ast);
    else if (node instanceof FunctionCall) res = this.visitFunctionCall(node, ast);
    else if (node instanceof FunctionCallOptions) res = this.visitFunctionCallOptions(node, ast);
    else if (node instanceof IndexAccess) res = this.visitIndexAccess(node, ast);
    else if (node instanceof IndexRangeAccess) res = this.visitIndexRangeAccess(node, ast);
    else if (node instanceof MemberAccess) res = this.visitMemberAccess(node, ast);
    else if (node instanceof NewExpression) res = this.visitNewExpression(node, ast);
    //  PrimaryExpression
    else if (node instanceof Identifier) res = this.visitIdentifier(node, ast);
    else if (node instanceof Literal) res = this.visitLiteral(node, ast);
    else if (node instanceof TupleExpression) res = this.visitTupleExpression(node, ast);
    else if (node instanceof UnaryOperation) res = this.visitUnaryOperation(node, ast);
    else if (node instanceof CairoFunctionDefinition)
      res = this.visitCairoFunctionDefinition(node, ast);
    else if (node instanceof FunctionDefinition) res = this.visitFunctionDefinition(node, ast);
    else if (node instanceof IdentifierPath) res = this.visitIdentifierPath(node, ast);
    else if (node instanceof ImportDirective) res = this.visitImportDirective(node, ast);
    else if (node instanceof InheritanceSpecifier) res = this.visitInheritanceSpecifier(node, ast);
    else if (node instanceof InlineAssembly) res = this.visitInlineAssembly(node, ast);
    else if (node instanceof ModifierDefinition) res = this.visitModifierDefinition(node, ast);
    else if (node instanceof ModifierInvocation) res = this.visitModifierInvocation(node, ast);
    else if (node instanceof PragmaDirective) res = this.visitPragmaDirective(node, ast);
    // Statement
    else if (node instanceof Break) res = this.visitBreak(node, ast);
    else if (node instanceof Continue) res = this.visitContinue(node, ast);
    else if (node instanceof DoWhileStatement) res = this.visitDoWhileStatement(node, ast);
    else if (node instanceof EmitStatement) res = this.visitEmitStatement(node, ast);
    else if (node instanceof ExpressionStatement) res = this.visitExpressionStatement(node, ast);
    else if (node instanceof ForStatement) res = this.visitForStatement(node, ast);
    else if (node instanceof IfStatement) res = this.visitIfStatement(node, ast);
    else if (node instanceof PlaceholderStatement) res = this.visitPlaceholderStatement(node, ast);
    else if (node instanceof Return) res = this.visitReturn(node, ast);
    else if (node instanceof RevertStatement) res = this.visitRevertStatement(node, ast);
    else if (node instanceof Throw) res = this.visitThrow(node, ast);
    else if (node instanceof TryCatchClause) res = this.visitTryCatchClause(node, ast);
    else if (node instanceof TryStatement) res = this.visitTryStatement(node, ast);
    else if (node instanceof VariableDeclarationStatement)
      res = this.visitVariableDeclarationStatement(node, ast);
    else if (node instanceof WhileStatement) res = this.visitWhileStatement(node, ast);
    else if (node instanceof StructuredDocumentation)
      res = this.visitStructuredDocumentation(node, ast);
    // TypeName
    else if (node instanceof ArrayTypeName) res = this.visitArrayTypeName(node, ast);
    else if (node instanceof ElementaryTypeName) res = this.visitElementaryTypeName(node, ast);
    else if (node instanceof FunctionTypeName) res = this.visitFunctionTypeName(node, ast);
    else if (node instanceof Mapping) res = this.visitMapping(node, ast);
    else if (node instanceof UserDefinedTypeName) res = this.visitUserDefinedTypeName(node, ast);
    else if (node instanceof UserDefinedValueTypeDefinition)
      res = this.visitUserDefinedValueTypeDefinition(node, ast);
    else if (node instanceof UsingForDirective) res = this.visitUsingForDirective(node, ast);
    else if (node instanceof VariableDeclaration) res = this.visitVariableDeclaration(node, ast);
    else {
      assert(false, `Unexpected node: ${node.type}`);
    }
    return res;
  }
  abstract commonVisit(node: ASTNode, ast: AST): T;
  visitCairoFunctionDefinition(node: CairoFunctionDefinition, ast: AST): T {
    return this.visitFunctionDefinition(node, ast);
  }
  visitElementaryTypeName(node: ElementaryTypeName, ast: AST): T {
    return this.visitTypeName(node, ast);
  }
  visitArrayTypeName(node: ArrayTypeName, ast: AST): T {
    return this.visitTypeName(node, ast);
  }
  visitMapping(node: Mapping, ast: AST): T {
    return this.visitTypeName(node, ast);
  }
  visitUserDefinedTypeName(node: UserDefinedTypeName, ast: AST): T {
    return this.visitTypeName(node, ast);
  }
  visitFunctionTypeName(node: FunctionTypeName, ast: AST): T {
    return this.visitTypeName(node, ast);
  }
  visitLiteral(node: Literal, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitIdentifier(node: Identifier, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitIdentifierPath(node: IdentifierPath, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitFunctionCallOptions(node: FunctionCallOptions, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitFunctionCall(node: FunctionCall, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitMemberAccess(node: MemberAccess, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitIndexAccess(node: IndexAccess, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitIndexRangeAccess(node: IndexRangeAccess, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitUnaryOperation(node: UnaryOperation, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitBinaryOperation(node: BinaryOperation, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitConditional(node: Conditional, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitElementaryTypeNameExpression(node: ElementaryTypeNameExpression, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitNewExpression(node: NewExpression, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitTupleExpression(node: TupleExpression, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitExpressionStatement(node: ExpressionStatement, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitAssignment(node: Assignment, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitVariableDeclaration(node: VariableDeclaration, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitBlock(node: Block, ast: AST): T {
    return this.visitStatementWithChildren(node, ast);
  }
  visitUncheckedBlock(node: UncheckedBlock, ast: AST): T {
    return this.visitStatementWithChildren(node, ast);
  }
  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitIfStatement(node: IfStatement, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitForStatement(node: ForStatement, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitWhileStatement(node: WhileStatement, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitDoWhileStatement(node: DoWhileStatement, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitReturn(node: Return, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitEmitStatement(node: EmitStatement, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitRevertStatement(node: RevertStatement, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitPlaceholderStatement(node: PlaceholderStatement, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitInlineAssembly(node: InlineAssembly, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitTryCatchClause(node: TryCatchClause, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitTryStatement(node: TryStatement, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitBreak(node: Break, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitContinue(node: Continue, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitThrow(node: Throw, ast: AST): T {
    return this.visitStatement(node, ast);
  }
  visitParameterList(node: ParameterList, ast: AST): T {
    return this.visitASTNodeWithChildren(node, ast);
  }
  visitModifierInvocation(node: ModifierInvocation, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitOverrideSpecifier(node: OverrideSpecifier, ast: AST): T {
    return this.visitASTNodeWithChildren(node, ast);
  }
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitModifierDefinition(node: ModifierDefinition, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitErrorDefinition(node: ErrorDefinition, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitEventDefinition(node: EventDefinition, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitStructDefinition(node: StructDefinition, ast: AST): T {
    return this.visitASTNodeWithChildren(node, ast);
  }
  visitEnumValue(node: EnumValue, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitEnumDefinition(node: EnumDefinition, ast: AST): T {
    return this.visitASTNodeWithChildren(node, ast);
  }
  visitUserDefinedValueTypeDefinition(node: UserDefinedValueTypeDefinition, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitUsingForDirective(node: UsingForDirective, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitInheritanceSpecifier(node: InheritanceSpecifier, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitContractDefinition(node: ContractDefinition, ast: AST): T {
    return this.visitASTNodeWithChildren(node, ast);
  }
  visitStructuredDocumentation(node: StructuredDocumentation, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitImportDirective(node: ImportDirective, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitPragmaDirective(node: PragmaDirective, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitSourceUnit(node: SourceUnit, ast: AST): T {
    return this.visitASTNodeWithChildren(node, ast);
  }
  visitCairoAssert(node: CairoAssert, ast: AST): T {
    return this.visitExpression(node, ast);
  }
  visitTypeName(node: TypeName, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitExpression(node: Expression, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitStatement(node: Statement, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitStatementWithChildren(node: StatementWithChildren<Statement>, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitASTNodeWithChildren(node: ASTNodeWithChildren<ASTNode>, ast: AST): T {
    return this.commonVisit(node, ast);
  }
  visitCairoContract(node: CairoContract, ast: AST): T {
    return this.visitContractDefinition(node, ast);
  }
}
