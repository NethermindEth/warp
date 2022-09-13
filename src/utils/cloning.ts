import {
  ArrayTypeName,
  Assignment,
  ASTNode,
  BinaryOperation,
  Block,
  Break,
  Continue,
  ContractDefinition,
  ElementaryTypeName,
  ElementaryTypeNameExpression,
  EmitStatement,
  EnumDefinition,
  EventDefinition,
  Expression,
  ExpressionStatement,
  ForStatement,
  FunctionCall,
  FunctionCallOptions,
  FunctionDefinition,
  FunctionTypeName,
  Identifier,
  IdentifierPath,
  ImportDirective,
  IfStatement,
  IndexAccess,
  Literal,
  Mapping,
  MemberAccess,
  ModifierDefinition,
  ModifierInvocation,
  NewExpression,
  OverrideSpecifier,
  ParameterList,
  PlaceholderStatement,
  Return,
  TupleExpression,
  UnaryOperation,
  UncheckedBlock,
  UserDefinedTypeName,
  UsingForDirective,
  VariableDeclaration,
  VariableDeclarationStatement,
  WhileStatement,
  StructuredDocumentation,
  StructDefinition,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { CairoAssert, CairoFunctionDefinition } from '../ast/cairoNodes';
import { printNode } from './astPrinter';
import { NotSupportedYetError, TranspileFailedError } from './errors';
import { createParameterList } from './nodeTemplates';
import { notNull } from './typeConstructs';

export function cloneASTNode<T extends ASTNode>(node: T, ast: AST): T {
  const idRemappings = new Map<number, number>();
  const clonedNode = cloneASTNodeImpl(node, ast, idRemappings);
  clonedNode.walk((node: ASTNode) => {
    if (node instanceof Identifier || node instanceof UserDefinedTypeName) {
      node.referencedDeclaration =
        idRemappings.get(node.referencedDeclaration) ?? node.referencedDeclaration;
    } else if (node instanceof Return) {
      node.functionReturnParameters =
        idRemappings.get(node.functionReturnParameters) ?? node.functionReturnParameters;
    } else if (node instanceof VariableDeclarationStatement) {
      node.assignments = node.assignments.map((assignment) => {
        if (assignment === null) return null;
        return idRemappings.get(assignment) ?? assignment;
      });
    } else if (
      node instanceof FunctionDefinition ||
      node instanceof VariableDeclaration ||
      node instanceof ImportDirective
    ) {
      node.scope = idRemappings.get(node.scope) ?? node.scope;
    }
  });
  return clonedNode;
}

function cloneASTNodeImpl<T extends ASTNode>(
  node: T,
  ast: AST,
  remappedIds: Map<number, number>,
): T {
  let newNode: ASTNode | null = null;

  // Expressions---------------------------------------------------------------
  if (node instanceof Assignment) {
    newNode = new Assignment(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      node.operator,
      cloneASTNodeImpl(node.vLeftHandSide, ast, remappedIds),
      cloneASTNodeImpl(node.vRightHandSide, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof BinaryOperation) {
    newNode = new BinaryOperation(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      node.operator,
      cloneASTNodeImpl(node.vLeftExpression, ast, remappedIds),
      cloneASTNodeImpl(node.vRightExpression, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof CairoAssert) {
    newNode = new CairoAssert(
      replaceId(node.id, ast, remappedIds),
      node.src,
      cloneASTNodeImpl(node.vExpression, ast, remappedIds),
      node.assertMessage,
      node.raw,
    );
  } else if (node instanceof ElementaryTypeNameExpression) {
    newNode = new ElementaryTypeNameExpression(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      typeof node.typeName === 'string'
        ? node.typeName
        : cloneASTNodeImpl(node.typeName, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof FunctionCall) {
    newNode = new FunctionCall(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      node.kind,
      cloneASTNodeImpl(node.vExpression, ast, remappedIds),
      node.vArguments.map((arg) => cloneASTNodeImpl(arg, ast, remappedIds)),
      node.fieldNames,
      node.raw,
    );
  } else if (node instanceof FunctionCallOptions) {
    const newOptionMap = new Map<string, Expression>();
    [...node.vOptionsMap.entries()].forEach(([key, value]) =>
      newOptionMap.set(key, cloneASTNodeImpl(value, ast, remappedIds)),
    );

    newNode = new FunctionCallOptions(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      cloneASTNodeImpl(node.vExpression, ast, remappedIds),
      newOptionMap,
      node.raw,
    );
  } else if (node instanceof IndexAccess) {
    newNode = new IndexAccess(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      cloneASTNodeImpl(node.vBaseExpression, ast, remappedIds),
      node.vIndexExpression && cloneASTNodeImpl(node.vIndexExpression, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof Identifier) {
    newNode = new Identifier(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      node.name,
      node.referencedDeclaration,
      node.raw,
    );
  } else if (node instanceof Literal) {
    newNode = new Literal(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      node.kind,
      node.hexValue,
      node.value,
      node.subdenomination,
      node.raw,
    );
  } else if (node instanceof MemberAccess) {
    newNode = new MemberAccess(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      cloneASTNodeImpl(node.vExpression, ast, remappedIds),
      node.memberName,
      node.referencedDeclaration,
      node.raw,
    );
  } else if (node instanceof NewExpression) {
    newNode = new NewExpression(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      cloneASTNode(node.vTypeName, ast),
      node.raw,
    );
  } else if (node instanceof TupleExpression) {
    const tupleComponents = node.vOriginalComponents.map((component) => {
      return component !== null ? cloneASTNodeImpl(component, ast, remappedIds) : null;
    });
    newNode = new TupleExpression(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      node.isInlineArray,
      tupleComponents,
      node.raw,
    );
  } else if (node instanceof UnaryOperation) {
    newNode = new UnaryOperation(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      node.prefix,
      node.operator,
      cloneASTNodeImpl(node.vSubExpression, ast, remappedIds),
      node.raw,
    );
    // TypeNames---------------------------------------------------------------
  } else if (node instanceof ArrayTypeName) {
    newNode = new ArrayTypeName(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      cloneASTNodeImpl(node.vBaseType, ast, remappedIds),
      node.vLength && cloneASTNodeImpl(node.vLength, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof ElementaryTypeName) {
    newNode = new ElementaryTypeName(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      node.name,
      node.stateMutability,
      node.raw,
    );
  } else if (node instanceof FunctionTypeName) {
    newNode = new FunctionTypeName(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      node.visibility,
      node.stateMutability,
      cloneASTNodeImpl(node.vParameterTypes, ast, remappedIds),
      cloneASTNodeImpl(node.vReturnParameterTypes, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof Mapping) {
    newNode = new Mapping(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      cloneASTNodeImpl(node.vKeyType, ast, remappedIds),
      cloneASTNodeImpl(node.vValueType, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof UserDefinedTypeName) {
    newNode = new UserDefinedTypeName(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.typeString,
      node.name,
      node.referencedDeclaration,
      node.path ? cloneASTNodeImpl(node.path, ast, remappedIds) : undefined,
      node.raw,
    );
    // Statements--------------------------------------------------------------
  } else if (node instanceof Block) {
    newNode = new Block(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.vStatements.map((s) => cloneASTNodeImpl(s, ast, remappedIds)),
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof Break) {
    newNode = cloneBreak(node, ast, remappedIds);
  } else if (node instanceof Continue) {
    newNode = cloneContinue(node, ast, remappedIds);
  } else if (node instanceof ExpressionStatement) {
    newNode = new ExpressionStatement(
      replaceId(node.id, ast, remappedIds),
      node.src,
      cloneASTNodeImpl(node.vExpression, ast, remappedIds),
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof EmitStatement) {
    newNode = new EmitStatement(
      replaceId(node.id, ast, remappedIds),
      node.src,
      cloneASTNodeImpl(node.vEventCall, ast, remappedIds),
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof ForStatement) {
    newNode = new ForStatement(
      replaceId(node.id, ast, remappedIds),
      node.src,
      cloneASTNodeImpl(node.vBody, ast, remappedIds),
      node.vInitializationExpression &&
        cloneASTNodeImpl(node.vInitializationExpression, ast, remappedIds),
      node.vCondition && cloneASTNodeImpl(node.vCondition, ast, remappedIds),
      node.vLoopExpression && cloneASTNodeImpl(node.vLoopExpression, ast, remappedIds),
      cloneDocumentation(node.documentation, ast, remappedIds), //cloneASTNodeImpl()
      node.raw,
    );
  } else if (node instanceof IfStatement) {
    newNode = new IfStatement(
      replaceId(node.id, ast, remappedIds),
      node.src,
      cloneASTNodeImpl(node.vCondition, ast, remappedIds),
      cloneASTNodeImpl(node.vTrueBody, ast, remappedIds),
      node.vFalseBody && cloneASTNodeImpl(node.vFalseBody, ast, remappedIds),
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof PlaceholderStatement) {
    newNode = clonePlaceholder(node, ast, remappedIds);
  } else if (node instanceof Return) {
    newNode = new Return(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.functionReturnParameters,
      node.vExpression && cloneASTNodeImpl(node.vExpression, ast, remappedIds),
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof VariableDeclarationStatement) {
    newNode = new VariableDeclarationStatement(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.assignments,
      node.vDeclarations.map((decl) => cloneASTNodeImpl(decl, ast, remappedIds)),
      node.vInitialValue && cloneASTNodeImpl(node.vInitialValue, ast, remappedIds),
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof WhileStatement) {
    newNode = new WhileStatement(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.vCondition && cloneASTNodeImpl(node.vCondition, ast, remappedIds),
      node.vBody && cloneASTNodeImpl(node.vBody, ast, remappedIds),
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof UncheckedBlock) {
    newNode = new UncheckedBlock(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.vStatements.map((s) => cloneASTNodeImpl(s, ast, remappedIds)),
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.raw,
    );
  } else if (node instanceof UsingForDirective) {
    newNode = new UsingForDirective(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.isGlobal,
      node.vLibraryName && cloneASTNodeImpl(node.vLibraryName, ast, remappedIds),
      node.vFunctionList?.map((f) => cloneASTNodeImpl(f, ast, remappedIds)),
      node.vTypeName && cloneASTNodeImpl(node.vTypeName, ast, remappedIds),
      node.raw,
    );
    // Resolvable--------------------------------------------------------------
  } else if (node instanceof CairoFunctionDefinition) {
    newNode = new CairoFunctionDefinition(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.scope,
      node.kind,
      node.name,
      node.virtual,
      node.visibility,
      node.stateMutability,
      node.isConstructor,
      cloneASTNodeImpl(node.vParameters, ast, remappedIds),
      cloneASTNodeImpl(node.vReturnParameters, ast, remappedIds),
      node.vModifiers.map((m) => cloneASTNodeImpl(m, ast, remappedIds)),
      new Set([...node.implicits]),
      node.functionStubKind,
      node.acceptsRawDarray,
      node.acceptsUnpackedStructArray,
      node.vOverrideSpecifier && cloneASTNodeImpl(node.vOverrideSpecifier, ast, remappedIds),
      node.vBody && cloneASTNodeImpl(node.vBody, ast, remappedIds),
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.nameLocation,
      node.raw,
    );
  } else if (node instanceof EventDefinition) {
    newNode = new EventDefinition(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.anonymous,
      node.name,
      createParameterList(
        node.vParameters.vParameters.map((o) => cloneASTNodeImpl(o, ast, remappedIds)),
        ast,
      ),
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.nameLocation,
      node.raw,
    );
  } else if (node instanceof FunctionDefinition) {
    newNode = new FunctionDefinition(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.scope,
      node.kind,
      node.name,
      node.virtual,
      node.visibility,
      node.stateMutability,
      node.isConstructor,
      cloneASTNodeImpl(node.vParameters, ast, remappedIds),
      cloneASTNodeImpl(node.vReturnParameters, ast, remappedIds),
      node.vModifiers.map((m) => cloneASTNodeImpl(m, ast, remappedIds)),
      node.vOverrideSpecifier && cloneASTNodeImpl(node.vOverrideSpecifier, ast, remappedIds),
      node.vBody && cloneASTNodeImpl(node.vBody, ast, remappedIds),
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.nameLocation,
      node.raw,
    );
  } else if (node instanceof ImportDirective) {
    newNode = new ImportDirective(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.file,
      node.absolutePath,
      node.unitAlias,
      node.symbolAliases.map((alias) => ({
        foreign:
          typeof alias.foreign === 'number'
            ? alias.foreign
            : cloneASTNodeImpl(alias.foreign, ast, remappedIds),
        local: alias.local,
      })),
      node.scope,
      node.sourceUnit,
      node.raw,
    );
  } else if (node instanceof ModifierDefinition) {
    newNode = new ModifierDefinition(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.name,
      node.virtual,
      node.visibility,
      cloneASTNodeImpl(node.vParameters, ast, remappedIds),
      node.vOverrideSpecifier && cloneASTNodeImpl(node.vOverrideSpecifier, ast, remappedIds),
      node.vBody && cloneASTNodeImpl(node.vBody, ast, remappedIds),
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.nameLocation,
      node.raw,
    );
  } else if (node instanceof StructDefinition) {
    newNode = new StructDefinition(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.name,
      node.scope,
      node.visibility,
      node.vMembers.map((o) => cloneASTNodeImpl(o, ast, remappedIds)),
    );
  } else if (node instanceof VariableDeclaration) {
    newNode = new VariableDeclaration(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.constant,
      node.indexed,
      node.name,
      node.scope,
      node.stateVariable,
      node.storageLocation,
      node.visibility,
      node.mutability,
      node.typeString,
      cloneDocumentation(node.documentation, ast, remappedIds),
      node.vType && cloneASTNodeImpl(node.vType, ast, remappedIds),
      node.vOverrideSpecifier && cloneASTNodeImpl(node.vOverrideSpecifier, ast, remappedIds),
      node.vValue && cloneASTNodeImpl(node.vValue, ast, remappedIds),
      node.nameLocation,
    );
    //ASTNodeWithChildren------------------------------------------------------
  } else if (node instanceof ParameterList) {
    newNode = new ParameterList(
      replaceId(node.id, ast, remappedIds),
      node.src,
      [...node.vParameters].map((p) => cloneASTNodeImpl(p, ast, remappedIds)),
      node.raw,
    );
  } else if (node instanceof ContractDefinition) {
    newNode = new ContractDefinition(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.name,
      node.scope,
      node.kind,
      node.abstract,
      node.fullyImplemented,
      node.linearizedBaseContracts,
      node.usedErrors,
      node.documentation,
      [...node.children].map((ch) => cloneASTNodeImpl(ch, ast, remappedIds)),
      node.nameLocation,
      node.raw,
    );
  } else if (node instanceof EnumDefinition) {
    newNode = new EnumDefinition(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.name,
      node.vMembers.map((v) => cloneASTNodeImpl(v, ast, remappedIds)),
      node.nameLocation,
      node.raw,
    );
    //Misc---------------------------------------------------------------------
  } else if (node instanceof IdentifierPath) {
    newNode = new IdentifierPath(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.name,
      node.referencedDeclaration,
      node.raw,
    );
  } else if (node instanceof ModifierInvocation) {
    newNode = new ModifierInvocation(
      replaceId(node.id, ast, remappedIds),
      node.src,
      cloneASTNodeImpl(node.vModifierName, ast, remappedIds),
      node.vArguments.map((a) => cloneASTNodeImpl(a, ast, remappedIds)),
      node.kind,
      node.raw,
    );
  } else if (node instanceof OverrideSpecifier) {
    newNode = new OverrideSpecifier(
      replaceId(node.id, ast, remappedIds),
      node.src,
      [...node.vOverrides].map((o) => cloneASTNodeImpl(o, ast, remappedIds)),
      node.raw,
    );
  }

  if (notNull(newNode) && sameType(newNode, node)) {
    ast.setContextRecursive(newNode);
    ast.copyRegisteredImports(node, newNode);
    return newNode;
  } else {
    throw new NotSupportedYetError(`Unable to clone ${printNode(node)}`);
  }
}

function sameType<T extends ASTNode>(newNode: ASTNode, ref: T): newNode is T {
  return newNode instanceof ref.constructor && ref instanceof newNode.constructor;
}

// When cloning large chunks of the AST, id based references in the resulting subtree
// should refer to newly created nodes, as such we build up a map of id to original -> id of clone
function replaceId(oldId: number, ast: AST, remappedIds: Map<number, number>): number {
  const id = ast.reserveId();
  if (remappedIds.has(oldId)) {
    throw new TranspileFailedError(`Attempted to replace id ${oldId} twice`);
  }
  remappedIds.set(oldId, id);
  return id;
}

// For some types the typechecker can't distinguish between T & U and T in cloneASTNode<T extends ASTNode>
// In such cases separate functions need to be created and called from within cloneASTNodeImpl
function cloneBreak(node: Break, ast: AST, remappedIds: Map<number, number>): Break {
  return new Break(
    replaceId(node.id, ast, remappedIds),
    node.src,
    cloneDocumentation(node.documentation, ast, remappedIds),
    node.raw,
  );
}

function cloneContinue(node: Continue, ast: AST, remappedIds: Map<number, number>): Continue {
  return new Continue(
    replaceId(node.id, ast, remappedIds),
    node.src,
    cloneDocumentation(node.documentation, ast, remappedIds),
    node.raw,
  );
}

function clonePlaceholder(
  node: PlaceholderStatement,
  ast: AST,
  remappedIds: Map<number, number>,
): PlaceholderStatement {
  return new PlaceholderStatement(
    replaceId(node.id, ast, remappedIds),
    node.src,
    cloneDocumentation(node.documentation, ast, remappedIds),
    node.raw,
  );
}

export function cloneDocumentation(
  node: string | StructuredDocumentation | undefined,
  ast: AST,
  remappedIds: Map<number, number>,
): string | StructuredDocumentation | undefined {
  if (typeof node === `string`) return node;
  else if (node instanceof StructuredDocumentation)
    return new StructuredDocumentation(
      replaceId(node.id, ast, remappedIds),
      node.src,
      node.text,
      node.raw,
    );
  else return undefined;
}
