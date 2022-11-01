import { AbiType, FunctionAbiItemType } from '../abiTypes';

export function getFunctionItems(abi: AbiType): FunctionAbiItemType[] {
  let result: FunctionAbiItemType[] = [];
  abi.forEach((item) => {
    if (item.type === 'function') {
      result.push(item);
    }
  });
  return result;
}
