export type StructAbiItemType = {
  members: { name: string; offset?: number; type: string }[];
  name: string;
  size?: number;
  type: 'struct';
};

export type FunctionAbiItemType = {
  inputs: { name: string; type: string }[];
  name: string;
  outputs: { name: string; type: string }[];
  stateMutability: string;
  type: 'function';
};

export type AbiItemType = StructAbiItemType | FunctionAbiItemType;

export type AbiType = AbiItemType[];
