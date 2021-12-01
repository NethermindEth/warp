import {
  ASTNode,
  ASTContext,
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
} from 'solc-typed-ast';
import { ASTVisitor, Imports } from './visitor';
import * as clone from 'clone';
import { CairoStorageVariable } from './cairoStorageVariable';
import CairoAssert from './cairoAssert';
import { counterGenerator, mergeImports } from '../utils/utils';

export interface AST {
  ast: ASTNode;
  imports: Imports;
  compilerVersion: string;
}

export class ASTMapper extends ASTVisitor<ASTNode> {
  imports: Imports;

  compilerVersion: string;

  idGen: Generator<number, number, unknown>;

  context: ASTContext;

  genId(): number {
    return this.idGen.next().value;
  }

  register(node: ASTNode) {
    this.context.register(node);
    node.children.map((child) => this.register(child));
  }

  map(node: AST): AST {
    this.imports = node.imports;
    this.compilerVersion = node.compilerVersion;
    this.context = node.ast.context;
    this.idGen = counterGenerator(node.ast.context.lastId + 1);
    return {
      ast: this.visit(node.ast),
      imports: this.imports,
      compilerVersion: this.compilerVersion,
    };
  }

  addImport(newImports: Imports): void {
    this.imports = mergeImports(this.imports, newImports);
  }

  visitList(nodes: readonly ASTNode[]): ASTNode[] {
    const result = [];
    for (const node of nodes) {
      result.push(this.visit(node));
    }
    return result;
  }

