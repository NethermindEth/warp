import assert from 'assert';
import {
  ArrayType,
  DataLocation,
  Expression,
  FunctionDefinition,
  generalizeType,
  Identifier,
  IndexAccess,
  Literal,
  MemberAccess,
  Mutability,
  PointerType,
  StateVariableVisibility,
  TypeNameType,
  TypeNode,
  VariableDeclaration,
  VariableDeclarationStatement,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { NotSupportedYetError, TranspileFailedError } from '../utils/errors';
import { generateExpressionTypeString } from '../utils/getTypeString';
import { CALLDATA_TO_MEMORY_PREFIX } from '../utils/nameModifiers';
import { createIdentifier } from '../utils/nodeTemplates';
import { safeGetNodeType, specializeType } from '../utils/nodeTypeProcessing';
import { getContainingFunction, typeNameFromTypeNode } from '../utils/utils';

export class StaticArrayIndexer extends ASTMapper {
  /*
      This pass replace all non literal calldata structures which have a non literal
      index access for a memory one.
      This pass is needed because static arrays are handled as cairo tuples, but cairo
      tuples (for now) can only be indexed by literals
      e.g.
        uint8[3] calldata b = ...
        uint8 x = b[i]
     // gets replaced by:
        uint8[3] calldata b = ...
        uint8[3] memory mem_b  = b
        uint8[x] = mem_b[i]
  
      More complex cases can occur as well, for example when the static array is nested
      inside another structure, then the whole structure is copied to memory
    */

  // Tracks calldata structures which already have a memory counterpart initalized
  private staticArrayAccesed = new Map<number, VariableDeclaration>();

  // Function to add passes that should have been run before this pass
  addInitialPassPrerequisites(): void {
    const passKeys: Set<string> = new Set<string>([]);
    passKeys.forEach((key) => this.addPassPrerequisite(key));
  }

  visitMemberAccess(node: MemberAccess, ast: AST): void {
    this.staticIndexToMemory(node, ast);
  }

  visitIndexAccess(node: IndexAccess, ast: AST): void {
    if (safeGetNodeType(node, ast.inference) instanceof TypeNameType)
      return this.commonVisit(node, ast);
    this.staticIndexToMemory(node, ast);
  }

  private staticIndexToMemory(node: IndexAccess | MemberAccess, ast: AST): void {
    if (!hasIndexAccess(node, ast)) {
      return this.visitExpression(node, ast);
    }

    const identifier = getReferenceDeclaration(node, ast);

    assert(identifier.vReferencedDeclaration instanceof VariableDeclaration);
    const parentFunction = getContainingFunction(node);

    const refId = identifier.referencedDeclaration;

    let refVarDecl = this.staticArrayAccesed.get(refId);
    if (refVarDecl === undefined) {
      refVarDecl = this.initMemoryArray(identifier, parentFunction, ast);
      this.staticArrayAccesed.set(refId, refVarDecl);
    }

    const indexReplacement = this.setExpressionToMemory(node, refVarDecl, ast);
    ast.context.register(node);
    ast.replaceNode(node, indexReplacement);
  }

  private setExpressionToMemory(
    expr: Expression,
    refVarDecl: VariableDeclaration,
    ast: AST,
  ): Identifier | IndexAccess | MemberAccess {
    const exprType = safeGetNodeType(expr, ast.inference);
    const exprMemoryType = specializeType(generalizeType(exprType)[0], DataLocation.Memory);

    let replacement: Identifier | IndexAccess | MemberAccess;
    if (expr instanceof Identifier) {
      replacement = createIdentifier(refVarDecl, ast, DataLocation.Memory);
    } else if (expr instanceof IndexAccess) {
      replacement = new IndexAccess(
        expr.id,
        expr.src,
        generateExpressionTypeString(exprMemoryType),
        this.setExpressionToMemory(expr.vBaseExpression, refVarDecl, ast),
        expr.vIndexExpression,
      );
    } else if (expr instanceof MemberAccess) {
      replacement = new MemberAccess(
        expr.id,
        '',
        generateExpressionTypeString(exprMemoryType),
        this.setExpressionToMemory(expr.vExpression, refVarDecl, ast),
        expr.memberName,
        expr.referencedDeclaration,
      );
    } else {
      throw new NotSupportedYetError(
        `Static array index access with nested expression ${printNode(expr)} is not supported yet`,
      );
    }
    ast.context.unregister(expr);
    return replacement;
  }

  private initMemoryArray(
    identifier: Identifier,
    parentFunction: FunctionDefinition,
    ast: AST,
  ): VariableDeclaration {
    const refId = identifier.referencedDeclaration;
    const memoryType = generalizeType(safeGetNodeType(identifier, ast.inference))[0];

    const varDecl = new VariableDeclaration(
      ast.reserveId(),
      '',
      false, // constant
      false, // indexed
      `${CALLDATA_TO_MEMORY_PREFIX}${identifier.name}`,
      parentFunction?.id,
      false, // stateVariable
      DataLocation.Memory,
      StateVariableVisibility.Internal,
      Mutability.Mutable,
      memoryType.pp(),
      undefined,
      typeNameFromTypeNode(memoryType, ast),
      undefined,
    );

    assert(identifier.vReferencedDeclaration instanceof VariableDeclaration);
    const assignation = createIdentifier(
      identifier.vReferencedDeclaration,
      ast,
      DataLocation.CallData,
    );

    const varDeclStmnt = new VariableDeclarationStatement(
      ast.reserveId(),
      '',
      [varDecl.id],
      [varDecl],
      assignation,
    );
    ast.setContextRecursive(varDeclStmnt);
    ast.setContextRecursive(varDecl);

    if (parentFunction.vParameters.vParameters.some((vd) => vd.id === refId)) {
      parentFunction.vBody?.insertAtBeginning(varDeclStmnt);
    } else {
      ast.insertStatementAfter(identifier.vReferencedDeclaration, varDeclStmnt);
    }
    return varDecl;
  }
}

function isCalldataStaticArray(type: TypeNode): boolean {
  return (
    type instanceof PointerType &&
    type.location === DataLocation.CallData &&
    type.to instanceof ArrayType &&
    type.to.size !== undefined
  );
}

function hasIndexAccess(node: Expression, ast: AST): boolean {
  return (
    (node instanceof IndexAccess &&
      ((isCalldataStaticArray(safeGetNodeType(node.vBaseExpression, ast.inference)) &&
        isIndexedByNonLiteral(node)) ||
        hasIndexAccess(node.vBaseExpression, ast))) ||
    (node instanceof MemberAccess && hasIndexAccess(node.vExpression, ast))
  );
}

function isIndexedByNonLiteral(node: IndexAccess): boolean {
  return node.vIndexExpression !== undefined && !(node.vIndexExpression instanceof Literal);
}

function getReferenceDeclaration(expr: Expression, ast: AST): Identifier {
  if (expr instanceof Identifier) {
    return expr;
  } else if (expr instanceof IndexAccess) {
    return getReferenceDeclaration(expr.vBaseExpression, ast);
  } else if (expr instanceof MemberAccess) {
    return getReferenceDeclaration(expr.vExpression, ast);
  }
  throw new TranspileFailedError(
    `Unexpected expression ${printNode(expr)} while searching for identifier`,
  );
}
