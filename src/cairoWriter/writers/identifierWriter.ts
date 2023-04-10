import { ASTWriter, Identifier, SrcDesc } from 'solc-typed-ast';
import { isCalldataDynArrayStruct, isExternalMemoryDynArray } from '../../utils/utils';
import { CairoASTNodeWriter } from '../base';
import { structRemappings } from './sourceUnitWriter';

export class IdentifierWriter extends CairoASTNodeWriter {
  writeInner(node: Identifier, _: ASTWriter): SrcDesc {
    if (isCalldataDynArrayStruct(node, this.ast.inference)) {
      // Calldata dynamic arrays have the element pointer and length variables
      // stored inside a struct. When the dynamic array is accessed, struct's members
      // must be used instead
      return [`${node.name}.len, ${node.name}.ptr`];
    }
    if (isExternalMemoryDynArray(node, this.ast.inference)) {
      // Memory treated as calldata behaves similarly to calldata but it's
      // element pointer and length variables are not wrapped inside a struct.
      // When access to the dynamic array is needed, this two variables are used instead
      return [`${node.name}_len, ${node.name}`];
    }

    return [
      `${
        node.vReferencedDeclaration
          ? structRemappings.get(node.vReferencedDeclaration?.id) || node.name
          : node.name
      }`,
    ];
  }
}
