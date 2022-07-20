import { Block, IfStatement, Return, Statement, UncheckedBlock } from 'solc-typed-ast';

export function hasPathWithoutReturn(statement: Statement): boolean {
  if (statement instanceof Block || statement instanceof UncheckedBlock) {
    return statement.vStatements.every(hasPathWithoutReturn);
  } else if (statement instanceof IfStatement) {
    if (hasPathWithoutReturn(statement.vTrueBody)) {
      return true;
    } else if (statement.vFalseBody !== undefined && hasPathWithoutReturn(statement.vFalseBody)) {
      return true;
    } else {
      return false;
    }
  } else if (statement instanceof Return) {
    return false;
  } else {
    return true;
  }
}

export function collectReachableStatements(statement: Statement): Set<Statement> {
  // This is created up front for space efficiency, to avoid constant creation and unions of sets
  const reachableStatements = new Set<Statement>();
  collectReachableStatementsImpl(statement, reachableStatements);
  return reachableStatements;
}

export function collectReachableStatementsImpl(
  statement: Statement,
  collection: Set<Statement>,
): void {
  collection.add(statement);
  if (statement instanceof Block || statement instanceof UncheckedBlock) {
    statement.vStatements.forEach((subStatement) =>
      collectReachableStatementsImpl(subStatement, collection),
    );
  } else if (statement instanceof IfStatement) {
    collectReachableStatementsImpl(statement.vTrueBody, collection);
    if (statement.vFalseBody) collectReachableStatementsImpl(statement.vFalseBody, collection);
  }
}
