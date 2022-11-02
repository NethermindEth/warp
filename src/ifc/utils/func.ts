import { AbiType, FunctionAbiItemType } from '../abiTypes';

export function getFunctionItems(abi: AbiType): FunctionAbiItemType[] {
  const result: FunctionAbiItemType[] = [];
  abi.forEach((item) => {
    if (item.type === 'function') {
      result.push(item);
    }
  });
  return result;
}
