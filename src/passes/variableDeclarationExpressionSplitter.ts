import assert from 'assert';
import {
  FunctionCall,
  TupleExpression,
  VariableDeclarationStatement,
  Block,
  StatementWithChildren,
  Statement,
  UncheckedBlock,
  ExpressionStatement,
  getNodeType,
  TupleType,
  VariableDeclaration,
  StateVariableVisibility,
  Mutability,
} from 'solc-typed-ast';
import { AST } from '../ast/ast';
import { ASTMapper } from '../ast/mapper';
import { printNode } from '../utils/astPrinter';
import { TranspileFailedError } from '../utils/errors';
import { createIdentifier } from '../utils/nodeTemplates';
import { notNull } from '../utils/typeConstructs';
import { typeNameFromTypeNode } from '../utils/utils';

// TODO check for case where a for loop contains a single tuple declaration as its body

export class VariableDeclarationExpressionSplitter extends ASTMapper {
  lastUsedConstantId = 0;
  generateNewConstantName(): string {
    return `__warp_td_${this.lastUsedConstantId++}`;
  }

  visitBlock(node: Block, ast: AST): void {
    // Recurse first to handle nested blocks
    // CommonVisiting a block will not split direct children of the block as that is done via visitStatementList
    this.commonVisit(node, ast);
    this.visitStatementList(node, ast);
  }

  visitUncheckedBlock(node: UncheckedBlock, ast: AST): void {
    this.commonVisit(node, ast);
    this.visitStatementList(node, ast);
  }

  visitStatementList(node: StatementWithChildren<Statement>, ast: AST): void {
    const replacements = node.children
      .map<[VariableDeclarationStatement, Statement[]] | null>((statement) => {
        if (statement instanceof VariableDeclarationStatement) {
          return [statement, this.splitDeclaration(statement, ast)];
        } else {
          return null;
        }
      })
      .filter(notNull);

    replacements.forEach((value) => {
      const [oldStatement, splitDeclaration] = value;
      if (splitDeclaration.length === 1 && oldStatement === splitDeclaration[0]) return;
      if (splitDeclaration.length === 0) return;

      if (splitDeclaration[0] !== oldStatement) {
        ast.replaceNode(oldStatement, splitDeclaration[0]);
      }
      splitDeclaration.slice(1).forEach((declaration, index) => {
        node.insertAfter(declaration, splitDeclaration[index]);
        ast.registerChild(declaration, node);
      });
    });
  }

  // e.g. (int a, int b, , ) = (e(), , g(),); => int a = e(); int b; g();
  splitDeclaration(node: VariableDeclarationStatement, ast: AST): Statement[] {
    const initialValue = node.vInitialValue;
    assert(
      initialValue !== undefined,
      'Expected variables to be initialised when running variable declaration expression splitter (did you run variable declaration initialiser?)',
    );

    const initialValueType = getNodeType(initialValue, ast.compilerVersion);

    if (!(initialValueType instanceof TupleType)) {
      return [node];
    }

    // In the case of (int a, int b) = f(), types that don't exactly match need to be extracted
    if (initialValue instanceof FunctionCall) {
      const newDeclarationStatements: VariableDeclarationStatement[] = [];

      const newAssignedIds = node.assignments.map((id, index) => {
        if (id === null) return null;

        const oldDeclaration = node.vDeclarations.find((decl) => decl.id === id);
        assert(oldDeclaration !== undefined, `${printNode(node)} has no declaration for id ${id}`);

        if (oldDeclaration.typeString === initialValueType.elements[index].pp()) {
          // If types are correct there's no need to create a new variable
          return id;
        } else {
          const currentTypeNode = initialValueType.elements[index];

          const newTypeName = typeNameFromTypeNode(currentTypeNode, ast);
          // This is the replacement variable in the tuple assignment
          const newDeclaration = new VariableDeclaration(
            ast.reserveId(),
            node.src,
            true,
            false,
            this.generateNewConstantName(),
            oldDeclaration.scope,
            false,
            oldDeclaration.storageLocation,
            StateVariableVisibility.Default,
            Mutability.Constant,
            newTypeName.typeString,
            undefined,
            newTypeName,
          );
          node.vDeclarations.push(newDeclaration);
          ast.registerChild(newDeclaration, node);

          // We now declare the variable that used to be inside the tuple
          const newDeclarationStatement = new VariableDeclarationStatement(
            ast.reserveId(),
            node.src,
            [oldDeclaration.id],
            [oldDeclaration],
            createIdentifier(newDeclaration, ast),
          );
          newDeclarationStatements.push(newDeclarationStatement);
          ast.setContextRecursive(newDeclarationStatement);
          return newDeclaration.id;
        }
      });
      node.assignments = newAssignedIds;
      node.vDeclarations = node.vDeclarations.filter((decl) => node.assignments.includes(decl.id));
      return [node, ...newDeclarationStatements];
    } else if (initialValue instanceof TupleExpression) {
      // Since Solidity 0.5.0 tuples on either side of an assignment must be of equal size

      return node.assignments
        .map((declId, tupleIndex) => {
          const exprToAssign = initialValue.vOriginalComponents[tupleIndex];
          // This happens when the lhs has an empty slot
          // The rhs is fully evaluated, so this cannot be ignored because of side effects
          if (declId === null) {
            if (exprToAssign === null) return null;

            return new ExpressionStatement(
              ast.reserveId(),
              initialValue.src, // TODO could make this more accurate
              exprToAssign,
              tupleIndex === 0 ? node.documentation : undefined,
              tupleIndex === 0 ? node.raw : undefined,
            );
          } else {
            const decl = node.vDeclarations.find((child) => child.id === declId);
            assert(
              decl !== undefined,
              `VariableDeclarationStatement #${node.id} has no declaration for id ${declId}`,
            );
            return new VariableDeclarationStatement(
              ast.reserveId(),
              node.src, // TODO could make this more accurate
              [declId],
              [decl],
              exprToAssign ?? undefined,
              tupleIndex === 0 ? node.documentation : undefined,
              tupleIndex === 0 ? node.raw : undefined,
            );
          }
        })
        .filter(notNull);
    }
    throw new TranspileFailedError(`Don't know how to destructure ${node.type}`);
  }
}
