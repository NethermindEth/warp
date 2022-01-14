/* import {
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
  UserDefinedValueTypeDefinition,
  UsingForDirective,
  InheritanceSpecifier,
  ContractDefinition,
  StructuredDocumentation,
  ImportDirective,
  PragmaDirective,
  SourceUnit,
  TypeName,
  Expression,
  ASTNode,
  PrimaryExpression,
  ASTNodeWithChildren,
  Statement,
  StatementWithChildren,
  YulNode,
} from 'solc-typed-ast';
import { CairoAssert } from '../src/ast/cairoNodes';
import CairoASTNode from '../src/ast/cairoNodes/cairoASTNode';


//Supertype
//  Subtype (referenced node subtypes)


ASTNode
  ASTNodeWithChildren<T>
    ContractDefinition (StructuredDocumentation, SourceUnit, ContractDefinition, ErrorDefinition)
    EnumDefinition (EnumValue, ContractDefinition|SourceUnit)
    OverrideSpecifier (UserDefinedTypeName|IdentifierPath)
    ParameterList (VariableDeclaration)
    SourceUnit (ContractDefinition|EnumDefinition|ErrorDefinition|FunctionDefinition|ImportDirective|StructDefinition|UserDefinedValueTypeDefinition|VariableDeclaration)
    StatementWithChildren<T> (StructuredDocumentation)
      Block(Statement)
      UncheckedBlock
    StructDefinition (VariableDeclaration, ContractDefinition|SourceUnit)
  CairoASTNode
    CairoAssert (Expression)
  EnumValue
  ErrorDefinition (StructuredDocumentation|string, ParameterList, ContractDefinition|SourceUnit)
  EventDefinition (StructuredDocumentation|string, ParameterList, ContractDefinition)
  Expression
    Assignment (Expression)
    BinaryOperation (Expression)
    Conditional (Expression)
    ElementaryTypeNameExpression (ElementaryTypeName)
    FunctionCall (Expression)
    FunctionCallOptions (Expression)
    IndexAccess (Expression)
    IndexRangeAccess (Expression)
    MemberAccess (Expression)
    NewExpression (TypeName)
    PrimaryExpression
      Identifier
      Literal
    TupleExpression (Expression)
    UnaryOperation (Expression)
  FunctionDefinition (StructuredDocumentation, ModifierInvocation, Block, OverrideSpecifier?, ParameterList, ContractDefinition|SourceUnit)
  IdentifierPath
  ImportDirective (SourceUnit)
  InheritanceSpecifier (UserDefinedTypeName|IdentifierPath, Expression)
  ModifierDefinition (StructuredDocumentation|string, ParameterList, OverrideSpecifier?, Block, ContractDefinition, )
  ModifierInvocation (Identifier|IdentifierPath, Expression, [ModifierDefinition|ContractDefinition])
  PragmaDirective
  Statement (StructuredDocumentation)
    Break
    Continue
    DoWhileStatement (Statement, Expression)
    EmitStatement (FunctionCall)
    ExpressionStatement (Expression)
    ForStatement (VariableDeclarationStatement|ExpressionStatement, Expression, ExpressionStatement, Statement)
    IfStatement (Statement, Expression)
    InlineAssembly - BANNED
    PlaceholderStatement
    Return (Expression, [ParameterList])
    RevertStatement (FunctionCall)
    Throw
    TryCatchClause (ParameterList, Block)
    TryStatement (FunctionCall, TryCatchClause)
    VariableDeclarationStatement (VariableDeclaration, Expression)
    WhileStatement (Expression, Statement)
  StructuredDocumentation
  TypeName
    ArrayTypeName (Expression)
    ElementaryTypeName
    FunctionTypeName
    Mapping
    UserDefinedTypeName (IdentifierPath?)
  UserDefinedValueTypeDefinition (ContractDefinition|SourceUnit, ElementaryTypeName)
  UsingForDirective (UserDefinedTypeName|IdentifierPath, TypeName?)
  VariableDeclaration (StructuredDocumentation, TypeName, OverrideSpecifier?, Expression)


// Constraints
//   A general ASTNode -> ASTNode map must obey the following


ASTNode
  ASTNodeWithChildren<T>
    ContractDefinition => ContractDefinition
    EnumDefinition => ExportedSymbol
    OverrideSpecifier => OverrideSpecifier?
    ParameterList => ParameterList
    SourceUnit => SourceUnit
    StatementWithChildren<T>
      Block => Block
      UncheckedBlock
    StructDefinition => ExportedSymbol
  CairoASTNode
    CairoAssert 
  EnumValue => EnumValue
  ErrorDefinition => ErrorDefinition
  EventDefinition 
  Expression => Expression
    Assignment 
    BinaryOperation 
    Conditional 
    ElementaryTypeNameExpression
    FunctionCall => FunctionCall
    FunctionCallOptions 
    IndexAccess 
    IndexRangeAccess 
    MemberAccess 
    NewExpression 
    PrimaryExpression
      Identifier => Identifier
      Literal
    TupleExpression 
    UnaryOperation 
  FunctionDefinition => ExportedSymbol
  IdentifierPath => Identifier|IdentifierPath
  ImportDirective => ExportedSymbol
  InheritanceSpecifier 
  ModifierDefinition => ModifierDefinition|ContractDefinition
  ModifierInvocation => ModifierInvocation
  PragmaDirective
  Statement => Statement
    Break
    Continue
    DoWhileStatement 
    EmitStatement 
    ExpressionStatement => ExpressionStatement
    ForStatement 
    IfStatement 
    InlineAssembly - BANNED
    PlaceholderStatement
    Return
    RevertStatement 
    Throw
    TryCatchClause => TryCatchClause
    TryStatement 
    VariableDeclarationStatement => VariableDeclarationStatement|ExpressionStatement
    WhileStatement 
  StructuredDocumentation => StructuredDocumentation
  TypeName => TypeName
    ArrayTypeName 
    ElementaryTypeName => ElementaryTypeName
    FunctionTypeName
    Mapping
    UserDefinedTypeName => UserDefinedTypeName|IdentifierPath
  UserDefinedValueTypeDefinition => ExportedSymbol
  UsingForDirective 
  VariableDeclaration => VariableDeclaration



*/
