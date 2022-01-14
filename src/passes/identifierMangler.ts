import {
  ASTNode,
  UserDefinedTypeName,
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
  UserDefinedValueTypeDefinition,
  UsingForDirective,
  InheritanceSpecifier,
  ContractDefinition,
  StructuredDocumentation,
  ImportDirective,
  PragmaDirective,
  SourceUnit,
  ExternalReferenceType,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoAssert } from '../ast/cairoNodes';
import { ASTMapper } from '../ast/mapper';

export class IdentifierMangler extends ASTMapper {
  lastUsedVariableId = 0;
  lastUsedFunctionId = 0;
  lastUsedTypeId = 0;

  updateQueue: (() => void)[] = [];

  map(ast: AST): AST {
    this.dispatchVisit(ast.root, ast);
    this.updateQueue.forEach((callBack) => callBack());
    return ast;
  }

  // This strategy should allow checked demangling post transpilation for a more readable result
  createNewFunctionName(existingName: string): string {
    return `__warp_usrfn${this.lastUsedFunctionId++}_${existingName}`;
  }

  createNewTypeName(existingName: string): string {
    return `__warp_usrT${this.lastUsedTypeId++}_${existingName}`;
  }

  createNewVariableName(existingName: string): string {
    return `__warp_usrid${this.lastUsedVariableId++}_${existingName}`;
  }

  visitUserDefinedTypeName(node: UserDefinedTypeName, ast: AST): void {
    this.updateQueue.push(() => {
      if (
        node.vReferencedDeclaration instanceof UserDefinedValueTypeDefinition ||
        node.vReferencedDeclaration instanceof StructDefinition
      ) {
        node.name = node.vReferencedDeclaration.name;
      }
    });

    this.commonVisit(node, ast);
  }

  visitIdentifier(node: Identifier, ast: AST): void {
    this.updateQueue.push(() => {
      if (
        node.vIdentifierType === ExternalReferenceType.UserDefined &&
        (node.vReferencedDeclaration instanceof VariableDeclaration ||
          node.vReferencedDeclaration instanceof FunctionDefinition)
      ) {
        node.name = node.vReferencedDeclaration.name;
      }
    });
  }
  visitIdentifierPath(node: IdentifierPath, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitFunctionCallOptions(node: FunctionCallOptions, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitFunctionCall(node: FunctionCall, ast: AST): void {
    // TODO field names
    this.commonVisit(node, ast);
  }
  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.commonVisit(node, ast);
    this.updateQueue.push(() => {
      const declaration = node.vReferencedDeclaration;

      if (declaration === undefined) {
        // No declaration means this is a solidity internal identifier
        return;
      } else if (
        declaration instanceof FunctionDefinition ||
        declaration instanceof VariableDeclaration ||
        declaration instanceof EnumValue
      ) {
        node.memberName = declaration.name;
      }
    });
  }
  visitIndexAccess(node: IndexAccess, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitIndexRangeAccess(node: IndexRangeAccess, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitUnaryOperation(node: UnaryOperation, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitBinaryOperation(node: BinaryOperation, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitConditional(node: Conditional, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitElementaryTypeNameExpression(node: ElementaryTypeNameExpression, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitNewExpression(node: NewExpression, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitTupleExpression(node: TupleExpression, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitExpressionStatement(node: ExpressionStatement, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitAssignment(node: Assignment, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitVariableDeclaration(node: VariableDeclaration, ast: AST): void {
    node.name = this.createNewVariableName(node.name);
    this.commonVisit(node, ast);
  }
  visitBlock(node: Block, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitUncheckedBlock(node: UncheckedBlock, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitVariableDeclarationStatement(node: VariableDeclarationStatement, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitIfStatement(node: IfStatement, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitForStatement(node: ForStatement, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitWhileStatement(node: WhileStatement, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitDoWhileStatement(node: DoWhileStatement, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitReturn(node: Return, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitEmitStatement(node: EmitStatement, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitRevertStatement(node: RevertStatement, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitPlaceholderStatement(node: PlaceholderStatement, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitInlineAssembly(node: InlineAssembly, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitTryCatchClause(node: TryCatchClause, ast: AST): void {
    // TODO may need to mangle this
    this.commonVisit(node, ast);
  }
  visitTryStatement(node: TryStatement, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitBreak(node: Break, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitContinue(node: Continue, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitThrow(node: Throw, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitParameterList(node: ParameterList, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitModifierInvocation(node: ModifierInvocation, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitOverrideSpecifier(node: OverrideSpecifier, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitFunctionDefinition(node: FunctionDefinition, ast: AST): void {
    // TODO switch based on type
    node.name = this.createNewFunctionName(node.name);
    this.commonVisit(node, ast);
  }
  visitModifierDefinition(node: ModifierDefinition, ast: AST): void {
    // TODO work out what this is
    this.commonVisit(node, ast);
  }
  visitErrorDefinition(node: ErrorDefinition, ast: AST): void {
    //TODO implement
    this.commonVisit(node, ast);
  }
  visitEventDefinition(node: EventDefinition, ast: AST): void {
    //TODO implement
    this.commonVisit(node, ast);
  }
  visitStructDefinition(node: StructDefinition, ast: AST): void {
    //TODO implement
    this.commonVisit(node, ast);
  }
  visitEnumValue(node: EnumValue, ast: AST): void {
    //TODO implement
    this.commonVisit(node, ast);
  }
  visitEnumDefinition(node: EnumDefinition, ast: AST): void {
    //TODO implement
    this.commonVisit(node, ast);
  }
  visitUserDefinedValueTypeDefinition(node: UserDefinedValueTypeDefinition, ast: AST): void {
    //TODO implement
    this.commonVisit(node, ast);
  }
  visitUsingForDirective(node: UsingForDirective, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitInheritanceSpecifier(node: InheritanceSpecifier, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitContractDefinition(node: ContractDefinition, ast: AST): void {
    //TODO implement
    this.commonVisit(node, ast);
  }
  visitStructuredDocumentation(node: StructuredDocumentation, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitImportDirective(node: ImportDirective, ast: AST): void {
    //TODO implement
    this.commonVisit(node, ast);
  }
  visitPragmaDirective(node: PragmaDirective, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitSourceUnit(node: SourceUnit, ast: AST): void {
    this.commonVisit(node, ast);
  }
  visitCairoAssert(node: CairoAssert, ast: AST): void {
    //TODO implement
    this.commonVisit(node, ast);
  }
}
