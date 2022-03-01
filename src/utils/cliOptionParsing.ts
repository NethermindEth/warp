import { InvalidArgumentError } from 'commander';
import { ASTMapper } from '../ast/mapper';
import { error } from './errors';

export function parsePassOrder(
  order: string | undefined,
  until: string | undefined,
  passes: Map<string, typeof ASTMapper>,
): typeof ASTMapper[] {
  if (order === undefined) {
    order = [...passes.keys()].reduce((acc, key) => `${acc}${key}`, '');
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
    if (key === until) break;
    remainingOrder = remainingOrder.slice(key.length);
  }

  return passesInOrder;
}

class PassOrderParseError extends InvalidArgumentError {
  constructor(passOrder: string, remainingPassOrder: string, validOptions: string[]) {
    const errorMessage = `Unable to parse options ${remainingPassOrder} of ${passOrder}`;
    const validOptionList = `Valid options are ${validOptions.join()}`;
    const example = `For example, --order ${validOptions.join('')}`;
    super(error(`${errorMessage}\n${validOptionList}\n${example}`));
  }
}
