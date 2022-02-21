import { IntType, MappingType, PointerType, TypeNode, UserDefinedType } from 'solc-typed-ast';
import { printTypeNode } from './astPrinter';
import { NotSupportedYetError } from './errors';

// TODO remove this and use CairoType.width
export function getFeltWidth(type: TypeNode): number {
  if (type instanceof IntType) {
    return type.nBits < 256 ? 1 : 2;
  } else if (type instanceof PointerType) {
    if (type.to instanceof MappingType) {
      return 1;
    }
  } else if (type instanceof UserDefinedType) {
    if (type.pp().startsWith('enum ')) {
      return 1;
    }
  }

  throw new NotSupportedYetError(`Width of ${printTypeNode(type)} not implemented yet`);
}
