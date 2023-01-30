import { Block, IfStatement, Return, Statement, UncheckedBlock } from 'solc-typed-ast';

export function hasPathWithoutReturn(statement: Statement): boolean {
  if (statement instanceof Block || statement instanceof UncheckedBlock) {
    return statement.vStatements.every(hasPathWithoutReturn);
  } else if (statement instanceof IfStatement) {
    if (hasPathWithoutReturn(statement.vTrueBody)) {
      return true;
    }
    return statement.vFalseBody === undefined || hasPathWithoutReturn(statement.vFalseBody);
  }
  return !(statement instanceof Return);
}

// collects the reachable statements within the given one
// proper use would be to pass the body of a function, for example
export function collectReachableStatements(statement: Statement): Set<Statement> {
  // This is created up front for space efficiency, to avoid constant creation and unions of sets
  const reachableStatements = new Set<Statement>();
  collectReachableStatementsImpl(statement, reachableStatements);
  return reachableStatements;
}

// inserts reachable statements into collection,
// and returns whether or not execution can continue past the given statement
export function collectReachableStatementsImpl(
  statement: Statement,
  collection: Set<Statement>,
): boolean {
  collection.add(statement);
  if (statement instanceof Block || statement instanceof UncheckedBlock) {
    for (const subStatement of statement.vStatements) {
      const flowContinues = collectReachableStatementsImpl(subStatement, collection);
      if (!flowContinues) return false;
    }
    return true;
  } else if (statement instanceof IfStatement) {
    const flowGetsThroughTrue = collectReachableStatementsImpl(statement.vTrueBody, collection);
    const flowGetsThroughFalse =
      !statement.vFalseBody || collectReachableStatementsImpl(statement.vFalseBody, collection);
    return flowGetsThroughTrue || flowGetsThroughFalse;
  } else if (statement instanceof Return) {
    return false;
  } else {
    return true;
  }
}
