import { InferType } from 'solc-typed-ast';

// Note that version is not used by InferType (yet?) thus for now its an empty string
// In future it will probbably have to be an attribute of AST class with version set
export const infer = new InferType('');
