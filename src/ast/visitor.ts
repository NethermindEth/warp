import assert = require('assert');
import {
  ASTNode,
  ElementaryTypeName,
  ArrayTypeName,
  Mapping,
  UserDefinedTypeName,
  FunctionTypeName,
  Literal,
  Identifier,
  IdentifierPath,
  FunctionCallOptions,
  FunctionCall,
  MemberAccess,
  IndexAccess,
  IndexRangeAccess,
  UnaryOperation,
  BinaryOperation,
  Conditional,
  ElementaryTypeNameExpression,
  NewExpression,
  TupleExpression,
  ExpressionStatement,
  Assignment,
  VariableDeclaration,
  Block,
  UncheckedBlock,
  VariableDeclarationStatement,
  IfStatement,
  ForStatement,
  WhileStatement,
  DoWhileStatement,
  Return,
  EmitStatement,
  RevertStatement,
  PlaceholderStatement,
  InlineAssembly,
  TryCatchClause,
  TryStatement,
  Break,
  Continue,
  Throw,
  ParameterList,
  ModifierInvocation,
  OverrideSpecifier,
  FunctionDefinition,
  ModifierDefinition,
  ErrorDefinition,
  EventDefinition,
  StructDefinition,
  EnumValue,
  EnumDefinition,
  UsingForDirective,
  InheritanceSpecifier,
  ContractDefinition,
  StructuredDocumentation,
  ImportDirective,
  PragmaDirective,
  SourceUnit,
  UserDefinedValueTypeDefinition,
  ASTContext,
} from 'solc-typed-ast';
import { CairoAssert, CairoStorageVariable, CairoFunctionCall } from './cairoNodes';

export type Imports = { [module: string]: Set<string> };

