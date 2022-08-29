import assert from 'assert';
import { InvalidArgumentError } from 'commander';
import { ASTMapper } from '../ast/mapper';
import { CLIError, PassOrderError } from './errors';
import { error } from './formatting';

class PassOrderParseError extends InvalidArgumentError {
  constructor(passOrder: string, remainingPassOrder: string, validOptions: string[]) {
    const errorMessage = `Unable to parse options ${remainingPassOrder} of ${passOrder}`;
    const validOptionList = `Valid options are ${validOptions.join()}`;
    const example = `For example, --order ${validOptions.join('')}`;
    super(error(`${errorMessage}\n${validOptionList}\n${example}`));
  }
}

export function parsePassOrder(
  order: string | undefined,
  until: string | undefined,
  warnings: boolean | undefined,
  dev: boolean | undefined,
  passes: Map<string, typeof ASTMapper>,
): typeof ASTMapper[] {
  if (order === undefined) {
    order = [...passes.keys()].reduce((acc, key) => `${acc}${key}`, '');
  }

  //We want keys in order of longest first otherwise 'Vs' would match 'V' and then error on 's'
  const sortedPassMap = [...passes.entries()].sort(([a], [b]) => b.length - a.length);
  const passesInOrder = [];
  const keyPassesInOrder: string[] = [];
  let remainingOrder = order;

  while (remainingOrder.length > 0) {
    const foundPass = sortedPassMap.find(([key]) => remainingOrder.startsWith(key));
    if (foundPass === undefined) {
      throw new PassOrderParseError(remainingOrder, order, [...passes.keys()]);
    }
    const [key, nextPass] = foundPass;
    passesInOrder.push(nextPass);
    keyPassesInOrder.push(key);
    if (key === until) break;
    remainingOrder = remainingOrder.slice(key.length);
  }

  passesInOrder.forEach((element, index) => {
    const prerequisite = element._getPassPrerequisites();
    const earlierPassKeys = [...keyPassesInOrder].slice(0, index);
    prerequisite.forEach((prerequisite) => {
      if (!passes.get(prerequisite)) {
        throw new Error(
          `Unknown pass key: ${prerequisite} in pass prerequisite of ${element.getPassName()}`,
        );
      }
      if (!earlierPassKeys.includes(prerequisite)) {
        if (warnings && dev) {
          console.log(
            `WARNING: ${passes
              .get(prerequisite)
              ?.getPassName()} pass is not before ${element.getPassName()} in the pass order`,
          );
        }
        if (!dev) {
          throw new PassOrderError(
            `${passes
              .get(prerequisite)
              ?.getPassName()} pass is not before ${element.getPassName()} in the pass order`,
          );
        }
      }
    });
  });

  return passesInOrder;
}

export function createPassMap(
  passes: [key: string, pass: typeof ASTMapper][],
): Map<string, typeof ASTMapper> {
  // By asserting that each key is the first one like it, we ensure that each key is unique
  assert(passes.every(([key], index) => passes.findIndex(([k]) => k === key) === index));
  assert(passes.every(([key]) => isCorrectCase(key)));
  return new Map(passes);
}

function isCorrectCase(key: string): boolean {
  return [...key].every((letter, index) =>
    index === 0 ? letter >= 'A' && letter <= 'Z' : letter >= 'a' || letter <= 'z',
  );
}

export function parseClassHash(filePath: string, CLIOutput: string): string {
  const splitter = new RegExp('[ ]+');
  const classHash = CLIOutput.split('\n')
    .map((line) => {
      const [contractT, classT, hashT, hash, ...others] = line.split(splitter);
      if (contractT === 'Contract' && classT === 'class' && hashT === 'hash:') {
        if (others.length !== 0) {
          throw new CLIError(
            `Error while parsing the 'declare' output of ${filePath}. Malformed lined.`,
          );
        }
        return hash;
      }
      return null;
    })
    .filter((val) => val !== null)[0];

  if (classHash === null || classHash === undefined)
    throw new CLIError(
      `Error while parsing the 'declare' output of ${filePath}. Couldn't find the class hash.`,
    );

  return classHash;
}
