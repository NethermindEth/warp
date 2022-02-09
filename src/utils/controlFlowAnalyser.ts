import { Block, IfStatement, Return, Statement, UncheckedBlock } from 'solc-typed-ast';
import { printNode } from './astPrinter';

export function analyseControlFlow(statement: Statement): Statement[][] {
  if (statement instanceof Block || statement instanceof UncheckedBlock) {
    const start: Statement[][] = [[statement]];
    return statement.vStatements.reduce((inFlows, curr) => {
      const outFlows = analyseControlFlow(curr);
      return mergeFlows(inFlows, outFlows);
    }, start);
  } else if (statement instanceof IfStatement) {
    const trueFlow = analyseControlFlow(statement.vTrueBody);
    const falseFlow = statement.vFalseBody ? analyseControlFlow(statement.vFalseBody) : [[]];
    return mergeFlows([[statement]], [...trueFlow, ...falseFlow]);
  } else {
    return [[statement]];
  }
}

function mergeFlows(inFlows: Statement[][], outFlows: Statement[][]): Statement[][] {
  return inFlows.flatMap((i) => {
    if (i.length > 0 && i[i.length - 1] instanceof Return) {
      return [i];
    } else {
      return outFlows.map((o) => [...i, ...o]);
    }
  });
}

export function printControlFlow(flow: Statement[][]): string {
  return flow
    .map((path: Statement[], index: number) => [`${index}.`, ...path.map(printNode)].join('\n'))
    .join('\n');
}
