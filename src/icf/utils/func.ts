import { AbiType, FunctionAbiItemType } from '../abiTypes';

export function getFunctionItems(abi: AbiType): FunctionAbiItemType[] {
  const result: FunctionAbiItemType[] = [];
  abi.forEach((item) => {
    if (item.type === 'function' && item.name !== '__default__') {
      result.push(item);
    }
  });
  return result;
}