  commonVisit(n: ASTNode): ASTNode {
    const node = clone.clonePrototype(n);
    for (const [key, value] of Object.entries(n)) {
      if (value instanceof ASTNode) {
        if (key !== 'parent') {
          node[key] = this.visit(value);
        }
      }
      if (value instanceof Array && value[0] instanceof ASTNode) {
        if (key !== 'parent') {
          node[key] = this.visitList(value);
        }
      }
    }
    return node;
  }
  visitElementaryTypeName(node: ElementaryTypeName): ASTNode {
    return this.commonVisit(node);
  }
  visitArrayTypeName(node: ArrayTypeName): ASTNode {
    return this.commonVisit(node);
  }
  visitMapping(node: Mapping): ASTNode {
    return this.commonVisit(node);
  }
  visitUserDefinedTypeName(node: UserDefinedTypeName): ASTNode {
    return this.commonVisit(node);
  }
  visitFunctionTypeName(node: FunctionTypeName): ASTNode {
    return this.commonVisit(node);
  }
  visitLiteral(node: Literal): ASTNode {
    return this.commonVisit(node);
  }
  visitIdentifier(node: Identifier): ASTNode {
    return this.commonVisit(node);
  }
  visitIdentifierPath(node: IdentifierPath): ASTNode {
    return this.commonVisit(node);
  }
  visitFunctionCallOptions(node: FunctionCallOptions): ASTNode {
    return this.commonVisit(node);
  }
  visitFunctionCall(node: FunctionCall): ASTNode {
    return this.commonVisit(node);
  }
  visitMemberAccess(node: MemberAccess): ASTNode {
    return this.commonVisit(node);
  }
  visitIndexAccess(node: IndexAccess): ASTNode {
    return this.commonVisit(node);
  }
  visitIndexRangeAccess(node: IndexRangeAccess): ASTNode {
    return this.commonVisit(node);
  }
  visitUnaryOperation(node: UnaryOperation): ASTNode {
    return this.commonVisit(node);
  }
  visitBinaryOperation(node: BinaryOperation): ASTNode {
    return this.commonVisit(node);
  }
  visitConditional(node: Conditional): ASTNode {
    return this.commonVisit(node);
  }
  visitElementaryTypeNameExpression(node: ElementaryTypeNameExpression): ASTNode {
    return this.commonVisit(node);
  }
  visitNewExpression(node: NewExpression): ASTNode {
    return this.commonVisit(node);
  }
  visitTupleExpression(node: TupleExpression): ASTNode {
    return this.commonVisit(node);
  }
  visitExpressionStatement(node: ExpressionStatement): ASTNode {
    return this.commonVisit(node);
  }
  visitAssignment(node: Assignment): ASTNode {
    return this.commonVisit(node);
  }
  visitVariableDeclaration(node: VariableDeclaration): ASTNode {
    return this.commonVisit(node);
  }
  visitBlock(node: Block): ASTNode {
    return this.commonVisit(node);
  }
  visitUncheckedBlock(node: UncheckedBlock): ASTNode {
    return this.commonVisit(node);
  }
  visitVariableDeclarationStatement(node: VariableDeclarationStatement): ASTNode {
    return this.commonVisit(node);
  }
  visitIfStatement(node: IfStatement): ASTNode {
    return this.commonVisit(node);
  }
  visitForStatement(node: ForStatement): ASTNode {
    return this.commonVisit(node);
  }
  visitWhileStatement(node: WhileStatement): ASTNode {
    return this.commonVisit(node);
  }
  visitDoWhileStatement(node: DoWhileStatement): ASTNode {
    return this.commonVisit(node);
  }
  visitReturn(node: Return): ASTNode {
    return this.commonVisit(node);
  }
  visitEmitStatement(node: EmitStatement): ASTNode {
    return this.commonVisit(node);
  }
  visitRevertStatement(node: RevertStatement): ASTNode {
    return this.commonVisit(node);
  }
  visitPlaceholderStatement(node: PlaceholderStatement): ASTNode {
    return this.commonVisit(node);
  }
  visitInlineAssembly(node: InlineAssembly): ASTNode {
    return this.commonVisit(node);
  }
  visitTryCatchClause(node: TryCatchClause): ASTNode {
    return this.commonVisit(node);
  }
  visitTryStatement(node: TryStatement): ASTNode {
    return this.commonVisit(node);
  }
  visitBreak(node: Break): ASTNode {
    return this.commonVisit(node);
  }
  visitContinue(node: Continue): ASTNode {
    return this.commonVisit(node);
  }
  visitThrow(node: Throw): ASTNode {
    return this.commonVisit(node);
  }
  visitParameterList(node: ParameterList): ASTNode {
    return this.commonVisit(node);
  }
  visitModifierInvocation(node: ModifierInvocation): ASTNode {
    return this.commonVisit(node);
  }
  visitOverrideSpecifier(node: OverrideSpecifier): ASTNode {
    return this.commonVisit(node);
  }
  visitFunctionDefinition(node: FunctionDefinition): ASTNode {
    return this.commonVisit(node);
  }
  visitModifierDefinition(node: ModifierDefinition): ASTNode {
    return this.commonVisit(node);
  }
  visitErrorDefinition(node: ErrorDefinition): ASTNode {
    return this.commonVisit(node);
  }
  visitEventDefinition(node: EventDefinition): ASTNode {
    return this.commonVisit(node);
  }
  visitStructDefinition(node: StructDefinition): ASTNode {
    return this.commonVisit(node);
  }
  visitEnumValue(node: EnumValue): ASTNode {
    return this.commonVisit(node);
  }
  visitEnumDefinition(node: EnumDefinition): ASTNode {
    return this.commonVisit(node);
  }
  visitUserDefinedValueTypeDefinition(node: UserDefinedValueTypeDefinition): ASTNode {
    return this.commonVisit(node);
  }
  visitUsingForDirective(node: UsingForDirective): ASTNode {
    return this.commonVisit(node);
  }
  visitInheritanceSpecifier(node: InheritanceSpecifier): ASTNode {
    return this.commonVisit(node);
  }
  visitContractDefinition(node: ContractDefinition): ASTNode {
    return this.commonVisit(node);
  }
  visitStructuredDocumentation(node: StructuredDocumentation): ASTNode {
    return this.commonVisit(node);
  }
  visitImportDirective(node: ImportDirective): ASTNode {
    return this.commonVisit(node);
  }
  visitPragmaDirective(node: PragmaDirective): ASTNode {
    return this.commonVisit(node);
  }
  visitSourceUnit(node: SourceUnit): ASTNode {
    return this.commonVisit(node);
  }
  visitCairoStorageVariable(node: CairoStorageVariable): ASTNode {
    return this.commonVisit(node);
  }
  visitCairoAssert(node: CairoAssert): ASTNode {
    return this.commonVisit(node);
  }
}
