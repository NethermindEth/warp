import { InvalidArgumentError } from 'commander';
import { ASTMapper } from '../ast/mapper';

export function parsePassOrder(
  order: string | undefined,
  passes: Map<string, ASTMapper>,
): ASTMapper[] {
  if (order === undefined) {
    return [...passes.values()];
  }

  //We want keys in order of longest first otherwise 'Vs' would match 'V' and then error on 's'
  const sortedPassMap = [...passes.entries()].sort(([a], [b]) => b.length - a.length);
  const passesInOrder = [];
  let remainingOrder = order;

  while (remainingOrder.length > 0) {
    const foundPass = sortedPassMap.find(([key]) => remainingOrder.startsWith(key));
    if (foundPass === undefined) {
      throw new PassOrderParseError(remainingOrder, order, [...passes.keys()]);
    }
    const [key, nextPass] = foundPass;
    passesInOrder.push(nextPass);
    remainingOrder = remainingOrder.slice(key.length);
  }

  return passesInOrder;
}

class PassOrderParseError extends InvalidArgumentError {
  constructor(passOrder: string, remainingPassOrder: string, validOptions: string[]) {
    const errorMessage = `Unable to parse options ${remainingPassOrder} of ${passOrder}`;
    const validOptionList = `Valid options are ${validOptions.join()}`;
    const example = `For example, --order ${validOptions.join('')}`;
    super(`${errorMessage}\n${validOptionList}\n${example}`);
  }
}