function setDecendentContext(node: ASTNode, context: ASTContext): ASTNode {
  if (context === undefined) {
    throw new Error('Expecting context to be defined for all visits');
  }
  if (context.map.has(node.id)) {
    if (node.context === undefined) {
      throw new Error(
        "Expected node context to be defined if it's already registered with the context. Did you forget to create a new node id?",
      );
    }
  } else {
    context.register(node);
  }
  node.children.forEach((child) => setDecendentContext(child, context));
  return node;
}
export abstract class ASTVisitor<T> {
  visit(node: ASTNode): T {
    let res: T | null = null;
    if (node instanceof CairoStorageVariable) res = this.visitCairoStorageVariable(node);
    else if (node instanceof CairoAssert) res = this.visitCairoAssert(node);
    else if (node instanceof CairoFunctionCall) res = this.visitCairoFunctionCall(node);
    else if (node instanceof ElementaryTypeName) res = this.visitElementaryTypeName(node);
    else if (node instanceof ArrayTypeName) res = this.visitArrayTypeName(node);
    else if (node instanceof Mapping) res = this.visitMapping(node);
    else if (node instanceof UserDefinedTypeName) res = this.visitUserDefinedTypeName(node);
    else if (node instanceof FunctionTypeName) res = this.visitFunctionTypeName(node);
    else if (node instanceof Literal) res = this.visitLiteral(node);
    else if (node instanceof Identifier) res = this.visitIdentifier(node);
    else if (node instanceof IdentifierPath) res = this.visitIdentifierPath(node);
    else if (node instanceof FunctionCallOptions) res = this.visitFunctionCallOptions(node);
    else if (node instanceof FunctionCall) res = this.visitFunctionCall(node);
    else if (node instanceof MemberAccess) res = this.visitMemberAccess(node);
    else if (node instanceof IndexAccess) res = this.visitIndexAccess(node);
    else if (node instanceof IndexRangeAccess) res = this.visitIndexRangeAccess(node);
    else if (node instanceof UnaryOperation) res = this.visitUnaryOperation(node);
    else if (node instanceof BinaryOperation) res = this.visitBinaryOperation(node);
    else if (node instanceof Conditional) res = this.visitConditional(node);
    else if (node instanceof ElementaryTypeNameExpression)
      res = this.visitElementaryTypeNameExpression(node);
    else if (node instanceof NewExpression) res = this.visitNewExpression(node);
    else if (node instanceof TupleExpression) res = this.visitTupleExpression(node);
    else if (node instanceof ExpressionStatement) res = this.visitExpressionStatement(node);
    else if (node instanceof Assignment) res = this.visitAssignment(node);
    else if (node instanceof VariableDeclaration) res = this.visitVariableDeclaration(node);
    else if (node instanceof Block) res = this.visitBlock(node);
    else if (node instanceof UncheckedBlock) res = this.visitUncheckedBlock(node);
    else if (node instanceof VariableDeclarationStatement)
      res = this.visitVariableDeclarationStatement(node);
    else if (node instanceof IfStatement) res = this.visitIfStatement(node);
    else if (node instanceof ForStatement) res = this.visitForStatement(node);
    else if (node instanceof WhileStatement) res = this.visitWhileStatement(node);
    else if (node instanceof DoWhileStatement) res = this.visitDoWhileStatement(node);
    else if (node instanceof Return) res = this.visitReturn(node);
    else if (node instanceof EmitStatement) res = this.visitEmitStatement(node);
    else if (node instanceof RevertStatement) res = this.visitRevertStatement(node);
    else if (node instanceof PlaceholderStatement) res = this.visitPlaceholderStatement(node);
    else if (node instanceof InlineAssembly) res = this.visitInlineAssembly(node);
    else if (node instanceof TryCatchClause) res = this.visitTryCatchClause(node);
    else if (node instanceof TryStatement) res = this.visitTryStatement(node);
    else if (node instanceof Break) res = this.visitBreak(node);
    else if (node instanceof Continue) res = this.visitContinue(node);
    else if (node instanceof Throw) res = this.visitThrow(node);
    else if (node instanceof ParameterList) res = this.visitParameterList(node);
    else if (node instanceof ModifierInvocation) res = this.visitModifierInvocation(node);
    else if (node instanceof OverrideSpecifier) res = this.visitOverrideSpecifier(node);
    else if (node instanceof FunctionDefinition) res = this.visitFunctionDefinition(node);
    else if (node instanceof ModifierDefinition) res = this.visitModifierDefinition(node);
    else if (node instanceof ErrorDefinition) res = this.visitErrorDefinition(node);
    else if (node instanceof EventDefinition) res = this.visitEventDefinition(node);
    else if (node instanceof StructDefinition) res = this.visitStructDefinition(node);
    else if (node instanceof EnumValue) res = this.visitEnumValue(node);
    else if (node instanceof EnumDefinition) res = this.visitEnumDefinition(node);
    else if (node instanceof UserDefinedValueTypeDefinition)
      res = this.visitUserDefinedValueTypeDefinition(node);
    else if (node instanceof UsingForDirective) res = this.visitUsingForDirective(node);
    else if (node instanceof InheritanceSpecifier) res = this.visitInheritanceSpecifier(node);
    else if (node instanceof ContractDefinition) res = this.visitContractDefinition(node);
    else if (node instanceof StructuredDocumentation) res = this.visitStructuredDocumentation(node);
    else if (node instanceof ImportDirective) res = this.visitImportDirective(node);
    else if (node instanceof PragmaDirective) res = this.visitPragmaDirective(node);
    else if (node instanceof SourceUnit) res = this.visitSourceUnit(node);
    else {
      assert(false, `Unexpected node: ${node.type}`);
    }
    if (res instanceof ASTNode) {
      res.parent = node.parent;
      res.acceptChildren();
      setDecendentContext(res, node.context);
    }
    return res;
  }
  abstract visitElementaryTypeName(node: ElementaryTypeName): T;
  abstract visitArrayTypeName(node: ArrayTypeName): T;
  abstract visitMapping(node: Mapping): T;
  abstract visitUserDefinedTypeName(node: UserDefinedTypeName): T;
  abstract visitFunctionTypeName(node: FunctionTypeName): T;
  abstract visitLiteral(node: Literal): T;
  abstract visitIdentifier(node: Identifier): T;
  abstract visitIdentifierPath(node: IdentifierPath): T;
  abstract visitFunctionCallOptions(node: FunctionCallOptions): T;
  abstract visitFunctionCall(node: FunctionCall): T;
  abstract visitMemberAccess(node: MemberAccess): T;
  abstract visitIndexAccess(node: IndexAccess): T;
  abstract visitIndexRangeAccess(node: IndexRangeAccess): T;
  abstract visitUnaryOperation(node: UnaryOperation): T;
  abstract visitBinaryOperation(node: BinaryOperation): T;
  abstract visitConditional(node: Conditional): T;
  abstract visitElementaryTypeNameExpression(node: ElementaryTypeNameExpression): T;
  abstract visitNewExpression(node: NewExpression): T;
  abstract visitTupleExpression(node: TupleExpression): T;
  abstract visitExpressionStatement(node: ExpressionStatement): T;
  abstract visitAssignment(node: Assignment): T;
  abstract visitVariableDeclaration(node: VariableDeclaration): T;
  abstract visitBlock(node: Block): T;
  abstract visitUncheckedBlock(node: UncheckedBlock): T;
  abstract visitVariableDeclarationStatement(node: VariableDeclarationStatement): T;
  abstract visitIfStatement(node: IfStatement): T;
  abstract visitForStatement(node: ForStatement): T;
  abstract visitWhileStatement(node: WhileStatement): T;
  abstract visitDoWhileStatement(node: DoWhileStatement): T;
  abstract visitReturn(node: Return): T;
  abstract visitEmitStatement(node: EmitStatement): T;
  abstract visitRevertStatement(node: RevertStatement): T;
  abstract visitPlaceholderStatement(node: PlaceholderStatement): T;
  abstract visitInlineAssembly(node: InlineAssembly): T;
  abstract visitTryCatchClause(node: TryCatchClause): T;
  abstract visitTryStatement(node: TryStatement): T;
  abstract visitBreak(node: Break): T;
  abstract visitContinue(node: Continue): T;
  abstract visitThrow(node: Throw): T;
  abstract visitParameterList(node: ParameterList): T;
  abstract visitModifierInvocation(node: ModifierInvocation): T;
  abstract visitOverrideSpecifier(node: OverrideSpecifier): T;
  abstract visitFunctionDefinition(node: FunctionDefinition): T;
  abstract visitModifierDefinition(node: ModifierDefinition): T;
  abstract visitErrorDefinition(node: ErrorDefinition): T;
  abstract visitEventDefinition(node: EventDefinition): T;
  abstract visitStructDefinition(node: StructDefinition): T;
  abstract visitEnumValue(node: EnumValue): T;
  abstract visitEnumDefinition(node: EnumDefinition): T;
  abstract visitUserDefinedValueTypeDefinition(node: UserDefinedValueTypeDefinition): T;
  abstract visitUsingForDirective(node: UsingForDirective): T;
  abstract visitInheritanceSpecifier(node: InheritanceSpecifier): T;
  abstract visitContractDefinition(node: ContractDefinition): T;
  abstract visitStructuredDocumentation(node: StructuredDocumentation): T;
  abstract visitImportDirective(node: ImportDirective): T;
  abstract visitPragmaDirective(node: PragmaDirective): T;
  abstract visitSourceUnit(node: SourceUnit): T;
  abstract visitCairoStorageVariable(node: CairoStorageVariable): T;
  abstract visitCairoAssert(node: CairoAssert): T;
  abstract visitCairoFunctionCall(node: CairoFunctionCall): T;
}
